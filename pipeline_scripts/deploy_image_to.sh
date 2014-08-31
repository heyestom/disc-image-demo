#!/bin/sh

if [ -z "$1" ]; then
    echo -e "\n-------------\nEnvironment to be deployed to has not been passed in\n-------------------\n"
    exit 1
fi
ENVIRONMENT=$1

if [ -z "$SNAP_PIPELINE_COUNTER" ]; then
    echo -e "\n-------------\nSnap Pipeline Counter has not been set\n---------------------------------\n"
    exit 1
fi

if [ -z "$SNAP_COMMIT" ]; then
    echo -e "\n-------------\nSnap Revision has not been set\n-----------------------------------------\n"
    exit 1
fi

bundle install
bundle exec ruby image_management/deploy_image_to.rb $ENVIRONMENT $SNAP_COMMIT $SNAP_PIPELINE_COUNTER