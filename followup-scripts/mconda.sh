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
conda init zsh
conda config --set auto_activate_base false

# use `conda create -n mypython3 python=3` to create new envs