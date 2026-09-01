include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../terraform/lldap"
}

inputs = {
  lldap_http_url = "https://lldap.nas.svc.h.mirceanton.com"
  lldap_ldap_url = "ldap://lldap.nas.svc.h.mirceanton.com:3890"
  lldap_base_dn  = "dc=mirceanton,dc=com"
  lldap_password = get_env("TF_VAR_lldap_password")

  groups = ["k8s-admins", "k8s-viewers", "modelhub-admins", "modelhub-editors"]

  users = {
    mirk = {
      email  = "mircea@mirceanton.com"
      groups = ["k8s-admins", "modelhub-admins"]
    }
  }
}
