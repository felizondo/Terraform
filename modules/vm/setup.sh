#!/bin/bash
sudo apt update && sudo apt upgrade -y

# Instalar NGINX
sudo apt install -y nginx

# Crear una página de prueba para NGINX
echo "Hello from NGINX on VM$" | sudo tee /var/www/html/index.html

##ssh-keygen -t rsa -b 2048 passwprd admin