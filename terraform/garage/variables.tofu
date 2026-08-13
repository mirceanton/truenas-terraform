variable "garage_url" {
  description = "Garage admin API endpoint"
  type        = string
}

variable "garage_token" {
  description = "Garage admin API token"
  type        = string
  sensitive   = true
}
