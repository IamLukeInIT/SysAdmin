#!/bin/bash

echo '$(tput setaf 2)Installation Zabbix'
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Updating Linux'
sudo apt update
sudo apt upgrade
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Installation LAMP stack'
sudo apt install apache2 php php-mysql php-mysqlnd php-ldap phpbcmath php-mbstring php-gd php-pdo php-xml libapache2-mod-php
echo '$(tput setaf 3)Apache2 status'
systemctl status apache2
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Installation MariaDB'
sudo apt install mariadb-server mariadb-client
echo '$(tput setaf 3)Apache2 status'
systemctl status mariadb
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Secure database'
sudo mysql_secure_installation
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Create database'
sudo mysql -u root -p
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'admin@monit1';
quit;
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Installing Zabbix'
wget
https://repo.zabix.com/zabbix/5.4/debian/pool/main/z/zabbix-relase/zabbix-relase_5.4-1+debian11_all.deb
dpkg -i zabbix-release_5.4-1+debian11_all.deb
apt update
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Installing Zabbix server, frontend and agemt packages'
sudo apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-agent
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Import initial schema and data into Zabbix'
zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -u zabbix -p zabbix
#zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -u zabbix -p zabbix
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Database settings'
echo "$(tput setaf 1)Uncomment or change these lines"
echo "$(tput setaf 1)########"
echo "$(tput setaf 1)DBHost=localhost"
echo "$(tput setaf 1)DBName=zabbix"
echo "$(tput setaf 1)DBUser=zabbix"
echo "$(tput setaf 1)DBPassword=admin@monit1"
sudo nano /etc/Zabbix/Zabbix
echo '$(tput setaf 6)##########################################'

systemctl restart apache2
systemctl start zabbux-server zabbix-agemt
systemctl enable zabbix-server zabbix-agent

echo '$(tput setaf 3)Firewall configuration'
ufw allow 80/tcp
ufw allow 443/tcp
ufw reload
echo "$(tput setaf 1)-A/-I"
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
echo '$(tput setaf 6)##########################################'

echo '$(tput setaf 3)Apache configuration'
sudo apt install zabbix-apache-conf
#time zone
nano /etc/Zabbix/apache.conf
echo '$(tput setaf 6)##########################################'

address=$(hostname -I)
echo '$(tput setaf 2)Address: $address/Zabbix'
