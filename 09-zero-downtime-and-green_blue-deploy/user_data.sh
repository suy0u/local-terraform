#!/bin/bash
dnf -y update
dnf -y install httpd

my_ip=$(curl -s --max-time 2 http://169.254.169.254/latest/meta-data/local-ipv4)
[ -z "$my_ip" ] && my_ip=$(awk 'END{print $1}' /etc/hosts)

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Build by Power of Terraform <font color="red"> v1.15.8</font></h2><br><p>
<font color="green">Server PrivateIP: <font color="aqua">$my_ip<br><br>

<font color="magenta">
<b>Version 1.0</b>
</body>
</html>
EOF

/usr/sbin/httpd -DFOREGROUND &
