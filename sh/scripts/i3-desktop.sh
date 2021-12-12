#!/bin/bash

sudo apt update
sudo apt install -y net-tools 
sudo apt install -y ranger i3 xrdp 
sudo systemctl restart xrdp.service
#sudo apt install tightvncserver
sudo apt install -y firefox ranger kitty

# Sound
# https://itsfoss.com/fix-sound-ubuntu-1304-quick-tip/
sudo apt install alsa-base pulseaudio -y
#pulseaudio --start

# Installing tools
sudo apt install -y docker.io ansible
sudo apt install curl wget fzf python3-minimal npm --no-install-recommends -y
sudo apt install -y vim libgtk2.0-0 silversearcher-ag ripgrep nodejs ssh git

## add agalan
sudo useradd -m -s /bin/bash -U agalan -u 666 
cp -pr /home/vagrant/.ssh /home/agalan/
sudo chown -R agalan:agalan /home/agalan
echo "%agalan ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/agalan

## install dot files
mkdir -p  /home/agalan/.config
git clone https://github.com/albertogalan/sh.git /tmp/sh
rsync -av /tmp/sh/dot/  /home/agalan/.config/
rsync -av /tmp/sh/dot/  /home/vagrant/.config/
sudo chown -R agalan:agalan  /home/agalan/.config
sudo chown -R vagrant:vagrant  /home/vagrant/.config

#sudo su -c "`ssh-agent -s`" - agalan
#sudo su -c "ssh-add /home/agalan/.ssh/agalan-github-key" - agalan

## Adding data folder 
sudo mkdir -p /data/src
sudo chown -R agalan:agalan /data
# adding folder for swap files for vim
mkdir -p /home/agalan/tmp


sudo apt install -y ruby
# Install home brew with no prompt
URL_BREW='https://raw.githubusercontent.com/Homebrew/install/master/install'
echo -n '- Installing brew ... '
echo | /usr/bin/ruby -e "$(curl -fsSL $URL_BREW)" > /dev/null
if [ $? -eq 0 ]; then echo 'OK'; else echo 'NG'; fi
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'  >> /home/vagrant/.profile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'  >> /home/agalan/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#brew install tfenv tgenv tfsec



## install in agalan user
sudo su -c "git clone --branch 0.25.0 --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && echo yes | /home/agalan/.fzf/install" - agalan

ifconfig | grep 192

sudo reboot

