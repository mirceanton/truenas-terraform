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
  default = "terraform"
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
