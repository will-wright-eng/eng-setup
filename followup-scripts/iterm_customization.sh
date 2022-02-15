#!/usr/bin/env bash

###############################################################################
# do this after ssh key added to github account           					  #
###############################################################################

echo "PROMPT='%B%m%~%b$(git_super_status) %# '" >> ~/.zshrc

#https://formulae.brew.sh/formula-linux/zsh-autosuggestions
#https://github.com/ohmyzsh/ohmyzsh

# inspect install script before downloading
#wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#sh install.sh

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


echo "# initialize zsh customizations
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
" >> ~/.zshrc

## NOTE
# the following lines were added, in place of the default oh-my-zsh prompt
echo "# custom prompts
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b$(git_super_status) %# '
RPROMPT='%*'
" >> ~/.zshrc

## ssh setup
touch ~/.ssh/config
echo "Host ec2
  Hostname ec2-35-169-93-188.compute-1.amazonaws.com
  user ubuntu
  IdentityFile ~/.ssh/my-aws-key.pem
  Port 22" >> ~/.ssh/config

# extra stuff
#echo "" >> ~/.zshrc
#echo "alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql" >> ~/.zshrc
#chmod 700 ~/.snowsql/config
#chmod 700 ~/.aws/config

###############################################################################
# example .zshrc file
###############################################################################

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-prompt)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f %b$(git_super_status)%# '
RPROMPT='%*'

# initalize iterm customizations
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh