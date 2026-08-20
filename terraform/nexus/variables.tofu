variable "nexus_url" {
  description = "Nexus Repository Manager base URL"
  type        = string
}

variable "nexus_username" {
  description = "Nexus Repository Manager admin username"
  type        = string
}

variable "nexus_password" {
  description = "Nexus Repository Manager admin password"
  type        = string
  sensitive   = true
}
