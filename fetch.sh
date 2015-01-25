mkdir -p ~/tmp
cd ~/tmp 
curl -s https://raw.githubusercontent.com/evanx/docker-node-test/master/dockertest.sh -O
cat dockertest.sh
chmod dockertest.sh
sudo ./dockertest.sh
  
