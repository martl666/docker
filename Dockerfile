FROM php:8.0.5-fpm-alpine

WORKDIR /var/www

RUN apk update && apk add \
    build-base \
    vim \
    wget \
    git \
    unzip \
    libxml2-dev 

RUN docker-php-ext-install pdo_mysql iconv xml soap opcache pdo

RUN apk add --update --no-cache --virtual .build-depencdencies $PHPIZE_DEPS \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && pecl clear-cache \
    && apk del .build-depencdencies

RUN apk add --update --no-cache $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN apk add libmcrypt-dev \
    && pecl install mcrypt-1.0.4 && docker-php-ext-enable mcrypt

RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

USER www

COPY --chown=www:www . /var/www/

EXPOSE 9000