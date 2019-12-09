#!/bin/bash
set -e
#provision.sh
 sudo yum -y update
 echo "Yum update done."
 sudo yum -y upgrade
 echo "Yum upgrade done." 
 sudo yum install -y epel-release
 echo "Install Epel done."
 sudo yum install -y python-dev python-pip
 echo "Install python done."
 sudo pip install ansible
 echo "Install ansible done."
 sudo yum install -y git
 echo "Install git done."
 sudo cd ~
 echo "Cd Raiz done."
 #sudo git clone https://github.com/jntoledo/desafio2mandic.git
 #echo "Git Clone done."
 #cd ~/desafio2mandic && sudo sed -i 's/100.100.100.100.*/127.0.0.1/g' hosts
 #cat ~/desafio2mandic/hosts
 #echo "Sed hosts done."
 #cd ~/desafio2mandic && sudo sed -i 's/Documents.*/desafio2mandic/g' ansible.cfg
 #cat ~/desafio2mandic/ansible.cfg
 #echo "Sed ansible done."
 #echo "Indo a pasta raiz e deletando o hosts"
 #cd ~/desafio2mandic && sudo rm -rf hosts
 #echo "Indo a pasta raiz e deletando o ansible.cfg"
 #cd ~/desafio2mandic && sudo rm -rf ansible.cfg
 #echo "Alterando arquivo blog"
 #cd ~/desafio2mandic && sudo sed -i s/servidor.*/all/g blog.yml
 #echo "iniciando o playbook"
 #sudo ansible-playbook ~/desafio2mandic/blog.yml
 #echo "Playbook Done"
