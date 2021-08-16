FROM centos:v7

MAINTAINER Temo Lomidze <temo@lomidze.ge>


RUN yum -y install httpd php

RUN echo "<h1>Hello Wolrd</h1>" > /var/www/html/index.html

RUN systemctl start httpd

RUN systemctl enable httpd

EXPOSE 80

VOLUME /mnt/docker_vol  /data

RUN echo "httpd" >> /root/.bashrc

CMD ["/bin/bash"]

