##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "instance_id" {
  value = length(aws_instance.this) > 0 ? aws_instance.this[0].id : (length(aws_instance.ami_ignore) > 0 ? aws_instance.ami_ignore[0].id : (length(aws_spot_instance_request.spot) > 0 ? aws_spot_instance_request.spot[0].spot_instance_id : ""))
}

output "state" {
  value = length(aws_instance.this) > 0 ? aws_instance.this[0].instance_state : (length(aws_instance.ami_ignore) > 0 ? aws_instance.ami_ignore[0].instance_state : (length(aws_spot_instance_request.spot) > 0 ? aws_spot_instance_request.spot[0].spot_request_state : ""))
}

output "iam_role" {
  value = try(var.iam.create, true) ? {
    instance_profile = aws_iam_instance_profile.this[0].name
    role             = aws_iam_role.this[0].name
    role_arn         = aws_iam_role.this[0].arn
  } : {}
}

output "key_pair_name" {
  value = try(var.instance.key_pair.create, false) ? aws_key_pair.this[0].key_name : ""
}

output "key_pair_public_key" {
  value     = try(var.instance.key_pair.create, false) ? tls_private_key.this[0].public_key_openssh : ""
  sensitive = true
}

output "key_pair_ssh_private_key" {
  value     = try(var.instance.key_pair.create, false) ? tls_private_key.this[0].private_key_openssh : ""
  sensitive = true
}

output "security_group_id" {
  value = length(aws_security_group.this) > 0 ? aws_security_group.this[0].id : ""
}

output "dedicated_host_id" {
  value = length(aws_ec2_host.this) > 0 ? aws_ec2_host.this[0].id : ""
}

output "dedicated_host_arn" {
  value = length(aws_ec2_host.this) > 0 ? aws_ec2_host.this[0].arn : ""
}