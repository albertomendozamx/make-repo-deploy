#!/bin/sh
DIR_REPOS="./"
DIR_DEPLOYS="./deploys"
printf "Project name: "
read PROJECT_NAME
mkdir -p $DIR_DEPLOYS/$PROJECT_NAME
mkdir -p $DIR_REPOS/$PROJECT_NAME.git && cd $DIR_REPOS/$PROJECT_NAME.git
git init --bare
touch hooks/post-receive
chmod -x hooks/post-receive
printf "Project created!"
