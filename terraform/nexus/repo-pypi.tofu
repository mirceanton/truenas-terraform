# NOTE: pypi-proxy is intentionally NOT managed here -- same upstream
# provider/NXRM version gap as repo-docker.tofu (unknown field on read).
# See: https://github.com/sonatype-nexus-community/terraform-provider-sonatyperepo/issues/443
# The repo still exists and is referenced by name in pypi_group below.

resource "sonatyperepo_repository_pypi_hosted" "pypi_hosted" {
  name   = "pypi-local"
  online = true

  storage = {
    blob_store_name                = "default"
    strict_content_type_validation = true
    write_policy                   = "ALLOW"
  }
}

import {
  to = sonatyperepo_repository_pypi_hosted.pypi_hosted
  id = "pypi-local"
}

resource "sonatyperepo_repository_pypi_group" "pypi_group" {
  name   = "pypi-all"
  online = true

  storage = {
    blob_store_name                = "default"
    strict_content_type_validation = true
  }

  group = {
    member_names = [
      sonatyperepo_repository_pypi_hosted.pypi_hosted.name,
      "pypi-proxy",
    ]
  }
}

import {
  to = sonatyperepo_repository_pypi_group.pypi_group
  id = "pypi-all"
}
