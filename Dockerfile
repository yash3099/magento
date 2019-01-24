FROM php:7.2-apache

ENV PHP_EXT_APCU_VERSION "5.1.12"
ENV PHP_EXT_MEMCACHED_VERSION "3.0.4"
ENV PHP_EXT_XDEBUG_VERSION "2.6.1"

RUN curl -s https://MAG005442789:4e0b11de7d396775723ea7526d40e2e563e710d6@www.magentocommerce.com/products/downloads/file/Magento-CE-2.3.0.tar.gz | tar zxvf - -C /var/www/html/
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html
COPY ./magento.conf /etc/apache2/sites-available/magento.conf


RUN build_packages="libpng-dev libfreetype6-dev libjpeg62-turbo-dev libxml2-dev libxslt1-dev libmemcached-dev sendmail-bin sendmail libicu-dev" \
    && apt-get update  && apt-get install -y $build_packages mysql-server \
    && yes "" | pecl install apcu-$PHP_EXT_APCU_VERSION && docker-php-ext-enable apcu \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && echo "no" | pecl install memcached-$PHP_EXT_MEMCACHED_VERSION && docker-php-ext-enable memcached \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && yes | pecl install xdebug-$PHP_EXT_XDEBUG_VERSION && docker-php-ext-enable xdebug \
    && docker-php-ext-install xsl \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN a2ensite magento.conf
RUN a2enmod rewrite
ENV USER=magento
ENV PASS=magento
ENV DB=magento
COPY ./start.sh .
RUN ["chmod", "+x", "./start.sh"]
ENTRYPOINT ./start.sh


