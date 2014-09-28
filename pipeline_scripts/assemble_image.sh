#!/bin/bash

sudo easy_install pip
sudo pip install paramiko PyYAML jinja2 httplib2

git clone git://github.com/ansible/ansible.git --recursive
cd ./ansible
source ./hacking/env-setup
cd ..

ansible all -m ping --ask-pass

echo Verifying that Packer has been installed to the application cache...
if [ ! -d ${SNAP_CACHE_DIR}/packer ]; then
    echo Packer was missing from the cache. Installing...
    wget --no-verbose https://dl.bintray.com/mitchellh/packer/0.7.1_linux_amd64.zip -O ${SNAP_CACHE_DIR}/packer.zip
    unzip ${SNAP_CACHE_DIR}/packer.zip -d ${SNAP_CACHE_DIR}/packer
    echo Packer installation complete
fi




${SNAP_CACHE_DIR}/packer/packer build image_management/digital_ocean_packer_script.json

