FROM php:8.0.0-fpm-buster

LABEL maintainer="Vicente Russo <vicente.russo@gmail.com>"

# PHP2Shell (CVE-2026-109618 / CVE-2026-109619): PHP 8.0 is EOL and has no
# official fixed release, so rebuild PHP 8.0.0 with the PHP security team's
# backport (php-src branch PHP-8.0-CVE-2026-109618-109619), adapted to 8.0.0. See php2shell/.
COPY php2shell/ /usr/src/php2shell/
RUN sh /usr/src/php2shell/rebuild-php.sh && rm -rf /usr/src/php2shell

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    g++ \
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
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gettext \
    mysqli \
    opcache \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    xsl \    
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install zip \
    && pecl install https://pecl.php.net/get/mongodb-1.9.1.tgz && docker-php-ext-enable mongodb \
    && pecl install https://pecl.php.net/get/redis-5.3.4.tgz && docker-php-ext-enable redis \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*
