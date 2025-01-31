#!/bin/bash
apt update
apt upgrade -y
apt install boxes -y
apt install cron nano -y
apt install firewalld -y
echo "Estamos Instalando Todo Espera Por Favor " | boxes -d peek -a c -s 40x11

echo "Configurando Firewall" | boxes -d peek -a c -s 40x1
# Install SSL and Firewall
firewall-cmd --zone=public --add-port=8080/tcp --permanent 
firewall-cmd --zone=public --add-port=2022/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent 
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload
