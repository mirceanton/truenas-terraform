include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../terraform/truenas"
}

inputs = {
  truenas_host                  = "nas.mgmt.h.mirceanton.com"
  ssh_user                      = "terraform"
  ssh_private_key               = get_env("TF_VAR_ssh_private_key")
  ssh_host_key_fingerprint      = get_env("TF_VAR_ssh_host_key_fingerprint")
  b2_backup_account             = get_env("TF_VAR_b2_backup_account")
  b2_backup_key                 = get_env("TF_VAR_b2_backup_key")
  b2_backup_encryption_password = get_env("TF_VAR_b2_backup_encryption_password")
  b2_backup_encryption_salt     = get_env("TF_VAR_b2_backup_encryption_salt")

  traefik_cf_dns_api_token = get_env("TF_VAR_traefik_cf_dns_api_token")
  lldap_smtp_username      = get_env("TF_VAR_lldap_smtp_username")
  lldap_smtp_password      = get_env("TF_VAR_lldap_smtp_password")
}
