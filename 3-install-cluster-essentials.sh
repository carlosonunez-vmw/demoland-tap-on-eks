#!/usr/bin/env bash
source "$(dirname "$0")/include/profiles.sh"
INSTALL_CARVEL_TOOLS_ONLY="${INSTALL_CARVEL_TOOLS_ONLY:-false}"
CLUSTER_NAMES=$(profiles_to_install)

usage() {
  cat <<-EOF
Installs the Cluster Essentials bundle onto Kind clusters.
Usage: $(basename "$0") [TANZU-NET-USERNAME] [TANZU-NET-PASSWORD]

NOTES

- Supply INSTALL_CARVEL_TOOLS_ONLY to just install the Carvel tools (useful for
  troubleshooting.)
EOF
  echo "$1"
  exit "${2:-0}"
}
CLUSTER_ESSENTIALS_FILE="$(dirname "$(realpath "$0")")/.data/tanzu/cluster-essentials.tar"
CLUSTER_ESSENTIALS_PATH="$(dirname "$(realpath "$0")")/.data/tanzu/cluster-essentials"
REGISTRY_FILES_PATH="$(dirname "$(realpath "$0")")/.data/tanzu/registry"
CERT_PATH="$REGISTRY_FILES_PATH/certs/cert.pem"
# TODO: You can also get this from PivNet.
# pivnet login --api-token=$TOKEN &&
#  pivnet ars -p tanzu-prerequisites | grep '.[] | select(.name | contains("cluster-essentials-bundle-")) | .digest'
export CLUSTER_ESSENTIALS_BUNDLE_DIGEST="sha256:5fd527dda8af0e4c25c427e5659559a2ff9b283f6655a335ae08357ff63b8e7f"
export INSTALL_BUNDLE="registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@$CLUSTER_ESSENTIALS_BUNDLE_DIGEST"
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME="${1?$(usage "Please provide your Tanzu Network username." 1)}"
export INSTALL_REGISTRY_PASSWORD="${2?$(usage "Please provide your Tanzu Network password." 1)}"
extract_cluster_essentials() {
  test -d "$CLUSTER_ESSENTIALS_PATH" || mkdir -p "$CLUSTER_ESSENTIALS_PATH"
  tar -xvf "$CLUSTER_ESSENTIALS_FILE" -C "$CLUSTER_ESSENTIALS_PATH"
}

cluster_essentials_downloaded() {
  test -f "$CLUSTER_ESSENTIALS_FILE"
}

# TODO: Automate this with pivnet.
# --------------------------------
# - pivnet login --api-token=$TOKEN
# - pivnet product-files -p tanzu-prerequisites -r 1.4.0 --format=json | \
#     jq '.[] | select(.name | contains("darwin")) | .id' | \
#     xargs -I {} pivnet download-product-files -p tanzu-prerequisites \
#       -r 1.4.0 -i {} -d "$TMPDIR/tanzu"
kubernetes_clusters_started() {
  grep -Eiq '^true$' <<< "$INSTALL_CARVEL_TOOLS_ONLY" && return 0

  clusters=$(kind get clusters)
  for cluster in "${CLUSTER_NAMES[@]}"
  do
    name=tap-$(awk -F '/' '{print $NF}' <<< "$cluster" | cut -f1 -d '.')-cluster
    grep -q "$name" <<< "$clusters" || return 1
  done
}

install_onto_every_cluster() {
  _create_kapp_controller_namespace() {
    kubectl get ns kapp-controller || kubectl create namespace kapp-controller
  }

  _create_kapp_controller_registry_secret() {
    kubectl get secret kapp-controller-config --namespace kapp-controller ||
      kubectl create secret generic kapp-controller-config \
        --namespace kapp-controller \
        --from-literal caCerts="$(cat "$CERT_PATH" | sed 's/$/\\n/' | tr -d '\n')"
  }

  _install_cluster_essentials() {
    pushd "$CLUSTER_ESSENTIALS_PATH"
    trap 'popd' INT HUP RETURN
    trap 'rc=$?; popd; exit $rc' EXIT
    ./install.sh --yes
  }

  grep -Eiq '^true$' <<< "$INSTALL_CARVEL_TOOLS_ONLY" && return 0
  for cluster in "${CLUSTER_NAMES[@]}"
  do
    name=tap-$(awk -F '/' '{print $NF}' <<< "$cluster" | cut -f1 -d '.')-cluster
    ctx="kind-${name}"
    kubectl config use-context "$ctx"

    _create_kapp_controller_namespace &&
      _create_kapp_controller_registry_secret &&
      _install_cluster_essentials
  done
}

if ! kubernetes_clusters_started
then
  >&2 echo "ERROR: None or some Kubernetes clusters missing. \
Please run 0-create-kind-cluster before running this script."
  exit 1
fi

if ! cluster_essentials_downloaded
then
  >&2 echo "ERROR: Please download the Tanzu Cluster Essentials and store them \
here: $CLUSTER_ESSENTIALS_FILE"
  exit 1
fi
extract_cluster_essentials &&
  install_onto_every_cluster
