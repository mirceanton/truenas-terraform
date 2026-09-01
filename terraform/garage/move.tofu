moved {
  from = garage_bucket.home_ops_volsync
  to   = garage_bucket.this["home_ops_volsync"]
}

moved {
  from = garage_bucket.home_ops_cnpg
  to   = garage_bucket.this["home_ops_cnpg"]
}

moved {
  from = garage_key.home_ops_backups_readwrite
  to   = garage_key.this["home_ops_backups_readwrite"]
}

moved {
  from = garage_bucket_permission.volsync_readwrite
  to   = garage_bucket_permission.this["home_ops_backups_readwrite/home_ops_volsync"]
}

moved {
  from = garage_bucket_permission.cnpg_readwrite
  to   = garage_bucket_permission.this["home_ops_backups_readwrite/home_ops_cnpg"]
}
