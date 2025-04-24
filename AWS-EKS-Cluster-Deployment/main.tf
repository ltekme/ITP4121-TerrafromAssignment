provider "kubernetes" {
  token                  = var.eks-cluster-token
  host                   = var.eks-cluster-endpoint
  cluster_ca_certificate = var.eks-cluster-certificate
}

resource "null_resource" "docker-build" {
  provisioner "local-exec" {
    command = "sudo docker build -t ${var.ecr-repository.repository_url} SimpleApplication"
  }
}

resource "null_resource" "docker-login" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region region | docker login --username AWS --password-stdin ${split("/", var.ecr-repository.repository_url)[0]}"
  }
  depends_on = [null_resource.docker-build]
}

resource "null_resource" "docker-push" {
  provisioner "local-exec" {
    command = "sudo docker push ${var.ecr-repository.repository_url}"
  }
  depends_on = [null_resource.docker-login]
}

resource "kubernetes_namespace" "demo-app" {
  metadata {
    name = "demo-app"
  }
}

resource "kubernetes_deployment" "simple-app" {
  metadata {
    name = "simple-app"
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "simple-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "simple-app"
        }
      }
      spec {
        container {
          image = var.ecr-repository.repository_url
          name  = "demo-application"
        }
      }
    }
  }

  depends_on = [null_resource.docker-push]
}
