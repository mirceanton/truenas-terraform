resource "keycloak_realm" "this" {
  realm        = var.realm_id
  display_name = var.realm_display_name
  enabled      = true
}

resource "random_password" "admin" {
  length  = 32
  special = false
}

resource "keycloak_user" "admin" {
  realm_id = keycloak_realm.this.id
  username = var.admin_username
  enabled  = true

  initial_password {
    value     = random_password.admin.result
    temporary = false
  }
}

# The realm's own realm-management client authorizes admin API calls scoped to that realm only,
# so granting these roles to a user of the realm itself never requires master-realm access.
data "keycloak_openid_client" "realm_management" {
  realm_id  = keycloak_realm.this.id
  client_id = "realm-management"
}

data "keycloak_role" "admin" {
  for_each = var.admin_realm_management_roles

  realm_id  = keycloak_realm.this.id
  client_id = data.keycloak_openid_client.realm_management.id
  name      = each.value
}

resource "keycloak_user_roles" "admin" {
  realm_id = keycloak_realm.this.id
  user_id  = keycloak_user.admin.id

  role_ids = [for role in data.keycloak_role.admin : role.id]
}
