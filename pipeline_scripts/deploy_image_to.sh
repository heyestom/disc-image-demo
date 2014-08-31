#!/bin/sh

if [ -z "$1" ]; then
    echo -e "\n-------------\nEnvironment to be deployed to has not been passed in\n-------------------\n"
    exit 1
fi
ENVIRONMENT=$1

bundle install
bundle exec ruby image_management/deploy_image_to.rb $ENVIRONMENT