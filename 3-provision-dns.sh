#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
EXTERNAL_DNS_VERSION="$(get_helm_app_version 'external-dns')" || exit 1
TANZU_PACKAGE_NAMESPACE="$(get_namespace 'tanzu_package_repo')" || exit 1
install_external_dns() {
  kapp deploy -a external-dns -n "$TANZU_PACKAGE_NAMESPACE" \
    --yes \
    -f <(helm template external-dns bitnami/external-dns --version "$2" -f - <<-EOF
provider: aws
policy: upsert-only
txtOwnerId: $4
aws:
  region: $3
  zoneType: public
sources:
  - service
  - ingress
  - contour-httpproxy
domainFilters:
  - $1
serviceAccount:
  create: true
  name: external-dns-sa
  annotations:
    eks.amazonaws.com/role-arn: "$5"
EOF
)
}

add_bitnami_helm_repo() {
  helm repo add bitnami https://charts.bitnami.com/bitnami
}

domain="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1
region=$(docker-compose run --rm terraform output -raw aws_region) || exit 1
zone_id=$(docker-compose run --rm terraform output -raw zone_id) || exit 1
role_arn=$(docker-compose run --rm terraform output -raw external_dns_role_arn) || exit 1
add_bitnami_helm_repo || exit 1
chart_version=$(helm search repo bitnami/external-dns --versions --output json |
  jq -r '.[] | select(.app_version == "'$EXTERNAL_DNS_VERSION'") | .version' |
  sort -r |
  head -1) &&
  install_external_dns "$domain" "$chart_version" "$region" "$zone_id" "$role_arn"
