#!/usr/bin/env bash

###############################################################################
# do this after ssh key added to github account           					  #
###############################################################################

# git branch indicator in iTerm
# cd repos/
# git clone git@github.com:zsh-git-prompt/zsh-git-prompt.git
# touch ~/.zshrc
# VAR1='/zsh-git-prompt/zshrc.sh'
# VAR2=$(pwd)
# echo "source $VAR2$VAR1" >> ~/.zshrc

echo "PROMPT='%B%m%~%b$(git_super_status) %# '" >> ~/.zshrc

#https://formulae.brew.sh/formula-linux/zsh-autosuggestions
#https://github.com/ohmyzsh/ohmyzsh

# inspect install script before downloading
#wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#sh install.sh

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# echo "" >> ~/.zshrc
# echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

# extra stuff
#echo "" >> ~/.zshrc
#echo "alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql" >> ~/.zshrc
#chmod 700 ~/.snowsql/config
#chmod 700 ~/.aws/config

brew install zsh
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

echo "# initialize zsh customizations
source /Users/willwright/repos/zsh-git-prompt/zshrc.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
" >> ~/.zshrc

## NOTE
# the following lines were added, in place of the default oh-my-zsh prompt
echo "# custom prompts
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b$(git_super_status) %# '
RPROMPT='%*'
" >> ~/.zshrc