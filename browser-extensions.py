import os
from pathlib import Path

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# from selenium import webdriver
# from webdriver_manager.chrome import ChromeDriverManager

# driver = webdriver.Chrome(ChromeDriverManager().install(), options=chrome_options)
# driver.get("https://www.google.com/")

extension_ids = [
    'mghlhfaogogibkliffpabpjoekdnenha',
    'eimadpbcbfnmbkopoojfekhnkhdbieeh',
    'nlnkcinjjeoojlhdiedbbolilahmnldj'
]

def main():
    for extension_id in extension_ids:
        print(f'https://chrome.google.com/webstore/detail/{extension_id}')

def _main():
    # Setup Chrome options
    chrome_options = webdriver.ChromeOptions()
    user = os.environ.get('USER')
    chrome_options.add_argument(f"--user-data-dir=/Users/{user}/Library/Application Support/Google/Chrome/Default")

    # Path to your ChromeDriver
    p = Path('.').resolve() / 'chromedriver_mac64' / 'chromedriver'
    service = Service(p)

    # raise ValueError(p)

    # Create a new instance of the Chrome driver
    driver = webdriver.Chrome(service=service, options=chrome_options)

    extension_ids = [
        'mghlhfaogogibkliffpabpjoekdnenha',
        'eimadpbcbfnmbkopoojfekhnkhdbieeh',
        'nlnkcinjjeoojlhdiedbbolilahmnldj'
    ]

    for extension_id in extension_ids:
        # Go to the extension page
        driver.get(f'https://chrome.google.com/webstore/detail/{extension_id}')
        
        # Wait for the page to load
        time.sleep(5)  # Adjust the sleep time as needed

        try:
            # Check if the extension is already installed
            already_installed = driver.find_elements(By.XPATH, '//span[contains(text(), "Remove from Chrome")]')
            if already_installed:
                print(f"Extension {extension_id} is already installed.")
                continue

            # Trigger the installation process
            install_button = driver.find_element(By.XPATH, '//button[contains(text(), "Add to Chrome")]')
            install_button.click()
            
            # Confirm the installation in the dialog
            time.sleep(2)  # Adjust the sleep time as needed
            confirm_button = driver.find_element(By.XPATH, '//button[contains(text(), "Add extension")]')
            confirm_button.click()
            
            # Wait for the installation to complete
            time.sleep(5)  # Adjust the sleep time as needed
        except Exception as e:
            print(f"Failed to install extension {extension_id}: {e}")

    # Close the browser
    driver.quit()

if __name__ == "__main__":
    main()
