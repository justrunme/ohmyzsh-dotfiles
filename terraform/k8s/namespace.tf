resource "kubernetes_namespace" "devspace" {
  metadata {
    name = "devspace"
  }
}
