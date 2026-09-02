variable "truenas_host" {
  description = "TrueNAS server hostname or IP address"
  type        = string
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "terraform"
}

variable "ssh_private_key" {
  description = "SSH private key contents"
  type        = string
  sensitive   = true
}

variable "ssh_host_key_fingerprint" {
  description = "SHA256 fingerprint of the TrueNAS server SSH host key"
  type        = string
}

variable "b2_backup_account" {
  description = "Backblaze B2 account/key ID used for cloud sync backups"
  type        = string
  sensitive   = true
}

variable "b2_backup_key" {
  description = "Backblaze B2 application key used for cloud sync backups"
  type        = string
  sensitive   = true
}

variable "b2_backup_encryption_password" {
  description = "Encryption password for B2 cloud sync tasks"
  type        = string
  sensitive   = true
}

variable "b2_backup_encryption_salt" {
  description = "Encryption salt for B2 cloud sync tasks"
  type        = string
  sensitive   = true
}

variable "traefik_cf_dns_api_token" {
  description = "Cloudflare API token for Traefik's DNS-01 ACME challenge"
  type        = string
  sensitive   = true
}

variable "traefik_dashboard_username" {
  description = "Traefik dashboard basic-auth username"
  type        = string
  default     = "admin"
}

variable "dozzle_admin_username" {
  description = "Dozzle admin username"
  type        = string
  default     = "admin"
}

variable "garage_webui_admin_username" {
  description = "Garage WebUI admin username"
  type        = string
  default     = "admin"
}

variable "keycloak_admin_username" {
  description = "Keycloak admin username"
  type        = string
  default     = "admin"
}

variable "lldap_smtp_username" {
  description = "SMTP username (mailbox address) LLDAP uses to send password-reset emails"
  type        = string
  sensitive   = true
}

variable "lldap_smtp_password" {
  description = "SMTP password for the LLDAP password-reset mailbox"
  type        = string
  sensitive   = true
}
