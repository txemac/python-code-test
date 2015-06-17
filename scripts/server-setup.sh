#!/bin/bash
# Server Setup
#
# Script to install all the requirements for the server-side part of the Infinity Health project

# Note that we may want to tighten it up a little for production - e.g. better DB user privs.

# Grab the environment var, default to 'dev'
ENV=${1-dev}
# ... and pick up related vars
source /vagrant/config/$ENV.sh

# Grab the user var, default to 'vagrant'
USER=${2-vagrant}

echo -e "\033[0;34m > Provisioning Vagrant server, with the following parameters:\033[0m"
echo -e "\033[0;34m > Environment: $ENV\033[0m"
echo -e "\033[0;34m > Main User:   $USER\033[0m"

# Housekeeping
apt-get update
apt-get install -y git vim

# Python environment and tools
apt-get install -y python-setuptools python2.7 build-essential python-dev libncurses5-dev fabric
easy_install pip
pip install virtualenv virtualenvwrapper

# Postgres DB setup
apt-get install -y postgresql-9.3 postgresql-client-9.3 postgresql-server-dev-9.3
echo -e "\033[0;34m > Setting up DB. If it already exists this will generate warnings, but no harm will be done.\033[0m"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME ENCODING='UTF8' TEMPLATE=template0;"
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
if [ $ENV == 'dev' -o $ENV == 'test' ]
    then
        sudo -u postgres psql -c "ALTER USER $DB_USER CREATEDB;"
fi

echo -e "\033[0;34m > Installing all the image support libs for pillow.\033[0m"
sudo apt-get install -y libjpeg62-dev zlib1g-dev libfreetype6-dev liblcms1-dev

# do the rest as the user we'll be logging in as through SSH
chmod +x /vagrant/scripts/server-setup-user.sh
sudo -u $USER /vagrant/scripts/server-setup-user.sh $ENV $USER

# install requirements
echo -e "\033[0;34m > Installing the pip requirements.\033[0m"
sudo -H -u vagrant /home/vagrant/.virtualenvs/le-code-test/bin/pip install -r /vagrant/requirements.txt
