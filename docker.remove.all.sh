#!/bin/bash

c0_rm_all() {
  for name in `docker ps -a | grep -v ^CONTAINER | cut -f1 -d' '`
  do 
    docker rm -f $name
  done
}

c0_default() {
  echo "commands: rm_all"
}

if [ $# -gt 0 ]
then
  command=$1
  shift
  c$#_$command $@
else
  c0_default
fi
