locals {
  bucket_permissions = merge([
    for key_name, key in var.keys : {
      for bucket_name, permission in key.permissions :
      "${key_name}/${bucket_name}" => {
        key    = key_name
        bucket = bucket_name
        read   = permission.read
        write  = permission.write
        owner  = permission.owner
      }
    }
  ]...)
}

resource "garage_bucket" "this" {
  for_each = var.buckets

  global_alias           = each.value.global_alias
  max_objects            = each.value.max_objects
  max_size               = each.value.max_size
  website_enabled        = each.value.website_enabled
  website_error_document = each.value.website_error_document
  website_index_document = each.value.website_index_document
}

resource "garage_key" "this" {
  for_each = var.keys

  name = each.value.name
}

resource "garage_bucket_permission" "this" {
  for_each = local.bucket_permissions

  bucket_id     = garage_bucket.this[each.value.bucket].id
  access_key_id = garage_key.this[each.value.key].id
  read          = each.value.read
  write         = each.value.write
  owner         = each.value.owner
}
