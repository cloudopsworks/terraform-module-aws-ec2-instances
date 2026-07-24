##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "instance_id" {
  description = "ID of the EC2 instance created by the active launch path."
  value       = local.ec2_instance_id
}

output "state" {
  description = "Current state of the EC2 instance created by the active launch path."
  value       = local.ec2_instance_state
}

output "iam_role" {
  description = "Created IAM instance profile, role name, and role ARN when iam.create is true."
  value = try(var.iam.create, true) ? {
    instance_profile = aws_iam_instance_profile.this[0].name
    role             = aws_iam_role.this[0].name
    role_arn         = aws_iam_role.this[0].arn
  } : {}
}

output "key_pair_name" {
  description = "Name of the generated AWS key pair when instance.key_pair.create is true."
  value       = try(var.instance.key_pair.create, false) ? aws_key_pair.this[0].key_name : ""
}

output "key_pair_public_key" {
  description = "Generated OpenSSH public key material when instance.key_pair.create is true."
  value       = try(var.instance.key_pair.create, false) ? tls_private_key.this[0].public_key_openssh : ""
  sensitive   = true
}

output "key_pair_ssh_private_key" {
  description = "Generated OpenSSH private key material when instance.key_pair.create is true."
  value       = try(var.instance.key_pair.create, false) ? tls_private_key.this[0].private_key_openssh : ""
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the managed security group when instance.security_group.create is true."
  value       = length(aws_security_group.this) > 0 ? aws_security_group.this[0].id : ""
}

output "security_group_name" {
  description = "Name of the managed security group when instance.security_group.create is true."
  value       = length(aws_security_group.this) > 0 ? aws_security_group.this[0].name : ""
}

output "dedicated_host_id" {
  description = "ID of the dedicated EC2 host when instance.dedicated_host.enabled is true."
  value       = length(aws_ec2_host.this) > 0 ? aws_ec2_host.this[0].id : ""
}

output "dedicated_host_arn" {
  description = "ARN of the dedicated EC2 host when instance.dedicated_host.enabled is true."
  value       = length(aws_ec2_host.this) > 0 ? aws_ec2_host.this[0].arn : ""
}

output "cloudwatch_agent" {
  description = "CloudWatch Agent SSM associations, configuration parameter, and opt-in tags."
  value = {
    enabled                         = local.cloudwatch_agent_enabled
    install_association_id          = try(aws_ssm_association.cloudwatch_agent_install[0].association_id, "")
    configure_association_id        = try(aws_ssm_association.cloudwatch_agent_configure[0].association_id, "")
    configuration_parameter_name    = try(aws_ssm_parameter.cloudwatch_agent_config[0].name, "")
    rollout_tag_key                 = local.cloudwatch_agent_rollout_tag_key
    rollout_tag_value               = local.cloudwatch_agent_rollout_tag_value
    workload_detection_enabled      = local.cloudwatch_agent_workload_detection_enabled
    workload_detection_tag_key      = local.cloudwatch_agent_workload_detection_tag_key
    workload_detection_tag_value    = local.cloudwatch_agent_workload_detection_tag_value
    attached_managed_policy_arns    = local.cloudwatch_agent_attached_managed_policy_arns
    ssm_association_target_key      = local.cloudwatch_agent_target_key
    ssm_association_target_values   = local.cloudwatch_agent_target_values
    configure_parameter_policy_name = try(aws_iam_role_policy.cloudwatch_agent_config[0].name, "")
  }
}
