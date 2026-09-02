include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "truenas" {
  config_path = find_in_parent_folders("truenas")

  # infrastructure/truenas may not have been applied with this output yet (e.g. a fresh
  # checkout's first `plan`); mock it so `plan` works, but never let `apply` use a fake token.
  mock_outputs                            = { garage_admin_token = "mock-garage-admin-token" }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

terraform {
  source = "../../../../terraform/garage"
}

inputs = {
  garage_url   = "https://garage-admin.nas.svc.h.mirceanton.com"
  garage_token = dependency.truenas.outputs.garage_admin_token

  buckets = {
    home_ops_volsync = { global_alias = "home-ops-volsync" }
    home_ops_cnpg    = { global_alias = "home-ops-cnpg" }
  }

  keys = {
    home_ops_backups_readwrite = {
      name = "home-ops-backups-readwrite"
      permissions = {
        home_ops_volsync = { read = true, write = true }
        home_ops_cnpg    = { read = true, write = true }
      }
    }
  }
}
