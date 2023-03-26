#!/bin/sh
#
#Date:2021.12.09
#Author:GZ
#Mail:V2board@qq.com

process()
{
install_date="V2board_install_$(date +%Y-%m-%d_%H:%M:%S).log"
printf "
\033[36m############################################# #########################
# Welcome to V2board one-click deployment script #
# Script adaptation environment CentOS7+/RetHot7+, memory 1G+ #
# For more information, please visit https://gz1903.github.io #
#######################################################################\033[0m
"

while :; do echo
    read -p "Please enter the Mysql database root password: " Database_Password
    [ -n "$Database_Password" ] && break
done

# Start counting script execution time after receiving information
START_TIME=`date +%s`


echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m# closing SElinux policy, please wait~ #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
setenforce 0
# Temporarily close SElinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
#Permanently close SElinux

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m# Configuring Firewall policy, please wait~ #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-ports
#Release TCP80, 443 port


echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m# Downloading the installation package, please wait for a long time~ #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
# Download the installation package
git clone https://gitee.com/gz1903/lnmp_rpm.git /usr/local/src/lnmp_rpm
cd /usr/local/src/lnmp_rpm
# Install nginx, mysql, php, redis
echo -e "\033[36m download completed, start installation~\033[0m"
rpm -ivhU /usr/local/src/lnmp_rpm/*.rpm --nodeps --force --nosignature
 
# start nmp
systemctl start php-fpm.service mysqld redis

# Add boot start
systemctl enable php-fpm.service mysqld nginx redis

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m# Mysql database is being configured, please wait~ #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
mysqladmin -u root password "$Database_Password"
echo "---mysqladmin -u root password "$Database_Password""
#Change database password
mysql -uroot -p$Database_Password -e "CREATE DATABASE v2board CHARACTER SET utf8 COLLATE utf8_general_ci;"
echo $?="Creating v2board database"

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m# Configuring PHP.ini, please wait~ #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
sed -i "s/post_max_size = 8M/post_max_size = 32M/" /etc/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 600/" /etc/php.ini
sed -i "s/max_input_time = 60/max_input_time = 600/" /etc/php.ini
sed -i "s#;date.timezone =#date.timezone = Asia/Shanghai#" /etc/php.ini
# Configure php-sg11
mkdir -p /sg
wget -P /sg/  https://cdn.jsdelivr.net/gh/gz1903/sg11/Linux%2064-bit/ixed.7.3.lin
sed -i '$a\extension=/sg/ixed.7.3.lin' /etc/php.ini
#Modify the PHP configuration file
echo $?="PHP.inin configuration complete"

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m# Configuring Nginx, please wait~ #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
cp -i /etc/nginx/conf.d/default.conf{,.bak}
cat > /etc/nginx/conf.d/default.conf <<"eof"
server {
    listen       80;
    root /usr/share/nginx/html/v2board/public;
    index index.html index.htm index.php;

    error_page   500 502 503 504  /50x.html;
    #error_page   404 /404.html;
    #fastcgi_intercept_errors on;

    location / {
        try_files $uri $uri/ /index.php$is_args$query_string;
    }
    location = /50x.html {
        root   /usr/share/nginx/html/v2board/public;
    }
    #location = /404.html {
    #    root   /usr/share/nginx/html/v2board/public;
    #}
    location ~ \.php$ {
        root           html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/html/v2board/public/$fastcgi_script_name;
        include        fastcgi_params;
    }
    location /downloads {
    }
    location ~ .*\.(js|css)?$
    {
        expires      1h;
        error_log off;
        access_log /dev/null;
    }
}
eof

cat > /etc/nginx/nginx.conf <<"eon"

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    #fastcgi_intercept_errors on;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
eon

mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/v2board.conf

# create php test file
touch /usr/share/nginx/html/phpinfo.php
cat > /usr/share/nginx/html/phpinfo.php <<eos
<?php
	phpinfo();
?>
eos

echo -e "\033[36m#######################################################################\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m# V2board is being deployed, please wait~ #\033[0m"
echo -e "\033[36m#                                                                     #\033[0m"
echo -e "\033[36m#######################################################################\033[0m"
rm -rf /usr/share/nginx/html/v2board
cd /usr/share/nginx/html
git clone https://github.com/v2board/v2board.git
cd /usr/share/nginx/html/v2board
echo -e "\033[36m, please enter y to confirm the installation: \033[0m"
sh /usr/share/nginx/html/v2board/init.sh
git clone https://gitee.com/gz1903/v2board-theme-LuFly.git /usr/share/nginx/html/v2board/public/LuFly
mv /usr/share/nginx/html/v2board/public/LuFly/* /usr/share/nginx/html/v2board/public/
chmod -R 777 /usr/share/nginx/html/v2board
# Add scheduled tasks
echo "* * * * * root /usr/bin/php /usr/share/nginx/html/v2board/artisan schedule:run >/dev/null 2>/dev/null &" >> /etc/crontab
# Install Node.js
curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum -y install nodejs
npm install -g n
n 17
node -v
# install pm2
npm install -g pm2
# Add guard queue
pm2 start /usr/share/nginx/html/v2board/pm2.yaml --name v2board
# Save the existing list data, and it will automatically load the saved application list to start after booting
pm2 save
# set boot
pm2 startup

# Get the host intranet ip
ip="$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')"
# Get the external network ip of the host
ips="$(curl ip.sb)"

systemctl restart php-fpm mysqld redis && nginx
echo $?="Service startup complete"
# Clear cache garbage
rm -rf /usr/local/src/v2board_install
rm -rf /usr/local/src/lnmp_rpm
rm -rf /usr/share/nginx/html/v2board/public/LuFly

# V2Board installation completion time statistics
END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo -e "\033[36m This installation uses $EXECUTING_TIME S!\033[0m"

echo -e "\033[32m--------------------------- Installation completed------------ ---------------\033[0m"
echo -e "\033[32m##################################################################\033[0m"
echo -e "\033[32m#                            V2board                             #\033[0m"
echo -e "\033[32m##################################################################\033[0m"
echo -e "\033[32m database user name: root\033[0m"
echo -e "\033[32m database password:"$Database_Password
echo -e "\033[32m website directory:/usr/share/nginx/html/v2board \033[0m"
echo -e "\033[32m Nginx configuration file: /etc/nginx/conf.d/v2board.conf \033[0m"
echo -e "\033[32m PHP configuration directory: /etc/php.ini \033[0m"
echo -e "\033[32m Intranet access: http://"$ip
echo -e "\033[32m Extranet access: http://"$ips
echo -e "\033[32m Installation log file:/var/log/"$install_date
echo -e "\033[32m------------------------------------------------------------------\033[0m"
echo -e "\033[32m If there is a problem with the installation, please feedback the installation log file.\033[0m"
echo -e "\033[32m If there is a problem with using it, please seek help here: https://gz1903.github.io\033[0m"
echo -e "\033[32m E-mail: v2board@qq.com\033[0m"
echo -e "\033[32m------------------------------------------------------------------\033[0m"

}
LOGFILE=/var/log/"V2board_install_$(date +%Y-%m-%d_%H:%M:%S).log"
touch $LOGFILE
tail -f $LOGFILE &
pid=$!
exec 3>&1
exec 4>&2
exec &>$LOGFILE
process
ret=$?
exec 1>&3 3>&-
exec 2>&4 4>&-