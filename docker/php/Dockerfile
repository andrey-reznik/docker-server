FROM php:7.3-apache

#COPY --from=sudobmitch/base:scratch / /
RUN apt-get update

# Configure PHP
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini\
 && pear config-set php_ini /usr/local/etc/php/php.ini

RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /usr/local/etc/php/php.ini\
 && sed -i "s/display_errors = .*/display_errors = On/" /usr/local/etc/php/php.ini\
 && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /usr/local/etc/php/php.ini\
 && sed -i "s/memory_limit = .*/memory_limit = 512M/" /usr/local/etc/php/php.ini\
 && sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /usr/local/etc/php/php.ini\
 && sed -i "s/post_max_size = .*/post_max_size = 100M/" /usr/local/etc/php/php.ini\
 && sed -i "s/;date.timezone.*/date.timezone = UTC/" /usr/local/etc/php/php.ini\
 && sed -i "s~;openssl.cafile=~openssl.cafile=/etc/ssl/certs/ca-certificates.crt~" /usr/local/etc/php/php.ini\
 && sed -i "s~;curl.cainfo =~curl.cainfo=/etc/ssl/certs/ca-certificates.crt~" /usr/local/etc/php/php.ini

# Install mysqli
RUN docker-php-ext-install mysqli

# Install GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev\
 && docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr\
 && docker-php-ext-install -j$(nproc) gd

# Install mcrypt
RUN apt-get install libmcrypt-dev -y\
 && pecl install mcrypt\
 && docker-php-ext-enable mcrypt

# Install mbstring
RUN apt-get install -y libonig-dev\
 && docker-php-ext-install mbstring

# Install zip
RUN apt-get install -y unzip libzip-dev\
 && docker-php-ext-install zip

# Install Xdebug
RUN pecl install xdebug\
 && docker-php-ext-enable xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer\
 && chmod 755 /usr/bin/composer
RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

# Install PDO
RUN docker-php-ext-install pdo pdo_mysql

# Add Xdebug config
ADD ./docker/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Install Ioncube Loader

RUN echo "zend_extension = $(php-config --extension-dir)/ioncube_loader_lin_7.3.so\n/" | cat - /usr/local/etc/php/php.ini > temp\
 && mv temp /usr/local/etc/php/php.ini

RUN curl -o ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 && tar xzf ioncube.tar.gz \
 && cp ioncube/ioncube_loader_lin_7.3.so `php-config --extension-dir` \
 && rm -rf ioncube.tar.gz ioncube

# Configure Apache
RUN sed -i "s~/var/www/html~/var/www/public~g" /etc/apache2/sites-available/000-default.conf
RUN rm -rf /var/www/html
RUN a2enmod rewrite

# Add user
RUN groupadd -g 1000 app\
 && useradd -m -u 1000 -s /bin/bash -d /home/app -g app app\
 && cp /root/.bashrc /home/app/.bashrc

WORKDIR /var/www
