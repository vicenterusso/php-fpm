# PHP-FPM 7.4.30 Docker Image

Docker container to install and run [PHP-FPM](https://www.php.net/manual/en/install.fpm.php) with pt_BR language installed and enabled.

[![Build Status](https://travis-ci.com/vicenterusso/php-fpm.svg?branch=7.4.30-alpine)](https://travis-ci.com/vicenterusso/php-fpm) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/vicenterusso/php-fpm)

## Getting image

```sh
sudo docker image pull vicenterusso/php-fpm:7.4.30-alpine
```

## Installed extensions

```bash
sudo docker container run --rm vicenterusso/php-fpm:7.4.30-alpine php -m
```

### PHP Modules

- bcmath
- calendar
- Core
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
- gmp
- hash
- iconv
- imagick
- intl
- json
- libxml
- mbstring
- mcrypt
- mongodb
- mysqlnd
- OAuth
- openssl
- pcntl
- pcre
- PDO
- pdo_dblib
- pdo_pgsql
- pdo_sqlite
- pgsql
- Phar
- posix
- psr
- readline
- redis
- Reflection
- session
- SimpleXML
- sockets
- sodium
- SPL
- sqlite3
- ssh2
- standard
- sysvmsg
- sysvsem
- sysvshm
- tidy
- tokenizer
- vips
- xml
- xmlreader
- xmlrpc
- xmlwriter
- xsl
- yaml
- zip
- zlib

### Zend Modules

_None_
