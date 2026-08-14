resource "sonatyperepo_security_realms" "realms" {
  active = [
    "NexusAuthenticatingRealm",
    "DockerToken",
    "NpmToken",
    "TerraformToken",
  ]
}

import {
  to = sonatyperepo_security_realms.realms
  id = "security_realms"
}
