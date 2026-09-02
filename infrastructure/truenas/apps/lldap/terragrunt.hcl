include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "truenas" {
  config_path = find_in_parent_folders("truenas")

  # infrastructure/truenas may not have been applied with this output yet (e.g. a fresh
  # checkout's first `plan`); mock it so `plan` works, but never let `apply` use a fake password.
  mock_outputs                            = { lldap_admin_password = "mock-lldap-admin-password" }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

terraform {
  source = "../../../../terraform/lldap"
}

inputs = {
  lldap_http_url = "https://lldap.nas.svc.h.mirceanton.com"
  lldap_ldap_url = "ldap://lldap.nas.svc.h.mirceanton.com:3890"
  lldap_base_dn  = "dc=mirceanton,dc=com"
  lldap_password = dependency.truenas.outputs.lldap_admin_password

  groups = ["k8s-admins", "k8s-viewers", "modelhub-admins", "modelhub-editors"]

  users = {
    mirk = {
      email  = "mircea@mirceanton.com"
      groups = ["k8s-admins", "modelhub-admins"]
    }
  }
}
