##############################################################################
# Input Variables
##############################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key to deploy resources."
  sensitive   = true
}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision the resources. If not provided the default resource group will be used."
  default     = null
}

variable "prefix" {
  type        = string
  nullable    = true
  description = "The prefix to be added to all resources created by this solution. To skip using a prefix, set this value to null or an empty string. The prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It should not exceed 16 characters, must not end with a hyphen('-'), and can not contain consecutive hyphens ('--'). Example: prod-0205-cos. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."

  validation {
    # - null and empty string is allowed
    # - Must not contain consecutive hyphens (--): length(regexall("--", var.prefix)) == 0
    # - Starts with a lowercase letter: [a-z]
    # - Contains only lowercase letters (a–z), digits (0–9), and hyphens (-)
    # - Must not end with a hyphen (-): [a-z0-9]
    condition = (var.prefix == null || var.prefix == "" ? true :
      alltrue([
        can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.prefix)),
        length(regexall("--", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--')."
  }

  validation {
    # must not exceed 16 characters in length
    condition     = var.prefix == null || var.prefix == "" ? true : length(var.prefix) <= 16
    error_message = "Prefix must not exceed 16 characters."
  }
}

variable "name" {
  type        = string
  description = "The name of the Messages for RabbitMQ instance. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "rabbitmq"
}

variable "region" {
  description = "The region to provision all resources in. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/region) about how to select different regions for different services."
  type        = string
  default     = "us-south"

  validation {
    condition     = var.existing_rabbitmq_instance_crn != null && var.region != local.existing_rabbitmq_region ? false : true
    error_message = "The region detected in the 'existing_rabbitmq_instance_crn' value must match the value of the 'region' input variable when passing an existing instance."
  }
}

variable "existing_rabbitmq_instance_crn" {
  type        = string
  default     = null
  description = "The CRN of an existing Messages for RabbitMQ instance. If no value is specified, a new instance is created."
}

variable "rabbitmq_version" {
  description = "The version of the Messages for RabbitMQ instance."
  type        = string
  default     = null
}

##############################################################################
# ICD hosting model properties
##############################################################################

variable "service_endpoints" {
  type        = string
  description = "The type of endpoint of the database instance. Possible values: `public`, `private`, `public-and-private`."
  default     = "private"

  validation {
    condition     = can(regex("^(public|public-and-private|private)$", var.service_endpoints))
    error_message = "Valid values for service_endpoints are 'public', 'public-and-private', and 'private'"
  }
}

variable "members" {
  type        = number
  description = "The number of members that are allocated. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling)."
  default     = 3
}

variable "member_memory_mb" {
  type        = number
  description = "The memory per member that is allocated. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling)"
  default     = 8192
}

variable "member_cpu_count" {
  type        = number
  description = "The dedicated CPU per member that is allocated. For shared CPU, set to 0. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling)."
  default     = 0
}

variable "member_disk_mb" {
  type        = number
  description = "The disk that is allocated per member. [Learn more](https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling)."
  default     = 1024
}

variable "member_host_flavor" {
  type        = string
  description = "The host flavor per member. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database#host_flavor)."
  default     = "multitenant"
  # Prevent null or "", require multitenant or a machine type
  validation {
    condition     = (length(var.member_host_flavor) > 0)
    error_message = "Member host flavor must be specified. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database#host_flavor)."
  }
}

variable "configuration" {
  type = object({
    delete_undefined_queues = optional(bool)
  })
  description = "Messages for RabbitMQ configuration parameters, see https://cloud.ibm.com/docs/messages-for-rabbitmq for more details."
  default = {
    delete_undefined_queues = true
  }
}

variable "service_credential_names" {
  description = "Map of name, role for service credentials that you want to create for the database. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-icd-rabbitmq/blob/main/solutions/standard/DA-types.md#svc-credential-name)"
  type        = map(string)
  default     = {}
}

variable "admin_pass" {
  type        = string
  description = "The password for the database administrator. If no admin password is provided (i.e., it is null), one will be generated automatically. Additional users can be added using a user block."
  default     = null
  sensitive   = true
}

variable "users" {
  type = list(object({
    name     = string
    password = string # pragma: allowlist secret
    type     = string # "type" is required to generate the connection string for the outputs.
    role     = optional(string)
  }))
  default     = []
  sensitive   = true
  description = "A list of users that you want to create on the database. Users block is supported by RabbitMQ version >= 6.0. Multiple blocks are allowed. The user password must be in the range of 10-32 characters. Be warned that in most case using IAM service credentials (via the var.service_credential_names) is sufficient to control access to the RabbitMQ instance. This blocks creates native RabbitMQ database users. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-icd-rabbitmq/blob/main/solutions/standard/DA-types.md#users)"
}

variable "resource_tags" {
  type        = list(string)
  description = "The list of tags to be added to the Messages for RabbitMQ instance."
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the Messages for RabbitMQ instance created by the solution. [Learn more](https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial)."
  default     = []
}

variable "version_upgrade_skip_backup" {
  type        = bool
  description = "Whether to skip taking a backup before upgrading the database version. Attention: Skipping a backup is not recommended. Skipping a backup before a version upgrade is dangerous and may result in data loss if the upgrade fails at any stage — there will be no immediate backup to restore from."
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection within terraform. This is not a property of the resource and does not prevent deletion outside of terraform. The database can not be deleted by terraform when this value is set to 'true'. In order to delete with terraform the value must be set to 'false' and a terraform apply performed before the destroy is performed. The default is 'true'."
  default     = true
}

variable "timeouts_update" {
  type        = string
  description = "A database update may require a longer timeout for the update to complete. The default is 120 minutes. Set this variable to change the `update` value in the `timeouts` block. [Learn more](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts)."
  default     = "120m"
}

##############################################################
# Encryption
##############################################################

variable "kms_encryption_enabled" {
  type        = bool
  description = "Set to true to enable KMS encryption using customer-managed keys. When enabled, you must provide a value for at least one of the following: existing_kms_instance_crn, existing_kms_key_crn, or existing_backup_kms_key_crn. If set to false, IBM-owned encryption is used (i.e., encryption keys managed and held by IBM)."
  default     = false

  validation {
    condition = (!var.kms_encryption_enabled ||
      var.existing_rabbitmq_instance_crn != null ||
      var.existing_kms_instance_crn != null ||
      var.existing_kms_key_crn != null ||
      var.existing_backup_kms_key_crn != null
    )
    error_message = "When 'kms_encryption_enabled' is true, you must provide either 'existing_backup_kms_key_crn', 'existing_kms_instance_crn' (to create a new key) or 'existing_kms_key_crn' (to use an existing key)."
  }

  validation {
    condition     = (var.existing_kms_instance_crn == null && var.existing_kms_key_crn == null && var.existing_backup_kms_key_crn == null) || var.kms_encryption_enabled
    error_message = "When either 'existing_kms_instance_crn', 'existing_kms_key_crn' or 'existing_backup_kms_key_crn' is set then 'kms_encryption_enabled' must be set to true."
  }
}

variable "existing_kms_instance_crn" {
  type        = string
  description = "The CRN of a Key Protect or Hyper Protect Crypto Services instance. Required to create a new encryption key and key ring which will be used to encrypt both deployment data and backups. To use an existing key, pass values for `existing_kms_key_crn` and/or `existing_backup_kms_key_crn`. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups)."
  default     = null
}

variable "existing_kms_key_crn" {
  type        = string
  description = "The CRN of a Key Protect or Hyper Protect Crypto Services encryption key to encrypt your data. By default this key is used for both deployment data and backups, but this behaviour can be altered using the optional `existing_backup_kms_key_crn` input. If no value is passed a new key will be created in the instance specified in the `existing_kms_instance_crn` input. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups)."
  default     = null
}

variable "kms_endpoint_type" {
  type        = string
  description = "The type of endpoint to use for communicating with the Key Protect or Hyper Protect Crypto Services instance. Possible values: `public`, `private`. Applies only if `existing_kms_key_crn` is not specified."
  default     = "private"

  validation {
    condition     = can(regex("^(public|private)$", var.kms_endpoint_type))
    error_message = "The kms_endpoint_type value must be 'public' or 'private'."
  }
}

variable "skip_rabbitmq_kms_auth_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits all Messages for RabbitMQ instances in the resource group to read the encryption key from the Hyper Protect Crypto Services instance specified in the `existing_kms_instance_crn` variable."
  default     = false
}

variable "ibmcloud_kms_api_key" {
  type        = string
  description = "The IBM Cloud API key that can create a root key and key ring in the key management service (KMS) instance. If not specified, the 'ibmcloud_api_key' variable is used. Specify this key if the instance in `existing_kms_instance_crn` is in an account that's different from the RabbitMQ instance. Leave this input empty if the same account owns both instances."
  sensitive   = true
  default     = null
}

variable "key_ring_name" {
  type        = string
  default     = "rabbitmq-key-ring"
  description = "The name for the key ring created for the Messages for RabbitMQ key. Applies only if not specifying an existing key. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
}

variable "key_name" {
  type        = string
  default     = "rabbitmq-key"
  description = "The name for the key created for the Messages for RabbitMQ key. Applies only if not specifying an existing key. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
}

variable "existing_backup_kms_key_crn" {
  type        = string
  description = "The CRN of a Key Protect or Hyper Protect Crypto Services encryption key that you want to use for encrypting the disk that holds deployment backups. Applies only if `use_ibm_owned_encryption_key` is false. If no value is passed, the value of `existing_kms_key_crn` is used. If no value is passed for `existing_kms_key_crn`, a new key will be created in the instance specified in the `existing_kms_instance_crn` input. Alternatively set `use_default_backup_encryption_key` to true to use the IBM Cloud Databases default encryption. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups)."
  default     = null
}

variable "use_default_backup_encryption_key" {
  type        = bool
  description = "When `kms_encryption_enabled` is set to true, backups will be encrypted with either the key specified in `existing_kms_key_crn`, in `existing_backup_kms_key_crn`, or with a new key that will be created in the instance specified in the `existing_kms_instance_crn` input. If you do not want to use your own key for backups encryption, you can set this to `true` to use the IBM Cloud Databases default encryption for backups. Alternatively set `kms_encryption_enabled` to false to use the default encryption for both backups and deployment data."
  default     = false
}

variable "backup_crn" {
  type        = string
  description = "The CRN of a backup resource to restore from. The backup is created by a database deployment with the same service ID. The backup is loaded after provisioning and the new deployment starts up that uses that data. A backup CRN is in the format crn:v1:<…>:backup:. If omitted, the database is provisioned empty."
  default     = null

  validation {
    condition = anytrue([
      var.backup_crn == null,
      can(regex("^crn:.*:backup:", var.backup_crn))
    ])
    error_message = "backup_crn must be null OR starts with 'crn:' and contains ':backup:'"
  }
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}

##############################################################
# Auto Scaling
##############################################################

variable "auto_scaling" {
  type = object({
    disk = object({
      capacity_enabled             = optional(bool, false)
      free_space_less_than_percent = optional(number, 10)
      io_above_percent             = optional(number, 90)
      io_enabled                   = optional(bool, false)
      io_over_period               = optional(string, "15m")
      rate_increase_percent        = optional(number, 10)
      rate_limit_mb_per_member     = optional(number, 3670016)
      rate_period_seconds          = optional(number, 900)
      rate_units                   = optional(string, "mb")
    })
    memory = object({
      io_above_percent         = optional(number, 90)
      io_enabled               = optional(bool, false)
      io_over_period           = optional(string, "15m")
      rate_increase_percent    = optional(number, 10)
      rate_limit_mb_per_member = optional(number, 114688)
      rate_period_seconds      = optional(number, 900)
      rate_units               = optional(string, "mb")
    })
  })
  description = "Optional rules to allow the database to increase resources in response to usage. Only a single autoscaling block is allowed. Make sure you understand the effects of autoscaling, especially for production environments. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-icd-rabbitmq/blob/main/solutions/standard/DA-types.md#autoscaling)"
  default     = null
}

##############################################################################
## Secrets Manager Service Credentials
##############################################################################

variable "existing_secrets_manager_instance_crn" {
  type        = string
  default     = null
  description = "The CRN of existing secrets manager to use to create service credential secrets for Messages for RabbitMQ instance."
}

variable "existing_secrets_manager_endpoint_type" {
  type        = string
  description = "The endpoint type to use if `existing_secrets_manager_instance_crn` is specified. Possible values: public, private."
  default     = "private"

  validation {
    condition     = contains(["public", "private"], var.existing_secrets_manager_endpoint_type)
    error_message = "Only \"public\" and \"private\" are allowed values for 'existing_secrets_endpoint_type'."
  }
}

variable "service_credential_secrets" {
  type = list(object({
    secret_group_name        = string
    secret_group_description = optional(string)
    existing_secret_group    = optional(bool)
    service_credentials = list(object({
      secret_name                                 = string
      service_credentials_source_service_role_crn = string
      secret_labels                               = optional(list(string))
      secret_auto_rotation                        = optional(bool)
      secret_auto_rotation_unit                   = optional(string)
      secret_auto_rotation_interval               = optional(number)
      service_credentials_ttl                     = optional(string)
      service_credential_secret_description       = optional(string)

    }))
  }))
  default     = []
  description = "Service credential secrets configuration for Messages for RabbitMQ. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-icd-rabbitmq/tree/main/solutions/standard/DA-types.md#service-credential-secrets)."

  validation {
    # Service roles CRNs can be found at https://cloud.ibm.com/iam/roles, select the IBM Cloud Database and select the role
    condition = alltrue([
      for group in var.service_credential_secrets : alltrue([
        # crn:v?:bluemix; two non-empty segments; three possibly empty segments; :serviceRole or role: non-empty segment
        for credential in group.service_credentials : can(regex("^crn:v[0-9]:bluemix(:..*){2}(:.*){3}:(serviceRole|role):..*$", credential.service_credentials_source_service_role_crn))
      ])
    ])
    error_message = "service_credentials_source_service_role_crn must be a serviceRole CRN. See https://cloud.ibm.com/iam/roles"
  }

  validation {
    condition = (
      length(var.service_credential_secrets) == 0 ||
      var.existing_secrets_manager_instance_crn != null
    )
    error_message = "`existing_secrets_manager_instance_crn` is required when adding service credentials to a secrets manager secret."
  }
}

variable "skip_rabbitmq_secrets_manager_auth_policy" {
  type        = bool
  description = "Whether an IAM authorization policy is created for Secrets Manager instance to create a service credential secrets for Messages for RabbitMQ. If set to false, the Secrets Manager instance passed by the user is granted the Key Manager access to the RabbitMQ instance created by the Deployable Architecture. Set to `true` to use an existing policy. The value of this is ignored if any value for 'existing_secrets_manager_instance_crn' is not passed."
  default     = false
}

variable "admin_pass_secrets_manager_secret_group" {
  type        = string
  description = "The name of a new or existing secrets manager secret group for admin password. To use existing secret group, `use_existing_admin_pass_secrets_manager_secret_group` must be set to `true`. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "rabbitmq-secrets"

  validation {
    condition = (
      var.existing_secrets_manager_instance_crn == null ||
      var.admin_pass_secrets_manager_secret_group != null
    )
    error_message = "`admin_pass_secrets_manager_secret_group` is required when `existing_secrets_manager_instance_crn` is set."
  }
}

variable "use_existing_admin_pass_secrets_manager_secret_group" {
  type        = bool
  description = "Whether to use an existing secrets manager secret group for admin password."
  default     = false
}

variable "admin_pass_secrets_manager_secret_name" {
  type        = string
  description = "The name of a new rabbitmq administrator secret. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "rabbitmq-admin-password"

  validation {
    condition = (
      var.existing_secrets_manager_instance_crn == null ||
      var.admin_pass_secrets_manager_secret_name != null
    )
    error_message = "`admin_pass_secrets_manager_secret_name` is required when `existing_secrets_manager_instance_crn` is set."
  }
}

##############################################################
# Context-based restriction (CBR)
##############################################################

variable "cbr_rules" {
  type = list(object({
    description = string
    account_id  = string
    rule_contexts = list(object({
      attributes = optional(list(object({
        name  = string
        value = string
    }))) }))
    enforcement_mode = string
    tags = optional(list(object({
      name  = string
      value = string
    })))
    operations = optional(list(object({
      api_types = list(object({
        api_type_id = string
      }))
    })))
  }))
  description = "(Optional, list) List of context-based restrictions rules to create."
  default     = []
}
