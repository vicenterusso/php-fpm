# PHP-FPM 8.3.2 Docker Image

Docker container to install and run [PHP-FPM](https://php-fpm.org/) with pt_BR language installed and enabled.

[![Build Status](https://travis-ci.com/vicenterusso/php-fpm.svg?branch=8.3.2)](https://travis-ci.com/vicenterusso/php-fpm) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/vicenterusso/php-fpm)

## What is PHP-FPM

PHP-FPM (FastCGI Process Manager) is an alternative FastCGI implementation for PHP.

## Getting image

```sh
sudo docker image pull vicenterusso/php-fpm:8.3.2
```

## Running your PHP script

Run the PHP-FPM image, mounting a directory from your host.

```sh
sudo docker container run --rm -v $(pwd):/var/www/html vicenterusso/php-fpm:8.3.2 php index.php
```

## Running as server

```sh
sudo docker container run --rm --name phpfpm -v $(pwd):/var/www/html -p 3000:3000 vicenterusso/php-fpm:8.3.2 php -S="0.0.0.0:3000" -t="/var/www/html"
```

or using [Docker Compose](https://docs.docker.com/compose/) :

```sh
version: '3'
services:
  phpfpm:
    container_name: phpfpm
    image: vicenterusso/php-fpm:8.3.2
    ports:
      - 3000:3000
    volumes:
      - /path/to/your/app:/var/www/html
    command: php -S="0.0.0.0:3000" -t="/var/www/html"
```

### Logging

```sh
sudo docker container logs phpfpm
```

## Installed extensions

```bash
sudo docker container run --rm vicenterusso/php-fpm:8.3.2 php -m
```

### PHP Modules

- bcmath
- bz2
- calendar
- Core
- cron
- ctype
- curl
- date
- dom
- exif
- fileinfo
- filter
- ftp
- gd
- gettext
- hash
- iconv
- imap
- intl
- json
- ldap
- libxml
- mbstring
- memcached
- mongodb
- mysqli
- mysqlnd
- openssl
- pcre
- PDO
- pdo_mysql
- pdo_pgsql
- pdo_sqlite
- pgsql
- Phar
- posix
- readline
- redis
- Reflection
- session
- SimpleXML
- soap
- sockets
- sodium
- SPL
- sqlite3
- standard
- tokenizer
- xdebug
- xml
- xmlreader
- xmlwriter
- xsl
- Zend OPcache
- zip
- zlib

### Zend Modules

- Xdebug
- Zend OPcache
