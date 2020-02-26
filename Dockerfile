FROM php:7.4-cli

RUN apt-get update && apt-get install -y autoconf pkg-config libssl-dev zlib1g-dev libpq-dev git libicu-dev libxml2-dev libzip-dev zip && \
    docker-php-ext-install pdo_pgsql pgsql bcmath zip pcntl

RUN apt-get install git curl openssl -y

RUN git clone https://github.com/swoole/swoole-src.git \
  && cd swoole-src \
  && phpize \
  && ./configure \
  --enable-async-redis \
  --enable-coroutine \
  --enable-coroutine-postgresql \
  && make && make install \
  && docker-php-ext-enable swoole \
  && rm -rf /tmp/*

RUN pecl install mongodb \
  && docker-php-ext-enable mongodb

RUN pecl install redis \
  && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www
copy ./src/composer.json composer.json
run composer install 

RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -
RUN apt-get -y install nodejs
RUN npm install pm2 -g

CMD ["pm2-runtime", "/var/www/server.php", "--watch"]
