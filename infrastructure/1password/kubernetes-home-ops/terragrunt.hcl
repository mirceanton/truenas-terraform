include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "keycloak" {
  config_path = find_in_parent_folders("truenas/apps/keycloak")

  # infrastructure/truenas/apps/keycloak may not have been applied yet (e.g. a fresh checkout's
  # first `plan`); mock its outputs so `plan` works, but never let `apply` push fake credentials.
  mock_outputs = {
    operator_username = "keycloak-operator"
    operator_password = "mock-keycloak-operator-password"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
  mock_outputs_merge_with_state           = true
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.1"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/truenas-terraform."
  secrets = {
    "keycloak-operator" = {
      category = "login"
      username = dependency.keycloak.outputs.operator_username
      password = dependency.keycloak.outputs.operator_password
    }
  }
}
