resource "random_string" "harbor_admin_password" {
  length = 16
}

resource "random_string" "harbor_xsrf_key" {
  length  = 32
  special = false
  upper   = false
}

output "harbor_admin_password" {
  value = random_string.harbor_admin_password.result
}

output "harbor_xsrf_key" {
  value = random_string.harbor_xsrf_key.result
}
