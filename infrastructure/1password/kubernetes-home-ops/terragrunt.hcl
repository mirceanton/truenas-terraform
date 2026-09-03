include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "keycloak" {
  config_path = find_in_parent_folders("truenas/apps/keycloak/Homelab")

  # infrastructure/truenas/apps/keycloak/Homelab may not have been applied with these outputs yet
  # (e.g. a fresh checkout's first `plan`); mock them so `plan` works, but never let `apply` push
  # fake secrets.
  mock_outputs = {
    realm_id       = "mock-realm"
    admin_username = "keycloak-operator"
    admin_password = "mock-keycloak-operator-password"
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
      username = dependency.keycloak.outputs.admin_username
      password = dependency.keycloak.outputs.admin_password
      sections = [
        {
          label = "extra"
          fields = [
            {
              label = "realm"
              value = dependency.keycloak.outputs.realm_id
            },
          ]
        },
      ]
    }
  }
}
