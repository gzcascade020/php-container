#!/bin/bash

source ${PHP_CONTAINER_SCRIPTS_PATH}/common.sh

log_info 'Processing additional php opcache configuration ...'

if [ ! -f ${PHP_INI_DIR}/conf.d/10-opcache.ini ]; then
  export OPCACHE_ENABLE=${OPCACHE_ENABLE:-1}
  export OPCACHE_INTERNED_STRINGS_BUFFER=${OPCACHE_INTERNED_STRINGS_BUFFER:-8}
  export OPCACHE_MAX_ACCELERATED_FILES=${OPCACHE_MAX_ACCELERATED_FILES:-4000}
  export OPCACHE_VALIDATE_TIMESTAMPS=${OPCACHE_VALIDATE_TIMESTAMPS:-0}
  export OPCACHE_REVALIDATE_FREQ=${OPCACHE_REVALIDATE_FREQ:-2}
  export OPCACHE_FAST_SHUTDOWN=${OPCACHE_FAST_SHUTDOWN:-0}

  if [ -n "${NO_MEMORY_LIMIT:-}" -o -z "${MEMORY_LIMIT_IN_BYTES:-}" ]; then
    #
    export OPCACHE_MEMORY_CONSUMPTION=${OPCACHE_MEMORY_CONSUMPTION:-128}
  else
    # dynamically calculated based on container memory limit/16
    memory_consumption_computed=$((MEMORY_LIMIT_IN_BYTES/1024/1024/16))
    [[ $memory_consumption_computed -le 64 ]] && memory_consumption_computed=64
    export OPCACHE_MEMORY_CONSUMPTION=${OPCACHE_MEMORY_CONSUMPTION:-$memory_consumption_computed}
    echo "-> Cgroups memory limit is set, using OPCACHE_MEMORY_CONSUMPTION=${OPCACHE_MEMORY_CONSUMPTION}"
  fi

  envsubst < /opt/app-root/etc/php.d/docker-php-ext-opcache.ini.template > ${PHP_INI_DIR}/conf.d/10-opcache.ini
fi
