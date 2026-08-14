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
