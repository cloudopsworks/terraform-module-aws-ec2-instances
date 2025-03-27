##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  backup_tags = try(var.instance.backup.enabled, false) && try(var.instance.backup.only_tag, true) ? {
    "aws-backup"          = "true"                                     # Tag to identify resources for AWS Backup
    "aws-backup-schedule" = try(var.instance.backup.schedule, "daily") # Tag to identify the backup plan
  } : {}
}