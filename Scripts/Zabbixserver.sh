#!/bin/bash

# Kiem tra su ton tai cua lsb
function lsb {
if [[ -x $(command -v lsb_release 2 >/dev/null) ]]; then
		return
	fi
# Neu khong se tai lsb cho tung phien ban distro trong linux
	if [[ -x $(command -v apt-get 2>dev/null) ]] then	
		sudo apt-get install -y lsb_release
	elif [[ -x $(command -v zypper 2>/dev/null) ]] then
		sudo zypper -n install lsb
	elif [[ -x $(command -v dnf 2>/dev/null) ]] then
		sudo dnf install -y rehad-lsb-core
	elif [[ -x $(command -v yum 2>/dev/null) ]] then
		sudo yum install -y redhad-lsb-core
	elif
			echo "Khong tim thay auto-install lsb_release"
			fi
}
# Hien thi ten distro vao phien ban distro bang cac option trong lsb_release
function hienthi {
		a=$(lsb_release -r -s)
		b=$(lsb_release -c -s)
		c=$(lsb_release -i -s)
		echo "Ban dang su dung he dieu hanh la $a $b $c"	
		sleep 5
	}
lsb
hienthi

# Khai bao va tao mat khau sql, database
function khaibao{
	echo "Tao user MSQL va phan quyen"
	
	echo "Nhap MYSQL_PASS cho tai khoan root"
	
	read p
	
	echo "Nhap ten CSDL muon tao"
	
	echo "Enter voi ten CSDL mac dinh la zabbix"
	
	read u
	
	u=${u:-zabbix}
	
	echo "Ban da tao CSDL voi ten mac dinh la zabbix"
	
	echo "Nhap password cho CSDL"
	
	echo "Enter voi password mac dinh la anhnt"
	
	read m
	
	m=${m:-anhnt}
	
	echo "Ban vua tao CSDL voi ten $u mat khau $m"
	
	sleep 5
}
# Dung cac lenh SQL de tao CSDL
function sql{
cat << EOF 	| mysql -uroot -p$p
create database $u character set utf8 collate utf8_bin;
grant all privileges on $u.* to zabbix@localhost identified by '$m';
flush privileges;
EOF
}
# Thuc hien cai dat zabbix server tren ubuntu 14.04
function ubuntu{

	echo "Chuong trinh cai dat zabbix server tren $c $a"
	
	echo "Start installing"
	
	sleep 5
	
	wget http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.0-1+trusty_all.deb
	
	echo "Cai dat goi vua tai ve"
	
	dpkg -i zabbix-release_3.0-1+trusty_all.deb
	
	apt-get update
	
	echo "Tai goi cai dat mysql"
	
	khaibao
	
# Cach chen password mysql khi tai moi lan dau ma khong can nhap tren man hinh	

	echo mysql-server mysql-server/root_password password $p | debconf-set-selections
	
	echo mysql-server mysql-server/root_password_again password $p | debconf-set-selections
	
	apt-get install zabbix-server-mysql zabbix-frontend-php -y
	
	sql
	
	zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -uroot -p$p
	
	echo "Backup lai file cau hinh"
	
	cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.bka
	
# Sua doi cac thong so nhu DBhost , DBName, DBPassword
	
	echo "Sua file cau hinh"
	
	sed -i's/# DBHost=localhost/DHost=localhost/g' /etc/zabbix/zabbix_server
	
	sed -i's/# DBName=zabbix/DBName=$u/g' /etc/zabbix/zabbix_server
	
	sed -i"s/# DBPassword=/DBPassword=$m/g" /etc/zabbix/zabbix_server
	
	sed -i's/# php_value data.timezone Europe\/Riga/php_value date.timezone Asia\/Ho_Chi_Minh/g' /etc/zabbix/zabbix_server
	
	echo "Restart"
	
	service zabbix-server start
	
	service apache2 restart
}
# Cai dat tren Centos
function centos {

	echo "Chuong trinh cai dat zabbix server tren $c $a"
	
	echo "Start installing"
	
	sleep 5
	
	rpm -Uvh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
	
	yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-java-gateway -y
	
	sql
	
	zcat /usr/share/doc/zabbix-server-mysql-3.0.9/create.sql.gz | mysql -uroot -p$p $u
	
	echo "Backup file cau hinh"
	
	cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.bka
	
# Sua lai cac thong so cai dat

	echo "Chinh sua file cau hinh"
	
	sed -i's/# DBHost=localhost/DBHost=localhost/g' /etc/zabbix/zabbix_server
	
	sed -i's/# DBName=zabbix/DBName=$u/g' /etc/zabbix/zabbix_server
	
	sed -i"s/# DBPassword=/DBPassword=$p/g" /etc/zabbix/zabbix_server
	
	sed -i's/# php_value date.timezone Europe/php_vale date.timezone Asia/g' /etc/httpd/conf.d/zabbix.conf
	
	sed -i's/Riga/Ho_Chi_Minh/g' /etc/httpd/conf.d/zabbix.conf
	
# Khoi dong cac dich vu

	service httpd restart
	
	systemctl start zabbix-server
	
	systemctl enable zabbix-server
	
	setsebool -P httpd_can_connect_zabbix on
	
# Mo firewall
	firewall-cmd --add-service={http,https} --permanet
	firewall-cmd --add-port={10051/tcp,10050/tcp} --permanet
	firewall-cmd --reload
}
if [[ "$c" == "Ubuntu" ]] && [[ "$a" == "14.04" ]]; then
	ubuntu
elif [[ "$c" == "CentOS" ]] && [[ "$a" == "7.3.1611" ]]; then	
	centos
else 
	echo "Scripts nay chi cai dat tren Ubuntu 14.04 va Centos 7"
fi	