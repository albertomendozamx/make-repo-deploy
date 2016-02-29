#!/bin/sh
# Obtain the host IP on OS X
HOSTIP=$(/sbin/ifconfig en0 | grep 'inet' | cut -d: -f2 | awk '{ print $2}' | tr -d '\n')
DIR_TEMPLATES="../templates"
DIR_REPOS="."
DIR_DEPLOYS="./deploys"
printf "New project name: "
read PROJECT_NAME
printf "Live server (Ex. git@server:/dir/to/deploy): "
read LIVE_SERVER
if [ -z $PROJECT_NAME ]; then 
	printf "The project name and live server are required!\n"
else
	if [ -d $DIR_REPOS/$PROJECT_NAME.git -o -d $DIR_DEPLOYS/$PROJECT_NAME ]; then
		printf "A project with this name already exist!"
	else
		mkdir -p $DIR_DEPLOYS/$PROJECT_NAME
		mkdir $DIR_REPOS/$PROJECT_NAME.git && cd $DIR_REPOS/$PROJECT_NAME.git
		git init --bare
		cp ../$DIR_TEMPLATES/post-receive ./hooks/
		sed -i '' 's/deploy-test/'$PROJECT_NAME'/g' ./hooks/post-receive
		sed -i '' 's~path_ssh~'$LIVE_SERVER'~g' ./hooks/post-receive
		sed -i '' 's~path_tmp_source~'$DIR_DEPLOYS'/'$PROJECT_NAME'~g' ./hooks/post-receive
		printf "Project created!\n"
		printf "Get source on git@$HOSTIP:$DIR_REPOS/$PROJECT_NAME.git\n"
	fi	
fi