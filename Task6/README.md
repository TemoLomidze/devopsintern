# Task 6 - Jenkins
## Main Part

What we know about Jenkins?

Jenkins is a free and open source automation server. It helps automate the parts of software development related to building, testing, and deploying, facilitating continuous integration and continuous delivery. It can be used from just copying files to destination, to compile code from github and push it to production server...

## 1: Install Jenkins. It must be installed in a docker container.
## 2: Install necessary plugins
<br>
 I had install jenkins in a Docker container. For that I created Virtual Machine with Ubuntu 18.04 in VMWare Workstation.
First I had to prepare system: Install all prerequisites. I've created bash shell script to simplify the process (It's in Task6 directory on Github), also it's good idea to give docker command permission to run without sudo. To do that, we have to run following command:

#### `sudo usermod -aG docker $USER`
and restart docker service (if restart service does not help, then we have to `logout`):
#### `sudo systemctl restart docker`

 After installation is complete, We need to create bridge netrwork in Docker using `docker network create jenkins`
  
  In order to execute Docker commands inside Jenkins nodes, download and run the ***docker:dind*** Docker image using the following `docker run` command (I followed the perfect guide with detailed explanations on jenknis webpage):
```  
docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 docker:dind --storage-driver overlay2
```  
 When done we have to create Dockerfile to build jenkins inside Docker container:
```
FROM jenkins/jenkins:2.289.3-lts-jdk11
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
RUN jenkins-plugin-cli --plugins "blueocean:1.24.7 docker-workflow:1.26"
```
Now we need to build Docker image from Dockerfile and assign name to it (in my case I gave it jenkins-temo:1.1) with this command

#### `docker build -t jenkins-temo:1.1 .`

 After building is complete, we have to run own container with the following `docker run` command:

```
docker run --name jenkins-blueocean --rm --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  jenkins-temo:1.1
```

#### If it's finishes successfully, we continue to post-installation setup wizzard using your favorite brawser: https://your.server.ip:8080
##### First time you will see screen that asks to unlock Jenkins. It's only one time setup feature.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/unlock-jenkins-page.jpg)


##### There is a help text, how to find one-time password. But that does not work for us, because we ran jenkins from docker container. We have to run docker command to get password:
##### to find your container ID, simply run `docker ps`.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/onetimepass.png)

##### If everyhing fine, wizzard takes to second screen to create Admnistrative account for Jenkins:

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/create-account.png)

##### Here we have to enter credentials for new Admin user and then click "Save and Continue" and it takes you next screen, where we have to decide install jenkins with suggested plugins or make clean installation. I recommend to install suggested plugins, because theese plugins already tested by thousands of users. Anyway, if we don't need any of installed plugins, they can be easely uninstalled after we finish setup wizard.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/jenkins1.png)

##### The wizzard proceeds with necessary installations and takes us to new screen with some reminder of how to access jenkins and on next page we are able to start using jenkins:

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/jenkins3.png)

##### When we press to Start using Jenkins, it takes us to Jenkins workspace:
<br>
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/jenkins.png)

  ## 3
 Now it's time to deploy jenkins agents. as we are using docker version. we are going to create agents inside containers.
First we need to create SSH key pair, usind `ssh-keygen -f ~/.ssh/your-key-name` command.
Now, when key is ready, we have to go to Jenkins Dashboard, then Manage Jenkins and then Click Manage Credentials.
 
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/ssh1.png)

It takes us to credentials manager page, where we can add/delete/manage ssh keys.
Click drop down button right to (global) and then "Add Credentials":

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/ssh2.png)

It take us to the next screen, where we finally can create new SSH

We have to feel form here. in "Kind" select: "SSH Username with private key" from drop down menu. Also in Scope select "Global", if not selected by default.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/ssh3.png)

In the <strong>"Private Key"</strong> Section, we have to click "Add" and copy content of previously created SSH key file, enter Passphrase and click "Ok"

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/ssh4.png)

### Our creadentials created!
<br>
#### It's time to configure build Agents.

I created two <strong>Ubuntu 18.04 VM's in VMWare workstation</strong> with Docker installed, to use as Jenkins Agents.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/vms.png)
<br>
We have to make some changes in <strong>/lib/systemd/system/docker.service</strong>, to communicate with Jenkins Master freely.

#### Important!!! Do not forget comment old entry of **ExecStart=**!!!
Then restart **daemon** and **docker.service**...
<br>
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/docker-service.png)
<br>
To check everythin works correct, use `curl localhost:yourporthere/version`. You should get output like this:
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/curl-local.png)
<br>
Now we have to install **docker** and **label** plugins into Jenkins. We will need it to build agents directly from Jenkins. For sure make installation of plugins with **restart**.
<br>
Now go to **Manage Jenkins > Manage Nodes and Clouds > Configure Clouds** and click **add new cloud** in drop down menu you will find **Docker**.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/addcloud.png)

and start configuring your cloud:
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/confcloud.png)

In Docker Host URI, write you **agent** IP with port you mention in service file for Docker API. Then click **Test Connection**. If you get answer like this: **Version = 20.10.8, API Version = 1.41**, then everything goes well at the moment.
Click **Docker Agent Templates > Add Docker Template**. Add Label, in my case I named it **"Slave1"** and check **Enabled** checkbox. Under Docker images type the image you want to use, Jenkins and Java must be preinstalled in the image. I've used image prevously create by Goga Samunashvili. In **Connect Method"** choose **Connect with SSH** and under **SSH Key** select **Use configured SSH credentials** and add new credentials. **Apply** and **Save** configuration. Repeat above steps to create second **Agent**.
<br>
#### Important!!!
<br> 
don't forget to use different label, while adding **Docker template** on second node.
<br>
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/ssh-cred.png)
<br>
   ## 4
##### We have to Create a Freestyle project. Which will show the current date as a result of execution.
<br>
For that we need to install Jenkins plugin called: **Timestamp**, it will show our current time and date. After installing plugin go to **Configure System**, find **Build Timestamp**, enable it, if disabled. Configure for your local timezone.
<br>
It's time to start our first Freestile project. It will show current time and date as a result. Click **New Item** select **Freestyle Project** (here we need plugin that we installed at the begining "Lable"), check **Restrict where this project can be run** and in **Label Expression** write your agent **label**.
<br>
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/timestamp.png)
<br>
Select **Execute shell** and write simple code: `echo "$BUILD_TIMESTAMP"`
Click **Apply**, then **Save** and **Build Now**. If we made no mistakes, output should be like this:
<br>
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/timedate.png)
<br>
   ## 5
  #### The task is to Create Pipeline which will execute docker ps -a in docker agent, running on Jenkins master’s Host.
<br>
Before we start we need to prepare agents. Go to **Manage Jenkins > Manage Nodes and Clouds > Configure Clouds > Edit Docker** and add the following line in settings tab:
```
type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock
```
This will bind docker agents to docker engine. Go to console and SSH into the agents. Execute this commands:
```
sudo chmod 777 /var/run/docker.sock
```
Now in Jenkins Home, click "New item", Select ***Pipeline*** and click **ok**, add following script:
<br>
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/ps-pipe.png)
<br>
In case if we did everything right console output should be like this:
<br>
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/docker-ps-a.png)
<br>
   ## 6
  #### Create Pipeline, which will build artefact using Dockerfile directly from your github repo
<br>  
We can create new pipeline or edit already existed to finish this task. Go to your pipeline and add following script to it, which gonna build Dockerfile from our github repo (do not forget to replace with your repo).

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/6.docker.png)

   ## 7
   #### Pass  variable PASSWORD=QWERTY! To the docker container. Variable must be encrypted!!!

For this part, we have have to go to: ***Manage Jenkins > Manage Credentials*** and add Global credentials in ***Secret Text*** format. Provided password is ***QWERTY!***.
Then we create pipeline as in example:
![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/password.png)
<br>
and the Console output should look like this:

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/master/Task6/screenshots/password1.png)
<br><br>
 #### That's all Falks ;)


