output "nexus_home_ops_password" {
  description = "Generated password for the Nexus home-ops service account"
  value       = random_password.home_ops.result
  sensitive   = true
}

output "nexus_mirceanton_password" {
  description = "Generated password for the Nexus mirceanton dev user"
  value       = random_pet.mirceanton.id
  sensitive   = true
}
