#!/bin/sh
# Rebuilds the PHP binaries of an official php:*-fpm image with the PHP2Shell
# fix (CVE-2026-109618 / CVE-2026-109619).
#
# PHP 7.4, 8.0 and 8.1 are EOL and got no official release with the fix. The
# PHP security team published minimal source backports instead:
#   https://github.com/php/php-src/tree/PHP-7.4-CVE-2026-109618-109619
#   https://github.com/php/php-src/tree/PHP-8.0-CVE-2026-109618-109619
#   https://github.com/php/php-src/tree/PHP-8.1-CVE-2026-109618-109619
# The patch next to this script is the "Avoid state corruption via bailout"
# commit of the matching branch. It is applied on top of the exact PHP source
# shipped in the image, which is then rebuilt with the same configure options
# and flags used by the official image (docker-library/php).
#
# The 8.0 backport targets 8.0.30. For older 8.0.x releases a patch for the
# exact version is shipped instead: identical to the backport, except that the
# ZEND_CONCAT overflow check (absent before later 8.0.x releases) is added
# rather than modified, the ZSTR_MAX_LEN/ZSTR_MAX_OVERHEAD macros it needs are
# added to Zend/zend_string.h (same definition as 8.0.30), and
# Zend/zend_vm_execute.h is regenerated from Zend/zend_vm_def.h with
# Zend/zend_vm_gen.php.
#
# The patched source is repacked into /usr/src/php.tar.xz, so extensions built
# later with docker-php-ext-install compile against the patched tree.
set -eux

DIR="$(cd "$(dirname "$0")" && pwd)"
# a patch adapted to the exact PHP version wins over the branch backport
PATCH="$DIR/php-$PHP_VERSION-CVE-2026-109618-109619.patch"
[ -f "$PATCH" ] || PATCH="$DIR/php-${PHP_VERSION%.*}-CVE-2026-109618-109619.patch"
[ -f "$PATCH" ]

# older official images use libedit instead of readline
case "$(php-config --configure-options)" in
	*--with-libedit*) apkEdit=libedit-dev aptEdit=libedit-dev ;;
	*) apkEdit=readline-dev aptEdit=libreadline-dev ;;
esac

if command -v apk >/dev/null; then
	apk add --no-cache --virtual .php2shell-build-deps \
		$PHPIZE_DEPS argon2-dev coreutils curl-dev gnu-libiconv-dev libsodium-dev \
		libxml2-dev linux-headers oniguruma-dev openssl-dev patch $apkEdit sqlite-dev
	# make sure musl's iconv doesn't get used (same as the official image)
	rm -vf /usr/include/iconv.h
	ln -sfv /usr/include/gnu-libiconv/*.h /usr/include/
else
	# Debian buster is EOL and was moved to archive.debian.org
	if grep -q buster /etc/apt/sources.list; then
		sed -i -e 's|deb.debian.org/debian|archive.debian.org/debian|' \
			-e 's|security.debian.org/debian-security|archive.debian.org/debian-security|' \
			/etc/apt/sources.list
		echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive
	fi
	savedAptMark="$(apt-mark showmanual)"
	apt-get update
	apt-get install -y --no-install-recommends \
		libargon2-dev libcurl4-openssl-dev libonig-dev $aptEdit libsodium-dev \
		libsqlite3-dev libssl-dev libxml2-dev patch zlib1g-dev
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"
	if [ ! -d /usr/include/curl ] && [ ! -e /usr/local/include/curl ]; then
		ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl
	fi
fi

# extract, patch and repack the source shipped with the image
docker-php-source delete
docker-php-source extract
cd /usr/src/php
patch -p1 < "$PATCH"
rm -f .docker-extracted
cd /usr/src
mv php "php-$PHP_VERSION"
tar -cJf php.tar.xz "php-$PHP_VERSION"
# the upstream signature no longer matches the patched tarball
rm -f php.tar.xz.asc
rm -rf "php-$PHP_VERSION"
docker-php-source extract
cd /usr/src/php

export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"
eval "./configure $(php-config --configure-options)"
make -j "$(nproc)"
find -type f -name '*.a' -delete
make install
find /usr/local -type f -perm '/0111' -exec sh -euxc 'strip --strip-all "$@" || :' -- '{}' +
make clean
cd /
docker-php-source delete

if command -v apk >/dev/null; then
	runDeps="$(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
		| tr ',' '\n' | sort -u \
		| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }')"
	apk add --no-cache $runDeps
	apk del --no-network .php2shell-build-deps
else
	apt-mark auto '.*' > /dev/null
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' | sort -u \
		| xargs -r dpkg-query --search | cut -d: -f1 | sort -u \
		| xargs -r apt-mark manual
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
	rm -rf /var/lib/apt/lists/*
fi
# update pecl channel definitions (same as the official image)
pecl update-channels
rm -rf /tmp/pear ~/.pearrc

# smoke test: the fix adds the exported zend_mm_safe_error_ex() symbol
php --version
php-fpm --version
grep -q zend_mm_safe_error_ex /usr/local/bin/php
grep -q zend_mm_safe_error_ex /usr/local/sbin/php-fpm
echo "PHP2Shell fix applied to PHP $PHP_VERSION"
