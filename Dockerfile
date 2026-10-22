FROM php:8.1.4-fpm-buster

LABEL maintainer="Vicente Russo <vicente.russo@gmail.com>"

# PHP2Shell (CVE-2026-109618 / CVE-2026-109619): PHP 8.1 is EOL and has no
# official fixed release, so rebuild PHP 8.1.4 with the PHP security team's
# backport (php-src branch PHP-8.1-CVE-2026-109618-109619). See php2shell/.
COPY php2shell/ /usr/src/php2shell/
RUN sh /usr/src/php2shell/rebuild-php.sh && rm -rf /usr/src/php2shell

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    g++ \
    git \
    libbz2-dev \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libzip-dev \
    memcached \
    wget \
    unzip \
    zlib1g-dev \
    locales \
    cron \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl \
    bcmath \
    bz2 \
    calendar \
    exif \
    gettext \
    opcache \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    xsl \    
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install zip \
    && pecl install https://pecl.php.net/get/mongodb-1.17.0.tgz && docker-php-ext-enable mongodb \
    && pecl install https://pecl.php.net/get/grpc-1.59.1.tgz && docker-php-ext-enable grpc \
    && pecl install https://pecl.php.net/get/redis-6.0.2.tgz && docker-php-ext-enable redis \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# Add locale pt_BR
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

# Add locale pt_BR
RUN sed -i 's/# pt_BR*/pt_BR/' /etc/locale.gen

RUN locale-gen

# Add user for application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change current user to www
USER www
