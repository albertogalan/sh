#!/bin/bash


if [[ $# -eq 0 ]]; then
  echo "$red This command send environment setup through ssh  $reset"
  echo "Usage: $green BRANCH dev2/dot-branch $reset"
  echo "Usage: ${FUNCNAME[0]} $green {master/branch} {USER@HOST} {dotbasic/dotphone} {debian/redhat}reset"
  echo "Usage: ${FUNCNAME[0]} branch agalan@host dotbasic"
  exit 0
fi



OPTION=$1
HOST=$2
USER=${HOST%@*}
HOST=${HOST#*@}
BRANCH=$3
DISTRIBUTION=$4

if [ "$DISTRIBUTION" == "debian" ]; then
    package_manager="apt"
else
    package_manager="yum"
fi

echo $HOST
echo $BRANCH


# ssh -A to forward agent identity 
ssh-agent
ssh-add  /home/agalan/.ssh/id_rsa


HOMESSH=`ssh $USER@$HOST "echo ~"`

if [ "$OPTION" == 'master' ]; then

	ssh $USER@$HOST -t -A   "
		DIRdot-git=$HOMESSH/.config/dot-git
		mkdir -p $HOMESSH/.config
		mkdir -p $HOMESSH/.ssh
		touch $HOMESSH/.ssh/known_hosts
		chown $USER:$USER $HOMESSH/.ssh
		chown $USER:$USER $HOMESSH/.ssh/known_hosts
		chmod 664 $HOMESSH/.ssh/known_hosts
		git clone --single-branch -b dev2 git@github.com:albertogalan/dot-git.git $HOMESSH/.config/dotgit
		cd $HOMESSH/.config/dot-git ; git  --work-tree=$HOMESSH  checkout -f --
		"
	echo "ready to start to work please reboot the system"

fi

if [[ "$HOST" == "phone"  ]]; then
		ssh -A -t $USER@$HOST "
			
			$package_manager install -y python vim vim-python tmux ranger
			$package_package_manager install -y mutt tsock
			$package_package_manager install nodejs
			pkg install man
			git config --global github.user albertogalan
			if [[ ! -f $HOMESSH/autojump/install.py ]]; then
				 git clone git://github.com/wting/autojump.git
				 cd autojump
				 ./install.py
			fi
		"
fi

if [[ "$HOST" != "master" ]]; then

	ssh -A -t $USER@$HOST "

		sudo $package_package_manager install -y python vim tmux ranger
		if [[ ! -f $HOMESSH/.fzf/install ]]; then
			git clone --depth 1 https://github.com/junegunn/fzf.git $HOMESSH/.fzf
		        $HOMESSH/.fzf/install
		fi
		mkdir -p $HOMESSH/.tldr/tldr
		git --branch agalan clone git://github.com/albertogalan/tldr.git $HOMESSH/.tldr/tldr
		mkdir -p $HOMESSH/.ssh
		if [ ! -d $HOMESSH/.config/dotgit ] ;then
			touch $HOMESSH/.ssh/known_hosts
			chown $USER:$USER $HOMESSH/.ssh
			chown $USER:$USER $HOMESSH/.ssh/known_hosts
			chmod 664 $HOMESSH/.ssh/known_hosts
			echo  git clone -b $BRANCH  git@github.com:albertogalan/dotgitnew.git $HOMESSH/.config/dotgit
			# updating submodules
			git --git-dir=$HOMESSH/.config/dotgit/.git  --work-tree=$HOMESSH submodule init
			git --git-dir=$HOMESSH/.config/dotgit/.git  --work-tree=$HOMESSH submodule update
			git --git-dir=$HOMESSH/.config/dotgit/.git  --work-tree=$HOMESSH checkout -f --
			# vim -c 'PlugInstall'
			echo $BRANCH branch already recover
		else
			echo 1
			git --git-dir=$HOMESSH/.config/dotgit/.git --work-tree=$HOMESSH  pull --
			git --git-dir=$HOMESSH/.config/dotgit/.git  --work-tree=$HOMESSH checkout -f --
			# vim -c 'PlugInstall'
		fi
	"

fi
