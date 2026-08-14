resource "random_password" "home_ops" {
  length  = 32
  special = false
}

resource "sonatyperepo_user" "home_ops" {
  user_id       = "home-ops"
  first_name    = "HomeOps"
  last_name     = "ServiceAccount"
  email_address = "homeops@mirceanton.com"
  password      = random_password.home_ops.result
  status        = "active"
  roles         = [sonatyperepo_role.docker_readonly.id]
}

import {
  to = sonatyperepo_user.home_ops
  id = "home-ops,default"
}

resource "random_pet" "mirceanton" {
  length = 3
}

resource "sonatyperepo_user" "mirceanton" {
  user_id       = "mirceanton"
  first_name    = "Mircea"
  last_name     = "Anton"
  email_address = "mircea@mirceanton.com"
  password      = random_pet.mirceanton.id
  status        = "active"
  roles         = [sonatyperepo_role.global_readwrite.id]
}

import {
  to = sonatyperepo_user.mirceanton
  id = "mirceanton,default"
}
