terraform {
  # Write-only secret attributes (provider_secrets_wo, encryption_password, …)
  # need >= 1.11. The repo pins opentofu "latest" via mise.
  required_version = ">= 1.11"

  required_providers {
    truenas = {
      source  = "registry.terraform.io/truenas/truenas"
      version = "~> 1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
  }
}

# Official first-party provider (TrueNAS/iXsystems). Unlike the previous
# deevus/truenas provider it does not use SSH: it opens a WebSocket JSON-RPC
# session against the middleware at /api/current and authenticates with an API
# key, so there is no SSH key and no host-key fingerprint to pass in.
# Requires TrueNAS >= 25.04 (this host runs 25.10.1).
provider "truenas" {
  endpoint = var.truenas_endpoint
  api_key  = var.truenas_api_key

  # The NAS serves its own UI certificate, which is not in the runner's trust
  # store. Switch to `insecure = false` plus `ca_cert = "/path/to/ca.pem"` once
  # that certificate is trusted by whatever runs `tofu`.
  insecure = var.truenas_insecure_tls
}