#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
TAP_VERSION="$(get_common_version 'tap')" || exit  1
TANZU_DATA_DIR="$(get_directory_from_config 'tanzu_data_dir')" || exit 1
TANZU_CLI_TAR_FILE="${TANZU_DATA_DIR}/tanzu-framework-darwin-amd64.tar"
KAPP_CONTROLLER_URL="$(get_url_from_config 'kapp-controller')"

tanzu_cli_tar_present() {
  find "$TANZU_DATA_DIR" -name 'tanzu-framework-darwin*' &>/dev/null
}

extract_tanzu_cli_tar() {
  test -f "$TANZU_DATA_DIR/cli-extracted" && return 0

  find "$TANZU_DATA_DIR" -name 'tanzu-framework-darwin*' \
    -exec tar -xvf {} -C "$TANZU_DATA_DIR" \; &&
  tar -xvf "$TANZU_CLI_TAR_FILE" -C "$TANZU_DATA_DIR" &&
    touch "$TANZU_DATA_DIR/cli-extracted"
}

download_tanzu_cli_with_pivnet() {
  pivnet login --api-token="$1"  || return 1
  pivnet product-files -p tanzu-application-platform -r "$TAP_VERSION" --format=json | \
     jq '.[] | select(.name | contains("framework-bundle-mac")) | .id' | \
     xargs -I {} pivnet download-product-files -p tanzu-application-platform \
       -r "$TAP_VERSION" -i {} -d "$TANZU_DATA_DIR"
}

install_tanzu_cli() {
  trap 'popd &>/dev/null' INT HUP EXIT RETURN
  &>/dev/null pushd "$TANZU_DATA_DIR" || return 1
  cli_bin=$(find cli -type f -name tanzu-core-darwin_amd64 | head -1)
  if ! test -f "$cli_bin"
  then
    >&2 echo "ERROR: CLI binary not found."
    return 1
  fi
  chmod +x "$cli_bin"
  >&2 echo "===> Installing the Tanzu CLI into your computer; enter password when/if prompted."
  TANZU_CLI_NO_INIT=true sudo install "$cli_bin" /usr/local/bin/tanzu
}

install_tanzu_plugins() {
  trap 'popd &>/dev/null' INT HUP EXIT RETURN
  &>/dev/null pushd "$TANZU_DATA_DIR" || return 1
  TANZU_CLI_NO_INIT=true tanzu plugin install --local cli all
}

create_tanzu_cli_dir() {
  test -d "$TANZU_DATA_DIR" || mkdir -p "$TANZU_DATA_DIR"
}

install_kapp_controller() {
  kapp deploy -a kc --yes -f "$KAPP_CONTROLLER_URL"
}

token="$(get_from_config '.config.pivotal_network.token')" || exit 1
tanzu_cli_tar_present || {
  create_tanzu_cli_dir &&
  download_tanzu_cli_with_pivnet "$token" && exit 1;
}
extract_tanzu_cli_tar &&
  install_tanzu_cli &&
  install_tanzu_plugins &&
  install_kapp_controller
