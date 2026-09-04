include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "truenas" {
  config_path = find_in_parent_folders("truenas")

  # infrastructure/truenas may not have been applied with this output yet (e.g. a fresh
  # checkout's first `plan`); mock it so `plan` works, but never let `apply` use a fake password.
  mock_outputs                            = { lldap_admin_password = "mock-lldap-admin-password" }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
  # infrastructure/truenas's existing state predates this output; shallow-merge so the mock
  # only fills the missing key instead of being ignored outright because state already exists.
  mock_outputs_merge_with_state = true
}

terraform {
  source = "../../../../terraform/lldap"
}

inputs = {
  lldap_http_url = "https://lldap.nas.svc.h.mirceanton.com"
  lldap_ldap_url = "ldap://lldap.nas.svc.h.mirceanton.com:3890"
  lldap_base_dn  = "dc=mirceanton,dc=com"
  lldap_password = dependency.truenas.outputs.lldap_admin_password

  # Login item per user in this vault - see terraform/lldap's `users` variable description for
  # the exact item shape expected (password field + an "Identity" section with
  # email/first_name/last_name fields).
  onepassword_vault_name = "Homelab Users"

  groups = ["k8s-admins", "k8s-viewers", "modelhub-admins", "modelhub-editors"]

  users = {
    mirk = {
      onepassword_item_title = "LLDAP User - mirk"
      groups                 = ["k8s-admins", "modelhub-admins"]
    }
    csoare = {
      onepassword_item_title = "LLDAP User - csoare"
    }
    cristig = {
      onepassword_item_title = "LLDAP User - cristig"
    }
    bomkii = {
      onepassword_item_title = "LLDAP User - bomkii"
    }
  }
}
