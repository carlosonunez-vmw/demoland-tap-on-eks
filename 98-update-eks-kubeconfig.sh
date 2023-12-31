#!/usr/bin/env bash
source "$(dirname "$0")/include/config.sh"
DEV_NAMESPACE="$(get_from_config '.config.tap.dev_namespace')" || exit 1
create_live_update_compatible_kubeconfig() {
  token=$(aws --region us-east-2 eks get-token --cluster-name tap-cluster \
    --output text \
    --query 'status.token') || return 1
  arn=$(aws --region us-east-2 eks describe-cluster --name tap-cluster \
      --output text \
      --query 'cluster.arn') || return 1
  kubectl config set-credentials tap-user --token "$token" &&
    kubectl config set-context tap-live-update-context --cluster="$arn" --user=tap-user --namespace "$DEV_NAMESPACE"
}
region=$(docker-compose run --rm terraform output -raw aws_region) || exit 1
aws eks update-kubeconfig --name tap-cluster --region "$region"
create_live_update_compatible_kubeconfig
