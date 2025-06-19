##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#
module "tags" {
  source  = "cloudopsworks/tags/local"
  version = "1.0.9"

  env = {
    organization_name = var.org.organization_name
    org_unit_name     = var.org.organization_unit
    environment_name  = var.org.environment_name
    environment_type  = var.org.environment_type
  }
}