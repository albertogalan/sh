#!/bin/bash 


repos="
docs
cheatsheet
dotvim
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

rsync -a /data/src/dotvim/  /home/agalan/.vim/


# install cheat
pip install cheat
rsync -a /data/src/cheatsheet/  /home/agalan/.cheat/
echo 'export CHEAT_CONFIG_PATH="~/.cheat/conf.yml"' >> $HOME/.profile
echo 'export CHEAT_CONFIG_PATH="~/.cheat/conf.yml"' >> $HOME/.bashrc
echo 'export CHEAT_USE_FZF=true' >> $HOME/.profile
echo 'export CHEAT_USE_FZF=true' >> $HOME/.bashrc
}


cloning_repos
sync_dot
