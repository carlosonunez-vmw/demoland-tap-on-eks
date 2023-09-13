#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
TAP_VERSION="$(get_common_version 'tap')" || exit  1
TANZU_DATA_DIR="$(get_directory_from_config 'tanzu_data_dir')" || exit 1
TANZU_CLI_TAR_FILE="${TANZU_DATA_DIR}/tanzu-cli-darwin-amd64.tar.gz"
TANZU_CLI_TAR_FILENAME="$(basename "$TANZU_CLI_TAR_FILE")"
TANZU_CLI_PACKAGE_NAME=tanzu-core-cli-mac
KAPP_CONTROLLER_URL="$(get_url_from_config 'kapp-controller')"

tanzu_cli_tar_present() {
  find "$TANZU_DATA_DIR" -name "$TANZU_CLI_TAR_FILENAME" 2>/dev/null | grep .
}

extract_tanzu_cli_tar() {
  test -f "$TANZU_DATA_DIR/cli-extracted" && return 0

  find "$TANZU_DATA_DIR" -name "$TANZU_CLI_TAR_FILENAME" \
    -exec tar -xvf {} -C "$TANZU_DATA_DIR" \; &&
  tar -xvf "$TANZU_CLI_TAR_FILE" -C "$TANZU_DATA_DIR" &&
    touch "$TANZU_DATA_DIR/cli-extracted"
}

download_tanzu_cli_with_pivnet() {
  pivnet login --api-token="$1"  || return 1
  pivnet product-files -p tanzu-application-platform -r "$TAP_VERSION" --format=json | \
     jq '.[] | select(.name | contains("'"$TANZU_CLI_PACKAGE_NAME"'")) | .id' | \
     xargs -I {} pivnet download-product-files -p tanzu-application-platform \
       -r "$TAP_VERSION" -i {} -d "$TANZU_DATA_DIR"
}

install_tanzu_cli() {
  cli_bin=$(find "$TANZU_DATA_DIR" -type f -name tanzu-cli-darwin_amd64 | head -1)
  if ! test -f "$cli_bin"
  then
    >&2 echo "ERROR: CLI binary not found."
    return 1
  fi
  chmod +x "$cli_bin"
  >&2 echo "===> Installing the Tanzu CLI into your computer; enter password when/if prompted."
  TANZU_CLI_NO_INIT=true sudo install "$cli_bin" /usr/local/bin/tanzu
}

# The architecture of Tanzu CLI plugins changed to now rely on OCI image registries.
# This means that doing it "airgapped" like we were doing would now require us to
# stand up Harbor before we install plugins.
#
# Given that we also install kapp-controller in this script and `cert-manager` and
# Contour are installed as `kapp` packages, we would need to cut all of the Tanzu CLI stuff
# and move it up a few steps.
#
# I'm lazy and don't want to do that right now.
#
# Instead, we're going to break our "airgap" for now and install plugins from VMware's registry.
#
# TODO: Do the above!
install_tanzu_plugins() {
  trap 'popd &>/dev/null' INT HUP EXIT RETURN
  &>/dev/null pushd "$TANZU_DATA_DIR" || return 1
  TANZU_CLI_NO_INIT=true tanzu plugin install --group "vmware-tap/default:v$TAP_VERSION"
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
