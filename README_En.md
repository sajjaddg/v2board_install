# V2board one-click deployment

**The script is suitable for the operating system: CentOS7.X/RedHat7.X deployment, memory 1G memory, disk capacity greater than 5G, it is best to use a separate server for the deployment environment to avoid environmental conflicts. **

#### Introduction to the environment (only the environment for the automatic installation of the script is introduced, no need to install any environment before running the script):

```shell
Nginx 1.20.2
Mysql 5.6.51
PHP 7.3.33
redis 6.2.2
```
> Test 1H1G machine deployment, about 170s. Please use centos7 series pure host deployment.


#### Software version:

```
V2board 1.7.3
```

#### One-click deployment script:

```shell
yum -y install git wget && git clone https://github.com/gz1903/v2board_install.git /usr/local/src/v2board_install && cd /usr/local/src/v2board_install && chmod +x v2board_install.sh && ./ v2board_install.sh
```

#### Installation process:

Custom database password:

```shell
#################################################### ###################
# Welcome to V2board one-click deployment script #
# Script adaptation environment CentOS7+/RetHot7+, memory 1G+ #
# For more information, please visit https://gz1903.github.io #
#################################################### ###################

Please enter the Mysql database root password: (custom)
```

> To execute the official script installation process, you need to execute yes
>
> ![y](https://cdn.jsdelivr.net/gh/gz1903/tu/a39ca9cd020e695f36612ed2dccdb0cb.png)

```shell
Running 2.0.13 (2021-04-27 13:11:08) with PHP 7.3.33 on Linux / 3.10.0-1160.el7.x86_64
Do not run Composer as root/super user! See https://getcomposer.org/root for details
Continue as root/super user [yes]? y
```

`Need to pull gitgub resources, the domestic network is slow, or the download fails, please ensure that the network is smooth`



#### Enter installation information:

Database address: localhost

Database: v2board

Database user name: root

Other customizations.

```shell
__ ______ ____ _  
\ \ / /___ \| __ ) ___ __ _ _ __ __| |
 \ \ / / __) | _ \ / _ \ / _` | '__/ _` |
  \ V / / __/| |_) | (_) | (_| | | | (_| |
   \_/ |_____|____/ \___/ \__,_|_| \__,_|

 Please enter the database address (default: localhost) [localhost]:
 > localhost

 Please enter the database name:
 > v2board

 Please enter the database username:
 > root

 Please enter the database password:
 > start custom password       

Importing database please wait...
Database import complete

 Please enter the administrator email address?:
 > v2board@qq.com

 Please enter the administrator password?:
 > Custom

Everything is ready
Visit http(s)://your site/admin to enter the management panel

```



#### finish installation

```shell
--------------------------- INSTALLATION COMPLETED -------------------- -------
#################################################### #################
#V2board#
#################################################### #################
 Database user name: root
 Database password:
 Website directory: /usr/share/nginx/html/v2board
 Nginx configuration file: /etc/nginx/conf.d/v2board.conf
 PHP configuration directory: /etc/php.ini
 Intranet access: http://
 Extranet access: http://
 Installation log file: /var/log/V2board_install_2021-12-10_17:15:09.log
-------------------------------------------------- ----------------
 If there is a problem with the installation, please report the installation log file.
 If you have any problems, please seek help here: https://gz1903.github.io
 E-mail: v2board@qq.com
-------------------------------------------------- ----------------
```


#### Main interface
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/0761a10fc7ec8db631493bf2ce455aad.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/c1c18e8cb08ee3ad7b4ce73c5f06d0ee.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/7f9d07a7d96dec7e07cf9de88c9e0c9a.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/6c90fee3362f6874ea96f64fe469a2ab.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/6c88a680e8bfd55e2c1d48f90839a8b7.png)
![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/07d87e6ddbaa2a974f061ae282a2d970.png)

#### Foreground login interface:

![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/30c58ac51674dc8df9a9f038302a1655.png)

#### Background login interface:

![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/144e26a3abb8a0b452fc235aed2be168.png)

#### Foreground interface:

![ok](https://cdn.jsdelivr.net/gh/gz1903/tu/5a7f75412aa261c360c3bf340e9a7246.png)