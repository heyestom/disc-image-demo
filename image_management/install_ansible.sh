#!/bin/sh
sudo apt-get update --fix-missing
sudo apt-get -y install python-software-properties
sudo apt-get -y install software-properties-common


sudo apt-add-repository -y ppa:rquillo/ansible
sudo apt-get -y install ansible


