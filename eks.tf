data "aws_caller_identity" "self" {}

data "aws_region" "current" {}

module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "19.15.3"
  cluster_name                   = "tap-cluster"
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true
  cluster_addons = {
    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.large"]
    capacity_type  = "SPOT"
    desired_size   = 3
    min_size       = 3
  }
  eks_managed_node_groups = {
    default = {
      max_size = 8
    }
  }
  aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.self.arn
      username = "self"
      groups   = ["system:masters"]
    }
  ]
  cluster_security_group_additional_rules = {
    eks_control_plane_to_kapp_controller = {
      description                = "Cluster API to kapp-controller"
      protocol                   = "tcp"
      from_port                  = 10250
      to_port                    = 10250
      source_node_security_group = true
      type                       = "ingress"
    }
  }
}

module "ebs_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    p = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "certmanager_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                  = "certmanager"
  attach_cert_manager_policy = true

  oidc_providers = {
    p = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }
}

module "externaldns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "externaldns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.zone.arn]

  oidc_providers = {
    p = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:external-dns-sa"]
    }
  }
}

module "clusterautoscaler_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  external_dns_hosted_zone_arns    = [data.aws_route53_zone.zone.arn]
  cluster_autoscaler_cluster_names = [module.eks.cluster_name]

  oidc_providers = {
    p = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}
