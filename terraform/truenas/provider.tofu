terraform {
  required_providers {
    truenas = {
      source  = "registry.terraform.io/deevus/truenas"
      version = "0.16.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
}

provider "truenas" {
  host        = var.truenas_host
  auth_method = "ssh"

  ssh {
    port                 = var.ssh_port
    user                 = var.ssh_user
    private_key          = var.ssh_private_key
    host_key_fingerprint = var.ssh_host_key_fingerprint
  }
}
