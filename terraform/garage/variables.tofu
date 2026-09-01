variable "garage_url" {
  description = "Garage admin API endpoint"
  type        = string
}

variable "garage_token" {
  description = "Garage admin API token"
  type        = string
  sensitive   = true
}

variable "buckets" {
  description = "Garage buckets, keyed by stable logical name"
  type = map(object({
    global_alias           = string
    max_objects            = optional(number)
    max_size               = optional(number)
    website_enabled        = optional(bool)
    website_error_document = optional(string)
    website_index_document = optional(string)
  }))
  default = {}
}

variable "keys" {
  description = "Garage access keys, keyed by stable logical name. Each key's permissions map is keyed by a bucket name present in var.buckets."
  type = map(object({
    name = string
    permissions = optional(map(object({
      read  = optional(bool, false)
      write = optional(bool, false)
      owner = optional(bool, false)
    })), {})
  }))
  default = {}
}
