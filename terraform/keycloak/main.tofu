resource "keycloak_user" "operator" {
  realm_id = "master"
  username = var.operator_username
  enabled  = true

  initial_password {
    value     = var.operator_password
    temporary = false
  }
}

data "keycloak_role" "admin" {
  realm_id = "master"
  name     = "admin"
}

resource "keycloak_user_roles" "operator" {
  realm_id = "master"
  user_id  = keycloak_user.operator.id
  role_ids = [data.keycloak_role.admin.id]
}
