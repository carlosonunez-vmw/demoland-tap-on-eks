#!/usr/bin/env bash
#shellcheck disable=SC2046
source "$(dirname "$0")/include/config.sh"
HARBOR_VERSION="$(get_helm_app_version 'harbor')" || exit 1
TANZU_PACKAGE_NAMESPACE="$(get_namespace 'tanzu_package_repo')" || exit 1
TAP_VERSION="$(get_common_version 'tap')" || exit 1
install_harbor() {
  set -x
  yaml=$(cat <<-EOF
adminPassword: $3
externalURL: https://harbor.$1
service:
  type: ClusterIP
  tls:
    enabled: true
    existingSecret: harbor-tls
    notaryExistingSecret: notary-tls
exposureType: ingress
persistence:
  persistentVolumeClaim:
    registry:
      size: 49G
ingress:
  core:
    tls: true
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      ingress.kubernetes.io/force-ssl-redirect: "true"
      kubernetes.io/ingress.class: contour
      kubernetes.io/tls-acme: "true"
      external-dns.alpha.kubernetes.io/hostname: harbor.$1
    hostname: harbor.$1
  notary:
    tls: true
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      ingress.kubernetes.io/force-ssl-redirect: "true"
      kubernetes.io/ingress.class: contour
      kubernetes.io/tls-acme: "true"
      external-dns.alpha.kubernetes.io/hostname: harbor-notary.$1
    hostname: harbor-notary.$1
EOF
)
  echo "\
apiVersion: v1
kind: Namespace
metadata:
  name: tanzu-system-registry
" | kapp deploy -n "$TANZU_PACKAGE_NAMESPACE" -a harbor-ns -f - --yes || return 1
  kapp deploy -a harbor -n "$TANZU_PACKAGE_NAMESPACE" \
    --into-ns tanzu-system-registry \
    --yes \
    -f <(helm template harbor bitnami/harbor -n tanzu-system-registry --version "$2" -f - <<< "$yaml")
}

add_bitnami_helm_repo() {
  helm repo add bitnami https://charts.bitnami.com/bitnami
}

create_tap_project() {
  curl -u "admin:$2" \
    "https://harbor.$1/api/v2.0/projects" \
     -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
    --data-raw '{"project_name":"tap-'"$TAP_VERSION"'","metadata":{"public":"true"},"storage_limit":-1,"registry_id":null}'
  if test "$?" -ne 0
  then
    >&2 echo "WARNING: Unable to create tap-$TAP_VERSION project in Harbor at harbor.$1; do so manually."
  fi
}

create_app_images_project() {
  curl -u "admin:$2" \
    "https://harbor.$1/api/v2.0/projects" \
     -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
    --data-raw '{"project_name":"tap-app-images","metadata":{"public":"true"},"storage_limit":-1,"registry_id":null}'
  if test "$?" -ne 0
  then
    >&2 echo "WARNING: Unable to create tap-$TAP_VERSION project in Harbor at harbor.$1; do so manually."
  fi
}

domain="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1
harbor_password="$(docker-compose run --rm terraform output -raw harbor_admin_password)" || exit 1
add_bitnami_helm_repo || exit 1
chart_version=$(helm search repo bitnami/harbor --versions --output json |
  jq -r '.[] | select(.app_version == "'"$HARBOR_VERSION"'") | .version' |
  sort -r |
  head -1) &&
  install_harbor "$domain" "$chart_version" "$harbor_password" &&
  create_tap_project "$domain" "$harbor_password" &&
  create_app_images_project "$domain" "$harbor_password"
