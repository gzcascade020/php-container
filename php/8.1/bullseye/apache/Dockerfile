FROM php:8.1-apache-bullseye


# This image provides an Apache+PHP environment for running PHP
# applications.

EXPOSE 8080
EXPOSE 8443

# Description
# This image provides an Apache 2.4 + PHP 7.4 environment for running PHP applications.
# Exposed ports:
# * 8080 - alternative port for http

ENV PHP_VER_SHORT=81 \
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
    gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install opcache
RUN docker-php-ext-install opcache

# Add scripts
COPY ./root /

ENV APP_ROOT=/opt/app-root
# The $HOME is not set by default, but some applications needs this variable
ENV HOME=${APP_ROOT}/src \
    PHP_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/php \
    APP_DATA=${APP_ROOT}/src \
    HTTPD_DOCUMENT_ROOT=/ \
    HTTPD_CONF_LINENO=172 \
    HTTPD_MPM_PREFORK_CONF=/etc/apache2/mods-available/mpm_prefork.conf \
    OPCACHE_INI=${PHP_INI_DIR}/conf.d/10-opcache.ini

# Reset permissions of modified directories
RUN chmod g+rwX ${APP_DATA} && \
    chgrp -R 0 /var/run/apache2 /var/lock/apache2 /var/log/apache2 && \
    chmod -R g+rwX /var/run/apache2 /var/lock/apache2 /var/log/apache2
# Copy php production config
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    touch ${OPCACHE_INI} && \
    chmod a+rw ${OPCACHE_INI}
# Update apache config
# Update apache ports
RUN a2enmod ssl  && \
    rm -f ${HTTPD_MPM_PREFORK_CONF} && \
    touch ${HTTPD_MPM_PREFORK_CONF} && \
    chmod a+rw ${HTTPD_MPM_PREFORK_CONF}
    
# Directory with the sources is set as the working directory so
# can execute relative to this path.
USER 1001
WORKDIR ${HOME}