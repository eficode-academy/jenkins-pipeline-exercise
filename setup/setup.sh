#! /bin/bash
echo "first start of by adding jenkins installation to the os sw repo"
sudo apt-get update
sudo apt-get upgrade -y
# install java jre 8 to jenkins from 
# http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html

sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt install oracle-java8-installer -y

#install jenkins from
# https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y

sleep 10
echo "your secret jenkins password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
