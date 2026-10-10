# Pull-through (proxy) Docker repositories: on first pull Nexus fetches the image
# from the upstream registry and caches it locally, and every later pull is served
# from the NAS. This is what lets hosts without WAN egress (the Services VLAN)
# still pull public images.
#
# The repository name doubles as the first path segment under /v2/ (Nexus >= 3.89
# requires lowercase names and always uses path-based routing), so it must equal
# the hostname the client's registry mirror rewrites to -- a mirror entry
# pointing at https://registry.nas.svc.h.mirceanton.com/v2/factory.talos.dev/ only
# resolves if a repository named `factory.talos.dev` exists.
resource "sonatyperepo_repository_docker_proxy" "this" {
  for_each = var.docker_proxy_registries

  name   = each.key
  online = true

  storage = {
    blob_store_name                = "default"
    strict_content_type_validation = true
  }

  proxy = {
    remote_url       = each.value
    content_max_age  = 1440
    metadata_max_age = 1440
  }

  negative_cache = {
    enabled      = true
    time_to_live = 1440
  }

  http_client = {
    # No auto-blocking: a transient upstream failure while the NAS itself is
    # offline would otherwise leave the repository blocked, and clients pulling
    # through it use `skipFallback`, so they have nowhere else to go.
    blocked    = false
    auto_block = false
  }

  docker = {
    # Clients authenticate against the Nexus DockerToken realm with the read-only
    # service account and then pull with the bearer token it issues.
    force_basic_auth = false
    v1_enabled       = false
    path_enabled     = true
  }

  docker_proxy = {
    # REGISTRY rather than HUB: the upstream at proxy.remote_url is a registry of
    # its own, not Docker Hub.
    index_type = "REGISTRY"
  }
}
