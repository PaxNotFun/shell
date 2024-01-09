#!/bin/bash

# Update and upgrade system packages
apt update
apt upgrade -y

# Instalando Dependencias
mkdir /var/www/
apt install git -y
apt install nano -y
apt install boxes -y
apt install unzip -y
echo "Estamos Instalando Todo Espera Por Favor " | boxes -d peek -a c -s 40x11
echo "Descargando Panel" | boxes -d peek -a c -s 40x1

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

echo "Instalando y Configurando Dependencias" | boxes -d peek -a c -s 40x1
apt install software-properties-common -y curl apt-transport-https ca-certificates gnupg
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
add-apt-repository ppa:redislabs/redis -y
apt update
apt install php8.1 php8.1-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar redis-server -y
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo "Descargando y Configurando Panel Jexactyl" | boxes -d peek -a c -s 40x1
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
php artisan migrate --seed --force
php artisan p:user:make
chown -R www-data:www-data
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
sudo systemctl enable --now panel.service
sudo systemctl enable --now redis-server

echo "Configurando NGINX" | boxes -d peek -a c -s 40x1
rm /etc/nginx/sites-available/default; rm /etc/nginx/sites-enabled/default

CODIGO FOR NGINX FILE

ln -s /etc/nginx/sites-available/panel.conf /etc/nginx/sites-enabled/panel.conf
nginx -t
systemctl restart nginx