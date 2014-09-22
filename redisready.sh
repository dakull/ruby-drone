#!/bin/bash
#
# Based on Rails Ready
#
# Original Author: Josh Frye <joshfng@gmail.com>
# Licence: MIT
#
# Contributions from: Wayne E. Seguin <wayneeseguin@gmail.com>
# Contributions from: Ryan McGeary <ryan@mcgeary.org>
# Contributions from: Marian Posaceanu
#
shopt -s nocaseglob
set -e

script_runner=$(whoami)
redisready_path=$(cd && pwd)/redisready
log_file="$redisready_path/install.log"
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
echo "##### Redis Server Ready ########"
echo "#################################"

distro="ubuntu"

echo -e "\n"
echo "run tail -f $log_file in a new terminal to watch the install"

# Check if the user has sudo privileges.
sudo -v >/dev/null 2>&1 || { echo $script_runner has no sudo privileges ; exit 1; }

echo -e "\n=> Creating install dir..."
cd && mkdir -p redisready/src && cd redisready && touch install.log
echo "==> done..."

echo -e "\n\n!!! Set to install chruby via ruby-install for user: $script_runner !!! \n"

pm='apt-get'
echo -e "\n=> Run apt-get update..."
sudo $pm -y update >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing redis-server..."
sudo $pm -y install redis-server >> $log_file 2>&1
echo "==> done..."

echo -e "\n#################################"
echo    "### Installation is complete! ###"
echo -e "#################################\n"