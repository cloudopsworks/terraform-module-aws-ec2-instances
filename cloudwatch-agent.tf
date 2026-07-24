##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  ec2_instance_id    = try(aws_instance.this[0].id, aws_instance.ami_ignore[0].id, aws_instance.spot[0].id, "")
  ec2_instance_state = try(aws_instance.this[0].instance_state, aws_instance.ami_ignore[0].instance_state, aws_instance.spot[0].instance_state, "")

  cloudwatch_agent_settings                   = try(var.instance.cloudwatch_agent, {})
  cloudwatch_agent_enabled                    = coalesce(try(local.cloudwatch_agent_settings.enabled, null), false)
  cloudwatch_agent_install_enabled            = local.cloudwatch_agent_enabled && coalesce(try(local.cloudwatch_agent_settings.install.enabled, null), true)
  cloudwatch_agent_configure_enabled          = local.cloudwatch_agent_enabled && coalesce(try(local.cloudwatch_agent_settings.configure.enabled, null), false)
  cloudwatch_agent_workload_detection_enabled = local.cloudwatch_agent_enabled && coalesce(try(local.cloudwatch_agent_settings.workload_detection.enabled, null), false)
  cloudwatch_agent_managed_policies_enabled   = local.cloudwatch_agent_enabled && coalesce(try(local.cloudwatch_agent_settings.attach_managed_policies, null), true) && try(var.iam.create, true)

  cloudwatch_agent_rollout_tag_key   = coalesce(try(local.cloudwatch_agent_settings.tag_key, null), "CloudWatchAgent")
  cloudwatch_agent_rollout_tag_value = coalesce(try(local.cloudwatch_agent_settings.tag_value, null), "enabled")
  cloudwatch_agent_rollout_tags = local.cloudwatch_agent_enabled ? {
    (local.cloudwatch_agent_rollout_tag_key) = local.cloudwatch_agent_rollout_tag_value
  } : {}

  cloudwatch_agent_workload_detection_tag_key   = coalesce(try(local.cloudwatch_agent_settings.workload_detection.tag_key, null), "CloudWatchWorkloadDetection")
  cloudwatch_agent_workload_detection_tag_value = coalesce(try(local.cloudwatch_agent_settings.workload_detection.tag_value, null), "enabled")
  cloudwatch_agent_workload_detection_tags = local.cloudwatch_agent_workload_detection_enabled ? {
    (local.cloudwatch_agent_workload_detection_tag_key) = local.cloudwatch_agent_workload_detection_tag_value
  } : {}

  cloudwatch_agent_target_key    = coalesce(try(local.cloudwatch_agent_settings.target.key, null), "InstanceIds")
  cloudwatch_agent_target_values = length(coalesce(try(local.cloudwatch_agent_settings.target.values, null), [])) > 0 ? local.cloudwatch_agent_settings.target.values : (local.cloudwatch_agent_target_key == "InstanceIds" ? [local.ec2_instance_id] : [local.cloudwatch_agent_rollout_tag_value])

  cloudwatch_agent_ssm_core_policy_arn = coalesce(try(
    local.cloudwatch_agent_settings.ssm_managed_policy_arn,
    null
  ), "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore")
  cloudwatch_agent_server_policy_arn = coalesce(try(
    local.cloudwatch_agent_settings.server_managed_policy_arn,
    null
  ), "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchAgentServerPolicy")

  cloudwatch_agent_install_parameters = merge(
    {
      action  = coalesce(try(local.cloudwatch_agent_settings.install.action, null), "Install")
      name    = coalesce(try(local.cloudwatch_agent_settings.install.package_name, null), "AmazonCloudWatchAgent")
      version = coalesce(try(local.cloudwatch_agent_settings.install.version, null), "latest")
    },
    coalesce(try(local.cloudwatch_agent_settings.install.parameters, null), {})
  )

  cloudwatch_agent_configuration_parameter_name = coalesce(try(
    local.cloudwatch_agent_settings.configure.parameter_name,
    null
  ), "AmazonCloudWatch-${local.name}-agent-config")
  cloudwatch_agent_configuration = try(local.cloudwatch_agent_settings.configure.config_json, null) != null ? local.cloudwatch_agent_settings.configure.config_json : jsonencode(
    coalesce(try(local.cloudwatch_agent_settings.configure.config, null), {})
  )
  cloudwatch_agent_configure_parameters = merge(
    {
      action                        = coalesce(try(local.cloudwatch_agent_settings.configure.action, null), "configure")
      mode                          = coalesce(try(local.cloudwatch_agent_settings.configure.mode, null), "ec2")
      optionalConfigurationSource   = coalesce(try(local.cloudwatch_agent_settings.configure.source, null), "ssm")
      optionalConfigurationLocation = local.cloudwatch_agent_configuration_parameter_name
      optionalRestart               = coalesce(try(local.cloudwatch_agent_settings.configure.restart, null), "yes")
    },
    coalesce(try(local.cloudwatch_agent_settings.configure.parameters, null), {})
  )
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_ssm_core" {
  count      = local.cloudwatch_agent_managed_policies_enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = local.cloudwatch_agent_ssm_core_policy_arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server" {
  count      = local.cloudwatch_agent_managed_policies_enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = local.cloudwatch_agent_server_policy_arn
}

resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  count       = local.cloudwatch_agent_configure_enabled ? 1 : 0
  name        = local.cloudwatch_agent_configuration_parameter_name
  description = "CloudWatch agent configuration for ${local.name}"
  type        = "String"
  value       = local.cloudwatch_agent_configuration
  tags        = local.all_tags
}

data "aws_iam_policy_document" "cloudwatch_agent_config" {
  count = local.cloudwatch_agent_configure_enabled && try(var.iam.create, true) && coalesce(try(local.cloudwatch_agent_settings.configure.attach_parameter_policy, null), true) ? 1 : 0

  statement {
    sid    = "AllowCloudWatchAgentConfigurationRead"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = [
      aws_ssm_parameter.cloudwatch_agent_config[0].arn
    ]
  }
}

resource "aws_iam_role_policy" "cloudwatch_agent_config" {
  count  = length(data.aws_iam_policy_document.cloudwatch_agent_config) > 0 ? 1 : 0
  role   = aws_iam_role.this[0].id
  name   = substr("${local.name}-cloudwatch-agent-config", 0, 128)
  policy = data.aws_iam_policy_document.cloudwatch_agent_config[0].json
}

resource "aws_ssm_association" "cloudwatch_agent_install" {
  count            = try(var.instance.create, true) && local.cloudwatch_agent_install_enabled ? 1 : 0
  name             = coalesce(try(local.cloudwatch_agent_settings.install.document_name, null), "AWS-ConfigureAWSPackage")
  association_name = substr(coalesce(try(local.cloudwatch_agent_settings.install.association_name, null), "${local.name}-cloudwatch-agent-install"), 0, 128)
  parameters       = local.cloudwatch_agent_install_parameters
  tags             = local.all_tags

  targets {
    key    = local.cloudwatch_agent_target_key
    values = local.cloudwatch_agent_target_values
  }

  depends_on = [
    aws_iam_instance_profile.this,
    aws_iam_role_policy_attachment.cloudwatch_agent_server,
    aws_iam_role_policy_attachment.cloudwatch_agent_ssm_core
  ]
}

resource "aws_ssm_association" "cloudwatch_agent_configure" {
  count            = try(var.instance.create, true) && local.cloudwatch_agent_configure_enabled ? 1 : 0
  name             = coalesce(try(local.cloudwatch_agent_settings.configure.document_name, null), "AmazonCloudWatch-ManageAgent")
  association_name = substr(coalesce(try(local.cloudwatch_agent_settings.configure.association_name, null), "${local.name}-cloudwatch-agent-config"), 0, 128)
  parameters       = local.cloudwatch_agent_configure_parameters
  tags             = local.all_tags

  targets {
    key    = local.cloudwatch_agent_target_key
    values = local.cloudwatch_agent_target_values
  }

  depends_on = [
    aws_iam_role_policy.cloudwatch_agent_config,
    aws_ssm_association.cloudwatch_agent_install,
    aws_ssm_parameter.cloudwatch_agent_config
  ]
}
