source "$(dirname "$0")/include/config.sh"

"$(dirname "$0")/scripts/create_backend.sh" &&
  docker-compose run --rm terraform init -backend-config="$(dirname "$0")/terraform.tfbackend"
