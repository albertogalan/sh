#!/bin/bash 

mvim (){
feature=$1
docker run -it --rm \
  --env-file ~/data/src/docker/env \
  -w /wk \
  -v ${PWD}:/wk \
  -v ${HOME}/data:/data \
  -v ${HOME}/.ssh:/root/.ssh \
  -v ${HOME}/.aws/:/root/.aws \
  -v ${HOME}/.kube:/root/.kube \
  -v ${HOME}/.bash_history:/root/.bash_history \
  -v ${HOME}/data/src/dotconfig/tmux:/root/.tmux \
  -v ${HOME}/data/src/dotconfig:/root/.config \
  -v ${HOME}/.ssh:/home/agalan/.ssh \
  -v ${HOME}/.aws/:/home/agalan/.aws \
  -v ${HOME}/.kube:/home/agalan/.kube \
  -v ${HOME}/.bash_history:/home/agalan/.bash_history \
  -v ${HOME}/data/src/dotconfig/tmux:/home/agalan/.tmux \
  -v ${HOME}/data/src/dotconfig:/home/agalan/.config \
  agalan75/im-desk-${feature} /bin/sh -c  '/bin/bash'
}


minit (){
  mvim aws:1.3.6
}

desk () {
# 1.3.2  
feature=$1
gituser=agalan  
HOME2=/home/agalan  
docker run -it --rm    \
  -v ${HOME}/.ssh:$HOME2/.ssh  \
  -v ${HOME}/.aws:$HOME2/.aws  \
  -v ${HOME}/.kube:$HOME2/.kube \
  -v ${HOME}/.bash_history:$HOME2/.bash_history \
  -v ${HOME}/data/src/dotconfig:$HOME2/.config \
  -v ${HOME}/data:/data \
  -v ${HOME}/data/src/dotconfig/tmux:$HOME2/.tmux \
  -v ${HOME}/data/src/dotconfig/.gitconfig-$gituser:$HOME2/.gitconfig \
  agalan75/im-desk-${feature} /bin/sh -c  '/bin/bash'
}

