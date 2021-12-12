#!/bin/bash 


repos="
docs
cheatsheet
dotvim
"


cloning_repos(){

eval `ssh-agent -s`
ssh-add /home/agalan/.ssh/agalan-github-key

for repo in $repos
do
git clone git@github.com:albertogalan/$repo.git /data/src
done

}

sync_dot(){

rsync -a /data/src/dotvim/  /home/agalan/.vim/

}


cloning_repos
sync_dot
