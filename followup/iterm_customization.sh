#!/usr/bin/env bash

###############################################################################
# do this after ssh key added to github account           					  #
###############################################################################

# git branch indicator in iTerm
cd repos/
git clone git@github.com:zsh-git-prompt/zsh-git-prompt.git
touch ~/.zshrc
VAR1='/zsh-git-prompt/zshrc.sh'
VAR2=$(pwd)
echo "source $VAR2$VAR1" >> ~/.zshrc
echo "PROMPT='%B%m%~%b$(git_super_status) %# '" >> ~/.zshrc

#https://formulae.brew.sh/formula-linux/zsh-autosuggestions
#https://github.com/ohmyzsh/ohmyzsh

# check for 
#brew install zsh

# inspect install script before downloading
#wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#sh install.sh

cd

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh-autosuggestions
brew install zsh-autosuggestions

echo "" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc