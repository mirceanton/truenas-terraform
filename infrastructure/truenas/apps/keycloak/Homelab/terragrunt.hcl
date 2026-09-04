include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "truenas" {
  config_path = find_in_parent_folders("truenas")

  # infrastructure/truenas may not have been applied with these outputs yet (e.g. a fresh
  # checkout's first `plan`); mock them so `plan` works, but never let `apply` use fake credentials.
  mock_outputs = {
    keycloak_admin_username = "admin"
    keycloak_admin_password = "mock-keycloak-admin-password"
    lldap_admin_password    = "mock-lldap-admin-password"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
  # infrastructure/truenas's existing state predates these outputs; shallow-merge so the mocks
  # only fill missing keys instead of being ignored outright because state already exists.
  mock_outputs_merge_with_state = true
}

terraform {
  source = "../../../../../terraform/keycloak"
}

inputs = {
  keycloak_url      = "https://keycloak.nas.svc.h.mirceanton.com"
  keycloak_username = dependency.truenas.outputs.keycloak_admin_username
  keycloak_password = dependency.truenas.outputs.keycloak_admin_password

  # Mirrors how infrastructure/1password/<vault-name> derives its vault name: this unit's
  # directory name is the realm name.
  realm_id = basename(get_terragrunt_dir())

  admin_username = "keycloak-operator"

  # LLDAP runs as a container alongside keycloak in the same compose stack/network (see
  # terraform/truenas/files/keycloak/compose.yaml), so keycloak reaches it by container name.
  ldap_url            = "ldap://lldap:3890"
  ldap_base_dn        = "dc=mirceanton,dc=com"
  ldap_bind_password = dependency.truenas.outputs.lldap_admin_password
}
