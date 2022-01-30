#!/usr/bin/env bash
#Install brew and qemu + cloud init metadata dependencies
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
#brew install qemu
#brew install cdrtools

#rm -rf $mainPath

mainPath=$PWD/tmp/images

#download Ubuntu 20.04 Cloud Image and resize to 30 Gigs
mkdir -p $mainPath/images
cd $mainPath/images
wget -nc -O  $mainPath/images/focal-server-cloudimg-amd64.img https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img 
qemu-img resize focal-server-cloudimg-amd64.img 30G

#create the cloud-init NoCloud metadata disk file
mkdir -p $mainPath/cloudinitmetadata
cd $mainPath/cloudinitmetadata
#ssh-keygen -b 2048 -t rsa -f id_rsa_ubuntu2004boot -P ""
#chmod 0600 $mainPath/cloudinitmetadata/id_rsa_ubuntu2004boot
#PUBLIC_KEY=$(cat id_rsa_ubuntu2004boot.pub)

cat <<EOF >$mainPath/cloudinitmetadata/meta-data
instance-id: neoxv-local716
local-hostname: neoxv
EOF

cat <<EOF >$mainPath/cloudinitmetadata/user-data
#cloud-config

## Set hostname
hostname: neoxv

## Configure default user
system_info:
  default_user:
    name: vagrant
    password: vagrant
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkt0vkmVLJeFm2GG+G/aSrsK/xLoXSe80AyOaTdLYd0Y7InzK0knkvU+iDyz4VOGCQyIC66t026qhXwFwQy981SgwFzwleGd909UOSu4ntkAFLmWxTAKe0X/YuVE+rSEyF3fpCbyVKhn0uwBAKpVrJ3uxISm3s+hUX0/mralUf6qooyQsOjbWPgUCBqsDKzYCQEmZez3s4AuAiQzzLmT/imB35rElBBj2xv7AQmbs0D2k/XiVdYd+yy4uTOJxQBOQcRW6N2Yhyi6/5f2GUAPzfYsKyyIFxQhVpmyTSiGucC9+OxKDYmzrhYVBar+h14ulnjgDqrd8daefqWc0NTUTFCjLjhL0O57g9pnaxJFw2vpx3rDNflg1VqB82W6AGqGsGdzy2KFEYC8OTrByIh9HfsA1eKGemttTlESi7K3Mkzc0IawdZpK8M9m8JtuR4F6nEJ9clqhgXM17WG0SK0Jr5mMfqjexAQRn6U6QRlUpkp7XCOndTk3T3nb2iGbczAg0= agalan@neobi
    sudo: ALL=(ALL) NOPASSWD:ALL

users:
  - name: agalan
    gecos: agalan
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    lock_passwd: true
    ssh_authorized_keys:
    passwd: mypass
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkt0vkmVLJeFm2GG+G/aSrsK/xLoXSe80AyOaTdLYd0Y7InzK0knkvU+iDyz4VOGCQyIC66t026qhXwFwQy981SgwFzwleGd909UOSu4ntkAFLmWxTAKe0X/YuVE+rSEyF3fpCbyVKhn0uwBAKpVrJ3uxISm3s+hUX0/mralUf6qooyQsOjbWPgUCBqsDKzYCQEmZez3s4AuAiQzzLmT/imB35rElBBj2xv7AQmbs0D2k/XiVdYd+yy4uTOJxQBOQcRW6N2Yhyi6/5f2GUAPzfYsKyyIFxQhVpmyTSiGucC9+OxKDYmzrhYVBar+h14ulnjgDqrd8daefqWc0NTUTFCjLjhL0O57g9pnaxJFw2vpx3rDNflg1VqB82W6AGqGsGdzy2KFEYC8OTrByIh9HfsA1eKGemttTlESi7K3Mkzc0IawdZpK8M9m8JtuR4F6nEJ9clqhgXM17WG0SK0Jr5mMfqjexAQRn6U6QRlUpkp7XCOndTk3T3nb2iGbczAg0= agalan@neobi

timezone: Madrid


EOF

#create the cloud-init optical drive
mkisofs -output cidata.iso -volid cidata -joliet -rock user-data meta-data

#boot the machine up
qemu-system-x86_64 -m 2048 -smp 4 -hda $mainPath/images/focal-server-cloudimg-amd64.img -cdrom $mainPath/cloudinitmetadata/cidata.iso -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2224-:22 -nographic
