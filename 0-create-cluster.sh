#!/usr/bin/env bash

docker-compose run --rm terraform-apply &&
  aws eks update-kubeconfig --name tap-cluster
