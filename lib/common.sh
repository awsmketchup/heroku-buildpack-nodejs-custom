info() {
	echo "       $*"
}

indent() {
	while read LINE; do
		echo "       $LINE" || true
	done
}

head() {
	echo ""
	echo "-----> $*"
}

file_contents() {
	if test -f $1; then
		echo "$(cat $1)"
	else
		echo ""
	fi
}

load_config() {
	info "Loading buildpack config..."

	source "${build_pack_dir}/buildpack.config"
	app_dir=$build_dir/$app_relative_path

	info "Detecting package.json..."

	if [ -f "$app_dir/package.json" ]; then
		info "* package.json found"
	else
		info "WARNING: no package.json detected"
	fi

	info "Will use the following versions:"
	info "* Node ${node_version}"
}

export_config_vars() {
	whitelist_regex=${2:-''}
	blacklist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'}
	if [ -d "$env_dir" ]; then
		info "Will export the following config vars:"
		for e in $(ls $env_dir); do
			echo "$e" | grep -E "$whitelist_regex" | grep -vE "$blacklist_regex" &&
			export "$e=$(cat $env_dir/$e)"
			:
		done
	fi
}
