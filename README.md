# PHP-FPM 8.1.4-puppeteer Docker Image

> **Security (PHP2Shell, CVE-2026-109618 / CVE-2026-109619):** use the tag `vicenterusso/php-fpm:8.1.4-puppeteer-php2shell-fix`, built on top of `vicenterusso/php-fpm:8.1.4-php2shell-fix` (PHP 8.1.4 rebuilt with the official backport from the PHP security team). The original `8.1.4-puppeteer` tag is left untouched and remains vulnerable.

Docker container to install and run [PHP-FPM](https://php-fpm.org/) with pt_BR language, Node, puppeteer and custom fonts installed and enabled.

[![Build Status](https://app.travis-ci.com/vicenterusso/php-fpm.svg?branch=8.1.4-puppeteer)](https://app.travis-ci.com/vicenterusso/php-fpm)

## What is PHP-FPM

PHP-FPM (FastCGI Process Manager) is an alternative FastCGI implementation for PHP.

## Getting image

```sh
sudo docker image pull vicenterusso/php-fpm:8.1.4-puppeteer
``` 

## Fonts installed

- Akshar
- Crete Round
- Roboto
- Roboto Slab
