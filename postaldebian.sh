#!/bin/bash

sudo apt install -y software-properties-common
sudo apt install -y ruby2.3 ruby2.3-dev build-essential
sudo apt install -y mariadb-server default-libmysqlclient-dev
sudo apt install -y rabbitmq-server
sudo apt install -y nodejs
sudo apt install -y git
sudo apt install -y nginx
sudo gem install bundler procodile --no-rdoc --no-ri


# MySQL
sudo echo 'CREATE DATABASE `postal` CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;' | mysql -u root
sudo echo 'GRANT ALL ON `postal`.* TO `postal`@`127.0.0.1` IDENTIFIED BY "onyeisinadubai@3454";' | mysql -u root
sudo echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`127.0.0.1`  IDENTIFIED BY "onyeisinadubai@3454";' | mysql -u root

# RabbitMQ
sudo rabbitmqctl add_vhost /postal
sudo rabbitmqctl add_user postal onyeisinadubai@3454
sudo rabbitmqctl set_permissions -p /postal postal ".*" ".*" ".*"

# System prep
sudo useradd -r -m -d /opt/postal -s /bin/bash postal
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/ruby2.3

# Application Setup
sudo -i -u postal mkdir -p /opt/postal/app
wget https://postal.atech.media/packages/stable/latest.tgz -O - | sudo -u postal tar zxpv -C /opt/postal/app ln -s /opt/postal/app/bin/postal /usr/bin/postal
sudo postal bundle /opt/postal/vendor/bundle
#Note: installing nokogiri takes 5min in my host
postal initialize-config
# Update /opt/postal/config/postal.yml passwords
postal initialize
postal start

# nginx
sudo cp /opt/postal/app/resource/nginx.cfg /etc/nginx/sites-available/default
sudo mkdir /etc/nginx/ssl/
sudo openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/postal.key -out /etc/nginx/ssl/postal.cert -days 365 -nodes -subj "/C=GB/ST=Example/L=Example/O=Example/CN=example.com"
service nginx start
sudo -u postal postal start
#
# All done
#
echo
echo "Installation complete u don try procced now"
