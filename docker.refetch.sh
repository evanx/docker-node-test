
cd ~/tmp || exit 1

  rm -rf dockernodetest
  curl -s https://raw.githubusercontent.com/evanx/docker-node-test/master/dockertest.sh -O
  sh dockertest.sh
