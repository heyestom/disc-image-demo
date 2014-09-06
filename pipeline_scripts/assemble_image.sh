#!/bin/bash

#Ensure packer is installed before attempting to build an image
if [ ! -d ${SNAP_CACHE_DIR}/packer ]; then
    wget --no-verbose https://dl.bintray.com/mitchellh/packer/0.6.1_linux_amd64.zip -O ${SNAP_CACHE_DIR}/packer.zip
    unzip ${SNAP_CACHE_DIR}/packer.zip -d ${SNAP_CACHE_DIR}/packer
fi

${SNAP_CACHE_DIR}/packer/packer build image_management/digital_ocean_packer_script.json

