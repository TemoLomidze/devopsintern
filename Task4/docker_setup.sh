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

#Check where from docker installing
apt-cache policy docker-ce

#install docker
sudo apt -y install docker-ce docker-ce-cli containerd.io

#start && enable docker service
sudo systemctl start docker
sudo systemctl enable docker

#check docker version
sudo docker --version

#User
sudo usermod -aG docker $USER

#install compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

#give executable permissions
sudo chmod +x /usr/local/bin/docker-compose

#Download and use Hello Worlds
sudo docker run hello-world

