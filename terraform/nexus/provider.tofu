terraform {
  required_providers {
    sonatyperepo = {
      source  = "registry.terraform.io/sonatype-nexus-community/sonatyperepo"
      version = "1.19.2"
    }
  }
}

# Nexus Repository Manager runs as the `registry` TrueNAS custom app
# (terraform/truenas/files/registry/compose.yaml), fronted by Traefik at
# registry.nas.svc.h.mirceanton.com. The provider talks to its REST API with the
# local Nexus admin account; that credential is external to this repo (like the
# TrueNAS API key), so it flows in as a `TF_VAR_*` variable.
provider "sonatyperepo" {
  url      = var.nexus_url
  username = var.nexus_username
  password = var.nexus_password
}
