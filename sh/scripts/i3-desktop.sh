#!/bin/bash


adding_user() {

## add agalan
sudo useradd -m -s /bin/bash -U agalan -u 666 
cp -pr /home/vagrant/.ssh /home/agalan/
echo "%agalan ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/agalan

## Adding data folder 
sudo mkdir -p /data/src
sudo chown -R agalan:agalan /data

# adding folder for swap files for vim
mkdir -p /home/agalan/tmp

# Copy post install
curl https://raw.githubusercontent.com/albertogalan/sh/develop/sh/scripts/postinstall.sh -o /tmp/postinstall.sh
sudo cp /tmp/postinstall.sh /home/agalan/postinstall.sh
sudo chmod 755 /home/agalan/postinstall.sh
 
sudo chown -R agalan:agalan /home/agalan

}

adding_basic_dotfiles(){

## install dot files
mkdir -p  /home/agalan/.config
git clone https://github.com/albertogalan/sh.git /tmp/sh
rsync -a /tmp/sh/dot/  /home/agalan/.config/
rsync -a /tmp/sh/dot/  /home/vagrant/.config/
sudo chown -R agalan:agalan  /home/agalan/.config
sudo chown -R vagrant:vagrant  /home/vagrant/.config

}


installation_packages() {

sudo apt update
sudo apt install -y python3-pip 
sudo apt install -y net-tools 
sudo apt install -y golang-go
sudo apt install -y ranger i3 xrdp 
sudo apt install -y ack 
sudo apt install -y ruby
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

# Install home brew with no prompt
yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'  >> /home/vagrant/.profile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'  >> /home/agalan/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#brew install tfenv tgenv tfsec



## install in agalan user
sudo su -c "git clone --branch 0.25.0 --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && echo yes | /home/agalan/.fzf/install" - agalan

ifconfig | grep 192

sudo reboot
}

sound (){
# 
# reinstall kernel
sudo install --reinstall linux-image-generic
sudo apt install alsa-oss -y
sudo xrdp-pulseaudio-installer -y
sudo modprobe 
aplay -l
# add the corresponding module module
sudo modprobe snd-hda-intel

}

adding_user
adding_basic_dotfiles
installation_packages
sound
