output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "zone_id" {
  value = data.aws_route53_zone.zone.id
}

output "external_dns_role_arn" {
  value = module.externaldns_irsa_role.iam_role_arn
}

output "certmanager_role_arn" {
  value = module.certmanager_irsa_role.iam_role_arn
}

output "ebs_csi_controller_role_arn" {
  value = module.ebs_irsa_role.iam_role_arn
}

output "cluster_autoscaler_role_arn" {
  value = module.clusterautoscaler_irsa_role.iam_role_arn
}
