#!/usr/bin/env bash

# ~/pydata.sh

# Removed user's cached credentials
# This script might be run with .dots, which uses elevated privileges
sudo -K

echo "------------------------------"
echo "Setting up pip."

# Install pip
# easy_install pip easy_install has been deprecated
# source: https://stackoverflow.com/questions/17271319/how-do-i-install-pip-on-macos-or-os-x
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

###############################################################################
# Virtual Enviroments                                                         #
###############################################################################

echo "------------------------------"
echo "Setting up virtual environments."

# Install virtual environments globally
# It fails to install virtualenv if PIP_REQUIRE_VIRTUALENV was true
export PIP_REQUIRE_VIRTUALENV=false
pip install virtualenv
pip install virtualenvwrapper

# echo "------------------------------"
# echo "Source virtualenvwrapper from ~/.extra"

# EXTRA_PATH=~/.extra
# echo $EXTRA_PATH
# echo "" >> $EXTRA_PATH
# echo "" >> $EXTRA_PATH
# echo "# Source virtualenvwrapper, added by pydata.sh" >> $EXTRA_PATH
# echo "export WORKON_HOME=~/.virtualenvs" >> $EXTRA_PATH
# echo "source /usr/local/bin/virtualenvwrapper.sh" >> $EXTRA_PATH
# echo "" >> $BASH_PROFILE_PATH
# source $EXTRA_PATH

# ###############################################################################
# # Python 2 Virtual Enviroment                                                 #
# ###############################################################################

# echo "------------------------------"
# echo "Setting up py2-data virtual environment."

# # Create a Python2 data environment
# mkvirtualenv py2-data
# workon py2-data

# # Install Python data modules
# pip install numpy
# pip install scipy
# pip install matplotlib
# pip install pandas
# pip install sympy
# pip install nose
# pip install unittest2
# pip install seaborn
# pip install scikit-learn
# pip install "ipython[all]"
# pip install bokeh
# pip install Flask
# pip install sqlalchemy
# pip install mysql-python

###############################################################################
# Python 3 Virtual Enviroment                                                 #
###############################################################################

touch ~/.zshrc
echo "alias python='python3'" >> ~/.zshrc
echo "alias pip='pip3'" >> ~/.zshrc

echo "------------------------------"
# echo "Setting up py3-data virtual environment."

# # Create a Python3 data environment
# mkvirtualenv --python=/usr/local/bin/python3 py3-data
# workon py3-data

# Install Python data modules
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install sympy
pip install nose
pip install unittest2
pip install seaborn
pip install scikit-learn
pip install "ipython[all]"
pip install bokeh
pip install Flask
pip install mysqlclient

# needed for Sentinel
pip install pyspark
pip install sqlalchemy
pip install snowflake-sqlalchemy
pip install great_expectations

