FROM php:8.1-fpm

RUN apt-get update -y \
    && apt-get install -y nginx \
    && apt-get install -y netcat

RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip

WORKDIR /app

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY nginx.conf /etc/nginx/nginx.conf
COPY --chown=www-data:www-data . /app

RUN composer install --no-dev --optimize-autoloader

COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD ["sh", "/docker-entrypoint.sh"]
