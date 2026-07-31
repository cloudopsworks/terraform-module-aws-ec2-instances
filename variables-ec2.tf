##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name" {
  description = "The name of the EC2 Instance"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "The name prefix of the EC2 Instance"
  type        = string
  default     = ""
}

##
# YAML Structure:
# instance:
#   create: true | false     # defaults to True
#   create_spot: true | false # defaults to False
#   dedicated_host: true | false # defaults to False - requests a dedicated host with the instance type
#   ignore_ami_changes: true | false # defaults to False
#   ami:
#     name: "ami-name" # (optional) if stated ami.id will be ignored
#     architecture: "x86_64" | "arm64" # defaults to "x86_64"
#     id: "ami-id" # (optional) if stated ami.name will be ignored
#     most_recent: true | false # defaults to True
#     owners: ["self"] # defaults to ["self"]
#     filters: # defaults to []
#       - name: "filter-name" # (optional) if stated filter.values will be ignored
#         values: ["filter-value"] # (optional) if stated filter.name will be ignored
#   type: "t2.micro" # defaults to "t2.micro"
#   hibernation: true | false # defaults to null
#   user_data: "user-data" # defaults to null
#   user_data_base64: "user-data-base64" # defaults to null
#   user_data_replace_on_change: true | false # defaults to null
#   cpu_options:
#     core_count: 1 # defaults to null
#     threads_per_core: 1 # defaults to null
#     amd_sev_snp: true | false # defaults to null
#   availability_zone: "us-east-1a" # defaults to null
#   key_name: "key-name" # defaults to null
#   monitoring: true | false # defaults to null
#   get_password_data: true | false # defaults to null
#   vpc:
#     security_group_ids: ["sg-12345678"] # defaults to null
#     associate_public_ip_address: true | false # defaults to null
#     subnet_id: "subnet-id" # defaults to null
#     private_ip: "private-ip" # defaults to null
#     secondary_private_ips: ["secondary-private-ip"] # defaults to null
#     ipv6_address_count: 1 # defaults to null
#     ipv6_addresses: ["ipv6-address"] # defaults to null
#   network_interface:
#     create: true | false # defaults to false
#     # Required if create is true
#     subnet_id: "subnet-id" # defaults to null
#     private_ips: ["private-ip"] # defaults to null
#     # Optional if create is false
#     network_interface_id: "eni-id" # defaults to null; mutually exclusive with create_spot, security_group.create, source_dest_check, and instance.vpc networking fields
#   extra_tags: {} # (Optional) Additional tags merged into the instance tags. Default: {}
#   volume_tags:
#     enabled: true | false # (Optional) Tag every attached volume through the instance-level volume_tags attribute. When false, tags are applied per block device instead. Default: true
#     extra_tags: {} # (Optional) Additional tags merged into the computed volume tags. Default: {}
#     # Computed volume tags are the common/extra module tags plus volume_tags.extra_tags,
#     # Name = <instance name>, and InstanceName = <instance name>.
#   root_block_device:
#     volume_size: 8 # defaults to null
#     volume_type: "gp3" # defaults to null
#     iops: 3000 # defaults to null
#     throughput: 125 # defaults to null
#     encrypted: true | false # defaults to null
#     kms_key_id: "kms-key-id" # defaults to null
#     delete_on_termination: true | false # defaults to null
#     tags: {} # (Optional) Root volume tags; only applied when volume_tags.enabled is false. Default: {}
#   ebs:
#     ebs_optimized: true | false # defaults to null
#     block_device:
#       - device_name: "/dev/xvda"
#         volume_size: 8
#         volume_type: "gp3"
#         iops: 3000
#         throughput: 125
#         encrypted: true
#         kms_key_id: "kms-key-id"
#         delete_on_termination: true
#         tags: {} # (Optional) Volume tags; only applied when volume_tags.enabled is false, merged over Name = "<instance name>-<index>". Default: {}
#   ephemeral_block_device:
#     - device_name: "/dev/sdh"
#       virtual_name: "ephemeral0"
#       no_device: true
#   metadata_options:
#     http_endpoint: "enabled" | "disabled" # defaults to "enabled"
#     http_tokens: "required" # defaults to "required" and enforces IMDSv2; "optional" is rejected
#     http_put_response_hop_limit: 1 # defaults to null; valid range 1 through 64
#     instance_metadata_tags: "enabled" | "disabled" # defaults to "disabled"
#   placement_group: "placement-group" # defaults to null
#   tenancy: "default" | "dedicated" # defaults to null
#   cloudwatch_agent:
#     enabled: true | false # (Optional) Install/configure the Amazon CloudWatch Agent through SSM State Manager. Default: false.
#     attach_managed_policies: true | false # (Optional) Attach CloudWatchAgentServerPolicy when iam.create=true; AmazonSSMManagedInstanceCore is provided by iam.ssm_enabled by default and skipped here to avoid duplicate attachments. Default: true.
#     tag_key: "CloudWatchAgent" # (Optional) Tag key used when tag-based SSM targeting is selected. Default: "CloudWatchAgent".
#     tag_value: "enabled" # (Optional) Tag value used when tag-based SSM targeting is selected. Default: "enabled".
#     ssm_managed_policy_arn: "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # (Optional) Override SSM managed instance policy ARN.
#     server_managed_policy_arn: "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" # (Optional) Override CloudWatch agent server policy ARN.
#     target:
#       key: "InstanceIds" # (Optional) SSM target key. Use "InstanceIds" or "tag:<TagKey>". Default: "InstanceIds".
#       values: ["i-0123456789abcdef0"] # (Optional) SSM target values. Default: created instance ID when key is "InstanceIds", otherwise [tag_value].
#     install:
#       enabled: true | false # (Optional) Create AWS-ConfigureAWSPackage association to install AmazonCloudWatchAgent. Default: true.
#       document_name: "AWS-ConfigureAWSPackage" # (Optional) SSM document used to install the package.
#       association_name: "name-cloudwatch-agent-install" # (Optional) Custom installation association name.
#       action: "Install" # (Optional) AWS-ConfigureAWSPackage action. Valid values include Install and Uninstall.
#       package_name: "AmazonCloudWatchAgent" # (Optional) Package name to install.
#       version: "latest" # (Optional) Package version.
#       parameters: {} # (Optional) Extra or overriding SSM document parameters.
#     configure:
#       enabled: true | false # (Optional) Store an agent config in SSM Parameter Store and run AmazonCloudWatch-ManageAgent. Default: false.
#       document_name: "AmazonCloudWatch-ManageAgent" # (Optional) SSM document used to configure/start the agent.
#       association_name: "name-cloudwatch-agent-config" # (Optional) Custom configuration association name.
#       parameter_name: "AmazonCloudWatch-name-agent-config" # (Optional) SSM parameter name for the agent JSON config. Default starts with AmazonCloudWatch-.
#       config: {} # (Optional) Agent configuration object encoded as JSON when config_json is unset.
#       config_json: "{}" # (Optional) Pre-rendered CloudWatch agent JSON configuration.
#       action: "configure" # (Optional) AmazonCloudWatch-ManageAgent action.
#       mode: "ec2" # (Optional) AmazonCloudWatch-ManageAgent mode. Common value: ec2.
#       source: "ssm" # (Optional) Configuration source. Common value: ssm.
#       restart: "yes" # (Optional) Restart the agent after configuration. Valid values: yes or no.
#       attach_parameter_policy: true | false # (Optional) Attach least-privilege SSM parameter read policy when iam.create=true. Default: true.
#       parameters: {} # (Optional) Extra or overriding SSM document parameters.
#     workload_detection:
#       enabled: true | false # (Optional) Add opt-in workload detection tags for CloudWatch tag-based deployment. Default: false.
#       tag_key: "CloudWatchWorkloadDetection" # (Optional) Workload detection opt-in tag key.
#       tag_value: "enabled" # (Optional) Workload detection opt-in tag value.
#   backup:
#     enabled: true | false # defaults to false
#     only_tag: true | false # defaults to true
#     schedule_tag: hourly | daily | weekly | monthly # defaults to daily
#     backup_vault_name: "backup-vault-name" # Required only_tag is false
variable "instance" {
  description = "The instance type to use for the EC2 Instance"
  type        = any
  default     = {}

  validation {
    condition = (
      coalesce(try(var.instance.metadata_options.http_endpoint, null), "enabled") == "enabled"
      || coalesce(try(var.instance.metadata_options.http_endpoint, null), "enabled") == "disabled"
    )
    error_message = "instance.metadata_options.http_endpoint must be either \"enabled\" or \"disabled\" when provided."
  }

  validation {
    condition     = coalesce(try(var.instance.metadata_options.http_tokens, null), "required") == "required"
    error_message = "instance.metadata_options.http_tokens is enforced as \"required\" for IMDSv2; omit it or set it to \"required\"."
  }

  validation {
    condition = (
      try(var.instance.metadata_options.http_put_response_hop_limit == null, true)
      || try(
        var.instance.metadata_options.http_put_response_hop_limit >= 1
        && var.instance.metadata_options.http_put_response_hop_limit <= 64,
        false
      )
    )
    error_message = "instance.metadata_options.http_put_response_hop_limit must be null or a value from 1 through 64."
  }

  validation {
    condition = (
      coalesce(try(var.instance.metadata_options.instance_metadata_tags, null), "disabled") == "enabled"
      || coalesce(try(var.instance.metadata_options.instance_metadata_tags, null), "disabled") == "disabled"
    )
    error_message = "instance.metadata_options.instance_metadata_tags must be either \"enabled\" or \"disabled\" when provided."
  }

  validation {
    condition = (
      try(trimspace(var.instance.network_interface.network_interface_id), "") == ""
      || (
        !try(var.instance.network_interface.create, false)
        && !try(var.instance.create_spot, false)
        && !try(var.instance.security_group.create, false)
        && try(var.instance.vpc.subnet_id, null) == null
        && try(var.instance.vpc.private_ip, null) == null
        && length(coalesce(try(var.instance.vpc.secondary_private_ips, null), [])) == 0
        && length(coalesce(try(var.instance.vpc.security_group_ids, null), [])) == 0
        && try(var.instance.vpc.associate_public_ip_address, null) == null
        && try(var.instance.vpc.ipv6_address_count, null) == null
        && length(coalesce(try(var.instance.vpc.ipv6_addresses, null), [])) == 0
        && try(var.instance.vpc.public_eip_id == null || var.instance.vpc.public_eip_id == "", true)
        && try(var.instance.source_dest_check, null) == null
      )
    )
    error_message = "When instance.network_interface.network_interface_id is set for an existing primary ENI, do not set create_spot, security_group.create, source_dest_check, or top-level instance.vpc networking fields such as subnet_id, private_ip, security_group_ids, public IP, EIP, or IPv6 options."
  }

  validation {
    condition = (
      !try(var.instance.network_interface.create, false)
      || (
        !try(var.instance.create_spot, false)
        && try(var.instance.network_interface.subnet_id, null) != null
        && try(var.instance.network_interface.network_interface_id, null) == null
        && try(var.instance.vpc.subnet_id, null) == null
        && try(var.instance.vpc.private_ip, null) == null
        && length(coalesce(try(var.instance.vpc.secondary_private_ips, null), [])) == 0
        && try(var.instance.vpc.associate_public_ip_address, null) == null
        && try(var.instance.vpc.ipv6_address_count, null) == null
        && length(coalesce(try(var.instance.vpc.ipv6_addresses, null), [])) == 0
      )
    )
    error_message = "When instance.network_interface.create=true, set instance.network_interface.subnet_id and do not set create_spot, network_interface_id, or top-level instance.vpc launch fields such as subnet_id, private_ip, public IP, or IPv6 options. Use network_interface.private_ips for static private IPv4 addresses."
  }

  validation {
    condition = (
      try(var.instance.cloudwatch_agent.target.key, null) == null
      || try(var.instance.cloudwatch_agent.target.key == "InstanceIds", false)
      || try(startswith(var.instance.cloudwatch_agent.target.key, "tag:"), false)
    )
    error_message = "instance.cloudwatch_agent.target.key must be \"InstanceIds\" or \"tag:<TagKey>\" when provided."
  }

  validation {
    condition = (
      try(var.instance.cloudwatch_agent.configure.restart, null) == null
      || try(contains(["yes", "no"], var.instance.cloudwatch_agent.configure.restart), false)
    )
    error_message = "instance.cloudwatch_agent.configure.restart must be \"yes\" or \"no\" when provided."
  }
}

variable "timeouts" {
  description = "The timeouts of the EC2 Instance"
  type        = any
  default     = {}
}

#   iam:
#     create: true | false # defaults to false
#     instance_profile: "instance-profile" # defaults to null
#     ssm_enabled: true | false # defaults to true; attaches AmazonSSMManagedInstanceCore to the created IAM role
variable "iam" {
  description = "The IAM role to use for the EC2 Instance"
  type        = any
  default     = {}
}
