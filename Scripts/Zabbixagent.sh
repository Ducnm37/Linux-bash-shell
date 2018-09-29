#! bin/bash

# Cai dat Zabbix agent tren Ubuntu 14.04

echo "Start installing"

hostname = `uname -n`

echo "Nhap IP Zabbix server"

read ip

# Tai cac goi cai dat

echo "Download pakage."

sleep 3

wget http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.0-1+trusty_all.deb

dpkg -i zabbix-release_3.0-1+trusty_all.deb

apt-get update

echo "Tai goi Zabbix agent"

sleep 3

apt-get install zabbix-agent -y

echo "Backup file cau hinh"

cp /etc/zabix/zabbix_agentd.conf

sed -i's/Server=127.0.0.1/Server=$ip/g' /etc/zabbix/zabbix_agentd.conf

sed -i's/ServerActive=127.0.0.1/ServerActive=$ip/g' /etc/zabbix/zabbix_agentd.conf

sed -i's/Hostname= Zabbix server/Hostname=$hostname/g' /etc/zabbix/zabbix_agentd.conf

service zabbix-agent restart



