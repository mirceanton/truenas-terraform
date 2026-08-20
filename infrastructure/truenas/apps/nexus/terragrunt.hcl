include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../terraform/nexus"
}

inputs = {
  nexus_url      = "https://registry.nas.svc.h.mirceanton.com"
  nexus_username = get_env("TF_VAR_nexus_username")
  nexus_password = get_env("TF_VAR_nexus_password")
}
