#!/usr/bin/env bash

###############################################################################
# do this after ssh key added to github account           					  #
###############################################################################

brew install zsh
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

touch ~/.zshrc
echo "" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

## change settings in profile
# Colors: set color preset to 'Solarized Dark' with 'Selection' slightly darker than 'Background' (adjusting contrast as necessary)
# Keys: 'Left Option Key' set to 'Esc+'
# https://stackoverflow.com/questions/18923765/bash-keyboard-shortcuts-in-iterm-like-altd-and-altf

## Other resources
# https://medium.com/@beatrizmrg/gaining-efficiency-with-iterm-prompt-customization-on-macos-3ad212f5bfde
# https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/
# https://formulae.brew.sh/formula-linux/zsh-autosuggestions
# https://github.com/ohmyzsh/ohmyzsh

# install ohmyzsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# inspect install script before downloading
#wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#sh install.sh

# cd ~
# curl -O https://raw.githubusercontent.com/donnemartin/dev-setup/master/.gitconfig