output "operator_username" {
  description = "Keycloak operator (admin-level) username"
  value       = keycloak_user.operator.username
}

output "operator_password" {
  description = "Keycloak operator (admin-level) password"
  value       = var.operator_password
  sensitive   = true
}
