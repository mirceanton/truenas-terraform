# SMB and NFS shares, plus the two service singletons.
#
# The `id` in each map entry is the live TrueNAS object id and is used only by
# the import blocks in imports.tofu; the resource itself addresses objects by
# name/path.
locals {
  smb_shares = {
    "Media"             = { id = 3, path = "/mnt/tank/Media", purpose = "DEFAULT_SHARE" }
    "Projects"          = { id = 18, path = "/mnt/tank/Projects", purpose = "DEFAULT_SHARE" }
    "Users"             = { id = 20, path = "/mnt/tank/Users", purpose = "DEFAULT_SHARE" }
    "Proxmox-Backups"   = { id = 26, path = "/mnt/tank/Backups/Proxmox", purpose = "DEFAULT_SHARE" }
    "torrent_downloads" = { id = 30, path = "/mnt/scratch/Torrent_Downloads", purpose = "DEFAULT_SHARE" }
    "TimeMachine"       = { id = 33, path = "/mnt/tank/Backups/TimeMachine", purpose = "TIMEMACHINE_SHARE" }
  }

  nfs_shares = {
    "/mnt/tank/Media"                = { id = 27, mapall_user = "apps", mapall_group = "apps" }
    "/mnt/tank/Media/Music"          = { id = 18, mapall_user = "apps", mapall_group = "apps" }
    "/mnt/tank/Media/Movies"         = { id = 19, mapall_user = "apps", mapall_group = "apps" }
    "/mnt/tank/Media/TV_Shows"       = { id = 21, mapall_user = "apps", mapall_group = "apps" }
    "/mnt/tank/Media/Documents"      = { id = 35, mapall_user = "apps", mapall_group = "apps" }
    "/mnt/tank/Media/Books"          = { id = 39, mapall_user = "apps", mapall_group = "apps" }
    "/mnt/tank/Media/Photos"         = { id = 54, mapall_user = "apps", mapall_group = "apps" }
    "/mnt/tank/Media/3D_Models"      = { id = 62 }
    "/mnt/scratch/Torrent_Downloads" = { id = 48 }
    "/mnt/tank/Apps/Immich" = {
      id            = 64
      comment       = "Immich library"
      hosts         = ["10.255.255.15"]
      maproot_user  = "apps"
      maproot_group = "apps"
    }
    "/mnt/tank/Projects/mirceanton" = {
      id           = 65
      comment      = "Projects - Mirceanton"
      mapall_user  = "mirk"
      mapall_group = "Home"
    }
  }
}

resource "truenas_smb_share" "this" {
  for_each = local.smb_shares

  name      = each.key
  path      = each.value.path
  purpose   = each.value.purpose
  enabled   = true
  browsable = true
}

resource "truenas_nfs_share" "this" {
  for_each = local.nfs_shares

  path          = each.key
  enabled       = true
  comment       = try(each.value.comment, null)
  hosts         = try(each.value.hosts, null)
  mapall_user   = try(each.value.mapall_user, null)
  mapall_group  = try(each.value.mapall_group, null)
  maproot_user  = try(each.value.maproot_user, null)
  maproot_group = try(each.value.maproot_group, null)
}

# SMB/NFS service singletons. These resources adopt the existing configuration
# on create and only destroy the local state ("forget") on destroy; only one
# workspace may own them. Only the settings that are deliberately configured
# here are declared — the rest follow the server.
resource "truenas_smb_config" "this" {
  netbiosname     = "TRUENAS"
  workgroup       = "WORKGROUP"
  description     = "TrueNAS Server"
  localmaster     = true
  multichannel    = true
  aapl_extensions = true
  encryption      = "DEFAULT"
  guest           = "nobody"
  unixcharset     = "UTF-8"
  bindip          = ["192.168.42.245", "10.255.255.245", "192.168.69.245", "10.0.10.245"]
}

resource "truenas_nfs_config" "this" {
  protocols = ["NFSV3", "NFSV4"]
  servers   = 8
  bindip    = ["10.255.255.245"]
}