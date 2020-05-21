function log_info {
  echo "---> `date +%T`     $@"
}

function log_and_run {
  log_info "Running $@"
  "$@"
}

# get_matched_files finds file for image extending
function get_matched_files() {
  local default_dir
  default_dir="$1"
  files_matched="$2"
  find "$default_dir" -maxdepth 1 -type f -name "$files_matched" -printf "%f\n"
}

# process_extending_files process extending files in $1 and $2 directories
# - source all *.sh files
#   (if there are files with same name source only file from $1)
function process_extending_files() {
  local default_dir
  default_dir=$1

  while read filename ; do
    echo "=> sourcing $filename ..."
    if [ -f $default_dir/$filename ]; then
      source $default_dir/$filename
    fi
  done <<<"$(get_matched_files "$default_dir" '*.sh' | sort -u)"
}

# process_extending_files process extending files in $1 and $2 directories
# - source all *.sh files
#   (if there are files with same name source only file from $1)
function sudo_process_extending_files() {
  local default_dir
  default_dir=$1

  while read filename ; do
    echo "=> sourcing $filename ..."
    if [ -f $default_dir/$filename ]; then
      sudo -E $default_dir/$filename
    fi
  done <<<"$(get_matched_files "$default_dir" '*.sh' | sort -u)"
}

# process extending config files in $1 and $2 directories
# - expand variables in *.conf and copy the files into /opt/app-root/etc/httpd.d directory
#   (if there are files with same name source only file from $1)
function process_extending_config_files() {
  local default_dir
  default_dir=$1

  while read filename ; do
    echo "=> sourcing $filename ..."
    if [ -f $default_dir/$filename ]; then
       envsubst < $default_dir/$filename > ${HTTPD_CONFIGURATION_PATH}/$filename
    fi
  done <<<"$(get_matched_files "$default_dir" '*.conf' | sort -u)"
}

# Copy config files from application to the location where httpd expects them
# Param sets the directory where to look for files
# This function was taken from httpd container
process_config_files() {
  local dir=${1:-.}
  if [ -d ${dir}/httpd-cfg ]; then
    echo "---> Copying httpd configuration files..."
    if [ "$(ls -A ${dir}/httpd-cfg/*.conf)" ]; then
      cp -v ${dir}/httpd-cfg/*.conf "${HTTPD_CONFIGURATION_PATH}"/
      rm -rf ${dir}/httpd-cfg
    fi
  fi
}