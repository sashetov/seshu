#!/bin/bash
function get_github_repo()  {
  set -x
  URL=$1
  export OUTDIR=`echo $URL | sed -r 's/^.+\///g'`;
  while [ -d $OUTDIR ]; do
    export OUTDIR="${OUTDIR}_"
  done;
  git clone $URL $OUTDIR && cd $OUTDIR && \
    git fetch --all && \
    git checkout -b $OUTDIR-sasheto && cd ..
  set +x
}
function __main__(){
  export URLSFILE='repo-urls'
  cat $URLSFILE | while read URL; do
    get_github_repo $URL
  done;
}
__main__ $*
