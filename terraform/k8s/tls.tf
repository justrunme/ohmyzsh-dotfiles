resource "tls_private_key" "frontend_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "frontend_cert" {
  validity_period_hours = 8760
  early_renewal_hours   = 168
  private_key_pem       = tls_private_key.frontend_key.private_key_pem

  subject {
    common_name  = "frontend.local"
    organization = "frontend.local"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = ["frontend.local"]
}
