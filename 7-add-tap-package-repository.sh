#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
export $(egrep -Ev '^#' "$(dirname "$0")/.env" | xargs -0)
TAP_VERSION="$(get_common_version 'tap')" || exit 1
TANZU_PACKAGE_NAMESPACE="$(get_namespace 'tanzu_package_repo')" || exit 1
DOMAIN_NAME="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1

create_namespace() {
  echo "\
apiVersion: v1
kind: Namespace
metadata:
  name: tap-install
" | kapp deploy -n $TANZU_PACKAGE_NAMESPACE -a tap-${TAP_VERSION}-config -f - --yes || return 1
}

create_registry_secret() {
  tanzu secret registry add tap-registry \
    --username admin \
    --password "$1" \
    --server "harbor.${DOMAIN_NAME}" \
    --export-to-all-namespaces --yes --namespace tap-install
}

add_package_repository() {
  tanzu package repository add tanzu-tap-repository  \
    --url "harbor.${DOMAIN_NAME}/tap-${TAP_VERSION}/tap-packages" \
    --namespace tap-install
}


harbor_password="$(docker-compose run --rm terraform output -raw harbor_admin_password)" || exit 1
create_namespace &&
  create_registry_secret "$harbor_password" &&
  add_package_repository
