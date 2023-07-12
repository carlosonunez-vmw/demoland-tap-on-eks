variable "domain_name" {
  description = "Your Route 53-managed domain name. Leave blank if you don't have this yet."
  default     = ""
}

variable "harbor_cluster_ingress_elb" {
  description = "The FQDN of the Envoy load balancer that Harbor is backed by. Leave blank if you don't have this yet."
  default     = ""
}

variable "tap_local_cluster_ingress_elb_fqdn" {
  description = "The FQDN of the Envoy load balance that TMC services are backed by. Leave blank if you don't have this yet."
  default     = ""
}

locals {
  harbor_records = [
    "harbor",
  ]
  tap_records = []
}

data "aws_route53_zone" "zone" {
  count        = var.domain_name == "" ? 0 : (var.harbor_cluster_ingress_elb == "" ? 0 : 1)
  name         = "${var.domain_name}."
  private_zone = false
}

data "dns_a_record_set" "harbor_elb_ips" {
  count = var.domain_name == "" ? 0 : (var.harbor_cluster_ingress_elb == "" ? 0 : 1)
  host  = "${var.harbor_cluster_ingress_elb}."
}

data "dns_a_record_set" "tap_elb_ips" {
  count = var.domain_name == "" ? 0 : (var.tap_local_cluster_ingress_elb_fqdn == "" ? 0 : 1)
  host  = "${var.tap_local_cluster_ingress_elb_fqdn}."
}

resource "aws_route53_record" "harbor_records" {
  count   = var.domain_name == "" ? 0 : (var.harbor_cluster_ingress_elb == "" ? 0 : length(local.harbor_records))
  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = "${local.harbor_records[count.index]}.${data.aws_route53_zone.zone[0].name}"
  type    = "A"
  ttl     = "1"
  records = data.dns_a_record_set.harbor_elb_ips[0].addrs
}

resource "aws_route53_record" "tap_records" {
  count   = var.domain_name == "" ? 0 : (var.tap_local_cluster_ingress_elb_fqdn == "" ? 0 : length(local.tap_records))
  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = "${local.tap_records[count.index]}.tmc.${data.aws_route53_zone.zone[0].name}"
  type    = "A"
  ttl     = "1"
  records = data.dns_a_record_set.tap_elb_ips[0].addrs
}

resource "aws_route53_record" "root_tap_record" {
  count   = var.domain_name == "" ? 0 : (var.tap_local_cluster_ingress_elb_fqdn == "" ? 0 : length(local.tap_records))
  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = "tmc.${data.aws_route53_zone.zone[0].name}"
  type    = "A"
  ttl     = "1"
  records = data.dns_a_record_set.tap_elb_ips[0].addrs
}
