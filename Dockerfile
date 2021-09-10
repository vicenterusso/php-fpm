FROM php:7.4.23-fpm-alpine3.14

LABEL Maintainer="Vicente Russo <vicente.russo@gmail.com>" \
    Description="PHP-FPM v7.4 with essential extensions on top of Alpine Linux."

# Composer - https://getcomposer.org/download/
ARG COMPOSER_VERSION="2.1.6"
ARG COMPOSER_SUM="72524ccebcb071968eb83284507225fdba59f223719b2b3f333d76c8a9ac6b72"

# Swoole - https://github.com/swoole/swoole-src
ARG SWOOLE_VERSION="4.7.1"

# Install dependencies
RUN set -eux \
    && apk add --no-cache \
        ca-certificates \
        freetds \
        freetype \
        gettext \
        gmp \
        icu-libs \
        imagemagick \
        libffi \
        libgmpxx \
        libintl \
        libjpeg-turbo \
        libmcrypt \
        libpng \
        libpq \
        libssh2 \
        libstdc++ \
        libtool \
        libxpm \
        libxslt \
        libzip \
        make \
        rabbitmq-c \
        tidyhtml \
        tzdata \
        vips \
        yaml \
        wget \
        unzip

#############################################
### Install and enable PHP extensions
#############################################

# Development dependencies
RUN set -eux \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        cmake \
        curl-dev \
        freetds-dev \
        freetype-dev \
        gcc \
        gettext-dev \
        git \
        gmp-dev \
        icu-dev \
        imagemagick-dev \
        libc-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        #libmemcached-dev \
        libpng-dev \
        libssh2-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt-dev \
        libzip-dev \
        linux-headers \
        openssl-dev \
        pcre-dev \
        pkgconf \
        postgresql-dev \
        rabbitmq-c-dev \
        tidyhtml-dev \
        vips-dev \
        yaml-dev \
        zlib-dev \
\
# Workaround for rabbitmq linking issue
    && ln -s /usr/lib /usr/local/lib64 \
# Enable ffi if it exists
    && set -eux \
        && if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
            echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
        fi \
\
################################
# Install PHP extensions
################################
\
# Install gd
    && ln -s /usr/lib/x86_64-linux-gnu/libXpm.* /usr/lib/ \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        --enable-gd-jis-conv \
    && docker-php-ext-install -j$(nproc) gd \
    && true \
\
# Install amqp (rabbit mq)
    && echo "/usr" | pecl install amqp \
    && docker-php-ext-enable amqp \
    && true \
\
# Install gettext
    && docker-php-ext-install -j$(nproc) gettext \
    && true \
\
# Install gmp
    && docker-php-ext-install -j$(nproc) gmp \
    && true \
\
# Install bcmath
    && docker-php-ext-install -j$(nproc) bcmath \
    && true \
\
# Install exif
    && docker-php-ext-install -j$(nproc) exif \
    && true \
\
# Install imagick
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && true \
\
# Install intl
    && docker-php-ext-install -j$(nproc) intl \
    && true \
\
# Install mcrypt
    && pecl install mcrypt \
    && docker-php-ext-enable mcrypt \
    && true \
\
# Install xmlrpc
    && docker-php-ext-configure xmlrpc --with-iconv-dir=/usr \
    && docker-php-ext-install -j$(nproc) xmlrpc \
    && true \
\
# Install mysqli
    && docker-php-ext-install -j$(nproc) mysqli \
    && true \
\
# Install oauth
    && pecl install oauth \
    && docker-php-ext-enable oauth \
    && true \
\
# Install pdo_mysql
    && docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && true \
\
# Install pdo_dblib
    && docker-php-ext-install -j$(nproc) pdo_dblib \
    && true \
\
# Install pcntl
    && docker-php-ext-install -j$(nproc) pcntl \
    && true \
\
# Install pdo_pgsql
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && true \
\
# Install pgsql
    && docker-php-ext-install -j$(nproc) pgsql \
    && true \
\
# Install psr
    && pecl install psr \
    && docker-php-ext-enable psr \
    && true \
\
# Install soap
    && docker-php-ext-install -j$(nproc) soap \
    && true \
\
# Install ssh2
    && pecl install ssh2-1.2 \
    && docker-php-ext-enable ssh2 \
    && true \
\
# Install sockets, sysvmsg, sysvsem, sysvshm (also needed by swoole)
    && docker-php-ext-install -j$(nproc) \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
    && docker-php-source extract \
    && true \
\
# Install swoole
    && mkdir /usr/src/php/ext/swoole \
    && curl -Lo swoole.tar.gz https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz \
    && tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole \
    && docker-php-ext-configure swoole \
            --enable-mysqlnd \
            --enable-sockets \
            --enable-openssl \
            --enable-http2 \
            --enable-swoole-json \
            --enable-swoole-curl \
    && docker-php-ext-install -j$(nproc) swoole \
    && rm -rf swoole.tar.gz $HOME/.composer/*-old.phar \
    && docker-php-ext-enable swoole \
    && true \
\
# Install tidy
    && docker-php-ext-install -j$(nproc) tidy \
    && true \
\
# Install xsl
    && docker-php-ext-install -j$(nproc) xsl \
    && true \
\
# Install yaml
    && pecl install yaml \
    && docker-php-ext-enable yaml \
    && true \
\
# Install vips
    && pecl install vips \
    && docker-php-ext-enable vips \
    && true \
\
# Install zip
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install -j$(nproc) zip \
    && true \
\
# Install mongodb
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && true \
#\
# Install memcached
    #&& pecl install memcached \
    #&& docker-php-ext-enable memcached \
    #&& true \
\
# Install redis
    && pecl install redis \
    && docker-php-ext-enable redis \
    && true \
\
# Clean up build packages
    && docker-php-source delete \
    && apk del .build-deps \
    && true

# Instal locales
ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl 
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

RUN apk add --no-cache \
    $MUSL_LOCALE_DEPS \
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
      && cd musl-locales-master \
      && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
      && cd .. && rm -r musl-locales-master

# Install Composer
RUN set -eux \
    && curl -LO "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
    && echo "${COMPOSER_SUM}  composer.phar" | sha256sum -c - \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && composer --version \
    && true

RUN set -eux \
# Fix php.ini settings for enabled extensions
    && chmod +x "$(php -r 'echo ini_get("extension_dir");')"/* \
# Shrink binaries
    && (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && true

# Add user for application
RUN adduser -SDu 1000 www www

# Change current user to www
USER www