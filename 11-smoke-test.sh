#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
TANZU_DATA_DIR="$(get_directory_from_config 'tanzu_data_dir')" || exit 1
DEV_NAMESPACE="$(get_from_config '.config.tap.dev_namespace')" || exit 1

clone_test_app() {
  test -d "${TANZU_DATA_DIR}/example-app" || git clone -b "$2" "$1" "${TANZU_DATA_DIR}/example-app"
}

create_workload_and_wait() {
  tanzu apps workload apply "$1" \
    -f "${TANZU_DATA_DIR}/example-app/$2" \
    -n "$DEV_NAMESPACE" \
    --yes \
    --wait \
    --tail
}

smoke_test() {
  url="https://$1.${DEV_NAMESPACE}.${DOMAIN_NAME}"
  output="$(curl -L "$url")" || return 1
  >&2 echo "===> [test] Comparing want '$2' with got '$output'"
  test "$2" == "$output"
}

repo="$(get_from_config '.config.e2e.repo')" || exit 1
ref="$(get_from_config '.config.e2e.ref')" || exit 1
want="$(get_from_config '.config.e2e.expected_output')" || exit 1
workload_fp="$(get_from_config '.config.e2e.workload_file_path')" || exit 1
clone_test_app "$repo" "$ref" &&
  app_name="$(yq -r '.metadata.name' "${TANZU_DATA_DIR}/example-app/config/workload.yaml")" &&
  create_workload_and_wait "$app_name" "$workload_fp" &&
  smoke_test "$app_name" "$want"
