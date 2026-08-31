variable "lldap_http_url" {
  description = "LLDAP HTTP admin API URL"
  type        = string
}

variable "lldap_ldap_url" {
  description = "LLDAP LDAP protocol URL"
  type        = string
}

variable "lldap_base_dn" {
  description = "LLDAP base DN"
  type        = string
}

variable "lldap_password" {
  description = "LLDAP admin password"
  type        = string
  sensitive   = true
}
