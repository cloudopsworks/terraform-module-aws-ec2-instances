##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# Establish this is a HUB or spoke configuration
variable "is_hub" {
  type    = bool
  default = false
}

variable "spoke_def" {
  type    = string
  default = "001"
}

variable "org" {
  type = object({
    organization_name = string
    organization_unit = string
    environment_type  = string
    environment_name  = string
  })
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
