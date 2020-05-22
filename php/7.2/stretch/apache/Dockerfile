FROM php:7.2-apache-stretch


# This image provides an Apache+PHP environment for running PHP
# applications.

EXPOSE 8080
EXPOSE 8443

# Description
# This image provides an Apache 2.4 + PHP 7.2 environment for running PHP applications.
# Exposed ports:
# * 8080 - alternative port for http

ENV PHP_VER_SHORT=72 \
    NAME=php

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="Apache 2.4 with PHP ${PHP_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="${NAME},${NAME}${PHP_VER_SHORT}" \
      version="${PHP_VERSION}"

# Install utils
RUN apt-get update && \
    apt-get -y install \
    sudo \
    gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install opcache
RUN docker-php-ext-install opcache

# Add scripts
COPY ./root /

ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=1001
# The $HOME is not set by default, but some applications needs this variable
ENV HOME=${APP_ROOT}/src \
    PHP_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/php \
    APP_DATA=${APP_ROOT}/src \
    HTTPD_DOCUMENT_ROOT=/ \
    HTTPD_CONF_LINENO=172 \
    HTTPD_MPM_PREFORK_AUTOMATICALLY_SET=1

# Reset permissions of modified directories
RUN chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chgrp -R 0 /var/run/apache2 /var/lock/apache2 /var/log/apache2 && \
    chmod -R g+rwX /var/run/apache2 /var/lock/apache2 /var/log/apache2 && \
# This permissions will be reset in application runtime
    chgrp 0 /etc/shadow && \
    chmod g=u /etc/passwd /etc/shadow && \
# Copy php production config
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
# Update apache config
    a2enmod ssl  && \
    sed -ri -e 's!/var/www/html!/opt/app-root/src${HTTPD_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!/opt/app-root/src${HTTPD_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    # Update apache ports
    sed -i -e 's!Listen 80!Listen 0.0.0.0:8080!g' /etc/apache2/ports.conf && \
    sed -i -e 's!Listen 443!Listen 0.0.0.0:8443!g' /etc/apache2/ports.conf && \
    sed -i -e 's!<VirtualHost \*:80>!<VirtualHost \*:8080>!g' /etc/apache2/sites-available/000-default.conf && \
    sed -i -e 's!_default_:443!_default_:8443!g' /etc/apache2/sites-available/default-ssl.conf && \
    sed -i -e "${HTTPD_CONF_LINENO}s%AllowOverride None%AllowOverride All%" /etc/apache2/apache2.conf
    
# Directory with the sources is set as the working directory so
# can execute relative to this path.
USER 1001
WORKDIR ${HOME}

ENTRYPOINT [ "uid_entrypoint" ]
CMD [ "run" ]