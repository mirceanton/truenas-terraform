resource "garage_bucket" "home_ops_volsync" {
  global_alias = "home-ops-volsync"
}

import {
  to = garage_bucket.home_ops_volsync
  id = "c9ba654b34ff8a86e917459ba335a5ac38476f156a9354dd0c2678c34bfbbfbf"
}

resource "garage_bucket" "home_ops_cnpg" {
  global_alias = "home-ops-cnpg"
}

import {
  to = garage_bucket.home_ops_cnpg
  id = "cbcdc3a56d8d62b50114ed6e67de530b229b6218c5d12ee49cee0ae4c8b4d511"
}

resource "garage_key" "home_ops_backups_readwrite" {
  name = "home-ops-backups-readwrite"
}

import {
  to = garage_key.home_ops_backups_readwrite
  id = "GK7cd956c3a961aab4e95ac3e9"
}

resource "garage_bucket_permission" "volsync_readwrite" {
  bucket_id     = garage_bucket.home_ops_volsync.id
  access_key_id = garage_key.home_ops_backups_readwrite.id
  read          = true
  write         = true
  owner         = false
}

import {
  to = garage_bucket_permission.volsync_readwrite
  id = "c9ba654b34ff8a86e917459ba335a5ac38476f156a9354dd0c2678c34bfbbfbf/GK7cd956c3a961aab4e95ac3e9"
}

resource "garage_bucket_permission" "cnpg_readwrite" {
  bucket_id     = garage_bucket.home_ops_cnpg.id
  access_key_id = garage_key.home_ops_backups_readwrite.id
  read          = true
  write         = true
  owner         = false
}

import {
  to = garage_bucket_permission.cnpg_readwrite
  id = "cbcdc3a56d8d62b50114ed6e67de530b229b6218c5d12ee49cee0ae4c8b4d511/GK7cd956c3a961aab4e95ac3e9"
}
