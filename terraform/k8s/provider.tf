terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "kubernetes" {
  config_path = "${path.module}/.kubeconfig"
}
