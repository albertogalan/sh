#!/bin/bash 


repos="
docs
cheatsheet
dot-tldr
"


cloning_repos(){


eval `ssh-agent -s`
ssh-add /home/agalan/.ssh/agalan-github-key

for repo in $repos
do
git clone git@github.com:albertogalan/$repo.git /data/src/$repo
done

}

sync_dot(){


# install vim flavour
rm -rf /home/agalan/.vim
git clone -b bix --single-branch git@github.com:albertogalan/dotvim.git /home/agalan/.vim

# install initial scripts
git clone --depth 1 git@github.com:albertogalan/dotconfig.git /data/src/dotconfig
rsync -a /data/src/dotconfig/sh ~/.config/
rsync -a /data/src/dotconfig/apps ~/.config/
cp ~/.config/sh/.bashrc ~/.bashrc
cp ~/.config/sh/.bash_profile ~/.bashrc_profile
rsync -a /data/src/dotconfig/ssh/config  ~/.config/.ssh/config

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo cp kubectl /usr/local/bin/
sudo chmod 755 /usr/local/bin/kubectl
mkdir ~/.kube



# install cheat
go get -u github.com/cheat/cheat/cmd/cheat
mkdir -p /home/agalan/.config/cheat

# adding config and helpers
git clone git@github.com:albertogalan/cheat.git /home/agalan/.config/cheat/

echo 'export CHEAT_CONFIG_PATH="~/.cheat/conf.yml"' >> $HOME/.profile
echo 'export CHEAT_CONFIG_PATH="~/.cheat/conf.yml"' >> $HOME/.bashrc
echo 'export CHEAT_USE_FZF=true' >> $HOME/.profile
echo 'export CHEAT_USE_FZF=true' >> $HOME/.bashrc
}

update_paths(){

echo 'PATH=$PATH:/home/agalan/go/bin' >> $HOME/.bashrc
echo 'PATH=$PATH:/home/agalan/go/bin' >> $HOME/.profile
source $HOME/.bashrc

}

cloning_repos
sync_dot
update_paths
