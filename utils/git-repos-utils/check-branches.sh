#!/bin/bash
for d in $(find . -maxdepth 1 -type d); do 
  if [ $d = '.' ]; then
    continue; 
  fi;
  cd $d;
  echo $(basename $d)':';
  git branch || break;
  cd ..;
done;
