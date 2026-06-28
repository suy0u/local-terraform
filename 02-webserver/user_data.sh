#!/bin/bash
yum -y update
yum -y install httpd
my_ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>Web Server with IP: $my_ip</h2><br>Build by tflocal" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
