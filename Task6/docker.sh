#!/bin/bash

#update system
sudo apt-get update -y

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sleep 5

#Add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sleep 3

#Update repos and install Docker
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

#Give Docker permissions to run without sudo
sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker restart


sleep 3

#install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sleep 3
sudo chmod +x /usr/local/bin/docker-compose

sleep 3

#Test install
docker-compose --version



