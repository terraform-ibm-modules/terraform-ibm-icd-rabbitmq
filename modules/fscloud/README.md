# Profile for IBM Cloud Framework for Financial Services

This code is a version of the [parent root module](../../) that includes a default configuration that complies with the relevant controls from the [IBM Cloud Framework for Financial Services](https://cloud.ibm.com/docs/framework-financial-services?topic=framework-financial-services-about). See the [Example for IBM Cloud Framework for Financial Services](/examples/fscloud/) for logic that uses this module.

:exclamation: **Exception:** The Databases for RabbitMQ service is not yet Financial services validated. Therefore, the infrastructure that is deployed by this module is also not validated with the Framework for Financial Services. For more information, see the list of [Financial Services Validated services](https://cloud.ibm.com/docs/framework-financial-services?topic=framework-financial-services-vpc-architecture-about#financial-services-validated-services).

The default values in this profile were scanned by [IBM Code Risk Analyzer (CRA)](https://cloud.ibm.com/docs/code-risk-analyzer-cli-plugin?topic=code-risk-analyzer-cli-plugin-cra-cli-plugin#terraform-command) for compliance with the IBM Cloud Framework for Financial Services profile that is specified by the IBM Security and Compliance Center.

The IBM Cloud Framework for Financial Services mandates the application of an inbound network-based allowlist in front of the IBM Cloud Databases for (ICD) RabbitMQ instance. You can comply with this requirement by using the `cbr_rules` variable in the module, which can be used to create a narrow context-based restriction rule that is scoped to the RabbitMQ instance.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.79.2, <2.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rabbitmq_database"></a> [rabbitmq\_database](#module\_rabbitmq\_database) | ../../ | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | A list of access tags to apply to the rabbitmq instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details | `list(string)` | `[]` | no |
| <a name="input_admin_pass"></a> [admin\_pass](#input\_admin\_pass) | The password for the database administrator. If the admin password is null then the admin user ID cannot be accessed. More users can be specified in a user block. | `string` | `null` | no |
| <a name="input_auto_scaling"></a> [auto\_scaling](#input\_auto\_scaling) | Optional rules to allow the database to increase resources in response to usage. Only a single autoscaling block is allowed. Make sure you understand the effects of autoscaling, especially for production environments. See https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-autoscaling in the IBM Cloud Docs. | <pre>object({<br/>    disk = object({<br/>      capacity_enabled             = optional(bool, false)<br/>      free_space_less_than_percent = optional(number, 10)<br/>      io_above_percent             = optional(number, 90)<br/>      io_enabled                   = optional(bool, false)<br/>      io_over_period               = optional(string, "15m")<br/>      rate_increase_percent        = optional(number, 10)<br/>      rate_limit_mb_per_member     = optional(number, 3670016)<br/>      rate_period_seconds          = optional(number, 900)<br/>      rate_units                   = optional(string, "mb")<br/>    })<br/>    memory = object({<br/>      io_above_percent         = optional(number, 90)<br/>      io_enabled               = optional(bool, false)<br/>      io_over_period           = optional(string, "15m")<br/>      rate_increase_percent    = optional(number, 10)<br/>      rate_limit_mb_per_member = optional(number, 114688)<br/>      rate_period_seconds      = optional(number, 900)<br/>      rate_units               = optional(string, "mb")<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_backup_crn"></a> [backup\_crn](#input\_backup\_crn) | The CRN of a backup resource to restore from. The backup is created by a database deployment with the same service ID. The backup is loaded after provisioning and the new deployment starts up that uses that data. A backup CRN is in the format crn:v1:<…>:backup:. If omitted, the database is provisioned empty. | `string` | `null` | no |
| <a name="input_backup_encryption_key_crn"></a> [backup\_encryption\_key\_crn](#input\_backup\_encryption\_key\_crn) | The CRN of a Key Protect or Hyper Protect Crypto Services encryption key that you want to use for encrypting the disk that holds deployment backups. Applies only if `use_ibm_owned_encryption_key` is false and `use_same_kms_key_for_backups` is false. If no value is passed, and `use_same_kms_key_for_backups` is true, the value of `kms_key_crn` is used. Alternatively set `use_default_backup_encryption_key` to true to use the IBM Cloud Databases default encryption. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups). | `string` | `null` | no |
| <a name="input_cbr_rules"></a> [cbr\_rules](#input\_cbr\_rules) | (Optional, list) List of CBR rules to create | <pre>list(object({<br/>    description = string<br/>    account_id  = string<br/>    rule_contexts = list(object({<br/>      attributes = optional(list(object({<br/>        name  = string<br/>        value = string<br/>    }))) }))<br/>    enforcement_mode = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | Allocated dedicated CPU per member. For shared CPU, set to 0. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling) | `number` | `0` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Enable deletion protection within terraform. This is not a property of the resource and does not prevent deletion outside of terraform. The database can not be deleted by terraform when this value is set to 'true'. In order to delete with terraform the value must be set to 'false' and a terraform apply performed before the destroy is performed. The default is 'true'. | `bool` | `true` | no |
| <a name="input_disk_mb"></a> [disk\_mb](#input\_disk\_mb) | Allocated disk per member. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling) | `number` | `1024` | no |
| <a name="input_kms_key_crn"></a> [kms\_key\_crn](#input\_kms\_key\_crn) | The CRN of a Key Protect or Hyper Protect Crypto Services encryption key to encrypt your data. Applies only if `use_ibm_owned_encryption_key` is false. By default this key is used for both deployment data and backups, but this behaviour can be altered using the `use_same_kms_key_for_backups` and `backup_encryption_key_crn` inputs. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups). | `string` | `null` | no |
| <a name="input_member_host_flavor"></a> [member\_host\_flavor](#input\_member\_host\_flavor) | Allocated host flavor per member. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database#host_flavor). | `string` | `null` | no |
| <a name="input_members"></a> [members](#input\_members) | Allocated number of members. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling) | `number` | `3` | no |
| <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb) | Allocated memory per member. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling). | `number` | `8192` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the RabbitMQ instance | `string` | n/a | yes |
| <a name="input_rabbitmq_version"></a> [rabbitmq\_version](#input\_rabbitmq\_version) | The version of RabbitMQ to deploy. If no value passed, the current ICD preferred version is used. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where you want to deploy your instance. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group ID where the RabbitMQ instance will be created. | `string` | n/a | yes |
| <a name="input_service_credential_names"></a> [service\_credential\_names](#input\_service\_credential\_names) | Map of name, role for service credentials that you want to create for the database | `map(string)` | `{}` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of IAM authorization policies that permits all Databases for RabbitMQ instances in the given resource group 'Reader' access to the Key Protect or Hyper Protect Crypto Services key that was provided in the `kms_key_crn` and `backup_encryption_key_crn` inputs. This policy is required in order to enable KMS encryption, so only skip creation if there is one already present in your account. No policy is created if `use_ibm_owned_encryption_key` is true. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional list of tags to be added to the RabbitMQ instance. | `list(string)` | `[]` | no |
| <a name="input_timeouts_update"></a> [timeouts\_update](#input\_timeouts\_update) | A database update may require a longer timeout for the update to complete. The default is 120 minutes. Set this variable to change the `update` value in the `timeouts` block. [Learn more](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts). | `string` | `"120m"` | no |
| <a name="input_use_default_backup_encryption_key"></a> [use\_default\_backup\_encryption\_key](#input\_use\_default\_backup\_encryption\_key) | When `use_ibm_owned_encryption_key` is set to false, backups will be encrypted with either the key specified in `kms_key_crn`, or in `backup_encryption_key_crn` if a value is passed. If you do not want to use your own key for backups encryption, you can set this to `true` to use the IBM Cloud Databases default encryption for backups. Alternatively set `use_ibm_owned_encryption_key` to true to use the default encryption for both backups and deployment data. | `bool` | `false` | no |
| <a name="input_use_ibm_owned_encryption_key"></a> [use\_ibm\_owned\_encryption\_key](#input\_use\_ibm\_owned\_encryption\_key) | Set to true to use the default IBM Cloud® Databases randomly generated keys for disk and backups encryption. To control the encryption keys, use the `kms_key_crn` and `backup_encryption_key_crn` inputs. | `string` | `false` | no |
| <a name="input_use_same_kms_key_for_backups"></a> [use\_same\_kms\_key\_for\_backups](#input\_use\_same\_kms\_key\_for\_backups) | Set this to false if you wan't to use a different key that you own to encrypt backups. When set to false, a value is required for the `backup_encryption_key_crn` input. Alternatiely set `use_default_backup_encryption_key` to true to use the IBM Cloud Databases default encryption. Applies only if `use_ibm_owned_encryption_key` is false. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups). | `bool` | `true` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of users that you want to create on the database. Multiple blocks are allowed. The user password must be in the range of 10-32 characters. Be warned that in most case using IAM service credentials (via the var.service\_credential\_names) is sufficient to control access to the RabbitMQ instance. This blocks creates native RabbitMQ database users, more info on that can be found here https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-user-management | <pre>list(object({<br/>    name     = string<br/>    password = string # pragma: allowlist secret<br/>    type     = optional(string)<br/>    role     = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_version_upgrade_skip_backup"></a> [version\_upgrade\_skip\_backup](#input\_version\_upgrade\_skip\_backup) | Whether to skip taking a backup before upgrading the database version. Attention: Skipping a backup is not recommended. Skipping a backup before a version upgrade is dangerous and may result in data loss if the upgrade fails at any stage — there will be no immediate backup to restore from. | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_adminuser"></a> [adminuser](#output\_adminuser) | Database admin user name |
| <a name="output_cbr_rule_ids"></a> [cbr\_rule\_ids](#output\_cbr\_rule\_ids) | CBR rule ids created to restrict RabbitMQ |
| <a name="output_certificate_base64"></a> [certificate\_base64](#output\_certificate\_base64) | Database connection certificate |
| <a name="output_crn"></a> [crn](#output\_crn) | RabbitMQ instance crn |
| <a name="output_guid"></a> [guid](#output\_guid) | RabbitMQ instance guid |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Database connection hostname |
| <a name="output_id"></a> [id](#output\_id) | RabbitMQ instance id |
| <a name="output_port"></a> [port](#output\_port) | Database connection port |
| <a name="output_service_credentials_json"></a> [service\_credentials\_json](#output\_service\_credentials\_json) | Service credentials json map |
| <a name="output_service_credentials_object"></a> [service\_credentials\_object](#output\_service\_credentials\_object) | Service credentials object |
| <a name="output_version"></a> [version](#output\_version) | RabbitMQ instance version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
