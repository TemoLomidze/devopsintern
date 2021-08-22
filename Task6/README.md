# Task 6 - Jenkins
## Main Part

What we know about Jenkins?

Jenkins is a free and open source automation server. It helps automate the parts of software development related to building, testing, and deploying, facilitating continuous integration and continuous delivery. It can be used from just copying files to destination, to compile code from github and push it to production server...

### 1.
 I had install jenkins in a Docker container. For that I setup AWS EC2 instance with ubuntu.
First I had to prepare system: Install all prerequisites. I've created bash shell script to simplify the process (It's in Task6 directory on Github), also it's good idea to give docker command permission to run without sudo. To do that, we have to run following command:
#### `sudo usermod -aG docker $USER`
and restart docker service (if restart does not help, then we have to `logout`):
#### `sudo systemctl restart docker`

 After installation is complete, We need to create bridge netrwork in Docker using `docker network create jenkins`
  In order to execute Docker commands inside Jenkins nodes, download and run the docker:dind Docker image using the following `docker run` command (I followed the perfect guide with detailed explanations on jenknis webpage):
`docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 docker:dind --storage-driver overlay2`
  
 When done we have to create Dockerfile to build jenkins inside Docker container:

`FROM jenkins/jenkins:2.289.3-lts-jdk11
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.24.7 docker-workflow:1.26"`

Now we need to build Docker image from Dockerfile and assign name to it (in my case I gave it jenkins-temo:1.1) with this command

#### `docker build -t myjenkins-blueocean:1.1 .`




