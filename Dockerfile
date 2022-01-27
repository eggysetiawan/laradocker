FROM php:8.1-fpm-alpine

# Copy composer.lock and composer.json
COPY ./src/composer.lock ./src/composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html

COPY --chown=www-data:www-data . /var/www/html


# Install Additional dependencies
RUN apk update && apk add --no-cache \
    build-base shadow vim curl \
    zip libzip-dev \
    php8 \
    php8-fpm \
    php8-exif \
    php8-common \
    php8-pdo \
    php8-pdo_mysql \
    php8-mysqli \
    php8-mbstring \
    php8-xml \
    php8-openssl \
    php8-json \
    php8-phar \
    php8-zip \
    php8-gd \
    php8-dom \
    php8-session \
    php8-zlib \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-install exif \
    && docker-php-ext-enable exif \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /var/cache/apk/* \
    && usermod -u 1000 www-data \
    && chown -R www-data:www-data /var/www/html

# Change current user to www
USER www-data


# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]