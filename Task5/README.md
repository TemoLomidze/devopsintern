# Task 5 - Main Part

1. We had to deploy 3 virtual machines on any cloud. I've used AWS Management console to deploy 3 EC2 instances of Amazon linux 2.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/f6a17a61a9d796bc7bf5c7647a2b5e3059698864/Task5/screenshots/instances.png)

after that we had to install Ansible on control-plane (in my case: Master). I've installed latest python version and used pip3: `sudo pip3 install ansible`

2. To be able to start using ansible, I had to create Inventory File, where I put all my vm's except Master.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/d2c928aceb571727c011814c4b89a4a530a81fce/Task5/screenshots/guests.txt.png)

Also We had to create ansible config file, because installation method I used to install Ansible, does not creating configuration file.

![alt tag](https://github.com/TemoLomidze/devopsintern/blob/c9da2107f6b2d111b0702baedde64f40d9bf267d/Task5/screenshots/ansible.cfg.png)

and to get access to guest vm's we need to give ansible user credenthials and path to keys. It can be done by creating variables folder > group_vars and file with the same name as a group name in Inventory file. In my case guest_rhel, in which we write all the necessary credentials:

![alt tag](https://for-git.s3.amazonaws.com/Task5/group_vars.png)

and then run easy test of connection using `ansible all -m ping`

![alt tag](https://for-git.s3.amazonaws.com/Task5/ping.png)

After that, we had to create playbook to install docker on guest machines. Playbook file `docker.yml` is uploaded to Task5 folder. The result of running playbook using `ansible-playbook docker.yml` below:

![alt tag](https://for-git.s3.amazonaws.com/Task5/docker.png)
