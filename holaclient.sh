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
wget https://github.com/PaxNotFun/shell/raw/main/HolaClient.zip
unzip HolaClient.zip

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
certbot certonly --nginx -d portal.cometrakko.com

echo "Instalando dependencias NodeJS y mas" | boxes -d peek -a c -s 40x1
# Install Node.js and dependencies
curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -
apt-get install nodejs gcc g++ make -y

# Navigate to HolaClient directory
cd HolaClient
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
pm2 start --name "holaclient" index.js

# Configure pm2 to start on system boot
pm2 startup
pm2 save

echo "Configurando NGINX" | boxes -d peek -a c -s 40x1
# Create or edit the Nginx configuration file for HolaClient
echo "server {
    listen 80;
    server_name portal.cometrakko.com;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;

    location /afkwspath {
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_pass \"http://68.233.127.117:2000/afkwspath\";
    }

    server_name portal.cometrakko.com;
    ssl_certificate /etc/letsencrypt/live/portal.cometrakko.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/portal.cometrakko.com/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://68.233.127.117:2000/;
        proxy_buffering off;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}" | sudo tee /etc/nginx/sites-enabled/holaclient.conf
sudo nginx -t
sudo systemctl reload nginx
