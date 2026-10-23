# Bloc 1 : le fournisseur (provider)
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

# Bloc 2 : une variable
variable "port" {
  description = "Port exposé sur la machine"
  type        = number
  default     = 8081
}

# Bloc 3 : l'image Docker
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Bloc 4 : le conteneur
resource "docker_container" "web" {
  name  = "atelier-iac-web"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = var.port
  }


  volumes {
    host_path      = abspath("${path.module}/site")
    container_path = "/usr/share/nginx/html"
  }
}