#!/usr/bin/env bash

# name
APP_NAME="rock-the-open-source"

# Remove old site
now -t "$NOW_TOKEN" rm -y $APP_NAME

# Deploy changes to a fresh URL
now -t "$NOW_TOKEN" \
    -n $APP_NAME \
    --public -C \
    -e REACT_APP_FIREBASE_APIKEY=$REACT_APP_FIREBASE_APIKEY \
    -e REACT_APP_FIREBASE_AUTHDOMAIN=$REACT_APP_FIREBASE_AUTHDOMAIN \
    -e REACT_APP_FIREBASE_DATABASEURL=$REACT_APP_FIREBASE_DATABASEURL \
    -e REACT_APP_FIREBASE_PROJECTID=$REACT_APP_FIREBASE_PROJECTID \
    -e REACT_APP_FIREBASE_STORAGEBUCKET=$REACT_APP_FIREBASE_STORAGEBUCKET \
    -e REACT_APP_FIREBASE_MESSAGINGSENDERID=$REACT_APP_FIREBASE_MESSAGINGSENDERID \
    "$(pwd)"

# Get the deploy ID of the fresh deploy
deploy_url=$(
  now -t "$NOW_TOKEN" ls $APP_NAME |
  awk '/ url/,EOF' |
  tail -n +2 |
  awk '{ print $1 }'
)

# Move the new deploy to an alias
now alias -t "$NOW_TOKEN" $deploy_url $APP_NAME
