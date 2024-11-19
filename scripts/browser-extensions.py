import os
import logging
import subprocess
from dataclasses import dataclass


@dataclass
class BrowserConfig:
    """Configuration for browser setup"""

    user_data_dir: str
    binary_location: str


class Constants:
    """Application-wide constants"""

    EXTENSION_IDS = [
        "mghlhfaogogibkliffpabpjoekdnenha",  # Tabs to Clipboard
        "eimadpbcbfnmbkopoojfekhnkhdbieeh",  # Dark Reader
        "nlnkcinjjeoojlhdiedbbolilahmnldj",  # Tab Sorter
        "fmkadmapgofadopljbjfkapdkoienihi",  # React Developer Tools
        "elglafmpaeiffddlclplkhgkplbdccca",  # Wayback Machine Lookup
        "gppongmhjkpfnbhagpmjfkannfbllamg",  # Wappalyzer
    ]
    WEBSTORE_URL = "https://chrome.google.com/webstore/detail/{}"
    WAIT_TIME_PAGE_LOAD = 5
    WAIT_TIME_DIALOG = 2
    WAIT_TIME_INSTALL = 5


class ExtensionInstaller:
    """Handles opening extension URLs in Brave browser"""

    def __init__(self, logger: logging.Logger):
        self.logger = logger

    def open_extension_url(self, extension_id: str) -> None:
        """Open extension URL in Brave browser"""
        url = Constants.WEBSTORE_URL.format(extension_id)
        self.logger.info(f"Opening extension URL: {url}")
        try:
            subprocess.run(["open", "-a", "Brave Browser", url], check=True)
        except subprocess.CalledProcessError as e:
            self.logger.error(f"Failed to open URL for extension {extension_id}: {e}")

    def install_all_extensions(self) -> None:
        """Open URLs for all configured extensions"""
        for extension_id in Constants.EXTENSION_IDS:
            self.open_extension_url(extension_id)


def setup_logging() -> logging.Logger:
    """Configure and return logger instance"""
    logging.basicConfig(
        level=logging.DEBUG,
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[logging.StreamHandler()],
    )
    return logging.getLogger(__name__)


def get_browser_config(logger: logging.Logger) -> BrowserConfig:
    """Create and return browser configuration"""
    user = os.environ.get("USER")
    if not user:
        logger.error("USER environment variable not set")
        raise EnvironmentError("USER environment variable not set")

    return BrowserConfig(
        user_data_dir=f"/Users/{user}/Library/Application Support/BraveSoftware/Brave-Browser/Default",
        binary_location="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
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

        installer = ExtensionInstaller(logger)
        installer.install_all_extensions()

    except Exception as e:
        logger.error(f"Application failed -- {str(e)}", exc_info=True)
        raise


if __name__ == "__main__":
    main()
