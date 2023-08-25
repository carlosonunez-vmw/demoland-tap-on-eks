#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
TANZU_DATA_DIR="$(get_directory_from_config 'tanzu_data_dir')" || exit 1
TANZU_PACKAGE_NAMESPACE="$(get_namespace 'tanzu_package_repo')" || exit 1
HELM_REGISTRY_FQDN=registry.tanzu.vmware.com
CHART_PATH_POSTGRES="oci://$HELM_REGISTRY_FQDN/tanzu-sql-postgres/vmware-sql-postgres-operator"
CHART_VERSION_POSTGRES="v2.2.0"
CHART_DIR="${TANZU_DATA_DIR}/tanzu-sql-charts"

log_into_tanzu_network_helm_registry() {
  helm registry login "$HELM_REGISTRY_FQDN" \
       --username="$1" \
       --password="$2"
}

get_tanzu_sql_chart_postgres() {
  test -d "$CHART_DIR" && rm -rf "$CHART_DIR"
  helm pull "$CHART_PATH_POSTGRES" --version "$CHART_VERSION_POSTGRES" \
    --untar --untardir "$CHART_DIR"
}

create_postgres_ns() {
  echo "\
apiVersion: v1
kind: Namespace
metadata:
  name: tanzu-data-postgres
" | kapp deploy -n "$TANZU_PACKAGE_NAMESPACE" -a tanzu-sql-postgres-ns -f - --yes
}

create_registry_secret() {
  kubectl create -n tanzu-data-postgres secret docker-registry vmware-tanzu-network \
    --docker-server="$HELM_REGISTRY_FQDN" \
    --docker-username="$1" \
    --docker-password="$2" \
    --dry-run -o yaml | kapp deploy -n "$TANZU_PACKAGE_NAMESPACE" \
      -a tanzu-sql-postgres-registry-secret -f - --yes
}

install_chart_postgres() {
  kapp deploy -n "$TANZU_PACKAGE_NAMESPACE" -a tanzu-sql-postgres-crds -f <(cat "$CHART_DIR"/vmware-sql-postgres-operator/crds/*.yaml) \
    --yes || return 1
  kapp deploy -a tanzu-sql-postgres -n "$TANZU_PACKAGE_NAMESPACE" \
    --yes \
    -f <(helm template tanzu-sql-postgres "$CHART_DIR/vmware-sql-postgres-operator" \
          --namespace tanzu-data-postgres \
          --set dockerRegistrySecretName=vmware-tanzu-network)
}

tanzu_net_username="$(get_from_config '.config.tanzu_network.username')" || exit 1
tanzu_net_password="$(get_from_config '.config.tanzu_network.password')" || exit 1
log_into_tanzu_network_helm_registry  "$tanzu_net_username" "$tanzu_net_password" &&
  get_tanzu_sql_chart_postgres &&
  create_postgres_ns &&
  create_registry_secret "$tanzu_net_username" "$tanzu_net_password" &&
  install_chart_postgres
