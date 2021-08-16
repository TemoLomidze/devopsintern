FROM ubuntu:16.04

MAINTAINER Temo Lomidze <temo@lomidze.ge>

ENV DEVOPS "darkhalf"

RUN apt -y update && apt -y install \
	apache2 \
	&& echo "<html><h1>Temo Lomidze Sandbox2021</h1><html>" > /var/www/html/index.html \

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

EXPOSE 80