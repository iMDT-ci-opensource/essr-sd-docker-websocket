FROM php:7.4-cli

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    netcat \
    libonig-dev \
    libzip-dev \
    libwebp-dev \
    libxpm-dev \
    imagemagick \
    libc-client-dev \
    procps \
    libkrb5-dev \
    rsync

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Set working directory
WORKDIR /data

# Change current user to www
USER www

RUN mkdir /tmp/composer-cache

# Feeds composer local cache
ADD _websocket/composer.json /tmp/composer-cache/
RUN sh -c "cd /tmp/composer-cache; composer install --no-autoloader --no-progress --no-suggest "

# The real command is specified in docker-compose.yml
CMD ["sleep", "10"]
