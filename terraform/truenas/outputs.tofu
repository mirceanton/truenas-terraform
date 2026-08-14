output "zipline_db_password" {
  description = "Generated Zipline Postgres password"
  value       = random_password.zipline_db.result
  sensitive   = true
}

output "zipline_core_secret" {
  description = "Generated Zipline core session secret"
  value       = random_password.zipline_core_secret.result
  sensitive   = true
}

output "zot_admin_password" {
  description = "Generated Zot admin password (username: admin)"
  value       = random_password.zot_admin.result
  sensitive   = true
}
