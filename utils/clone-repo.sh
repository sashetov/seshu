#!/bin/bash
if [ $# -lt 2 ]; then
  echo Usage: $0 OLD_REPO_URL NEW_REPO_URL
  exit 1;
fi
function ee (){
  echo $*;
  eval $*;
}
export OLDGH=$1
export NEWGH=$2
ee git clone --mirror $OLDGH
ee cd $REPO
ee git remote set-url --push origin $NEWGH
ee git push --mirror
