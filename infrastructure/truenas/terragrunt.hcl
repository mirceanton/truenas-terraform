include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../terraform/truenas"
}

inputs = {
  truenas_host             = "nas.mgmt.h.mirceanton.com"
  ssh_user                 = "terraform"
  ssh_private_key          = get_env("TF_VAR_ssh_private_key")
  ssh_host_key_fingerprint = get_env("TF_VAR_ssh_host_key_fingerprint")
  b2_backup_account        = get_env("TF_VAR_b2_backup_account")
  b2_backup_key            = get_env("TF_VAR_b2_backup_key")
}
