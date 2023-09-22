#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
TAP_VERSION="$(get_common_version 'tap')" || exit 1
SCST_VERSION="$(get_common_version 'scanning-testing-pipeline')" || exit 1
DOMAIN_NAME="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1
DEV_NAMESPACE="$(get_from_config '.config.tap.dev_namespace')" || exit 1

install_tap() {
  template=$(ytt -v domain_name="$DOMAIN_NAME" \
    -v tap_version="$TAP_VERSION" \
    -v catalog_url="$GIT_CATALOGS_URL" \
    -v app_namespace="$DEV_NAMESPACE" \
    -f "$(dirname "$0")/conf/values.yaml") || return 1
  tanzu package install tap \
    -p tap.tanzu.vmware.com \
    -v "$TAP_VERSION" \
    --values-file <(echo "$template") \
    -n tap-install
}

install_source_code_scan_and_test_supply_chain() {
  template=$(ytt -v domain_name="$DOMAIN_NAME" \
    -v tap_version="$TAP_VERSION" \
    -f "$(dirname "$0")/conf/scst-values.yaml") || return 1
  tanzu package install ootb-supply-chain-testing-scanning \
    -p ootb-supply-chain-testing-scanning.tanzu.vmware.com \
    -v "$SCST_VERSION" \
    --values-file <(echo "$template") \
    -n tap-install \
    --wait=false
}



install_tap
install_source_code_scan_and_test_supply_chain
