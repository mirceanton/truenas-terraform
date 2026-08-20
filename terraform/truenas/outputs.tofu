output "zot_admin_password" {
  description = "Generated Zot admin password (username: admin)"
  value       = random_password.zot_admin.result
  sensitive   = true
}
