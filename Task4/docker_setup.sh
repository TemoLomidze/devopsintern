#!/bin/bash

#Prepare system
yum -y install epel-release

yum -y update

yum clean all

#Remove any old Docker Engine if exists
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

#Prepare Docker Repositories

yum install -y yum-utils mc nano

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

#Install Docker CE
yum -y install docker-ce docker-ce-cli containerd.io

#Start & Enable Docker Ce Service
systemctl start docker
systemctl start containerd.service

systemctl enable docker
systemctl enable containerd.service

#Install Docker Composer
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

#Make it executable
chmod +x /usr/local/bin/docker-compose

#Check Composer Works
docker-compose --version

#Verify that Docker Engine is installed correctly by running the hello-world image
docker run hello-world
