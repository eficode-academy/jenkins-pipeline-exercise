#! /bin/bash
echo "first start of by adding jenkins installation to the os sw repo"
sudo apt-get update
sudo apt-get upgrade -y

sudo apt install openjdk-11-jdk

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
