##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "aws_ec2_host" "this" {
  count             = try(var.instance.create, true) && !try(var.instance.create_spot, false) && try(var.instance.dedicated_host.enabled, false) ? 1 : 0
  availability_zone = try(var.instance.availability_zone, null)
  instance_family   = try(var.instance.dedicated_host.instance_family, null)
  instance_type     = try(var.instance.dedicated_host.instance_family, "") == "" ? var.instance.type : null
  host_recovery     = try(var.instance.dedicated_host.host_recovery, null)
  auto_placement    = try(var.instance.dedicated_host.auto_placement, null)
  tags = merge(
    local.all_tags,
    {
      Name = local.name
    }
  )
}