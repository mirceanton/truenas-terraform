include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "truenas" {
  config_path = find_in_parent_folders("truenas")

  # infrastructure/truenas may not have been applied with these outputs yet (e.g. a fresh
  # checkout's first `plan`); mock them so `plan` works, but never let `apply` use fake credentials.
  mock_outputs = {
    keycloak_admin_username    = "admin"
    keycloak_admin_password    = "mock-keycloak-admin-password"
    keycloak_operator_username = "keycloak-operator"
    keycloak_operator_password = "mock-keycloak-operator-password"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
  # infrastructure/truenas's existing state predates these outputs; shallow-merge so the mocks
  # only fill missing keys instead of being ignored outright because state already exists.
  mock_outputs_merge_with_state = true
}

terraform {
  source = "../../../../terraform/keycloak"
}

inputs = {
  keycloak_url = "https://keycloak.nas.svc.h.mirceanton.com"

  keycloak_admin_username = dependency.truenas.outputs.keycloak_admin_username
  keycloak_admin_password = dependency.truenas.outputs.keycloak_admin_password

  operator_username = dependency.truenas.outputs.keycloak_operator_username
  operator_password = dependency.truenas.outputs.keycloak_operator_password
}
