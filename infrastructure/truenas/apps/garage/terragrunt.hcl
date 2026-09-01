include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../terraform/garage"
}

inputs = {
  garage_url   = "https://garage-admin.nas.svc.h.mirceanton.com"
  garage_token = get_env("TF_VAR_garage_token")

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
