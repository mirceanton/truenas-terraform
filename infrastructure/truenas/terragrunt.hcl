include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../terraform/truenas"
}

inputs = {
  truenas_endpoint = "wss://nas.mgmt.h.mirceanton.com/api/current"
  truenas_api_key  = get_env("TF_VAR_truenas_api_key")

  b2_backup_account             = get_env("TF_VAR_b2_backup_account")
  b2_backup_key                 = get_env("TF_VAR_b2_backup_key")
  b2_backup_encryption_password = get_env("TF_VAR_b2_backup_encryption_password")
  b2_backup_encryption_salt     = get_env("TF_VAR_b2_backup_encryption_salt")

  traefik_cf_dns_api_token = get_env("TF_VAR_traefik_cf_dns_api_token")
  lldap_smtp_username      = get_env("TF_VAR_lldap_smtp_username")
  lldap_smtp_password      = get_env("TF_VAR_lldap_smtp_password")
}