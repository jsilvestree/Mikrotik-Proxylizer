#!/bin/bash
# Se quiser configurar a rede manualmente para acesso rapido a rede, descomente, retire o (#)do começo da linhas 3,4,5,6,7,8
#ifconfig eth1 192.168.0.52/24 up
#route del default gw 192.168.0.4
#route add default gw 192.168.0.1 eth1
#echo "" >> /etc/resolv.conf
#echo "nameserver 192.168.0.13" >> /etc/resolv.conf
#/etc/init.d/networking restart

sudo apt-get update
sudo apt-get install syslog-ng libapache2-mod-php5 php5-cli php-pear php-db php-mail php-mail-mime php-net-smtp php5-mysql mysql-server mysql-client -y

echo "ServerName mikrotik" >> /etc/apache2/httpd.conf

sudo tar -xvzf  ./proxylizer_0.1.1b.tar.gz -C /var/www/
cp -rf ./webproxylogtomysql.php  /var/www/proxylizer/
chown mikrotik:www-data /var/www/proxylizer -R 
sudo chown mikrotik:www-data /var/www/proxylizer -R 
sudo chmod g+w /var/www/proxylizer -R
sudo chmod ug+x /var/www/proxylizer/checkwebproxy.sh /var/www/proxylizer/mail_send.php /var/www/proxylizer/webproxylogtomysql.php

#scp -rp mikrotik@192.168.0.53:/etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/
chmod +x ./syslog-ng.sh
mv /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf-ori
echo "" >> /etc/syslog-ng/syslog-ng.conf
./syslog-ng.sh
#sudo gedit /etc/syslog-ng/syslog-ng.conf 

mkfifo /home/mikrotik/mysql.pipe
sudo chown mikrotik:mikrotik /home/mikrotik/mysql.pipe
sudo chmod g+w /home/mikrotik/mysql.pipe
#scp -rp mikrotik@192.168.0.53:/var/www/proxylizer/webproxylogtomysql.php /var/www/proxylizer/

#gedit /var/www/proxylizer/webproxylogtomysql.php

sudo /etc/init.d/syslog-ng restart


sudo mkdir /var/log/proxylizer
sudo chown mikrotik:mikrotik /var/log/proxylizer
sudo chmod u+w /var/log/proxylizer

#scp -rp mikrotik@192.168.0.53:/home/mikrotik/proxylizercrontab /home/mikrotik/

touch /home/mikrotik/proxylizercrontab
cat <<ATEOFIM >> /home/mikrotik/proxylizercrontab 
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* *     * * *           /var/www/proxylizer/mail_send.php >> /var/log/proxylizer/mail_send_log.log
* *     * * *           /var/www/proxylizer/checkwebproxy.sh >> /var/log/proxylizer/checkwebproxy.log &
ATEOFIM

crontab /home/mikrotik/proxylizercrontab

sudo /etc/init.d/apache2 restart

#sudo cp -rp phpmyadmin /var/www/
#chmod -R /var/www/phpmyadmin/
#sudo chmod 774 -R /var/www/phpmyadmin
#sudo chown mikrotik:www-data /var/www/phpmyadmin/ -R 
#reboot 
#sudo reboot 

sudo apt-get install freeradius-utils freeradius-mysql freeradius -y


#netstat -antu | grep :1812 # verifica se a porta do freeradius esta em pé
invoke-rc.d freeradius stop
sudo cp -rp /etc/freeradius/ /etc/freeradius-ori
sudo rm -rf /etc/freeradius/
sudo cp -rp ./freeradius/ /etc/
sudo chown mikrotik:freerad /etc/freeradius -R 
ps aux | grep freeradius
mysql -u root -proot -e "CREATE DATABASE radius;"
mysql -u root -proot radius < ./radius.sql
invoke-rc.d freeradius restart
sudo invoke-rc.d freeradius restart
netstat -antu | grep :1812
mysql -u root -proot -e "CREATE DATABASE proxylizerdb;"
mysql -u root -proot radius < ./proxylyzer.sql

radtest user 1234 127.0.0.1:1812 0000 nassecret
#sudo apt-get install wine

ps aux |grep freeradius |grep -v grep && ps aux |grep apache |grep -v grep && ps aux |grep mysqld |grep -v grep && ps aux |grep syslog-ng |grep -v grep

exit
