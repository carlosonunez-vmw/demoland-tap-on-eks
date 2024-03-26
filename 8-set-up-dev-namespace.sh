#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
DEV_NAMESPACE="$(get_from_config '.config.tap.dev_namespace')" || exit 1
DOMAIN_NAME="$(docker-compose run --rm terraform output -raw tap-domain)" || exit 1

harbor_password="$(docker-compose run --rm terraform output -raw harbor_admin_password)" || exit 1

kubectl get ns "$DEV_NAMESPACE" &>/dev/null ||
  kubectl create ns "$DEV_NAMESPACE"

registry_secret=$(kubectl create secret docker-registry registry-credentials \
    --docker-server="harbor.${DOMAIN_NAME}" \
    --docker-username=admin \
    --docker-password="$harbor_password" \
    -n "$DEV_NAMESPACE" \
    -o yaml \
    --dry-run=client) || return 1
manifest=$(cat <<-MANIFEST
$registry_secret

---

apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K

---

apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: registry-credentials
imagePullSecrets:
  - name: registry-credentials
  - name: tap-registry

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-permit-deliverable
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: deliverable
subjects:
  - kind: ServiceAccount
    name: default

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-permit-workload
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: workload
subjects:
  - kind: ServiceAccount
    name: default
MANIFEST
)
kapp deploy -a tap-dev-namespace-config \
  -n tap-install \
  --into-ns "${DEV_NAMESPACE}" -f - --yes <<< "$manifest" &&
  ytt -v app_namespace="$DEV_NAMESPACE" \
    -f "$(dirname "$0")/conf/testing-pipeline.yaml" |
    kapp deploy -a tap-noop-test-pipeline -f - --yes -n tap-install \
      --into-ns "$DEV_NAMESPACE" &&
  kapp deploy -a "tap-${DEV_NAMESPACE}-scan-policy" \
    -f "$(dirname "$0")/conf/scan-policy.yaml" \
    -n tap-install \
    --into-ns "$DEV_NAMESPACE" \
    --yes
  kapp deploy -a "tap-${DEV_NAMESPACE}-trivy-scan-policy" \
    -f "$(dirname "$0")/conf/trivy-scan-policy.yaml" \
    -n tap-install \
    --into-ns "$DEV_NAMESPACE" \
    --yes
