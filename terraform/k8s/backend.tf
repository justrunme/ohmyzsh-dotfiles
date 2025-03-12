resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.devspace.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name  = "backend"
          image = "hashicorp/http-echo"          # Публичный тестовый образ

          args = ["-text=Hello from Terraform backend!"] # Параметры запуска

          port {
            container_port = 5678                # Порт, который слушает контейнер
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.devspace.metadata[0].name
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 80                          # Порт, на котором сервис будет доступен
      target_port = 5678                        # Направляем трафик на порт контейнера
      protocol    = "TCP"
    }

    type = "ClusterIP"                          # Внутрикластерный доступ
  }
}
