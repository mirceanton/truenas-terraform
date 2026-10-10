include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../terraform/nexus"
}

inputs = {
  nexus_url      = "https://registry.nas.svc.h.mirceanton.com"
  nexus_username = get_env("TF_VAR_nexus_username")
  nexus_password = get_env("TF_VAR_nexus_password")

  # Docker pull-through repositories, keyed by the name clients use under /v2/
  # (see the module's `docker_proxy_registries` description).
  #
  # Only `factory.talos.dev` is listed: it is the one registry the NAS does not
  # already proxy, and it is what publishes the Talos installer from v1.14 on
  # (`ghcr.io/siderolabs/installer` has no v1.14.x tag). The repositories that
  # already existed -- docker.io, registry-1.docker.io, ghcr.io, gcr.io, quay.io,
  # mcr.microsoft.com, registry.k8s.io and oci.external-secrets.io -- were created
  # by hand before this module existed; adopting them needs `import` blocks and a
  # plan against their live configuration, which is a separate change.
  docker_proxy_registries = {
    "factory.talos.dev" = "https://factory.talos.dev"
  }
}
