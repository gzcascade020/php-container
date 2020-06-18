FROM php:7.2-alpine
    
ENV EXT_XDEBUG_VERSION=2.9.6

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer

# Install Xdebug
RUN docker-php-source extract \
    && mkdir -p /usr/src/php/ext/xdebug \
    && curl -fsSL https://github.com/xdebug/xdebug/archive/$EXT_XDEBUG_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/xdebug --strip 1 \
    && docker-php-ext-install xdebug \
    && docker-php-source delete

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && sed -i 's/^memory_limit = 128M$/memory_limit = -1/g' "$PHP_INI_DIR/php.ini"

# Install phpunit7 https://phpunit.de/getting-started/phpunit-7.html
RUN curl -sSL https://phar.phpunit.de/phpunit-7.phar -o phpunit.phar \
    && chmod a+x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

# Install phpcs https://github.com/squizlabs/PHP_CodeSniffer
RUN curl -sSOL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod a+x phpcs.phar \
    && mv phpcs.phar /usr/local/bin/phpcs

# Install phpmd https://github.com/phpmd/phpmd
RUN curl -sSOL https://phpmd.org/static/latest/phpmd.phar \
    && chmod a+x phpmd.phar \
    && mv phpmd.phar /usr/local/bin/phpmd 

# Install phpcpd https://github.com/sebastianbergmann/phpcpd
RUN curl -sSL https://phar.phpunit.de/phpcpd-4.phar -o phpcpd.phar \
    && chmod a+x phpcpd.phar \
    && mv phpcpd.phar /usr/local/bin/phpcpd 

# Install security-checker https://github.com/sensiolabs/security-checker
RUN curl -sSOL https://get.sensiolabs.org/security-checker.phar \
    && chmod a+x security-checker.phar \
    && mv security-checker.phar /usr/local/bin/security-checker

ENV HOME=/tmp \
    APP_ROOT=/app \
    COMPOSER_HOME=/tmp/.composer

RUN mkdir -p ${APP_ROOT} \
    && chown -R 1000:1000 ${APP_ROOT}

USER 1000
WORKDIR ${APP_ROOT}
