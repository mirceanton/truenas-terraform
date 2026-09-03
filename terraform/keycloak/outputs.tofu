output "operator_realm" {
  description = "Realm the Keycloak operator service account is scoped to administer"
  value       = var.realm_id
}

output "operator_username" {
  description = "Keycloak operator service account username"
  value       = keycloak_user.operator.username
}

output "operator_password" {
  description = "Generated Keycloak operator service account password"
  value       = random_password.operator.result
  sensitive   = true
}
