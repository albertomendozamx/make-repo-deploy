#!/bin/sh
# Obtain the host IP on OS X
HOSTIP=$(/sbin/ifconfig en0 | grep 'inet' | cut -d: -f2 | awk '{ print $2}' | tr -d '\n')
DIR_REPOS="."
DIR_DEPLOYS="./deploys"
printf "New project name: "
read PROJECT_NAME
echo "Live server ssh key required"
printf "Live server [git@server:/dir/to/deploy]: "
read LIVE_SERVER
if [ -z $PROJECT_NAME ]; then 
	printf "The project name is required!\n"
else
	if [ -d $DIR_REPOS/$PROJECT_NAME.git -o -d $DIR_DEPLOYS/$PROJECT_NAME ]; then
		printf "A project with this name already exist!"
	else
		mkdir -p $DIR_DEPLOYS/$PROJECT_NAME
		mkdir $DIR_REPOS/$PROJECT_NAME.git && cd $DIR_REPOS/$PROJECT_NAME.git
		git init --bare
		# Get hook template from git repo
		touch hooks/post-receive
		chmod -x hooks/post-receive
		printf "Project created!\n"
		printf "Get source on git@$HOSTIP:$DIR_REPOS/$PROJECT_NAME.git\n"
	fi	
fi