##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_spot_instance_request" "spot" {
  count                       = try(var.instance.create, true) && !try(var.instance.ignore_ami_changes, false) && try(var.instance.create_spot, false) ? 1 : 0
  ami                         = try(data.aws_ami.this[0].id, var.instance.ami.id, null)
  instance_type               = var.instance.type
  hibernation                 = try(var.instance.hibernation, null)
  user_data                   = try(var.instance.user_data, null)
  user_data_base64            = try(var.instance.user_data_base64, null)
  user_data_replace_on_change = try(var.instance.user_data_replace_on_change, null)
  key_name                    = try(var.instance.key_pair.create, false) ? aws_key_pair.this[0].key_name : try(var.instance.key_pair.name, null)
  monitoring                  = try(var.instance.monitoring, null)
  get_password_data           = try(var.instance.get_password_data, null)
  iam_instance_profile        = try(var.iam.create, true) ? aws_iam_instance_profile.this[0].name : try(var.iam.instance_profile, null)
  dynamic "cpu_options" {
    for_each = length(try(var.instance.cpu_options, {})) > 0 ? [var.instance.cpu_options] : []
    content {
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
      amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null)
    }
  }
  availability_zone           = try(var.instance.availability_zone, null)
  vpc_security_group_ids      = try(var.instance.security_group.create, false) ? concat([aws_security_group.this[0].id], try(var.instance.vpc.security_group_ids, [])) : try(var.instance.vpc.security_group_ids, null)
  associate_public_ip_address = try(var.instance.vpc.associate_public_ip_address, null)
  subnet_id                   = try(var.instance.vpc.subnet_id, null)
  private_ip                  = try(var.instance.vpc.private_ip, null)
  secondary_private_ips       = try(var.instance.vpc.secondary_private_ips, null)
  ipv6_address_count          = try(var.instance.vpc.ipv6_address_count, null)
  ipv6_addresses              = try(var.instance.vpc.ipv6_addresses, null)
  ebs_optimized               = try(var.instance.ebs.ebs_optimized, null)
  # SPOT
  spot_price                     = try(var.instance.spot.price, null)
  spot_type                      = try(var.instance.spot.type, null)
  wait_for_fulfillment           = try(var.instance.spot.wait_for_fulfillment, null)
  launch_group                   = try(var.instance.spot.launch_group, null)
  block_duration_minutes         = try(var.instance.spot.block_duration_minutes, null)
  instance_interruption_behavior = try(var.instance.spot.instance_interruption_behavior, null)
  valid_until                    = try(var.instance.spot.valid_until, null)
  valid_from                     = try(var.instance.spot.valid_from, null)
  # SPOT
  dynamic "root_block_device" {
    for_each = try(var.instance.root_block_device, [])
    content {
      delete_on_termination = try(root_block_device.value.delete_on_termination, null)
      encrypted             = try(root_block_device.value.encrypted, null)
      iops                  = try(root_block_device.value.iops, null)
      kms_key_id            = try(root_block_device.value.kms_key_id, null)
      volume_size           = try(root_block_device.value.volume_size, null)
      volume_type           = try(root_block_device.value.volume_type, null)
      throughput            = try(root_block_device.value.throughput, null)
      tags                  = try(root_block_device.value.tags, null)
    }
  }
  dynamic "ebs_block_device" {
    for_each = try(var.instance.ebs.block_device, [])
    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, null)
      iops                  = try(ebs_block_device.value.iops, null)
      kms_key_id            = try(ebs_block_device.value.kms_key_id, null)
      snapshot_id           = try(ebs_block_device.value.snapshot_id, null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
    }
  }
  dynamic "metadata_options" {
    for_each = length(try(var.instance.metadata_options, {})) > 0 ? [var.instance.metadata_options] : []
    content {
      http_endpoint               = try(metadata_options.value.http_endpoint, null)
      http_put_response_hop_limit = try(metadata_options.value.http_put_response_hop_limit, null)
      http_tokens                 = try(metadata_options.value.http_tokens, null)
      instance_metadata_tags      = try(metadata_options.value.instance_metadata_tags, null)
    }
  }
  dynamic "network_interface" {
    for_each = try(var.instance.network_interface, [])
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = try(network_interface.value.network_interface_id, null)
      delete_on_termination = try(network_interface.value.delete_on_termination, true)
    }
  }
  dynamic "ephemeral_block_device" {
    for_each = try(var.instance.ephemeral_block_device, [])
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = try(ephemeral_block_device.value.no_device, null)
      virtual_name = try(ephemeral_block_device.value.virtual_name, null)
    }
  }
  dynamic "private_dns_name_options" {
    for_each = length(try(var.instance.private_dns_name_options, {})) > 0 ? [var.instance.private_dns_name_options] : []
    content {
      hostname_type                        = try(private_dns_name_options.value.hostname_type, null)
      enable_resource_name_dns_a_record    = try(private_dns_name_options.value.enable_resource_name_dns_a_record, null)
      enable_resource_name_dns_aaaa_record = try(private_dns_name_options.value.enable_resource_name_dns_aaaa_record, null)
    }
  }
  dynamic "maintenance_options" {
    for_each = length(try(var.instance.maintenance_options, {})) > 0 ? [var.instance.maintenance_options] : []
    content {
      auto_recovery = try(maintenance_options.value.auto_recovery, null)
    }
  }
  enclave_options {
    enabled = try(var.instance.enclave_options.enabled, null)
  }
  credit_specification {
    cpu_credits = local.is_t_instance_type ? try(var.instance.cpu_credits, null) : null
  }
  dynamic "capacity_reservation_specification" {
    for_each = length(try(var.instance.capacity_reservation_specification, {})) > 0 ? [var.instance.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)
      dynamic "capacity_reservation_target" {
        for_each = try([capacity_reservation_specification.value.capacity_reservation_target], [])
        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }
  source_dest_check                    = try(var.instance.source_dest_check, null)
  disable_api_termination              = try(var.instance.disable_api_termination, null)
  disable_api_stop                     = try(var.instance.disable_api_stop, null)
  instance_initiated_shutdown_behavior = try(var.instance.instance_initiated_shutdown_behavior, null)
  placement_group                      = try(var.instance.placement_group, null)
  tenancy                              = try(var.instance.tenancy, null)
  host_id                              = try(var.instance.host_id, null)
  tags = merge(
    local.all_tags,
    local.backup_tags,
    try(var.instance.extra_tags, {}),
    {
      Name = local.name
    }
  )
  volume_tags = merge(
    local.all_tags,
    local.backup_tags,
    try(var.instance.volume_extra_tags, {}),
    {
      Name = local.name
    }
  )
  timeouts {
    create = try(var.timeouts.create, null)
    delete = try(var.timeouts.delete, null)
  }
}