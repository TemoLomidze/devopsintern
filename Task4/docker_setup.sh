#!/bin/bash

#update system
sudo apt -y update

#install prerequisites
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common

#add GPG Key for Docker Repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#add repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#refresh packeges again
sudo apt -y update

#install docker
sudo apt -y install docker-ce docker-ce-cli containerd.io

#start && enable docker service
sudo systemctl start docker
sudo systemctl enable docker

#check docker version
sudo docker --version

#install compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

#give executable permissions
sudo chmod +x /usr/local/bin/docker-compose