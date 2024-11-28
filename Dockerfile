FROM php:5.6.40-fpm

LABEL maintainer="Vicente Russo Neto <vicente.russo@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

# Configure Debian archives
RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    g++ \
    libbz2-dev \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libmagickwand-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libssh2-1 \
    libreadline-dev \
    libxslt1-dev \
    memcached \
    wget \
    unzip \
    zlib1g-dev

# Install PHP extensions
RUN docker-php-ext-install \
    mcrypt \
    mysql \
    mysqli \
    pdo_mysql \
    pdo_pgsql

# Configure and install GD
RUN docker-php-ext-configure gd \
        --with-jpeg-dir=/usr/lib \
        --with-png-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 \
    && docker-php-ext-install gd

# Install IMAP
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

# Install intl
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Install PECL extensions
RUN pecl install memcached-2.2.0 && docker-php-ext-enable memcached
RUN pecl install redis-4.3.0 && docker-php-ext-enable redis
RUN pecl install imagick && docker-php-ext-enable imagick

# Cleanup
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*