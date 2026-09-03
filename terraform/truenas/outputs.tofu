output "zot_admin_password" {
  description = "Generated Zot admin password (username: admin)"
  value       = random_password.zot_admin.result
  sensitive   = true
}

output "traefik_dashboard_username" {
  description = "Traefik dashboard basic-auth username"
  value       = var.traefik_dashboard_username
}

output "traefik_dashboard_password" {
  description = "Generated Traefik dashboard basic-auth password"
  value       = random_password.traefik_dashboard_admin.result
  sensitive   = true
}

output "dozzle_admin_username" {
  description = "Dozzle admin username"
  value       = var.dozzle_admin_username
}

output "dozzle_admin_password" {
  description = "Generated Dozzle admin password"
  value       = random_password.dozzle_admin.result
  sensitive   = true
}

output "garage_rpc_secret" {
  description = "Generated Garage RPC secret"
  value       = random_id.garage_rpc_secret.hex
  sensitive   = true
}

output "garage_admin_token" {
  description = "Generated Garage admin API token"
  value       = random_password.garage_admin_token.result
  sensitive   = true
}

output "garage_webui_admin_username" {
  description = "Garage WebUI admin username"
  value       = var.garage_webui_admin_username
}

output "garage_webui_admin_password" {
  description = "Generated Garage WebUI admin password"
  value       = random_password.garage_webui_admin.result
  sensitive   = true
}

output "keycloak_admin_username" {
  description = "Keycloak admin username"
  value       = var.keycloak_admin_username
}

output "keycloak_admin_password" {
  description = "Generated Keycloak admin password"
  value       = random_password.keycloak_admin.result
  sensitive   = true
}

output "keycloak_db_password" {
  description = "Generated Keycloak Postgres password"
  value       = random_password.keycloak_db.result
  sensitive   = true
}

output "keycloak_operator_username" {
  description = "Keycloak operator (admin-level) username"
  value       = var.keycloak_operator_username
}

output "keycloak_operator_password" {
  description = "Generated Keycloak operator (admin-level) password"
  value       = random_password.keycloak_operator.result
  sensitive   = true
}

output "lldap_jwt_secret" {
  description = "Generated LLDAP JWT secret"
  value       = random_password.lldap_jwt_secret.result
  sensitive   = true
}

output "lldap_admin_password" {
  description = "Generated LLDAP admin password"
  value       = random_password.lldap_admin.result
  sensitive   = true
}
