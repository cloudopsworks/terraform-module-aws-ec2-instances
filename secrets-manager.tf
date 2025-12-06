##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# Secrets saving
resource "aws_secretsmanager_secret" "instance_public_key" {
  count = try(var.instance.create, true) && try(var.instance.secrets_manager_enabled, true) && try(var.instance.key_pair.create, false) ? 1 : 0
  name  = "${local.secret_store_path}/instance/${local.name}/public-key"
  tags  = local.all_tags
}

resource "aws_secretsmanager_secret_version" "instance_public_key" {
  count         = try(var.instance.create, true) && try(var.instance.secrets_manager_enabled, true) && try(var.instance.key_pair.create, false) ? 1 : 0
  secret_id     = aws_secretsmanager_secret.instance_public_key[count.index].id
  secret_string = aws_key_pair.this[count.index].public_key
}

resource "aws_secretsmanager_secret" "instance_private_key" {
  count = try(var.instance.create, true) && try(var.instance.secrets_manager_enabled, true) && try(var.instance.key_pair.create, false) ? 1 : 0
  name  = "${local.secret_store_path}/instance/${local.name}/private-key"
  tags  = local.all_tags
}

resource "aws_secretsmanager_secret_version" "instance_private_key" {
  count         = try(var.instance.create, true) && try(var.instance.secrets_manager_enabled, true) && try(var.instance.key_pair.create, false) ? 1 : 0
  secret_id     = aws_secretsmanager_secret.instance_private_key[count.index].id
  secret_string = tls_private_key.this[count.index].private_key_pem
}

# resource "aws_ssm_parameter" "tronador_accelerate_instance_key" {
#   count = try(var.instance.create, true) && try(var.instance.secrets_manager_enabled, true) && var.devops_accelerator ? 1 : 0
#   name  = "/cloudopsworks/tronador/bastion/${var.spoke_def}/key-secret-name"
#   type  = "String"
#   value = aws_secretsmanager_secret.instance_private_key[0].name
# }
#
# resource "aws_ssm_parameter" "tronador_accelerate_instance_instance" {
#   count = try(var.instance.create, true) && try(var.instance.secrets_manager_enabled, true) && var.devops_accelerator ? 1 : 0
#   name  = "/cloudopsworks/tronador/bastion/${var.spoke_def}/instance-id"
#   type  = "String"
#   value = aws_instance.instance_server[0].id
# }
