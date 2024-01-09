#!/bin/bash

# Update and upgrade system packages
apt update
apt upgrade -y

# Install Firewall and Connfigure
apt install firewalld -y
firewall-cmd --zone=public --add-port=8080/tcp --permanent 
firewall-cmd --zone=public --add-port=2022/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent 
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload

bash <(curl -s https://pterodactyl-installer.se)