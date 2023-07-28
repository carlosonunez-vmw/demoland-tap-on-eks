#!/usr/bin/env bash
set -euo pipefail
registry_path="${1?Please provide a registry path, like 'hub.docker.io/v1'}"
for directory in secure insecure
do
  >&2 echo "===> Creating workload for [$directory] example..."
  image_name="$(yq -r .metadata.name "$(dirname "$0")/workload.yaml")"
  image_tag="${registry_path}/${image_name}:$(date +%s)"
  template=$(ytt -v image_name="$image_tag" -f "$(dirname "$0")/workload.yaml")
  docker build -t "$image_tag" -f "$(dirname "$0")/${directory}-base-image/Dockerfile" . &&
    docker push "$image_tag" &&
    tanzu apps workload apply -n apps --yes -f - <<< "$template"
done
