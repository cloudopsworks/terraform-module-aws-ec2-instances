##
# (c) 2021-2025
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
#     # Required if crate is true
#     subnet_id: "subnet-id" # defaults to null
#     private_ips: ["private-ip"] # defaults to null
#     # Optionals if create is false
#     delete_on_termination: true | false # defaults to null
#     network_interface_id: "eni-id" # defaults to null
#   root_block_device:
#     volume_size: 8 # defaults to null
#     volume_type: "gp3" # defaults to null
#     iops: 3000 # defaults to null
#     throughput: 125 # defaults to null
#     encrypted: true | false # defaults to null
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
#   ephemeral_block_device:
#     - device_name: "/dev/sdh"
#       virtual_name: "ephemeral0"
#       no_device: true
#   metadata_options:
#     http_endpoint: "enabled" | "disabled" # defaults to "enabled"
#     http_tokens: "required" | "optional" # defaults to "optional"
#     http_put_response_hop_limit: 1 # defaults to null
#     instance_metadata_tags: "enabled" | "disabled" # defaults to "enabled"
#   placement_group: "placement-group" # defaults to null
#   tenancy: "default" | "dedicated" # defaults to null
#   backup:
#     enabled: true | false # defaults to false
#     only_tag: true | false # defaults to true
#     schedule_tag: hourly | daily | weekly | monthly # defaults to daily
#     backup_vault_name: "backup-vault-name" # Required only_tag is false
variable "instance" {
  description = "The instance type to use for the EC2 Instance"
  type        = any
  default     = {}
}

variable "timeouts" {
  description = "The timeouts of the EC2 Instance"
  type        = any
  default     = {}
}

#   iam:
#     create: true | false # defaults to false
#     instance_profile: "instance-profile" # defaults to null
variable "iam" {
  description = "The IAM role to use for the EC2 Instance"
  type        = any
  default     = {}
}