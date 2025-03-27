##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
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
#     id: "ami-id" # (optional) if stated ami.name will be ignored
#     most_recent: true | false # defaults to True
#     owners: ["self"] # defaults to ["self"]
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
#   ebs:
#     ebs_optimized: true | false # defaults to null
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