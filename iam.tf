##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#
data "aws_partition" "current" {}

locals {
  iam_role_name = "role-${local.name}"
}

data "aws_iam_policy_document" "assume_role" {
  count = try(var.instance.create, true) && try(var.iam.create, true) ? 1 : 0
  statement {
    sid    = "AllowAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "this" {
  count                 = try(var.instance.create, true) && try(var.iam.create, true) ? 1 : 0
  name                  = local.iam_role_name
  path                  = try(var.iam.path, null)
  description           = try(var.iam.role_description, "IAM Instance Role ${local.name}")
  assume_role_policy    = data.aws_iam_policy_document.assume_role[count.index].json
  permissions_boundary  = try(var.iam.permissions_boundary, null)
  force_detach_policies = true
  tags = merge(local.all_tags, try(var.iam.extra_tags, {}), {
    Name = local.iam_role_name
  })
}

data "aws_iam_policy_document" "policy" {
  count = try(var.instance.create, true) && try(var.iam.create, true) && length(try(var.iam.policies, [])) > 0 ? length(try(var.iam.policies, [])) : 0
  dynamic "statement" {
    for_each = try(var.iam.policies[count.index].statements, [])
    content {
      sid       = try(statement.value.sid, null)
      effect    = try(statement.value.effect, null)
      actions   = try(statement.value.actions, [])
      resources = try(statement.value.resources, [])
      principals {
        type        = try(statement.value.principals.type, null)
        identifiers = try(statement.value.principals.identifiers, [])
      }
      dynamic "condition" {
        for_each = try(statement.value.conditions, [])
        content {
          test     = try(condition.value.test, null)
          variable = try(condition.value.variable, null)
          values   = try(condition.value.values, [])
        }
      }
    }
  }
}

resource "aws_iam_role_policy" "policy" {
  count  = try(var.instance.create, true) && try(var.iam.create, true) && length(try(var.iam.policies, [])) > 0 ? length(try(var.iam.policies, [])) : 0
  role   = aws_iam_role.this[0].id
  name   = var.iam.policies[count.index].name
  policy = data.aws_iam_policy_document.policy[count.index].json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for k, v in try(var.iam.role_policies, {}) : k => v if try(var.instance.create, true) && try(var.iam.create, true)
  }
  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_instance_profile" "this" {
  count = try(var.instance.create, true) && try(var.iam.create, true) ? 1 : 0
  role  = aws_iam_role.this[0].name
  name  = local.iam_role_name
  path  = try(var.iam.path, null)
  tags = merge(local.all_tags, try(var.iam.extra_tags, {}), {
    Name = local.iam_role_name
  })
  lifecycle {
    create_before_destroy = true
  }
}


