#!/bin/bash

sudo apt-get update
## install curl
sudo apt-get install gnupg curl
#get GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
#create a sources list file
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
#reload package database
sudo apt-get update
#install Mongo
sudo apt-get install -y mongodb-org
#start mongo
sudo systemctl enable mongod.service
sudo systemctl daemon-reload
sudo systemctl start mongod