output "vpc_id" {
  value = module.vpc.vpc_id
}

output "region" {
  value = data.aws_region.current.name
}

output "key" {
  value = module.key_pair.key_pair_name
}
