import os
import time
import logging
import zipfile
import platform
import subprocess
from typing import Optional
from pathlib import Path
from dataclasses import dataclass

import requests
from selenium import webdriver
from selenium.common.exceptions import WebDriverException, NoSuchElementException
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.remote.webdriver import WebDriver


@dataclass
class BrowserConfig:
    """Configuration for browser setup"""

    user_data_dir: str
    binary_location: str
    chromedriver_path: Path


class Constants:
    """Application-wide constants"""

    EXTENSION_IDS = [
        "mghlhfaogogibkliffpabpjoekdnenha",
        "eimadpbcbfnmbkopoojfekhnkhdbieeh",
        "nlnkcinjjeoojlhdiedbbolilahmnldj",
    ]
    WEBSTORE_URL = "https://chrome.google.com/webstore/detail/{}"
    WAIT_TIME_PAGE_LOAD = 5
    WAIT_TIME_DIALOG = 2
    WAIT_TIME_INSTALL = 5


class ExtensionInstaller:
    """Handles the installation of Chrome/Brave extensions"""

    def __init__(self, config: BrowserConfig, logger: logging.Logger):
        """
        Initialize the installer with configuration and logger

        Args:
            config: Browser configuration settings
            logger: Logger instance for output
        """
        self.config = config
        self.logger = logger
        self.driver: Optional[WebDriver] = None

    def setup_driver(self) -> None:
        """Initialize the WebDriver with proper configuration"""
        try:
            chrome_options = webdriver.ChromeOptions()
            chrome_options.add_argument(f"--user-data-dir={self.config.user_data_dir}")
            chrome_options.binary_location = self.config.binary_location

            service = Service(str(self.config.chromedriver_path))
            self.driver = webdriver.Chrome(service=service, options=chrome_options)

        except WebDriverException as e:
            self.logger.error("Failed to initialize WebDriver", exc_info=True)
            raise RuntimeError("Browser setup failed") from e

    def is_extension_installed(self, extension_id: str) -> bool:
        """
        Check if an extension is already installed

        Args:
            extension_id: The Chrome extension ID

        Returns:
            bool: True if extension is installed, False otherwise
        """
        try:
            elements = self.driver.find_elements(By.XPATH, '//span[contains(text(), "Remove from Chrome")]')
            return len(elements) > 0
        except WebDriverException:
            return False

    def install_extension(self, extension_id: str) -> bool:
        """
        Install a single extension

        Args:
            extension_id: The Chrome extension ID

        Returns:
            bool: True if installation successful, False otherwise
        """
        if not self.driver:
            raise RuntimeError("WebDriver not initialized")

        url = Constants.WEBSTORE_URL.format(extension_id)
        try:
            self.logger.info(f"Installing extension: {extension_id}")
            self.logger.debug(f"Navigating to: {url}")

            self.driver.get(url)
            time.sleep(Constants.WAIT_TIME_PAGE_LOAD)

            if self.is_extension_installed(extension_id):
                self.logger.info(f"Extension {extension_id} is already installed")
                return True

            # Click install button
            install_button = self.driver.find_element(By.XPATH, '//button[contains(text(), "Add to Chrome")]')
            install_button.click()
            self.logger.debug("Clicked 'Add to Chrome' button")

            # Confirm installation
            time.sleep(Constants.WAIT_TIME_DIALOG)
            confirm_button = self.driver.find_element(By.XPATH, '//button[contains(text(), "Add extension")]')
            confirm_button.click()
            self.logger.debug("Confirmed installation")

            time.sleep(Constants.WAIT_TIME_INSTALL)
            return True

        except (NoSuchElementException, WebDriverException) as e:
            self.logger.error(f"Failed to install extension {extension_id} -- {str(e)}", exc_info=True)
            self.logger.info(f"Opening extension URL in browser: {url}")
            subprocess.run(["open", url], check=True)
            return False

    def install_all_extensions(self) -> None:
        """Install all configured extensions"""
        try:
            self.setup_driver()
            for extension_id in Constants.EXTENSION_IDS:
                self.install_extension(extension_id)
        finally:
            if self.driver:
                self.logger.info("Closing browser")
                self.driver.quit()


class ChromeDriverManager:
    """Manages ChromeDriver download and setup"""

    CHROMEDRIVER_URLS = {
        "Darwin-x86_64": "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.71/mac-x64/chromedriver-mac-x64.zip",
        "Darwin-arm64": "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.71/mac-arm64/chromedriver-mac-arm64.zip",
        "Linux": "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.71/linux64/chromedriver-linux64.zip",
    }

    def __init__(self, logger: logging.Logger):
        self.logger = logger
        self.driver_dir = Path(".").resolve() / "chromedriver"
        self.driver_path = self.driver_dir / "chromedriver"

    def get_system_key(self) -> str:
        """Get the system key for the ChromeDriver URL"""
        system = platform.system()
        if system == "Darwin":
            # Use machine() instead of processor() for more reliable architecture detection
            machine = platform.machine()
            if machine == "arm64":
                return "Darwin-arm64"
            return "Darwin-x86_64"
        return system

    def setup(self) -> Path:
        """Download and setup ChromeDriver if not present"""
        if self.driver_path.exists():
            self.logger.info("Removing existing ChromeDriver")
            self.driver_path.unlink()

        self.logger.info("Setting up ChromeDriver")
        system_key = self.get_system_key()
        self.logger.info(f"Detected system: {system_key}")

        if system_key not in self.CHROMEDRIVER_URLS:
            raise RuntimeError(f"Unsupported system: {system_key}")

        # Create directory if it doesn't exist
        self.driver_dir.mkdir(exist_ok=True)

        # Download and extract ChromeDriver
        url = self.CHROMEDRIVER_URLS[system_key]
        zip_path = self.driver_dir / "chromedriver.zip"

        self.logger.info(f"Downloading ChromeDriver from {url}")
        response = requests.get(url)
        response.raise_for_status()

        with open(zip_path, "wb") as f:
            f.write(response.content)

        self.logger.info("Extracting ChromeDriver")
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            # List contents to find the chromedriver executable
            contents = zip_ref.namelist()
            chromedriver_file = next((f for f in contents if f.endswith("chromedriver")), None)

            if not chromedriver_file:
                raise RuntimeError("Could not find chromedriver in the downloaded zip")

            # Extract only the chromedriver file
            source = zip_ref.extract(chromedriver_file, self.driver_dir)

            # Move it to the correct location
            source_path = Path(source)
            if source_path != self.driver_path:
                self.driver_path.parent.mkdir(parents=True, exist_ok=True)
                source_path.rename(self.driver_path)

        # Make ChromeDriver executable
        self.logger.info("Setting executable permissions")
        os.chmod(self.driver_path, 0o755)

        # Cleanup
        zip_path.unlink()

        if not self.driver_path.exists():
            raise RuntimeError(f"Failed to setup ChromeDriver at {self.driver_path}")

        self.logger.info(f"ChromeDriver successfully setup at {self.driver_path}")
        return self.driver_path


def setup_logging() -> logging.Logger:
    """Configure and return logger instance"""
    logging.basicConfig(
        level=logging.DEBUG,
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[logging.FileHandler("browser_extensions.log"), logging.StreamHandler()],
    )
    return logging.getLogger(__name__)


def get_browser_config(logger: logging.Logger) -> BrowserConfig:
    """Create and return browser configuration"""
    user = os.environ.get("USER")
    if not user:
        raise EnvironmentError("USER environment variable not set")

    # Setup ChromeDriver
    driver_manager = ChromeDriverManager(logger)
    chromedriver_path = driver_manager.setup()

    return BrowserConfig(
        user_data_dir=f"/Users/{user}/Library/Application Support/BraveSoftware/Brave-Browser/Default",
        binary_location="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
        chromedriver_path=chromedriver_path,
    )


def main():
    """Main entry point for the application"""
    try:
        logger = setup_logging()
        logger.info("Starting browser extension installation")

        config = get_browser_config(logger)

        # Validate browser binary
        if not os.path.exists(config.binary_location):
            raise FileNotFoundError(f"Brave browser not found at: {config.binary_location}")

        installer = ExtensionInstaller(config, logger)
        installer.install_all_extensions()

    except Exception as e:
        logger.error(f"Application failed -- {str(e)}", exc_info=True)
        raise


if __name__ == "__main__":
    main()
