#!/bin/bash 

repos="
docs
"

adding_dotfiles(){

## install dot files
mkdir -p  /home/agalan/.config
git clone https://github.com/albertogalan/sh.git /tmp/sh
rsync -a /tmp/sh/dot/  /home/agalan/.config/

}


cloning_repos(){

eval `ssh-agent -s`
ssh-add /home/agalan/.ssh/agalan-github-key

for repo in $repos
do
git clone git@github.com:albertogalan/$repo.git
done

}

adding_dotfiles
cloning_repos

