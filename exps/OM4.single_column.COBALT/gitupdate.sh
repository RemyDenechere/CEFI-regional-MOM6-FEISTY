#!/bin/bash
#
# bash file to add changes / commit / and push
# Define variables: 
REPO="CEFI-regional-MOM6-FEISTY"
USER_NAME="RemyDenechere"
GITHUB_TOKEN=$(cat ~/token)
WORKING_DIR=$(pwd)
HOME_DIR="/project/rdenechere/$REPO"
# 
if [ "$#" -eq 0 ]; then
    COMMIT_MESSAGE="Commit on $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Using default commit message: $COMMIT_MESSAGE"
elif  [ "$#" -eq 1 ]; then
    COMMIT_MESSAGE=$1
    echo "Using commit message: $COMMIT_MESSAGE"
else
    echo "error wrong number of input variables; use either no input variable or ./test.sh <COMMIT_MESSAGE>"
    exit 1
fi

echo "going to home "$HOME_DIR" to stage changes" 
cd $HOME_DIR

git add *
git add .gitignore

git commit -m "$COMMIT_MESSAGE"

# push last commits: 
git push https://$GITHUB_TOKEN@github.com/$USER_NAME/$REPO

echo "going back to working directory"
cd $WORKING_DIR
