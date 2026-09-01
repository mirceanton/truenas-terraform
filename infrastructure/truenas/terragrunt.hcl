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

  traefik_cf_dns_api_token     = get_env("TF_VAR_traefik_cf_dns_api_token")
  traefik_dashboard_basic_auth = get_env("TF_VAR_traefik_dashboard_basic_auth")
  dozzle_admin_username        = get_env("TF_VAR_dozzle_admin_username")
  dozzle_admin_password        = get_env("TF_VAR_dozzle_admin_password")
  garage_rpc_secret            = get_env("TF_VAR_garage_rpc_secret")
  garage_admin_token           = get_env("TF_VAR_garage_admin_token")
  garage_webui_admin_pass      = get_env("TF_VAR_garage_webui_admin_pass")
  keycloak_admin_username      = get_env("TF_VAR_keycloak_admin_username")
  keycloak_admin_password      = get_env("TF_VAR_keycloak_admin_password")
  keycloak_db_password         = get_env("TF_VAR_keycloak_db_password")
  lldap_jwt_secret             = get_env("TF_VAR_lldap_jwt_secret")
  lldap_admin_password         = get_env("TF_VAR_lldap_admin_password")
  lldap_smtp_username          = get_env("TF_VAR_lldap_smtp_username")
  lldap_smtp_password          = get_env("TF_VAR_lldap_smtp_password")
}
