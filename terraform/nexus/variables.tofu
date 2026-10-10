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

variable "docker_proxy_registries" {
  description = "Docker pull-through (proxy) repositories to manage, keyed by repository name and mapping to the upstream registry they proxy. The name is also the first path segment clients request under /v2/, so it must match the hostname the clients' registry mirror rewrites to (e.g. a repository named `factory.talos.dev` serves https://registry.nas.svc.h.mirceanton.com/v2/factory.talos.dev/<image>)."
  type        = map(string)
  default     = {}
}
