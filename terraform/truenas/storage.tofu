# Storage: pools, datasets and ZVOLs.
#
# Pools already exist (they were created in the UI) and are read-only inputs
# here, so they are data sources. The provider's `truenas_pool` *resource* can
# create a pool but refuses to change or destroy an existing one — a data
# source is the right tool for a pool this configuration only needs the id of
# (scrub tasks are per pool and take that numeric id).
data "truenas_pool" "this" {
  for_each = toset(["tank", "scratch"])
  name     = each.key
}

# Datasets and ZVOLs that already exist on the box. Each is adopted with an
# import block in imports.tofu — no data is created, moved or deleted.
#
# Only properties that are set *locally* on the dataset are declared below.
# The provider reports an inherited/default ZFS property as unset, so
# declaring an inherited value would make the first apply convert that
# inherited property into a local one on every dataset (a real change to how
# the pool inherits properties) for no benefit. Everything not declared here
# follows its parent / the ZFS default and is left unmanaged. Effective values
# for the whole tree are in the migration PR description.
locals {
  datasets = {
    "scratch"                   = { aclmode = "DISCARD", acltype = "posix", atime = "OFF", compression = "lz4" }
    "scratch/Nexus_Data"        = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", copies = 1 }
    "scratch/Torrent_Downloads" = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", copies = 1 }
    "tank"                      = { aclmode = "DISCARD", acltype = "posix", atime = "OFF", compression = "lz4" }
    "tank/Apps"                 = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", copies = 1 }
    "tank/Apps/Garage"          = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", copies = 1 }
    "tank/Apps/Immich"          = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", compression = "lz4" }
    "tank/Backups"              = { aclmode = "PASSTHROUGH", acltype = "nfsv4", compression = "gzip-9", copies = 1, recordsize = "1M", snapdir = "HIDDEN" }
    "tank/Backups/HomeOps"      = { copies = 1 }
    "tank/Backups/Proxmox"      = { copies = 1 }
    "tank/Backups/TimeMachine"  = { comments = "Apple TimeMachine Backups Endpoint.", copies = 1 }
    "tank/Media"                = { aclmode = "RESTRICTED", acltype = "nfsv4", copies = 1 }
    "tank/Media/3D_Models"      = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", copies = 1 }
    "tank/Media/Books"          = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", copies = 1 }
    "tank/Media/Documents"      = { copies = 1 }
    "tank/Media/Movies"         = { copies = 1 }
    "tank/Media/Music"          = { copies = 1 }
    "tank/Media/Photos"         = { aclmode = "PASSTHROUGH", acltype = "nfsv4", atime = "OFF", copies = 1 }
    "tank/Media/TV_Shows"       = { copies = 1 }
    "tank/Projects"             = {}
    "tank/Projects/BehindGates" = {}
    "tank/Projects/Drums"       = { aclmode = "RESTRICTED", acltype = "nfsv4", copies = 1 }
    "tank/Projects/bomkii"      = { aclmode = "RESTRICTED", acltype = "nfsv4", copies = 1 }
    "tank/Projects/mirceanton"  = { aclmode = "RESTRICTED", acltype = "nfsv4", copies = 1 }
    "tank/Users"                = {}
    "tank/Users/bianca"         = { copies = 1 }
    "tank/Users/mircea"         = { copies = 1 }
    "tank/Users/terraform"      = { copies = 1 }
    "tank/ZVOLs"                = { copies = 1 }
  }
}

resource "truenas_dataset" "this" {
  for_each = local.datasets

  name        = each.key
  aclmode     = try(each.value.aclmode, null)
  acltype     = try(each.value.acltype, null)
  atime       = try(each.value.atime, null)
  comments    = try(each.value.comments, null)
  compression = try(each.value.compression, null)
  copies      = try(each.value.copies, null)
  recordsize  = try(each.value.recordsize, null)
  snapdir     = try(each.value.snapdir, null)

  # `acltype` and `type` are create-only on TrueNAS: a change is planned as a
  # replace, i.e. destroying and recreating the dataset. Refuse that instead
  # of silently erasing terabytes of data; change it out of band (or remove
  # this guard deliberately) if a dataset ever has to be recreated.
  lifecycle {
    prevent_destroy = true
  }
}

# The Steam library ZVOL behind the iSCSI extent. `volsize`/`volblocksize` are
# create-time settings; both are declared at their live values so the first
# apply is a no-op.
resource "truenas_zvol" "steamlib" {
  name         = "tank/ZVOLs/mircea-steamlib"
  volsize      = 1099511660544 # 1 TiB
  volblocksize = 32768         # 32K

  lifecycle {
    prevent_destroy = true
  }
}