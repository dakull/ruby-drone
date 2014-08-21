#!/bin/bash
#
# Rails Ready
#
# Author: Josh Frye <joshfng@gmail.com>
# Licence: MIT
#
# Contributions from: Wayne E. Seguin <wayneeseguin@gmail.com>
# Contributions from: Ryan McGeary <ryan@mcgeary.org>
#
# http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p0.tar.gz
shopt -s nocaseglob
set -e

script_runner=$(whoami)
railsready_path=$(cd && pwd)/railsready
log_file="$railsready_path/install.log"
system_os=`uname | env LANG=C LC_ALL=C LC_CTYPE=C tr '[:upper:]' '[:lower:]'`

control_c()
{
  echo -en "\n\n*** Exiting ***\n\n"
  exit 1
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

clear

echo "#################################"
echo "########## Rails Ready ##########"
echo "#################################"

distro="ubuntu"

echo -e "\n\n"
echo "run tail -f $log_file in a new terminal to watch the install"

# Check if the user has sudo privileges.
sudo -v >/dev/null 2>&1 || { echo $script_runner has no sudo privileges ; exit 1; }

echo -e "\n\n!!! Set to install chruby via ruby-install for user: $script_runner !!! \n"

echo -e "\n=> Creating install dir..."
cd && mkdir -p railsready/src && cd railsready && touch install.log
echo "==> done..."

echo -e "\n=> Downloading and running recipe for $distro...\n"

# Download the distro specific recipe and run it, passing along all the variables as args
# Install build tools
pm='apt-get'
echo -e "\n=> Run update..."
sudo $pm -y update >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing build tools..."
sudo $pm -y install \
    wget curl build-essential clang \
    bison openssl zlib1g \
    libxslt1.1 libssl-dev libxslt1-dev \
    libxml2 libffi-dev libyaml-dev \
    libxslt-dev autoconf libc6-dev \
    libreadline6-dev zlib1g-dev libcurl4-openssl-dev \
    libtool >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing redis-server..."
sudo $pm -y install redis-server >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing imagemagick..."
sudo $pm -y install imagemagick libmagickwand-dev >> $log_file 2>&1
echo "==> done..."

# Install git-core
echo -e "\n=> Installing git, htop and vim..."
sudo $pm -y install git-core htop vim >> $log_file 2>&1
echo "==> done..."

# Install nginx
echo -e "\n=> Installing nginx..."
sudo $pm -y install nginx >> $log_file 2>&1
echo "==> done..."
echo -e "\n==> done running $distro specific commands..."

# Install Ruby-install
echo -e "\n=> Downloading ruby-install \n"
cd $railsready_path/src && wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz
echo -e "\n==> done..."
echo -e "\n=> Extracting"
tar -xzvf ruby-install-0.4.3.tar.gz >> $log_file 2>&1
echo "==> done..."
echo -e "\n=> Building ruby-install..."
cd ruby-install-0.4.3 && sudo make install >> $log_file 2>&1
echo "==> done..."

# Install chruby
echo -e "\n=> Downloading chruby \n"
cd $railsready_path/src && wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
echo -e "\n==> done..."
echo -e "\n=> Extracting"
tar -xzvf chruby-0.3.8.tar.gz >> $log_file 2>&1
echo "==> done..."
echo -e "\n=> Building chruby..."
cd chruby-0.3.8 && sudo make install >> $log_file 2>&1
echo "==> done..."

# Install Ruby stable
echo -e "\n=> Compiling Ruby 2.1.2 \n"
ruby-install ruby 2.1.2
echo "==> done..."

# Update bashrc and bashprofile
echo -e "\n=> Update bashrc and bash_profile with default chruby \n"
cat >> ~/.bashrc <<DELIM
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby ruby-2.1.2
DELIM
echo "source ~/.bashrc" >> ~/.bash_profile 2>&1
echo "==> done..."

# Reload bash
echo -e "\n=> Reloading shell so ruby and rubygems are available..."
source ~/.bashrc
echo "==> done..."

echo -e "\n=> Updating Rubygems..."
source ~/.bashrc && gem update --system --no-ri --no-rdoc >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing Bundler..."
source ~/.bashrc && gem install bundler --no-ri --no-rdoc -f >> $log_file 2>&1
echo "==> done..."

echo -e "\n#################################"
echo    "### Installation is complete! ###"
echo -e "#################################\n"
