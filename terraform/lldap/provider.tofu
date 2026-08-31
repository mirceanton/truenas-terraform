terraform {
  required_providers {
    lldap = {
      source  = "registry.terraform.io/tasansga/lldap"
      version = "0.4.2"
    }
  }
}

provider "lldap" {
  http_url = var.lldap_http_url
  ldap_url = var.lldap_ldap_url
  base_dn  = var.lldap_base_dn
  password = var.lldap_password
}
