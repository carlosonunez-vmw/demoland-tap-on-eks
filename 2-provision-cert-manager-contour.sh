#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
CERT_MANAGER_VERSION="$(get_tanzu_package_version 'cert-manager')" || exit 1
TANZU_PACKAGES_VERSION="$(get_tanzu_package_version 'tkg-packages')" || exit 1
CONTOUR_VERSION="$(get_tanzu_package_version 'contour')" || exit 1
TANZU_PACKAGE_NAMESPACE="$(get_namespace 'tanzu_package_repo')" || exit 1

create_pkg_namespace() {
  kubectl create ns "$TANZU_PACKAGE_NAMESPACE" || true
}

add_tanzu_standard_pkg_repo() {
  2>/dev/null kubectl get pkgr vmware -n "$TANZU_PACKAGE_NAMESPACE" ||
  tanzu package repository add vmware -n "$TANZU_PACKAGE_NAMESPACE" \
    --url "projects.registry.vmware.com/tkg/packages/standard/repo:v$TANZU_PACKAGES_VERSION"
}

install_cert_manager() {
  tanzu package install \
      -n "$TANZU_PACKAGE_NAMESPACE" \
      cert-manager \
      -p cert-manager.tanzu.vmware.com \
      -v "$CERT_MANAGER_VERSION"
}

install_contour() {
  tanzu package install \
      -n "$TANZU_PACKAGE_NAMESPACE" \
      contour \
      -p contour.tanzu.vmware.com \
      -v "$CONTOUR_VERSION" \
      --values-file "$(dirname "$0")/conf/contour.values"
}

install_cluster_issuer() {
  kubectl apply -f - <<-EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: $2
    privateKeySecretRef:
      name: letsencrypt-sk
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - selector:
        dnsZones:
          - "$1"
      dns01:
        route53:
          region: "$3"
EOF
}

wait_for_cluster_issuer_to_become_ready() {
  >&2 echo "INFO: Waiting for the Let's Encrypt ClusterIssuer to be validated"
  kubectl wait --for condition=Ready=true --timeout=10m clusterissuer/letsencrypt-prod
}

annotate_cert_manager_with_irsa_ref() {
  kubectl annotate sa -n cert-manager cert-manager "eks.amazonaws.com/role-arn=$1"  &&
    kubectl rollout restart -n cert-manager deployment cert-manager
}

# Since we don't have a way of adding annotations to the instance of
# cert-manager installed by this Tanzu package, annotations are
# added after cert-manager is installed.
#
# Since this isn't the desired state that kapp knew about during the install,
# kapp undoes these changes. This prevents cert-manager from receiving the
# AWS IAM role to request via EKS IRSA, which prevents DNS challenges
# from succeeding and new Certificates issued by cert-manager to never
# be issued.
#
# This function tells kapp to not reconcile this app so that this doesn't
# happen.
pause_cert_manager_kapp_reconciliation_so_annotations_remain() {
  kubectl -n "$TANZU_PACKAGE_NAMESPACE" patch pkgi cert-manager \
    --type merge \
    --patch '{"spec":{"paused":true}}'
}

region=$(docker-compose run --rm terraform output -raw aws_region) || exit 1
iam_role=$(docker-compose run --rm terraform output -raw certmanager_role_arn) || exit 1
domain="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1
create_pkg_namespace  &&
  add_tanzu_standard_pkg_repo  &&
  install_cert_manager  &&
  pause_cert_manager_kapp_reconciliation_so_annotations_remain &&
  annotate_cert_manager_with_irsa_ref "$iam_role" &&
  install_contour &&
  install_cluster_issuer "$domain" "$EMAIL_ADDRESS" "$region" &&
  wait_for_cluster_issuer_to_become_ready
