#!/usr/bin/env bash

# name
APP_NAME="rock-the-open-source"

# Grab the deploy ID from the running site
existing_id=$(now --token=$NOW_TOKEN ls $APP_NAME | tail -n 2 | head -n 1 | awk '{print $1}')

# Deploy changes to a fresh URL
now -t "$NOW_TOKEN" \
    -n $APP_NAME \
    --public -C \
    -e NODE_ENV='production' \
    -e REACT_APP_FIREBASE_APIKEY=$REACT_APP_FIREBASE_APIKEY \
    -e REACT_APP_FIREBASE_AUTHDOMAIN=$REACT_APP_FIREBASE_AUTHDOMAIN \
    -e REACT_APP_FIREBASE_DATABASEURL=$REACT_APP_FIREBASE_DATABASEURL \
    -e REACT_APP_FIREBASE_PROJECTID=$REACT_APP_FIREBASE_PROJECTID \
    -e REACT_APP_FIREBASE_STORAGEBUCKET=$REACT_APP_FIREBASE_STORAGEBUCKET \
    -e REACT_APP_FIREBASE_MESSAGINGSENDERID=$REACT_APP_FIREBASE_MESSAGINGSENDERID \
    "$(pwd)"

# Get the deploy ID of the fresh deploy
deployment_id=$($now ls $APP_NAME | head -n 5 | tail -n 1 | awk '{print $1}')

# Move the URL symbolic link to the new deploy
now ln -C \
    -t "$NOW_TOKEN" \
    "$deployment_id" $APP_NAME

# Remove the old version
now rm -y "$existing_id"
