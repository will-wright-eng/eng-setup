#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install `wget` with IRI support.
brew install wget #--with-iri

# Install Python
brew install python
brew install python3
# brew install apache-spark

# Install more recent versions of some OS X tools.
brew install vim #--override-system-vi
brew install grep
brew install openssh

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install binutils
brew install nmap

# Install other useful binaries.
brew install ack
brew install git
brew install gh
brew install tree

# Komodo stack
#brew install --cask snowflake-snowsql
#brew install gimme-aws-creds


brew install htop
brew install awscli
brew install direnv
brew install jupyterlab

brew install --cask vlc
brew install --cask spotify
brew install --cask transmission
brew install --cask the-unarchiver
brew install --cask microsoft-excel

# Core casks
brew install --cask --appdir="~/Applications" iterm2
brew install --cask --appdir="~/Applications" java

# Development tool casks
brew install --cask --appdir="/Applications" sublime-text
brew install --cask --appdir="/Applications" macdown
#brew install --cask --appdir="/Applications" postico
#brew install --cask --appdir="/Applications" postman

# Misc casks
brew install --cask --appdir="/Applications" brave-browser
brew install --cask --appdir="/Applications" slack
brew install --cask --appdir="/Applications" zoom

# Install Docker, which requires virtualbox
brew install docker
brew install boot2docker

# Remove outdated versions from the cellar.
brew cleanup
