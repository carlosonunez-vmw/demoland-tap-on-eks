data "aws_caller_identity" "self" {}

module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "19.15.3"
  cluster_name                   = "tap-cluster"
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }
  vpc_id                   = modules.vpc.vpc_id
  subnet_ids               = modules.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.large"]
    capacity_type  = "SPOT"
  }
  aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.arn
      username = "self"
      groups   = ["system:masters"]
    }
  ]
}
