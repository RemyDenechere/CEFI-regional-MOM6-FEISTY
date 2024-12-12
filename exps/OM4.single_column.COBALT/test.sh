#!/bin/bash
#
# bash file to add changes / commit / and push
# Define variables: 
REPO="CEFI-regional-MOM6-FEISTY"
USER_NAME="RemyDenechere"
GITHUB_TOKEN=$(cat ~/token)
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

git add .
git add /project/rdenechere/CEFI-regional-MOM6-FEISTY/src/ocean_BGC/generic_tracers/generic_COBALT.F90
git add /project/rdenechere/CEFI-regional-MOM6-FEISTY/src/ocean_BGC/generic_tracers/generic_FEISTY.F90

git commit -m "$COMMIT_MESSAGE"

# push last commits: 
git push https://$GITHUB_TOKEN@github.com/$USER_NAME/$REPO.git
