terraform {
  required_providers {
    keycloak = {
      source  = "registry.terraform.io/keycloak/keycloak"
      version = "5.3.0"
    }
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  url       = var.keycloak_url
  username  = var.keycloak_admin_username
  password  = var.keycloak_admin_password
}
