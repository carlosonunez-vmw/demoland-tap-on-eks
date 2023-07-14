#!/usr/bin/env bash
region=$(docker-compose run --rm terraform output -raw aws_region) || exit 1
aws eks update-kubeconfig --name tap-cluster --region "$region"
