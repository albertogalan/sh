#!/bin/bash


echo "sync database from local to remote tornae.com"
fromserver="ppostgres05.lxc"
frompath="/data/databases/postgresql/9.5/main"
odoo_database="tornae01"
toserver="www.tornae.com"
topath="/var/lib/postgresql/9.5/main4/"
echo introduce from database
read a
frompath_odoo="/data/apps/odoo/Odoo/filestore/$a/"
echo introduce new database
read a
topath_odoo="/home/odoo/.local/share/Odoo/$a"

a=$(ssh $toserver "sudo grep -R 'data_directory'  	l/9.5/main/postgresql.conf")
echo " "
b=$(ssh $toserver "sudo cat /home/odoo/oddo.conf | grep data_directory" )
echo $b

echo "actual psql dir is $a"
echo "actual odoo dir is $b"
echo " "
echo "First you have to change database if necesaryt"
echo " "
echo "Now will sync the files"
rsync -avz  --chown=odoo:odoo --rsync-path="sudo rsync"   $frompath_odoo $toserver:$topath_odoo
ssh $toserver  "sudo chown -R odoo:odoo $topath_odoo"
ssh $toserver  "sudo chmod -R 774 $topath_odoo"
echo "now you have to change the default /home/odoo/odoo.conf  filterdb= newdb "


# if [[ "$a" == "y" ]]; then
# 	echo begin the routine
# 	ssh $fromserver  "sudo service postgresql stop"
# 	sudo rsync -av --rsync-path='sudo rsync' $frompath $toserver:$topath
# 	ssh $fromserver  "sudo service postgresql start"
# 	echo " ....."
# 	echo " ....."
# 	echo " ....."
# 	echo "execute this commands"
# 	echo "ssh $toserver"
# 	echo "vim /etc/postgresql/9.5/main/postgresql.conf"
# 	echo " change data_dirrectory   to  $topath"
# 	echo "sudo service postgresql restart"
# fi

