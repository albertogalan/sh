#!/bin/bash 


repos="
docs
cheat
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

set_file (){
rm ~/$1
ln -s ~/.config/$1 ~/$1
}


install_dot(){
BRANCH=$1
mkdir -p $HOME/.config
mkdir -p $HOME/.ssh

# install .config dot
rm -rf $HOME/.config/
git clone --recurse-submodules --single-branch --depth 1 -b $BRANCH git@github.com:albertogalan/dotconfig.git $HOME/.config
#cd $HOME/.config/dotconfig ; git  --work-tree=$HOME/.config  checkout -f --

#prompt
git clone https://github.com/nojhan/liquidprompt.git $HOME/liquidprompt

# install vim flavour
#rm -rf /home/agalan/.vim
git clone -b bix --single-branch git@github.com:albertogalan/dotvim.git /home/agalan/.vim


# install tmux flavour
git clone  git@github.com:albertogalan/dottmux.git /home/agalan/.tmux

# config git
set_file .gitconfig
set_file .gitignore_global
set_file .git-commit-template
set_file .bashrc
set_file .bash_profile
set_file .ssh/config
set_file .cheat/conf.yml
set_file postinstall.sh



}


install_developer_packages(){

# install kubectl
mkdir -p ~/.kube

# config kitty


# docker
sudo usermod -aG docker ${USER}

# k9s

# config jira
pip3 install jira

# config gh
sudo apt install gitsome -y

# config bithucket cli
sudo gem install atlassian-stash
stash config 

# aws and jq
sudo apt install -y awscli jq

}

update_paths(){

echo 'PATH=$PATH:/home/agalan/go/bin' >> $HOME/.bashrc
echo 'PATH=$PATH:/home/agalan/go/bin' >> $HOME/.profile
source $HOME/.bashrc

}

cloning_repos
install_dot master
install_developer_packages
#update_paths
