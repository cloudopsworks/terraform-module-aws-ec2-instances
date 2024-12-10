##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

data "aws_subnet" "this" {
  count = try(var.instance.create, true) ? 1 : 0
  id    = var.instance.vpc.subnet_id
}

resource "aws_security_group" "this" {
  count       = try(var.instance.create, true) && try(var.instance.security_group.create, false) ? 1 : 0
  name        = "${local.name}-sg"
  description = "Security group for ${local.name} access to any resource"
  vpc_id      = data.aws_subnet.this[0].vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.all_tags, tomap({
    "Name" = "${local.name}-sg"
  }))
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  for_each = {
    for k, v in try(var.instance.security_group.ingress_rules, {}) : k => v if try(var.instance.create, true) && try(var.instance.security_group.create, false)
  }
  security_group_id        = aws_security_group.this[0].id
  description              = try(each.value.description, "Rule for ${local.name} access")
  from_port                = try(each.value.from_port, 0)
  protocol                 = try(each.value.protocol, "-1")
  to_port                  = try(each.value.to_port, 0)
  type                     = try(each.value.type, "ingress")
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}
