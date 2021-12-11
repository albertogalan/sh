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

# Network tools
sudo $package_manager install net-tools -y

# Sound
# https://itsfoss.com/fix-sound-ubuntu-1304-quick-tip/
#sudo $package_manager install alsa-base pulseaudio -y
#pulseaudio --start

# Graphical environment
sudo $package_manager install -y i3 xinit xrdp ranger autojump

# Browser
sudo $package_manager install -y firefox

# kitty Terminal 
#curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
sudo $package_manager install -y kitty

# Tools
sudo $package_manager install -y docker.io ansible
sudo $package_manager install curl wget fzf python3-minimal npm --no-install-recommends -y
git clone --branch 0.25.0 --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && echo yes | ~/.fzf/install
sudo $package_manager install -y vim libgtk2.0-0 silversearcher-ag ripgrep nodejs ssh git


# Add Home Brew
#curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

LINE="%$MAINUSER ALL=(ALL:ALL) NOPASSWD:ALL" 
FILE=/etc/sudoers
grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"

#sudo adduser $MAINUSER
#sudo adduser $MAINUSER admin sudoers
#sudo usermod -u 1004 $MAINUSER	
#sudo groupmod -g 1004 $MAINUSER
sudo mkdir -p /home/$MAINUSER/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaWulObziluJLzVk7tmEDfkAKpCHEmp4AFvnQVhh6Yof40s2yfz1h/bMCfBstg+jLz86K99DV/tnIDtxXRx2GfGVz11l/BSuhStUDu9RKxZYN4DhMzc31/vwIWWP/P4vnJX96+JlcfF+0hbXmqfHhlcJACT7nRFuQrtVs+REAyJG/3ZuWNH1jvSKmXJYRj+CeCl0hElYtf+bF3JCEnmXl+ezUQcIXyhJ3loPhuEoGPHjHP8gZmiSjUn5SHaLkH1JPt6A/DvpxyPHdFmopL/HxFJEPxF4m5hCLleM2do3r5Owe4lmmOGgANkRLhS8b/Mmqe0mjOno9gYGYcnJ4iaPa9 $MAINUSER@neolearn" | sudo tee -a /home/$MAINUSER/.ssh/authorized_keys
sudo chmod 600 /home/$MAINUSER/.ssh/authorized_keys
sudo chown $MAINUSER:$MAINUSER -R  /home/$MAINUSER/.ssh
sudo adduser $MAINUSER sudo
#echo introduce github deploy-key
#sudo su -c  "ls /home/$MAINUSER/.ssh/$MAINUSER-github-key || vim /home/$MAINUSER/.ssh/$MAINUSER-github-key" - agalan

sudo su -c "`ssh-agent -s`" - agalan
sudo su -c "ssh-add /home/agalan/.ssh/agalan-github-key"



## Adding data folder 
sudo mkdir -p /data/src
sudo chown -R agalan:agalan /data
# adding folder for swap files for vim
mkdir -p /home/agalan/tmp

sudo su -c "cd /data/src/;git clone git@github.com:albertogalan/devops-desk.git" - agalan
sudo su -c "cd /data/src/;git clone https://github.com/albertogalan/dotconfig.git" - agalan
sudo su -c "cd /data/src/;git clone https://github.com/albertogalan/dotvim.git" - agalan
sudo su -c "cd /data/src/;git clone https://github.com/albertogalan/docs.git" - agalan
sudo su -c "cd /data/src/;git clone https://github.com/albertogalan/cheatsheet.git" - agalan

echo "you need to sync from computer .tmux .vim .gitconfig .profile .bashrc ranger"
echo  "you need to sync from repo /data/src/dotconfig/kitty"
echo  "you need to sync from repo /data/src/cheatsheet"

