<!-- 
  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  -->
[![README Header][readme_header_img]][readme_header_link]

[![cloudopsworks][logo]](https://cloudops.works/)

# Terraform AWS EC2 Instance


This Terraform module simplifies provisioning and managing Amazon EC2 instances in AWS. 
It allows you to define configurations such as instance types, VPC subnets, security groups, 
and more. By encapsulating all essential settings and optional features, the module helps 
ensure that your EC2 infrastructure remains consistent, reproducible, and version-controlled.


---

This project is part of our comprehensive approach towards DevOps Acceleration. 
[<img align="right" title="Share via Email" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/ios-mail.svg"/>][share_email]
[<img align="right" title="Share on Google+" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-googleplus.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-facebook.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-reddit.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-linkedin.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" width="24" height="24" src="https://docs.cloudops.works/images/ionicons/logo-twitter.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudops.works/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We have [*lots of terraform modules*][terraform_modules] that are Open Source and we are trying to get them well-maintained!. Check them out!






## Introduction

The Terraform AWS EC2 Instance module is designed to provide an easy way to manage and 
scale virtual machines within the AWS ecosystem. Whether you need to provision single or 
multiple EC2 instances, this module offers an opinionated yet flexible approach that 
streamlines the process of creating, configuring, and maintaining your infrastructure.

By leveraging the features of Terraform, you can control changes to your EC2 instances 
through code, facilitate audit trails, and eliminate the need for manual configuration. 
This module is a specific solution aimed at making it straightforward for teams to define 
and deploy EC2-based workloads in AWS with minimal overhead.

## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=vX.Y.Z`) of one of our [latest releases](https://github.com/cloudopsworks/terraform-module-aws-ec2-instances/releases).


To incorporate this module, reference it with Terragrunt while following the structure of the .boilerplate templates in the "develop" branch of this repository.

Basic steps to use the module:
1. Install Terraform (v1.0 or higher) and Terragrunt.
2. Create or update your Terragrunt configuration files using the .boilerplate patterns.
3. Provide required variables (AWS region, AMI IDs, instance types, etc.).
4. Run terragrunt init to initialize your working directory.
5. Run terragrunt plan to view resource changes.
6. Run terragrunt apply to create the resources.

Available Variables:

name: (string, optional)
  - The name of the EC2 Instance
  - Default: ""

name_prefix: (string, optional)
  - The name prefix of the EC2 Instance
  - Default: ""

instance: (map, optional)
  Complex configuration for EC2 instance. Supports following structure:
  ```yaml
  instance:
    create: true | false     # defaults to True
    create_spot: true | false # defaults to False
    dedicated_host: true | false # defaults to False
    ignore_ami_changes: true | false # defaults to False
    ami:
      name: "ami-name" # optional
      architecture: "x86_64" | "arm64" # defaults to "x86_64"
      id: "ami-id" # optional
      most_recent: true | false # defaults to True
      owners: ["self"] # defaults to ["self"]
      filters: []
    type: "t2.micro" # defaults to "t2.micro"
    hibernation: true | false # defaults to null
    user_data: "user-data" # defaults to null
    user_data_base64: "user-data-base64" # defaults to null
    user_data_replace_on_change: true | false # defaults to null
    cpu_options:
      core_count: 1 # defaults to null
      threads_per_core: 1 # defaults to null
      amd_sev_snp: true | false # defaults to null
    availability_zone: "us-east-1a" # defaults to null
    key_name: "key-name" # defaults to null
    monitoring: true | false # defaults to null
    get_password_data: true | false # defaults to null
    vpc:
      security_group_ids: ["sg-12345678"] # defaults to null
      associate_public_ip_address: true | false # defaults to null
      subnet_id: "subnet-id" # defaults to null
      private_ip: "private-ip" # defaults to null
      secondary_private_ips: ["secondary-private-ip"] # defaults to null
      ipv6_address_count: 1 # defaults to null
      ipv6_addresses: ["ipv6-address"] # defaults to null
    ebs:
      ebs_optimized: true | false # defaults to null
    backup:
      enabled: true | false # defaults to false
      only_tag: true | false # defaults to true
      schedule_tag: hourly | daily | weekly | monthly # defaults to daily
      backup_vault_name: "backup-vault-name" # Required if only_tag is false
  ```

timeouts: (map, optional)
  - The timeouts configuration for the EC2 Instance
  - Default: {}

iam: (map, optional)
  IAM configuration with following structure:
  ```yaml
  iam:
    create: true | false # defaults to false
    instance_profile: "instance-profile" # defaults to null
  ```

Example of a Terragrunt configuration referencing this module (terragrunt.hcl):
```hcl
terraform {
  source = "git::https://github.com/cloudopsworks/terraform-module-aws-ec2-instances.git//?ref=develop"
}

inputs = {
  name = "my-instance"
  instance = {
    create = true
    type = "t2.micro"
    ami = {
      name = "my-custom-ami"
      owners = ["self"]
    }
    vpc = {
      subnet_id = "subnet-123456"
      security_group_ids = ["sg-123456"]
    }
  }
  iam = {
    create = true
    instance_profile = "my-profile"
  }
}
```

## Quick Start

1. Clone or fork the repository to review the .boilerplate templates under the "develop" branch.
2. Adapt the relevant Terragrunt configuration files for your own environment by referencing this module.
3. Initialize your workspace using terragrunt init.
4. Review proposed infrastructure changes by running terragrunt plan.
5. Finally, configure and deploy your EC2 instances with terragrunt apply.


## Examples

Here are sample use cases you can adapt in the .boilerplate files on the "develop" branch:

1. Single Development Instance
   - Combine this module with minimal settings to spin up a small instance for dev/testing.

2. Multi-Instance Setup
   - Leverage the instance_count variable to manage auto-scaling scenarios or replicate standardized instances in multiple environments.

3. Private Subnet Deployment
   - Apply advanced networking configurations using Terragrunt's environment-based structure, automatically enforcing best practices established in boilerplate templates.

For more Terragrunt-based examples and structural hints, see the .boilerplate directory in the "develop" branch.



## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform/opentofu code
  tag                                 Tag the current version

```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_host.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_host) | resource |
| [aws_ec2_tag.spot_instance_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.ami_ignore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_spot_instance_request.spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_iam"></a> [iam](#input\_iam) | The IAM role to use for the EC2 Instance | `any` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | The instance type to use for the EC2 Instance | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the EC2 Instance | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix of the EC2 Instance | `string` | `""` | no |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | The timeouts of the EC2 Instance | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dedicated_host_arn"></a> [dedicated\_host\_arn](#output\_dedicated\_host\_arn) | n/a |
| <a name="output_dedicated_host_id"></a> [dedicated\_host\_id](#output\_dedicated\_host\_id) | n/a |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | n/a |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_key_pair_name"></a> [key\_pair\_name](#output\_key\_pair\_name) | n/a |
| <a name="output_key_pair_public_key"></a> [key\_pair\_public\_key](#output\_key\_pair\_public\_key) | n/a |
| <a name="output_key_pair_ssh_private_key"></a> [key\_pair\_ssh\_private\_key](#output\_key\_pair\_ssh\_private\_key) | n/a |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |
| <a name="output_state"></a> [state](#output\_state) | n/a |



## Help

**Got a question?** We got answers. 

File a GitHub [issue](https://github.com/cloudopsworks/terraform-module-aws-ec2-instances/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Tools

## Slack Community


## Newsletter

## Office Hours

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudopsworks/terraform-module-aws-ec2-instances/issues) to report any bugs or file feature requests.

### Developing




## Copyrights

Copyright © 2024-2025 [Cloud Ops Works LLC](https://cloudops.works)





## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained by [Cloud Ops Works LLC][website]. 


### Contributors

|  [![Cristian Beraha][berahac_avatar]][berahac_homepage]<br/>[Cristian Beraha][berahac_homepage] |
|---|

  [berahac_homepage]: https://github.com/berahac
  [berahac_avatar]: https://github.com/berahac.png?size=50

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudops.works/logo-300x69.svg
  [docs]: https://cowk.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=docs
  [website]: https://cowk.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=website
  [github]: https://cowk.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=github
  [jobs]: https://cowk.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=jobs
  [hire]: https://cowk.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=hire
  [slack]: https://cowk.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=slack
  [linkedin]: https://cowk.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=linkedin
  [twitter]: https://cowk.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=twitter
  [testimonial]: https://cowk.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=testimonial
  [office_hours]: https://cloudops.works/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=office_hours
  [newsletter]: https://cowk.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=newsletter
  [email]: https://cowk.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=email
  [commercial_support]: https://cowk.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=commercial_support
  [we_love_open_source]: https://cowk.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=we_love_open_source
  [terraform_modules]: https://cowk.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=terraform_modules
  [readme_header_img]: https://cloudops.works/readme/header/img
  [readme_header_link]: https://cloudops.works/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=readme_header_link
  [readme_footer_img]: https://cloudops.works/readme/footer/img
  [readme_footer_link]: https://cloudops.works/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudops.works/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudops.works/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudopsworks/terraform-module-aws-ec2-instances&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=Terraform+AWS+EC2+Instance&url=https://github.com/cloudopsworks/terraform-module-aws-ec2-instances
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+EC2+Instance&url=https://github.com/cloudopsworks/terraform-module-aws-ec2-instances
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudopsworks/terraform-module-aws-ec2-instances
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudopsworks/terraform-module-aws-ec2-instances
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudopsworks/terraform-module-aws-ec2-instances
  [share_email]: mailto:?subject=Terraform+AWS+EC2+Instance&body=https://github.com/cloudopsworks/terraform-module-aws-ec2-instances
  [beacon]: https://ga-beacon.cloudops.works/G-7XWMFVFXZT/cloudopsworks/terraform-module-aws-ec2-instances?pixel&cs=github&cm=readme&an=terraform-module-aws-ec2-instances
