#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
TAP_VERSION="$(get_common_version 'tap')" || exit 1
TRIVY_VERSION=0.1.4-alpha.6
IMGPKG_APP_PATH="$(dirname "$(realpath "$0")")/.data/tanzu/cluster-essentials/imgpkg"
DEV_NAMESPACE="$(get_from_config '.config.tap.dev_namespace')" || exit 1

login_to_local_registry() {
  docker login "harbor.$1" -u admin -p "$2"
}

upload_trivy_alpha_images() {
  "$IMGPKG_APP_PATH" copy \
    -b "$2" \
    --to-repo "harbor.$1/tap-${TAP_VERSION}/tap-scanners/trivy-scanner"
}

add_trivy_package_repository() {
  last_installed_status=$(kubectl get pkgr trivy-scanner-repository -n tap-install -o jsonpath='{.status.deploy.exitCode}')
  test "$last_installed_status" -eq 0 && return 0

  tanzu package repository add trivy-scanner-repository \
    --url "harbor.$1/tap-${TAP_VERSION}/tap-scanners/trivy-scanner:${TRIVY_VERSION}" \
    --namespace tap-install
}

install_trivy() {
  template=$(ytt -v app_namespace="$DEV_NAMESPACE" \
    -v registry_credentials=registry-credentials \
    -v metadata_store_secret=metadata-store-secret \
    -f "$(dirname "$0")/conf/trivy-values.yaml") || return 1
  tanzu package install trivy-scanning \
    -p trivy.scanning.apps.tanzu.vmware.com \
    -v "$TRIVY_VERSION" \
    --values-file <(echo "$template") \
    -n tap-install
}

patch_trivy_source_scan_metadata_store_config_mismatch_bug() {
  _pause_trivy_repo_reconciliation() {
    kubectl patch pkgi trivy-scanning -n tap-install --type merge --patch '{"spec":{"paused": true}}'
  }

  _apply_patched_yaml() {
    for template in public blob
    do
      kubectl delete -n "$DEV_NAMESPACE" scantemplate "trivy-${template}-source-scan-template"
      kubectl apply -n "$DEV_NAMESPACE" -f "$(dirname "$0")/conf/trivy-${template}-source-scan-template.yaml"
    done
  }


  # VMware Internal: https://vmware.slack.com/archives/C02D60T1ZDJ/p1709044582641039
  _pause_trivy_repo_reconciliation && _apply_patched_yaml
}

domain="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1
harbor_password="$(docker-compose run --rm terraform output -raw harbor_admin_password)" || exit 1
trivy_scanner_bundle="$(get_repo_from_config 'trivy_tap_scanner')" || exit 1
login_to_local_registry "$domain" "$harbor_password" &&
  upload_trivy_alpha_images "$domain" "$trivy_scanner_bundle" &&
  add_trivy_package_repository "$domain" &&
  install_trivy &&
  patch_trivy_source_scan_metadata_store_config_mismatch_bug
