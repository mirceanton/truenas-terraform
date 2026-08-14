# NOTE: the 7 docker proxy repos (docker.io, ghcr.io, gcr.io, quay.io,
# mcr.microsoft.com, registry.k8s.io, oci.external-secrets.io) are
# intentionally NOT managed here. Nexus 3.94.0+ (we're on 3.95.1) added an
# `ecrAuth` field to the docker proxy repository API response that the
# sonatyperepo provider doesn't parse, even at latest (v1.14.0) -- every
# import fails with `json: unknown field "ecrAuth"`. This is a known, open,
# currently-blocked upstream issue:
# https://github.com/sonatype-nexus-community/terraform-provider-sonatyperepo/issues/443
# Revisit once that's fixed upstream. The proxy repos still exist and work
# in Nexus, they're just unmanaged by Terraform for now.
locals {
  registries = [
    "docker.io",
    "ghcr.io",
    "gcr.io",
    "quay.io",
    "mcr.microsoft.com",
    "registry.k8s.io",
    "oci.external-secrets.io",
  ]
}

resource "sonatyperepo_repository_docker_hosted" "docker_hosted" {
  name   = "docker-internal"
  online = true

  storage = {
    blob_store_name                = "default"
    strict_content_type_validation = true
    write_policy                   = "ALLOW"
  }

  docker = {
    force_basic_auth = false
    v1_enabled       = false
  }
}

import {
  to = sonatyperepo_repository_docker_hosted.docker_hosted
  id = "docker-internal"
}

resource "sonatyperepo_repository_docker_group" "docker_group" {
  name   = "docker-all"
  online = true

  storage = {
    blob_store_name                = "default"
    strict_content_type_validation = true
  }

  group = {
    member_names = concat(
      [sonatyperepo_repository_docker_hosted.docker_hosted.name],
      local.registries
    )
  }

  docker = {
    force_basic_auth = false
    v1_enabled       = false
  }
}

import {
  to = sonatyperepo_repository_docker_group.docker_group
  id = "docker-all"
}
