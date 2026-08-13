include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../terraform/garage"
}

inputs = {
  garage_url   = "https://garage-admin.nas.svc.h.mirceanton.com"
  garage_token = get_env("TF_VAR_garage_token")
}
