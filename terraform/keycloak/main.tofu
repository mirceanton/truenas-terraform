resource "keycloak_realm" "this" {
  realm        = var.realm_id
  display_name = var.realm_display_name
  enabled      = true
}

resource "time_rotating" "admin_password" {
  rotation_days = var.admin_password_rotation_days
}

resource "random_password" "admin" {
  length  = 32
  special = false

  keepers = {
    rotation = time_rotating.admin_password.id
  }
}

# Password-grant admin API auth is always issued from the master realm, so the account has to
# live there - it can't be a user of var.realm_id itself. It stays scoped to just var.realm_id by
# only holding roles on the delegated-admin client Keycloak auto-creates in master for every
# realm ("<realm>-realm"), never any role on the master-realm client.
resource "keycloak_user" "admin" {
  realm_id = "master"
  username = var.admin_username
  enabled  = true

  initial_password {
    value     = random_password.admin.result
    temporary = false
  }

  # keycloak_user only applies initial_password on creation, not on update (the provider
  # explicitly suppresses that diff) - so a rotated password only takes effect in Keycloak if the
  # user resource itself is replaced.
  lifecycle {
    replace_triggered_by = [random_password.admin]
  }
}

data "keycloak_openid_client" "delegated_admin" {
  realm_id  = "master"
  client_id = "${keycloak_realm.this.realm}-realm"
}

data "keycloak_role" "admin" {
  for_each = var.admin_realm_management_roles

  realm_id  = "master"
  client_id = data.keycloak_openid_client.delegated_admin.id
  name      = each.value
}

resource "keycloak_user_roles" "admin" {
  realm_id = "master"
  user_id  = keycloak_user.admin.id

  role_ids = [for role in data.keycloak_role.admin : role.id]
}
