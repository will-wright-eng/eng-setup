#!/usr/bin/env bash

###############################################################################
# do this after ssh key added to github account           					  #
###############################################################################

#https://formulae.brew.sh/formula-linux/zsh-autosuggestions
#https://github.com/ohmyzsh/ohmyzsh

# inspect install script before downloading
#wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#sh install.sh

# ohmyzsh overwrites .zshrc file -- copy contents and reinsert after run

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## ssh setup
touch ~/.ssh/config
echo "Host ec2
  Hostname ec2-35-169-93-188.compute-1.amazonaws.com
  user ubuntu
  IdentityFile ~/.ssh/my-aws-key.pem
  Port 22" >> ~/.ssh/config

# replaces existing zshrc file!!!
touch ~/.zshrc
echo '
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Example format: plugins=(rails git textmate ruby lighthouse)
# others: https://travis.media/top-10-oh-my-zsh-plugins-for-productive-developers/
plugins=(git git-prompt)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# initalize iterm customizations
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# google cloud sdk
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

eval $(thefuck --alias)

eval "$(direnv hook zsh)"

' > ~/.zshrc

echo "exiting script"
exit 1

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

# initalize iterm customizations
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# google cloud sdk
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

eval $(thefuck --alias)
