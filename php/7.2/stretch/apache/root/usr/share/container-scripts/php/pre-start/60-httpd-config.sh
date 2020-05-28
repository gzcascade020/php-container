if [ ${HTTPD_MPM_PREFORK_AUTOMATICALLY_SET} -ne 0 ]; then
  log_info 'Processing additional httpd configuration ...'

  export HTTPD_START_SERVERS=${HTTPD_START_SERVERS:-8}
  export HTTPD_MAX_SPARE_SERVERS=$((HTTPD_START_SERVERS+10))

  if [ -n "${NO_MEMORY_LIMIT:-}" -o -z "${MEMORY_LIMIT_IN_BYTES:-}" ]; then
    #
    export HTTPD_MAX_REQUEST_WORKERS=${HTTPD_MAX_REQUEST_WORKERS:-256}
  else
    # A simple calculation for MaxRequestWorkers would be: Total Memory / Size Per Apache process.
    # The total memory is determined from the Cgroups and the average size for the
    # Apache process is estimated to 15MB.
    max_clients_computed=$((MEMORY_LIMIT_IN_BYTES/1024/1024/15))
    # The MaxClients should never be lower than StartServers, which is set to 5.
    # In case the container has memory limit set to <64M we pin the MaxClients to 4.
    [[ $max_clients_computed -le 4 ]] && max_clients_computed=4
    export HTTPD_MAX_REQUEST_WORKERS=${HTTPD_MAX_REQUEST_WORKERS:-$max_clients_computed}
    echo "-> Cgroups memory limit is set, using HTTPD_MAX_REQUEST_WORKERS=${HTTPD_MAX_REQUEST_WORKERS}"
  fi

  envsubst < /opt/app-root/etc/httpd.d/mpm_prefork.conf.template > /etc/apache2/mods-available/mpm_prefork.conf
fi
