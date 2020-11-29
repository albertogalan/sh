#!/bin/bash
#Usage bash < (curl  -s repo.sh ) 
echo "https://gist.github.com/bf98f49269664eff6b2bc47292562ae2"

if [[ $# -eq 0 ]]; then
  echo "$red This command send environment setup through ssh  $reset"
  echo "Usage: $green BRANCH dev2/dot-branch $reset"
  echo "Usage: ${FUNCNAME[0]} $green @HOST} {debian/redhat} $reset"
  echo "Usage: ${FUNCNAME[0]} branch agalan@host dotbasic"
  exit 0
fi



MAINUSER=agalan

DISTRIBUTION="$1"
    

if [ "$DISTRIBUTION" == "debian" ]; then
    package_manager="apt"
else
    package_manager="yum"
fi


sudo $package_manager update
sudo $package_manager -y install python-simplejson
sudo $package_manager install -y openssh-server

LINE="%$MAINUSER ALL=(ALL:ALL) NOPASSWD:ALL" 
FILE=/etc/sudoers
grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"

sudo adduser $MAINUSER
sudo adduser $MAINUSER admin sudoers
sudo usermod -u 1004 $MAINUSER	
sudo groupmod -g 1004 $MAINUSER
sudo mkdir -p /home/$MAINUSER/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaWulObziluJLzVk7tmEDfkAKpCHEmp4AFvnQVhh6Yof40s2yfz1h/bMCfBstg+jLz86K99DV/tnIDtxXRx2GfGVz11l/BSuhStUDu9RKxZYN4DhMzc31/vwIWWP/P4vnJX96+JlcfF+0hbXmqfHhlcJACT7nRFuQrtVs+REAyJG/3ZuWNH1jvSKmXJYRj+CeCl0hElYtf+bF3JCEnmXl+ezUQcIXyhJ3loPhuEoGPHjHP8gZmiSjUn5SHaLkH1JPt6A/DvpxyPHdFmopL/HxFJEPxF4m5hCLleM2do3r5Owe4lmmOGgANkRLhS8b/Mmqe0mjOno9gYGYcnJ4iaPa9 $MAINUSER@neolearn" | sudo tee -a /home/$MAINUSER/.ssh/authorized_keys
sudo chmod 600 /home/$MAINUSER/.ssh/authorized_keys
sudo chown $MAINUSER:$MAINUSER -R  /home/$MAINUSER/.ssh
sudo adduser $MAINUSER sudo
echo introduce github deploy-key
sudo su -c  "ls /home/$MAINUSER/.ssh/$MAINUSER-github-key || vim /home/$MAINUSER/.ssh/$MAINUSER-github-key" - agalan
sudo $package_manager install -y docker.io
sudo $package_manager install -y ansible
sudo su -c "`ssh-agent -s`" - agalan
sudo su -c "ssh-add /home/agalan/.ssh/agalan-github-key"
sudo su -c "cd /home/agalan/;git clone git@github.com:albertogalan/devops-desk.git" - agalan


