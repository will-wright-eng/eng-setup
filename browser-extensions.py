import os
import logging
import time
from pathlib import Path
from typing import Optional
from dataclasses import dataclass
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webdriver import WebDriver
from selenium.webdriver.remote.webelement import WebElement
from selenium.common.exceptions import WebDriverException, NoSuchElementException

@dataclass
class BrowserConfig:
    """Configuration for browser setup"""
    user_data_dir: str
    binary_location: str
    chromedriver_path: Path

class Constants:
    """Application-wide constants"""
    EXTENSION_IDS = [
        'mghlhfaogogibkliffpabpjoekdnenha',
        'eimadpbcbfnmbkopoojfekhnkhdbieeh',
        'nlnkcinjjeoojlhdiedbbolilahmnldj'
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
            elements = self.driver.find_elements(
                By.XPATH,
                '//span[contains(text(), "Remove from Chrome")]'
            )
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

        try:
            url = Constants.WEBSTORE_URL.format(extension_id)
            self.logger.info(f"Installing extension: {extension_id}")
            self.logger.debug(f"Navigating to: {url}")

            self.driver.get(url)
            time.sleep(Constants.WAIT_TIME_PAGE_LOAD)

            if self.is_extension_installed(extension_id):
                self.logger.info(f"Extension {extension_id} is already installed")
                return True

            # Click install button
            install_button = self.driver.find_element(
                By.XPATH,
                '//button[contains(text(), "Add to Chrome")]'
            )
            install_button.click()
            self.logger.debug("Clicked 'Add to Chrome' button")

            # Confirm installation
            time.sleep(Constants.WAIT_TIME_DIALOG)
            confirm_button = self.driver.find_element(
                By.XPATH,
                '//button[contains(text(), "Add extension")]'
            )
            confirm_button.click()
            self.logger.debug("Confirmed installation")

            time.sleep(Constants.WAIT_TIME_INSTALL)
            return True

        except NoSuchElementException as e:
            self.logger.error(f"Required button not found for {extension_id}", exc_info=True)
            return False
        except WebDriverException as e:
            self.logger.error(f"Failed to install extension {extension_id}", exc_info=True)
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

def setup_logging() -> logging.Logger:
    """Configure and return logger instance"""
    logging.basicConfig(
        level=logging.DEBUG,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler('browser_extensions.log'),
            logging.StreamHandler()
        ]
    )
    return logging.getLogger(__name__)

def get_browser_config() -> BrowserConfig:
    """Create and return browser configuration"""
    user = os.environ.get('USER')
    if not user:
        raise EnvironmentError("USER environment variable not set")

    return BrowserConfig(
        user_data_dir=f"/Users/{user}/Library/Application Support/BraveSoftware/Brave-Browser/Default",
        binary_location="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
        chromedriver_path=Path('.').resolve() / 'chromedriver_mac64' / 'chromedriver'
    )

def main():
    """Main entry point for the application"""
    try:
        logger = setup_logging()
        config = get_browser_config()

        # Validate paths before proceeding
        if not os.path.exists(config.binary_location):
            raise FileNotFoundError(f"Brave browser not found at: {config.binary_location}")
        if not config.chromedriver_path.exists():
            raise FileNotFoundError(f"ChromeDriver not found at: {config.chromedriver_path}")

        installer = ExtensionInstaller(config, logger)
        installer.install_all_extensions()

    except Exception as e:
        logger.error("Application failed", exc_info=True)
        raise

if __name__ == "__main__":
    main()
