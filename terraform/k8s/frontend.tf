resource "kubernetes_config_map" "frontend_html" {
  metadata {
    name      = "frontend-html"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }

  data = {
    "index.html" = <<EOF
<!DOCTYPE html>
<html>
<head><title>Frontend via Terraform</title></head>
<body>
  <h1 style="color:green">Hello from the frontend!</h1>
  <p>Served by Nginx in Kubernetes 🚀</p>
</body>
</html>
EOF
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.devspace.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:alpine"

          port {
            container_port = 80
          }

          volume_mount {
            name       = "html-volume"
            mount_path = "/usr/share/nginx/html"
            read_only  = true
          }
        }

        volume {
          name = "html-volume"

          config_map {
            name = kubernetes_config_map.frontend_html.metadata[0].name
            items {
              key  = "index.html"
              path = "index.html"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
