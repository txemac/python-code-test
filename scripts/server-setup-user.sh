#!/bin/bash
# VirtualEnv and Django setup
#
# This is a distinct file as it's meant to be run as the primary user we SSH in as

# Grab the environment var, default to 'dev'
ENV=${1-dev}
# ... and pick up related vars
source /vagrant/config/$ENV.sh

# Grab the user var, default to 'vagrant'
USER=${2-vagrant}

echo -e "\033[0;34m > Running main-user setup script, with the following parameters:\033[0m"
echo -e "\033[0;34m > Environment: $ENV\033[0m"
echo -e "\033[0;34m > Main User:   $USER\033[0m"

# Set up virtualenv directory for the user if required
if [ ! -d /home/$USER/.virtualenvs ]; then
    echo -e "\033[0;31m > Creating .virtualenvs folder"
    mkdir /home/$USER/.virtualenvs
fi

# write all the profile stuff for the user if required
grep -q WORKON /home/$USER/.bashrc
if [ $? -ne 0 ]; then
    echo -e "\033[0;31m > Updating profile file\033[0m"
    echo "export WORKON_HOME=~/.virtualenvs" >> /home/$USER/.bashrc
    echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/$USER/.bashrc
    echo "export PIP_VIRTUALENV_BASE=~/.virtualenvs" >> /home/$USER/.bashrc
    echo "workon le-code-test" >> /home/$USER/.bashrc
    echo "cd /vagrant/" >> /home/$USER/.bashrc
fi

echo -e "\033[0;34m > Setting up virtualenv\033[0m"
export WORKON_HOME=/home/$USER/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=/home/$USER/.virtualenvs
mkvirtualenv le-code-test
workon le-code-test
