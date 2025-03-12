resource "kubernetes_secret" "frontend_tls" {
  metadata {
    name      = "frontend-tls"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64encode(tls_self_signed_cert.frontend_cert.cert_pem)
    "tls.key" = base64encode(tls_private_key.frontend_key.private_key_pem)
  }
}

