FROM gzcascade/php:7.2-apache-stretch

# Description
# This image provides an Apache 2.4 + PHP 7.2 environment for running Laravel applications.
# Exposed ports:
# * 8080 - alternative port for http

ENV LARAVEL_VERSION=5.7 \
    LARAVEL_VER_SHORT=57 \
    NAME=laravel

ENV SUMMARY="Platform for building and running Laravel $LARAVEL_VERSION applications" \
    DESCRIPTION="Laravel is a web application framework with expressive, elegant syntax. \
    We’ve already laid the foundation freeing you to create without sweating the small things."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="Apache 2.4 with Laravel ${LARAVEL_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="${NAME},${NAME}${LARAVEL_VER_SHORT}" \
      version="${LARAVEL_VERSION}"

# Set httpd DocumentRoot
ENV HTTPD_DOCUMENT_ROOT=/public

ENV LARAVEL_CONFIG_CACHE= \
    LARAVEL_OPTIMIZE= \
    LARAVEL_SECRETS=1 \
    LARAVEL_ENV_EXAMPLE_FILES=.env.example \
    LARAVEL_ENV_FILES=.env

USER root

# Enable httpd rewrite mod
RUN a2enmod rewrite

# Add pre-start scripts
COPY ./pre-start ${PHP_CONTAINER_SCRIPTS_PATH}/pre-start/

USER 1001
WORKDIR ${HOME}
