# devops-small-lab
This is small nodejs lab of devops

#include tools
- Docker
- Ansible
- Terraform
- Gitlab CI/CD
- Azure

# first we should test our code in local
clone repo $ git clone https://github.com/nyeinchan4/devops-small-lab.git

go to Docker-Dir  
$ cd Docker-Dir
install some requirement app to test node.js app not mention here
test node.js app
$ node app.js

see it work or not 
$ curl localhost:3000

# next test with docker with docker-compose

install docker and docker compose from official webiste 

after that 
$ docker-compose  up -d 

test 
$ curl localhost:3333

# create 2 deployment VM on Azure with terraform 

before use terraform prepare for some requirement
- need to have Azure account
- install terraform and also Azure cli for Auth.. 
- and then form Azure cli auth with your Azure account

go to terraform dir 
$ terraform apply 
and then comfirm with $ yes

this will create 3 vm on azure
1 is for github runner (optional)
2 is for deploy node.js app 

# install docker on deployment server for node.js docker 
go to ansible Dir

- install ansible and fix host file 
- add deploy az vm host user name and password or auth ssh key

to run ansible playbook
$ ansible-playbook install-docker.yaml 

after that you have already installed docker on deploy server

# Last step is to run CI/CD on gitlab 

go to gitlab-cidd dir and copy .gitlab-ci.yml and past on your
gitlab cicd file

pre requirement
- install gitlab runner on one vm if you want to use (optional)
- add deploy vm ssh key on gitlab password variable

after that run github CI if all good run manual CD
