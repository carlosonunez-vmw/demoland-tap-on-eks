#!/usr/bin/env bash
CERT_MANAGER_VERSION=1.7.2+vmware.1-tkg.1
HARBOR_VERSION=2.6.1+vmware.1-tkg.1
TANZU_PACKAGES_VERSION=1.6.1

create_pkg_namespace() {
  kubectl create ns tanzu-package-repo-global || true
}

add_tanzu_standard_pkg_repo() {
  2>/dev/null kubectl get pkgr vmware -n tanzu-package-repo-global ||
  tanzu package repository add vmware -n tanzu-package-repo-global \
    --url "projects.registry.vmware.com/tkg/packages/standard/repo:v$TANZU_PACKAGES_VERSION"
}

install_cert_manager() {
  tanzu package install \
      -n tanzu-package-repo-global \
      cert-manager \
      -p cert-manager.tanzu.vmware.com \
      -v "$CERT_MANAGER_VERSION"
}

install_harbor() {
  tanzu package install -n tanzu-package-repo-global harbor \
    -p harbor.tanzu.vmware.com \
    -v "$HARBOR_VERSION" \
    --values-file <(cat <<-EOF
hostname: harbor.$1
harborAdminPassword: supersecret
secretKey: abcdef012345678a
core:
  secret: supersecret
  xsrfKey: abcdef012345678aabcdef012345678a
jobservice:
  secret: supersecret
registry:
  secret: supersecret
database:
  password: supersecret
EOF
)
}

switch_to_context() {
  kubectl config use-context "kind-$1"
}
domain="${1?Please provide the domain to use for fronting Harbor.}"
source "$(dirname "$0")/include/profiles.sh"
for cluster_name in $(profiles_to_install)
do
  cluster_name="tap-$cluster_name-cluster"
  switch_to_context "$cluster_name" || exit 1
  create_pkg_namespace  &&
    add_tanzu_standard_pkg_repo  &&
    install_cert_manager  &&
    install_harbor "$1" 
done
