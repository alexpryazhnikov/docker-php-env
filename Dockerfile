FROM php:7.4-fpm

# Node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      procps \
      nano \
      git \
      nodejs \
      unzip \
      libicu-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      supervisor \
      cron \
      libzip-dev \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
      pdo_mysql \
      sockets \
      intl \
      opcache \
      zip \
    && rm -rf /tmp/* \
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Config PHP
COPY ./config/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/php/php.ini /usr/local/etc/php/php.ini

# Composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# XDebug
RUN pecl install xdebug
COPY ./config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

#Supervisor
RUN mkdir -p /var/log/supervisor
COPY --chown=root:root ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY --chown=root:root ./config/cron /var/spool/cron/crontabs/root
RUN chmod 0600 /var/spool/cron/crontabs/root

WORKDIR /var/www/html

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm", "-R"]
