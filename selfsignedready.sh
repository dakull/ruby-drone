#!/bin/bash
#
# Self Signed Cert Ready
#
# Author: Posaceanu Marian
# Licence: MIT
#
shopt -s nocaseglob
set -e

script_runner=$(whoami)

control_c()
{
  echo -en "\n\n*** Exiting ***\n\n"
  exit 1
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

clear

echo "#################################"
echo "##########  SSC Ready  ##########"
echo "#################################"

distro="ubuntu"

# Check if the user has sudo privileges.
sudo -v >/dev/null 2>&1 || { echo $script_runner has no sudo privileges ; exit 1; }

echo -e "\n\n!!! Set to install self signed cert for nginx. \n"
cd /etc/nginx && sudo mkdir ssl && cd ssl && sudo openssl req -new -x509 -nodes -out server.crt -keyout server.key && sudo chmod 600 server.key
echo "==> done..."
