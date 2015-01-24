
cd ~/tmp/dockernodetest || exit 1

[ -f Dockerfile -a -f start.sh -a -f index.js ] || exit 1

  docker build -t nodetest .
  docker run -d --name nodetest1 -p 8888:8888 nodetest 
  docker ps -a
  sleep 1
  curl -s 'http://localhost:8888'; echo
  docker rm -f nodetest1
