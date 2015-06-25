#!/bin/bash 

if ! which docker 
then 
  echo "docker not installed, so aborting"
  exit 1
fi

netstat -ntlp  2>/dev/null | grep -qv 8888 || exit 1

mkdir -p ~/tmp/dockernodetest 

cd ~/tmp/dockernodetest || exit 1

pwd

echo "
  var http = require('http');
  http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello, Dockerized Node World!');
  }).listen(8888);
  console.info('test web app started');
" > index.js

echo "
  mkdir -p testapp
  cd testapp
  cp /tmp/index.js .
  nodejs index.js
" > start.sh

echo "
  FROM ubuntu:14.04
  RUN apt-get update
  RUN apt-get install -y nodejs npm
  RUN npm install http -g
  ADD start.sh /tmp/
  ADD index.js /tmp/
  RUN chmod +x /tmp/start.sh
  EXPOSE 8888
  CMD /tmp/start.sh
" > Dockerfile

ls -l 

c0_build_nodetest() {
  docker build -t nodetest .
  docker ps -a
}

c0_run_detached_nodetest1() {
  docker run -d --name nodetest1 -p 8888:8888 nodetest 
  docker ps -a
  sleep 1
  echo
  if curl -s 'http://localhost:8888' 
  then
    echo; echo
    echo "curl succeed! If on your localhost, "
    echo "try in your browser, http://localhost:8888"
    echo "or similarly with your server's IP number or name"
  else 
    echo; echo
    echo "curl failed!"
  fi
  echo "If you interrupt this script, check: docker ps -a"
  echo "and if necessary, to cleanup: docker rm -f nodetest1"
}

c0_attach_nodetest1() {
  echo "attach - press ctrl-pq to detach"
  docker attach nodetest1
  echo 
  docker ps -a
}

c0_exec_nodetest1_bash() {
  echo "exec bash - press enter to see shell, ctrl-pq to detach,"
  echo "or type exit to stop the container"
  docker exec nodetest1 /bin/bash
  echo
  docker ps -a
}

c0_rm_nodetest1() {
  if docker ps | grep -q nodetest1
  then
    echo "removing container"
    docker rm -f nodetest1
  fi
}

c0_default() {
  c0_rm_nodetest1
  c0_build_nodetest 
  c0_run_detached_nodetest1
  #c0_attach_nodetest1
  #c0_exec_nodetest1_bash
  echo "Press any key to continue, to remove container"
  read any
  c0_rm_nodetest1
}

if [ $# -gt 0 ]
then
  command=$1
  shift
  c$#_$command $@
else
  c0_default
fi
