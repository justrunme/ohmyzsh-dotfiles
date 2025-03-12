resource "kubernetes_network_policy" "allow_frontend_to_backend" {
  metadata {
    name      = "allow-frontend-to-backend"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        app = "backend"
      }
    }

    ingress {
      from {
        pod_selector {
          match_labels = {
            app = "frontend"
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = 80
      }
    }

    policy_types = ["Ingress"]
  }
}
