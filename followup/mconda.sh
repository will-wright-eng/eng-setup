#!/usr/bin/env bash

# https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html

# # download miniconda install file 
# curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh --output Miniconda3-latest-MacOSX-x86_64.sh
# bash Miniconda3-latest-MacOSX-x86_64.sh

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda

# when prompted "Do you wish the installer to initialize Miniconda3 by running conda init?" type 'yes'