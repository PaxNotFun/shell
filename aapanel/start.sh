#!/bin/bash

# Update and upgrade system packages
apt update
apt upgrade -y

# Instalando Dependencias
apt install nano -y
apt install boxes -y
echo "Estamos Instalando Todo Espera Por Favor " | boxes -d peek -a c -s 40x11
echo "Configurando Firewall" | boxes -d peek -a c -s 40x1
# Install SSL and Firewall
apt install firewalld -y
firewall-cmd --zone=public --add-port=888/tcp --permanent 
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=20/tcp --permanent 
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --reload

wget -O install.sh https://raw.githubusercontent.com/PaxNotFun/shell/main/aapanel/install-aapanel.sh
sudo bash install.sh aapanel
