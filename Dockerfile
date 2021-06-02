# Using official PHP image as a parent image
FROM php:7.3-fpm
# Setting the working directory to /var/www/html
WORKDIR /var/www/html
# Installing required packages
RUN apt-get update && apt-get install -y --no-install-recommends gnupg netcat sudo libicu-dev libfreetype6-dev libjpeg-dev libpng-dev libxml2-dev libsodium-dev libxslt-dev     libzip-dev rsync unzip vim gzip tar
# Configure gd php extension
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
# Installing required php extensions
RUN docker-php-ext-install bcmath intl gd opcache soap sodium xsl zip pdo pdo_mysql
# Create php.ini from php.ini.production
ENV PHP_INI_DIR /usr/local/etc/php
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# Update PHP Settings
RUN sed -E -i -e 's/max_execution_time = 30/max_execution_time = 1200/' "$PHP_INI_DIR/php.ini" \
 && sed -E -i -e 's/memory_limit = 128M/memory_limit = 4000M/' "$PHP_INI_DIR/php.ini" \
 && sed -E -i -e 's/post_max_size = 8M/post_max_size = 100M/' "$PHP_INI_DIR/php.ini" \
 && sed -E -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 15M/' "$PHP_INI_DIR/php.ini" \
 && sed -i -r 's/expose_php = On/expose_php = Off/' "$PHP_INI_DIR/php.ini" \
 && sed -i -r 's/; max_input_vars = 1000/max_input_vars = 100000/' "$PHP_INI_DIR/php.ini"