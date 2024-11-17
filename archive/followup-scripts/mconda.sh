#!/usr/bin/env bash

# docs
#https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html

# turning off auto activate base
#https://stackoverflow.com/questions/54429210/how-do-i-prevent-conda-from-activating-the-base-environment-by-default

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
# when prompted "Do you wish the installer to initialize Miniconda3 by running conda init?" type 'yes'

rm ~/miniconda.sh

source $HOME/miniconda/bin/activate

### MAKE SURE THE FOLLOWING CONTENTS ARE ADDED TO `.zshrc`

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ww931d/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ww931d/miniconda/etc/profile.d/conda.sh" ]; then
        . "/Users/ww931d/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ww931d/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

###
# ...continued:

conda init zsh
conda config --set auto_activate_base false

# use `conda create -n mypython3 python=3` to create new envs
