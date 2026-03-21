##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "region" {
  description = "Azure Region to deploy resources into. Example: 'eastus2', defaults to empty string as some of the resources may not require region setting."
  type        = string
  default     = ""
}