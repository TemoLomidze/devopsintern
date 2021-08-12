#!/bin/bash

sudo yum -y install epel-release
sudo yum -y update
sudo yum -y install nginx
sudo echo '<h1>Hello World</h1>' Droplet: $HOSTNAME, IP Address: $PUBLIC_IPV4 > /usr/share/nginx/html/index.html
sudo systemctl enable nginx
sudo systemctl start nginx
