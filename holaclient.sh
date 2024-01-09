#!/bin/bash

# Update and upgrade system packages
apt update
apt upgrade -y

# Create web directory and install Git
mkdir /var/www/
apt install git -y
apt install nano -y
apt install boxes -y
apt install unzip -y
echo "Estamos Instalando Todo Espera Por Favor " | boxes -d peek -a c -s 40x11
echo "Descargando Panel" | boxes -d peek -a c -s 40x1
# Clone HolaClient repository
rm -rf /var/www/panel
rm -rf /var/www/heliactyl
git clone https://github.com/HeliactylCP/panel.git /var/www/panel

echo "Configurando Firewall" | boxes -d peek -a c -s 40x1
# Install SSL and Firewall
apt install firewalld -y
firewall-cmd --zone=public --add-port=8080/tcp --permanent 
firewall-cmd --zone=public --add-port=2022/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent 
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload
echo "Configurando SSl" | boxes -d peek -a c -s 40x1
sudo apt install -y python3-certbot-nginx nginx
rm /etc/nginx/sites-enabled/default
certbot certonly --nginx -d portals.cometrakko.com

echo "Instalando dependencias NodeJS y mas" | boxes -d peek -a c -s 40x1
# Install Node.js and dependencies
curl -sL https://deb.nodesource.com/setup_20.x | sudo bash -
apt-get install nodejs gcc g++ make -y
npm install -g n
n latest

# Navigate to HolaClient directory
cp /var/www/panel /var/www/heliactyl
cd /var/www/heliactyl
rm -rf settings.json
wget https://raw.githubusercontent.com/PaxNotFun/shell/main/settings.json

# Install Yarn
sudo apt-get update
sudo apt-get install yarn -y

# Install npm dependencies
npm i

# Install pm2 globally
npm i -g pm2

# Start HolaClient with pm2
pm2 start --name "Heliactyl" index.js

# Configure pm2 to start on system boot
pm2 startup
pm2 save

echo "Configurando NGINX" | boxes -d peek -a c -s 40x1
# Create or edit the Nginx configuration file for HolaClient
cd /etc/nginx/sites-enabled/
rm -rf heliactyl.conf
wget https://raw.githubusercontent.com/PaxNotFun/shell/main/heliactyl.conf
sudo nginx -t
sudo systemctl reload nginx
