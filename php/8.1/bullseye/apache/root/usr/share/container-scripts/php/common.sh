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
