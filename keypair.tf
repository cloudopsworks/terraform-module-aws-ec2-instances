##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "tls_private_key" "this" {
  count     = try(var.instance.create, true) && try(var.instance.key_pair.create, false) ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "this" {
  count      = try(var.instance.create, true) && try(var.instance.key_pair.create, false) ? 1 : 0
  key_name   = try(var.instance.key_pair.name, format("key/%s", local.name))
  public_key = tls_private_key.this[0].public_key_openssh
  tags       = local.all_tags
}