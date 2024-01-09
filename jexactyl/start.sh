#!/bin/bash

echo -e "\e[31mESTAS REINSTALANDO TODO PUEDE OCASIONAR UN MAL FUNCIONAMIENTO\e[0m" | boxes -d peek -a c -s 40x11

# Update and upgrade system packages
apt update
apt upgrade -y

# Instalando Dependencias
mkdir /var/www/
apt install git -y
apt install nano -y
apt install boxes -y
apt install unzip -y
apt install cron -y
echo "Estamos Instalando Todo Espera Por Favor " | boxes -d peek -a c -s 40x11

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
certbot certonly --nginx -d console.cometrakko.com

echo "Instalando y Configurando Dependencias" | boxes -d peek -a c -s 40x1
apt install software-properties-common curl apt-transport-https ca-certificates gnupg -y
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
add-apt-repository ppa:redislabs/redis -y
apt update
apt install php8.1 php8.1-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar redis-server -y
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo "Descargando Panel Y Configurando" | boxes -d peek -a c -s 40x1
rm -rf /var/www/jexactyl
mkdir -p /var/www/jexactyl
cd /var/www/jexactyl
curl -Lo panel.tar.gz https://github.com/jexactyl/jexactyl/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz
chmod -R 755 storage/* bootstrap/cache/

echo "Configurando Bases De Datos" | boxes -d peek -a c -s 40x1
mysql -u root -p <<MYSQL_SCRIPT
CREATE USER 'jexactyl'@'127.0.0.1' IDENTIFIED BY 'admin';
CREATE DATABASE panel;
GRANT ALL PRIVILEGES ON panel.* TO 'jexactyl'@'127.0.0.1' WITH GRANT OPTION;
exit
MYSQL_SCRIPT

echo "Configurando Panel Jexactyl" | boxes -d peek -a c -s 40x1
cd /var/www/jexactyl
cp .env.example .env
composer install --no-dev --optimize-autoloader
php artisan key:generate --force
php artisan p:environment:setup
php artisan p:environment:database
php artisan p:environment:mail
php artisan migrate --seed --force
php artisan p:user:make
chown -R www-data:www-data /var/www/jexactyl/*
systemctl disable panel.service
rm -rf panel.service
(crontab -l ; echo "* * * * * php /var/www/jexactyl/artisan schedule:run >> /dev/null 2>&1") | crontab -
echo "# Jexactyl Queue Worker File
# ----------------------------------

[Unit]
Description=Jexactyl Queue Worker

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/jexactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/panel.service > /dev/null
systemctl enable --now panel.service
systemctl enable --now redis-server

echo "Configurando NGINX" | boxes -d peek -a c -s 40x1
rm /etc/nginx/sites-available/default; rm /etc/nginx/sites-enabled/default

rm -rf /etc/nginx/sites-available/panel.conf
rm -rf /etc/nginx/sites-enabled/panel.conf
cd /etc/nginx/sites-available/
wget https://raw.githubusercontent.com/PaxNotFun/shell/main/jexactyl/panel.conf

ln -s /etc/nginx/sites-available/panel.conf /etc/nginx/sites-enabled/panel.conf
nginx -t
systemctl restart nginx
