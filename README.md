# Mikrotik Proxylizer
## :blue_book: Documentation

Documentation is found at [Mikrotik-Proxylizer](https://github.com/jsilvestree/Mikrotik-Proxylizer) and [Mais Infomações](https://github.com/jsilvestree/Mikrotik-Proxylizer).
## Este link leva para uma páguina antiga que pode ou não estar funcionando!
        https://wiki.mikrotik.com/wiki/Proxylizer

                                                                           
*    MikroTik Proxylizer, Web-proxy log analyzer                           
*    Copyright (C) 2009  MikroTik                                          
*                                                                          
*    This program is free software: you can redistribute it and/or modify  
*    it under the terms of the GNU General Public License as published by  
*    the Free Software Foundation, either version 3 of the License, or     
*    (at your option) any later version.                                    
*                                                                           
*    This program is distributed in the hope that it will be useful,        
*    but WITHOUT ANY WARRANTY; without even the implied warranty of         
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          
*    GNU General Public License for more details.                           
*                                                                           
*    You should have received a copy of the GNU General Public License      
*    along with this program.  If not, see <http://www.gnu.org/licenses/>.  
## :penguin: Compatibility

Mikrotik-Proxylizer will run on popular distros as long as the minimum requirements are met.

* Ubuntu
* Debian
* CentOS é preciso modificar varios comandos                                                                            

# Este projeto foi descontinuado pela Mikrotik e os arquivos originais não estão mais disponiveis,  coloquei no github para interessados estudarem os codigos 
Não existe garantias, use por sua conta e risco.

# Note: MikroTik has discontinued the Proxylizer project, it will no longer receive updates, and technical support will not be available



O script install.sh são alguns passos dp guia de instalação, você pode usar o script ou executar comando por comando.
se executar o install.sh ele instalará no Ubuntu varios pacotes e suas dependencias.

O script espera um usuario do linux chamado mikrotik, se o nome do seu usuario é outro edite o script antes de executalo,

Alguns pacotes 
syslog-ng 
libapache2-mod-php5
php5-cli 
php-pear
php-db 
php-mail 
php-mail-mime 
php-net-smtp
php5-mysql 
mysql-server
mysql-client

Esta instalação foi usado o Ubuntu com nome de usuário mikrotik.

# Para mais informações leia o documento instalar-proxylizer.pdf no repositório Mikrotik-Proxylizer.
* :computer: Console
* 
``` sudo apt-get update```

``` sudo apt-get install syslog-ng libapache2-mod-php5 php5-cli php-pear php-db php-mail php-mail-mime php-net-smtp php5-mysql mysql-server mysql-client -y ```

``` echo "ServerName mikrotik" >> /etc/apache2/httpd.conf ```

``` sudo tar -xvzf  ./proxylizer_0.1.1b.tar.gz -C /var/www/```

```cp -rf ./webproxylogtomysql.php  /var/www/proxylizer/```

```chown mikrotik:www-data /var/www/proxylizer -R ```

```sudo chown mikrotik:www-data /var/www/proxylizer -R ```

```sudo chmod g+w /var/www/proxylizer -R```

```sudo chmod ug+x /var/www/proxylizer/checkwebproxy.sh /var/www/proxylizer/mail_send.php /var/www/proxylizer/webproxylogtomysql.php```

```#scp -rp mikrotik@192.168.0.53:/etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/```

```chmod +x ./syslog-ng.sh```
```mv /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf-ori```

```echo "" >> /etc/syslog-ng/syslog-ng.conf```

```./syslog-ng.sh```

```#sudo gedit /etc/syslog-ng/syslog-ng.conf ```

```mkfifo /home/mikrotik/mysql.pipe```

```sudo chown mikrotik:mikrotik /home/mikrotik/mysql.pipe```

```sudo chmod g+w /home/mikrotik/mysql.pipe```

```#scp -rp mikrotik@192.168.0.53:/var/www/proxylizer/webproxylogtomysql.php /var/www/proxylizer/```


```#gedit /var/www/proxylizer/webproxylogtomysql.php```

```sudo /etc/init.d/syslog-ng restart```


```sudo mkdir /var/log/proxylizer```

```sudo chown mikrotik:mikrotik /var/log/proxylizer```

```sudo chmod u+w /var/log/proxylizer```




```touch /home/mikrotik/proxylizercrontab```

```cat <<ATEOFIM >> /home/mikrotik/proxylizercrontab 

SHELL=/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

 * *     * * *           /var/www/proxylizer/mail_send.php >> /var/log/proxylizer/mail_send_log.log
 * *     * * *           /var/www/proxylizer/checkwebproxy.sh >> /var/log/proxylizer/checkwebproxy.log &
ATEOFIM```

```crontab /home/mikrotik/proxylizercrontab```

```sudo /etc/init.d/apache2 restart```

```sudo apt-get install freeradius-utils freeradius-mysql freeradius -y```


```netstat -antu | grep :1812 # verifica se a porta do freeradius esta em pé```
```invoke-rc.d freeradius stop```
```sudo cp -rp /etc/freeradius/ /etc/freeradius-ori```
```sudo rm -rf /etc/freeradius/```
```sudo cp -rp ./freeradius/ /etc/```
```sudo chown mikrotik:freerad /etc/freeradius -R ```
```ps aux | grep freeradius```
```mysql -u root -proot -e "CREATE DATABASE radius;"```
```mysql -u root -proot radius < ./radius.sql```
```invoke-rc.d freeradius restart```
```sudo invoke-rc.d freeradius restart```
```netstat -antu | grep :1812```
```mysql -u root -proot -e "CREATE DATABASE proxylizerdb;"```
```mysql -u root -proot radius < ./proxylyzer.sql```

```radtest user 1234 127.0.0.1:1812 0000 nassecret```

# Exibe serviços ativos
```ps aux | grep freeradius | grep -v grep && ps aux | grep apache | grep -v grep && ps aux | grep mysqld |grep -v grep && ps aux | grep syslog-ng |grep -v grep```
