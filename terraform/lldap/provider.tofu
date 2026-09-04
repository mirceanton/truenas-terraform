terraform {
  required_providers {
    lldap = {
      source  = "registry.terraform.io/tasansga/lldap"
      version = "0.4.2"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 3.0"
    }
  }
}

provider "lldap" {
  http_url = var.lldap_http_url
  ldap_url = var.lldap_ldap_url
  base_dn  = var.lldap_base_dn
  password = var.lldap_password
}

# Auth via OP_CONNECT_HOST / OP_CONNECT_TOKEN env vars - already exported in CI (see
# terragrunt-ci.yaml/terragrunt-cd.yaml) to resolve .env.1pass, so nothing to configure here.
provider "onepassword" {}
