output "namespace" {
  value = kubernetes_namespace.devspace.metadata[0].name
}
