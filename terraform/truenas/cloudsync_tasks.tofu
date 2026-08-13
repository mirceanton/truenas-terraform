locals {
  b2_backup_bucket = "mirceanton-truenas-backup"

  b2_backup_schedule = {
    minute = "0"
    hour   = "0"
    dom    = "*"
    month  = "*"
    dow    = "*"
  }
}

resource "truenas_cloudsync_task" "users_mircea" {
  description   = "B2 - Users - Mircea"
  path          = "/mnt/tank/Users/mircea"
  credentials   = tonumber(truenas_cloudsync_credentials.backblaze_b2.id)
  direction     = "push"
  transfer_mode = "sync"
  transfers     = 16
  snapshot      = true

  b2 {
    bucket = local.b2_backup_bucket
    folder = "/Users/mircea"
  }

  schedule {
    minute = local.b2_backup_schedule.minute
    hour   = local.b2_backup_schedule.hour
    dom    = local.b2_backup_schedule.dom
    month  = local.b2_backup_schedule.month
    dow    = local.b2_backup_schedule.dow
  }

  encryption {
    password = var.b2_backup_encryption_password
    salt     = var.b2_backup_encryption_salt
  }
}

import {
  to = truenas_cloudsync_task.users_mircea
  id = "10"
}

resource "truenas_cloudsync_task" "users_bianca" {
  description   = "B2 - Users - Bianca"
  path          = "/mnt/tank/Users/bianca"
  credentials   = tonumber(truenas_cloudsync_credentials.backblaze_b2.id)
  direction     = "push"
  transfer_mode = "sync"
  transfers     = 16
  snapshot      = true

  b2 {
    bucket = local.b2_backup_bucket
    folder = "/Users/bianca"
  }

  schedule {
    minute = local.b2_backup_schedule.minute
    hour   = local.b2_backup_schedule.hour
    dom    = local.b2_backup_schedule.dom
    month  = local.b2_backup_schedule.month
    dow    = local.b2_backup_schedule.dow
  }

  encryption {
    password = var.b2_backup_encryption_password
    salt     = var.b2_backup_encryption_salt
  }
}

import {
  to = truenas_cloudsync_task.users_bianca
  id = "11"
}

resource "truenas_cloudsync_task" "projects_mirceanton" {
  description   = "B2 - Projects - mirceanton"
  path          = "/mnt/tank/Projects/mirceanton"
  credentials   = tonumber(truenas_cloudsync_credentials.backblaze_b2.id)
  direction     = "push"
  transfer_mode = "sync"
  transfers     = 16
  snapshot      = true

  b2 {
    bucket = local.b2_backup_bucket
    folder = "/Projects/mirceanton"
  }

  schedule {
    minute = local.b2_backup_schedule.minute
    hour   = local.b2_backup_schedule.hour
    dom    = local.b2_backup_schedule.dom
    month  = local.b2_backup_schedule.month
    dow    = local.b2_backup_schedule.dow
  }

  encryption {
    password = var.b2_backup_encryption_password
    salt     = var.b2_backup_encryption_salt
  }
}

import {
  to = truenas_cloudsync_task.projects_mirceanton
  id = "12"
}

resource "truenas_cloudsync_task" "projects_bomkii" {
  description   = "B2 - Projects - bomkii"
  path          = "/mnt/tank/Projects/bomkii"
  credentials   = tonumber(truenas_cloudsync_credentials.backblaze_b2.id)
  direction     = "push"
  transfer_mode = "sync"
  transfers     = 16
  snapshot      = true

  b2 {
    bucket = local.b2_backup_bucket
    folder = "/Projects/bomkii"
  }

  schedule {
    minute = local.b2_backup_schedule.minute
    hour   = local.b2_backup_schedule.hour
    dom    = local.b2_backup_schedule.dom
    month  = local.b2_backup_schedule.month
    dow    = local.b2_backup_schedule.dow
  }

  encryption {
    password = var.b2_backup_encryption_password
    salt     = var.b2_backup_encryption_salt
  }
}

import {
  to = truenas_cloudsync_task.projects_bomkii
  id = "13"
}

resource "truenas_cloudsync_task" "projects_behindgates" {
  description   = "B2 - Projects - BehindGates"
  path          = "/mnt/tank/Projects/BehindGates"
  credentials   = tonumber(truenas_cloudsync_credentials.backblaze_b2.id)
  direction     = "push"
  transfer_mode = "sync"
  transfers     = 16
  snapshot      = true

  b2 {
    bucket = local.b2_backup_bucket
    folder = "/Projects/BehindGates"
  }

  schedule {
    minute = local.b2_backup_schedule.minute
    hour   = local.b2_backup_schedule.hour
    dom    = local.b2_backup_schedule.dom
    month  = local.b2_backup_schedule.month
    dow    = local.b2_backup_schedule.dow
  }

  encryption {
    password = var.b2_backup_encryption_password
    salt     = var.b2_backup_encryption_salt
  }
}

import {
  to = truenas_cloudsync_task.projects_behindgates
  id = "14"
}

resource "truenas_cloudsync_task" "apps" {
  description   = "B2 - Apps"
  path          = "/mnt/tank/Apps"
  credentials   = tonumber(truenas_cloudsync_credentials.backblaze_b2.id)
  direction     = "push"
  transfer_mode = "sync"
  transfers     = 16
  snapshot      = false
  exclude       = ["Torrent_Downloads"]

  b2 {
    bucket = local.b2_backup_bucket
    folder = "/Apps"
  }

  schedule {
    minute = local.b2_backup_schedule.minute
    hour   = local.b2_backup_schedule.hour
    dom    = local.b2_backup_schedule.dom
    month  = local.b2_backup_schedule.month
    dow    = local.b2_backup_schedule.dow
  }

  encryption {
    password = var.b2_backup_encryption_password
    salt     = var.b2_backup_encryption_salt
  }
}

import {
  to = truenas_cloudsync_task.apps
  id = "17"
}
