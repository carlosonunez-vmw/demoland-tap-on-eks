#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
# shellcheck disable=SC2155
export INSTALL_BUNDLE="$(get_from_config '.config.tanzu_network.registry_hostname')" || exit 1
# shellcheck disable=SC2155
export INSTALL_REGISTRY_HOSTNAME="$(get_from_config '.config.tanzu_network.registry_hostname')" || exit 1
# shellcheck disable=SC2155
export INSTALL_REGISTRY_USERNAME="$(get_from_config '.config.tanzu_network.username')" || exit 1
# shellcheck disable=SC2155
export INSTALL_REGISTRY_PASSWORD="$(get_from_config '.config.tanzu_network.password')" || exit 1
TAP_VERSION="$(get_common_version 'tap')" || exit 1
TANZU_CLI_DATA_DIR="$(get_directory_from_config 'tanzu_data_dir')" || exit 1
CLUSTER_ESSENTIALS_PATH="${TANZU_CLI_DATA_DIR}/cluster-essentials"
CLUSTER_ESSENTIALS_FILE="${CLUSTER_ESSENTIALS_PATH}/tanzu-cluster-essentials-darwin-amd64-${TAP_VERSION}.tgz"
extract_cluster_essentials() {
  test -d "$CLUSTER_ESSENTIALS_PATH" || mkdir -p "$CLUSTER_ESSENTIALS_PATH"
  tar -xvf "$CLUSTER_ESSENTIALS_FILE" -C "$CLUSTER_ESSENTIALS_PATH"
}

cluster_essentials_downloaded() {
  test -f "$CLUSTER_ESSENTIALS_FILE"
}

# TODO: You can also get this from PivNet.
# pivnet login --api-token=$TOKEN &&
#  pivnet ars -p tanzu-prerequisites | grep '.[] | select(.name | contains("cluster-essentials-bundle-")) | .digest'
cluster_essentials_digest() {
  pivnet ars -p tanzu-prerequisites --format=json |
    jq -r '.[] | select(.name == "cluster-essentials-bundle-'$TAP_VERSION'") | .digest'
}

install_cluster_essentials() {
  export INSTALL_BUNDLE="registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@$1"
  pushd "$CLUSTER_ESSENTIALS_PATH"
  trap 'popd' INT HUP RETURN
  trap 'rc=$?; popd; exit $rc' EXIT
  ./install.sh --yes
}

create_tanzu_cluster_essentials_dir() {
  test -d "$CLUSTER_ESSENTIALS_PATH" || mkdir -p "$CLUSTER_ESSENTIALS_PATH"
}

#  pivnet ars -p tanzu-prerequisites | grep '.[] | select(.name | contains("cluster-essentials-bundle-")) | .digest'
# TODO: Automate this with pivnet.
# --------------------------------
# - pivnet login --api-token=$TOKEN
# - pivnet product-files -p tanzu-prerequisites -r 1.4.0 --format=json | \
#     jq '.[] | select(.name | contains("darwin")) | .id' | \
#     xargs -I {} pivnet download-product-files -p tanzu-prerequisites \
#       -r 1.4.0 -i {} -d "$TMPDIR/tanzu"
download_tanzu_cluster_essentials_with_pivnet() {
  pivnet product-files -p tanzu-prerequisites -r "$TAP_VERSION" --format=json | \
     jq '.[] | select(.name | contains("darwin")) | .id' | \
     xargs -I {} pivnet download-product-files -p tanzu-prerequisites \
       -r "$TAP_VERSION" -i {} -d "$CLUSTER_ESSENTIALS_PATH"
}

log_into_pivnet() {
  pivnet login --api-token="$1"
}

tanzu_cluster_essentials_tar_present() {
  find "$CLUSTER_ESSENTIALS_PATH" -name '*darwin*' &>/dev/null
}

# We install the kapp-controller when the cluster is first provisioned.
# Trying to install it again yields an error.
remove_references_to_installing_kapp_controller() {
  if ! sed --version &>/dev/null
  then gsed -i '/kapp-controller/d' "${CLUSTER_ESSENTIALS_PATH}/install.sh"
  else sed -i '' '/kapp-controller/d' "${CLUSTER_ESSENTIALS_PATH}/install.sh"
  fi
}

token="$(get_from_config '.config.pivotal_network.token')" || exit 1
log_into_pivnet "$token" || exit 1
cluster_essentials_digest=$(cluster_essentials_digest) || exit 1
tanzu_cluster_essentials_tar_present || {
  create_tanzu_cluster_essentials_dir &&
  download_tanzu_cluster_essentials_with_pivnet || exit 1;
  extract_cluster_essentials;
} &&
remove_references_to_installing_kapp_controller;
install_cluster_essentials "$cluster_essentials_digest"
