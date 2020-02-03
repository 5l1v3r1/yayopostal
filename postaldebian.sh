#!/bin/bash

apt install -y software-properties-common
apt install -y ruby2.3 ruby2.3-dev build-essential
apt install -y mariadb-server default-libmysqlclient-dev
apt install -y rabbitmq-server
apt install -y nodejs
apt install -y git
apt install -y nginx
gem install bundler procodile --no-rdoc --no-ri

# MySQL
echo 'CREATE DATABASE `postal` CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;' | mysql -u root
echo 'GRANT ALL ON `postal`.* TO `postal`@`127.0.0.1` IDENTIFIED BY "pass123";' | mysql -u root
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`127.0.0.1`  IDENTIFIED BY "pass123";' | mysql -u root

# RabbitMQ
rabbitmqctl add_vhost /postal
rabbitmqctl add_user postal pass123
rabbitmqctl set_permissions -p /postal postal ".*" ".*" ".*"

# System prep
useradd -r -m -d /opt/postal -s /bin/bash postal
setcap 'cap_net_bind_service=+ep' /usr/bin/ruby2.3

# Application Setup
sudo -i -u postal mkdir -p /opt/postal/app
wget https://postal.atech.media/packages/stable/latest.tgz -O - | sudo -u postal tar zxpv -C /opt/postal/app
ln -s /opt/postal/app/bin/postal /usr/bin/postal
postal bundle /opt/postal/vendor/bundle
#Note: installing nokogiri takes 5min in my host
postal initialize-config
# Update /opt/postal/config/postal.yml passwords
postal initialize
postal start

# nginx
cp /opt/postal/app/resource/nginx.cfg /etc/nginx/sites-available/default
mkdir /etc/nginx/ssl/
openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/postal.key -out /etc/nginx/ssl/postal.cert -days 365 -nodes -subj "/C=GB/ST=Example/L=Example/O=Example/CN=example.com"
service nginx reload

#
# All done
#
echo
echo "Installation complete"
