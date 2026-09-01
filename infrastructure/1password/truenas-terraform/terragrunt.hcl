include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "truenas" {
  config_path = find_in_parent_folders("truenas")
}

dependency "garage" {
  config_path = find_in_parent_folders("truenas/apps/garage")
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.1"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/truenas-terraform."
  secrets = merge(
    {
      "Traefik Dashboard" = {
        category = "login"
        username = dependency.truenas.outputs.traefik_dashboard_username
        password = dependency.truenas.outputs.traefik_dashboard_password
      }
      "Dozzle" = {
        category = "login"
        username = dependency.truenas.outputs.dozzle_admin_username
        password = dependency.truenas.outputs.dozzle_admin_password
      }
      "Garage RPC Secret" = {
        category = "password"
        password = dependency.truenas.outputs.garage_rpc_secret
      }
      "Garage Admin Token" = {
        category = "password"
        password = dependency.truenas.outputs.garage_admin_token
      }
      "Garage WebUI" = {
        category = "login"
        username = dependency.truenas.outputs.garage_webui_admin_username
        password = dependency.truenas.outputs.garage_webui_admin_password
      }
      "Keycloak Admin" = {
        category = "login"
        username = dependency.truenas.outputs.keycloak_admin_username
        password = dependency.truenas.outputs.keycloak_admin_password
      }
      "Keycloak Postgres" = {
        category = "database"
        db_type  = "postgresql"
        hostname = "keycloak-db"
        port     = "5432"
        database = "keycloak"
        username = "keycloak"
        password = dependency.truenas.outputs.keycloak_db_password
      }
      "LLDAP" = {
        category = "login"
        username = "admin"
        password = dependency.truenas.outputs.lldap_admin_password
        sections = [
          {
            label = "extra"
            fields = [
              {
                label = "jwt_secret"
                type  = "CONCEALED"
                value = dependency.truenas.outputs.lldap_jwt_secret
              },
            ]
          },
        ]
      }
      "Zot Admin" = {
        category = "login"
        username = "admin"
        password = dependency.truenas.outputs.zot_admin_password
      }
    },
    {
      for name, key in dependency.garage.outputs.keys : "Garage Key - ${key.name}" => {
        category = "login"
        username = key.id
        password = key.secret_access_key
      }
    },
  )
}
