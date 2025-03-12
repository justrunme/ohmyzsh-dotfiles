resource "kubernetes_service_account" "reader" {
  metadata {
    name      = "pod-reader"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }
}

resource "kubernetes_role" "read_pods" {
  metadata {
    name      = "pod-reader-role"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role_binding" "reader_binding" {
  metadata {
    name      = "read-pods-binding"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }

  role_ref {
    kind     = "Role"
    name     = kubernetes_role.read_pods.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.reader.metadata[0].name
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }
}
