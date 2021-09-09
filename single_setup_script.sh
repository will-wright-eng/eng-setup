#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Run the brew.sh Script
# For a full listing of installed formulae and apps, refer to
# the commented brew.sh source file directly and tweak it to
# suit your needs.
echo ""
echo "------------------------------"
echo "Installing Homebrew along with some common formulae and apps."
echo "This might take a while to complete, as some formulae need to be installed from source."
echo "------------------------------"
echo ""
./auto-scripts/brew.sh

# Run the osx.sh Script
# I strongly suggest you read through the commented osx.sh
# source file and tweak any settings based on your personal
# preferences. The script defaults are intended for you to
# customize. For example, if you are not running an SSD you
# might want to change some of the settings listed in the
# SSD section.
echo ""
echo "------------------------------"
echo "Setting sensible OSX defaults."
echo "------------------------------"
echo ""
./auto-scripts/osx.sh

# Run the pydata.sh Script
echo "------------------------------"
echo "Setting up Python data development environment."
echo "------------------------------"
echo ""
./auto-scripts/pydata.sh

# Run the aws.sh Script
# dependent upon virtualenvwrapper in ./pydata.sh
echo "------------------------------"
echo "Setting up AWS development environment."
echo "------------------------------"
echo ""
./auto-scripts/aws.sh

# # Run the secrets.sh script
# echo "------------------------------"
# echo "Apply secrets from folder."
# echo "------------------------------"
# echo ""
# ./secrets.sh

echo "------------------------------"
echo "auto-scripts complete."
echo "------------------------------"
echo "See scripts in followup folder and modify appropriately before running."
echo "------------------------------"
echo ""