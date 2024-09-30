FROM php:8.3.12-fpm-bookworm

LABEL maintainer="Vicente Russo <vicente.russo@gmail.com>"

# Install dependencies and PHP extensions
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    cron \
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
    #libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    libzip-dev \
    memcached \
    wget \
    unzip \
    zlib1g-dev \
    locales \
    cron \
    && docker-php-ext-install pdo_mysql  \
    && docker-php-ext-install mysqli  \
    && docker-php-ext-configure gd --with-webp --with-jpeg --with-xpm --with-freetype \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl \
    bcmath \
    bz2 \
    calendar \
    exif \
    gettext \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    xsl \    
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install zip \
    #    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    #    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install redis && docker-php-ext-enable redis \
    #&& pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# Add locale pt_BR
RUN sed -i 's/# pt_BR*/pt_BR/' /etc/locale.gen && locale-gen

# Add user for application
RUN groupadd -g 1000 www && useradd -u 1000 -ms /bin/bash -g www www

# Change current user to www
USER www