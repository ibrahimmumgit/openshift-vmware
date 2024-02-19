#!/bin/bash
# Install nginx and epel-release equivalent on Ubuntu
web_server_name="192.168.9.23"
app_server_name="192.168.9.22"
sudo apt update
sudo apt install -y nginx

# Download the reverse proxy configuration
sudo wget -O /etc/nginx/conf.d/proxy.conf https://raw.githubusercontent.com/ibrahimmumgit/3Tier/master/config/proxy.nginx.conf
sudo sed -i "s@SERVERNAME@$web_server_name@" /etc/nginx/conf.d/proxy.conf
sudo sed -i "s@APPTIER@$app_server_name@" /etc/nginx/conf.d/proxy.conf

# Create the SSL folder
sudo mkdir -p /etc/nginx/ssl

# Download the proxy SSL conf
sudo wget -O /etc/nginx/ssl/proxy.conf https://raw.githubusercontent.com/ibrahimmumgit/3Tier/master/config/proxy.ssl.conf
sudo sed -i "s@WEBSERVERNAME@$web_server_name@" /etc/nginx/ssl/proxy.conf

# Generate SSL keys
sudo openssl req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout /etc/nginx/ssl/proxy.key -out /etc/nginx/ssl/proxy.pem -config /etc/nginx/ssl/proxy.conf

# Open http firewall for remote connections
sudo ufw allow 'Nginx Full'

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx
