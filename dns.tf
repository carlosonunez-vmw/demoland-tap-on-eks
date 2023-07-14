variable "domain_name" {
  description = "Your Route 53-managed domain name."
}

data "aws_route53_zone" "zone" {
  // Leaving count here since this used to be a conditional resource and I didn't want to update
  // everything to not be non-indexed
  name         = "${var.domain_name}."
  private_zone = false
}
