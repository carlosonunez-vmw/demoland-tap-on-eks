ENCRYPTED_CONFIG_FILE="$(git rev-parse --show-toplevel)/config.enc.yaml"
UNCOMMITTED_CONFIG_FILE="$(git rev-parse --show-toplevel)/config.yaml"

_decrypt_then_yq() {
  if test -f "$ENCRYPTED_CONFIG_FILE"
  then sops --decrypt "$ENCRYPTED_CONFIG_FILE" | yq "$1"
  else yq "$1" "$UNCOMMITTED_CONFIG_FILE"
  fi
}

get_from_config() {
  val=$(_decrypt_then_yq "$1") || return 1
  if test "$val" == 'null'
  then
    >&2 echo "ERROR: key not found in config: $1"
    return 1
  fi
  echo "$val" 
}

get_directory_from_config() {
  dir_raw=$(get_from_config ".config.common_unencrypted.directories.$1") || return 1
  eval 'echo "'"$dir_raw"'"'
}

get_common_version() {
  get_from_config ".versions_unencrypted.common.$1"
}

get_helm_app_version() {
  get_from_config ".versions_unencrypted.helm_app.$1"
}

get_tanzu_package_version() {
  get_from_config ".versions_unencrypted.tanzu_packages.$1"
}

get_namespace() {
  get_from_config ".config.common_unencrypted.namespaces.$1"
}

get_repo_from_config() {
  get_from_config ".config.common_unencrypted.repositories.$1"
}

get_current_demo_environment_id() {
  get_from_config '.config.demo_information_unencrypted.id'
}

get_url_from_config() {
  get_from_config '.urls_unencrypted.kapp-controller'
}

for required in yq sops
do
  if ! &>/dev/null which "$required"
  then
    >&2 echo "ERROR: Please install '$required' first before running these scripts"
    exit 1
  fi
done
if ! test -f "$ENCRYPTED_CONFIG_FILE" && ! test -f "$UNCOMMITTED_CONFIG_FILE"
then
  >&2 echo "ERROR: Encrypted config file not found at $ENCRYPTED_CONFIG_FILE or 
$UNCOMMITTED_CONFIG_FILE.

Make sure to create a copy from ${CONFIG_FILE}.example first and either:

- Save that copy as $UNCOMMITTED_CONFIG_FILE, or
- (preferred) Encrypt the copy as $ENCRYPTED_CONFIG_FILE with sops.

Note: If you are contributing to this demo stack, note that you MUST
create or update the encrypted config file at $ENCRYPTED_CONFIG_FILE before
creating your pull request. Changes to $UNCOMMITTED_CONFIG_FILE will not
be committed to Git!"
  exit 1
fi
