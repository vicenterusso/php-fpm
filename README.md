# PHP-FPM 7.4.30 Docker Image

Docker container to install and run [PHP-FPM](https://www.php.net/manual/en/install.fpm.php) with pt_BR language installed and enabled.

![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/vicenterusso/php-fpm/Docker%20Image%20CI/7.4.30-alpine?label=Github%20Build&logo=github&style=flat-square) ![Travis (.com) branch](https://img.shields.io/travis/com/vicenterusso/php-fpm/7.4.30-alpine?label=Travis%20build%20status&style=flat-square)

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
