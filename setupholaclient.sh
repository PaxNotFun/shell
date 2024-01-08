#!/bin/bash

# Update and upgrade system packages
apt update
apt upgrade -y

# Create web directory and install Git
mkdir /var/www/
apt -y install git

# Clone HolaClient repository
git clone https://github.com/HolaClient/HolaClient.git

# Install Node.js and dependencies
curl -sL https://deb.nodesource.com/setup_17.x | sudo bash -
apt-get install -y nodejs gcc g++ make

# Navigate to HolaClient directory
cd HolaClient

# Install Yarn
sudo apt-get update
sudo apt-get install yarn

# Install npm dependencies
npm i

# Install pm2 globally
npm i -g pm2

# Start HolaClient with pm2
pm2 start --name "holaclient" /src/app.js

# Configure pm2 to start on system boot
pm2 startup
pm2 save
