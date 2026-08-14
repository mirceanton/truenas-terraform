# NOTE: npm-proxy is intentionally NOT managed here -- same upstream
# provider/NXRM version gap as repo-docker.tofu (unknown field on read).
# See: https://github.com/sonatype-nexus-community/terraform-provider-sonatyperepo/issues/443
# The repo still exists and is referenced by name in npm_group below.

resource "sonatyperepo_repository_npm_hosted" "npm_hosted" {
  name   = "npm-local"
  online = true

  storage = {
    blob_store_name                = "default"
    strict_content_type_validation = true
    write_policy                   = "ALLOW"
  }
}

import {
  to = sonatyperepo_repository_npm_hosted.npm_hosted
  id = "npm-local"
}

resource "sonatyperepo_repository_npm_group" "npm_group" {
  name   = "npm-all"
  online = true

  storage = {
    blob_store_name                = "default"
    strict_content_type_validation = true
  }

  group = {
    member_names = [
      sonatyperepo_repository_npm_hosted.npm_hosted.name,
      "npm-proxy",
    ]
  }
}

import {
  to = sonatyperepo_repository_npm_group.npm_group
  id = "npm-all"
}
