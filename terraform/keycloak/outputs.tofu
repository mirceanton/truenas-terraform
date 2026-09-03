output "realm_id" {
  description = "Realm that was created and that the admin account is scoped to administer"
  value       = keycloak_realm.this.id
}

output "admin_username" {
  description = "Realm admin account username"
  value       = keycloak_user.admin.username
}

output "admin_password" {
  description = "Generated realm admin account password"
  value       = random_password.admin.result
  sensitive   = true
}
