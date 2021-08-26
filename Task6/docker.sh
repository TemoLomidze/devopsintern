#!/bin/bash

#update system
sudo apt-get update -y

sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common

sudo sleep 5

#Add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo sleep 3

#Update repos and install Docker
sudo apt-get -y update
apt-cache policy docker-ce

sudo sleep 5


sudo apt-get -y install docker-ce docker-ce-cli containerd.io

sudo sleep 3

#Give Docker permissions to run without sudo
sudo usermod -aG docker $USER
sudo sleep 2
sudo service docker restart


sudo sleep 3

#install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo sleep 3
sudo chmod +x /usr/local/bin/docker-compose

sudo sleep 3

#Test install
docker-compose --version



