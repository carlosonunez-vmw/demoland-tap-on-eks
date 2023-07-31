#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
IMGPKG_APP_PATH="$(dirname "$(realpath "$0")")/.data/tanzu/cluster-essentials/imgpkg"
# shellcheck disable=SC2155
export INSTALL_REGISTRY_HOSTNAME="$(get_from_config '.config.tanzu_network.registry_hostname')" || exit 1
# shellcheck disable=SC2155
export INSTALL_REGISTRY_USERNAME="$(get_from_config '.config.tanzu_network.username')" || exit 1
# shellcheck disable=SC2155
export INSTALL_REGISTRY_PASSWORD="$(get_from_config '.config.tanzu_network.password')" || exit 1
TAP_VERSION="$(get_common_version 'tap')" || exit 1

login_to_local_registry() {
  docker login "harbor.$1" -u admin -p "$2"
}

login_to_tap_registry() {
  docker login "$INSTALL_REGISTRY_HOSTNAME" -u "$INSTALL_REGISTRY_USERNAME" \
    -p "$INSTALL_REGISTRY_PASSWORD"
}

# This needs to be set to 'localhost' instead of 'registry' since imgpkg
# runs on your computer instead of within a Kubernetes pod.
slurp_images() {
  "$IMGPKG_APP_PATH" copy \
    -b "$2" \
      --to-repo "harbor.$1/tap-${TAP_VERSION}/tap-packages"
}

domain="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1
harbor_password="$(docker-compose run --rm terraform output -raw harbor_admin_password)" || exit 1
tap_packages_repo="$(get_repo_from_config 'tap_packages')" || exit 1
login_to_local_registry "$domain" "$harbor_password" &&
  login_to_tap_registry &&
  slurp_images "$domain" "$tap_packages_repo"
