##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the RabbitMQ instance will be created."
}

variable "instance_name" {
  type        = string
  description = "The name of the RabbitMQ instance"
}

variable "plan_validation" {
  type        = bool
  description = "Enable or disable validating the database parameters for rabbitmq during the plan phase"
  default     = true
}

variable "region" {
  type        = string
  description = "The region where you want to deploy your instance."
  default     = "us-south"
}

variable "rabbitmq_version" {
  description = "The version of RabbitMQ to deploy. If no value passed, the current ICD preferred version is used."
  type        = string
  default     = null
  validation {
    condition = anytrue([
      var.rabbitmq_version == null,
      var.rabbitmq_version == "3.9",
      var.rabbitmq_version == "3.11"
    ])
    error_message = "Version must be 3.9 or 3.11. If no value passed, the current ICD preferred version is used."
  }
}

variable "endpoints" {
  description = "Endpoints available to the database instance (public, private, public-and-private)"
  type        = string
  default     = "private"
  validation {
    condition     = can(regex("public|public-and-private|private", var.endpoints))
    error_message = "Valid values for endpoints are 'public', 'public-and-private', and 'private'"
  }
}

variable "tags" {
  type        = list(any)
  description = "Optional list of tags to be added to the RabbitMQ instance."
  default     = []
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. Only used if var.kms_encryption_enabled is set to true."
  default     = null
  validation {
    condition = anytrue([
      var.kms_key_crn == null,
      can(regex(".*kms.*", var.kms_key_crn)),
      can(regex(".*hs-crypto.*", var.kms_key_crn)),
    ])
    error_message = "Value must be the root key CRN from either the Key Protect or Hyper Protect Crypto Service (HPCS)"
  }
}

variable "admin_pass" {
  type        = string
  description = "The password for the database administrator. If the admin password is null then the admin user ID cannot be accessed. More users can be specified in a user block. The admin password must be in the range of 10-32 characters."
  default     = null
  sensitive   = true
}

variable "members" {
  type        = number
  description = "Allocated number of members. For more information, see: https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling"
  default     = 3
  # Validation is done in the Terraform plan phase by the IBM provider, so no need to add extra validation here.
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
  description = "A list of users that you want to create on the database. Multiple blocks are allowed. The user password must be in the range of 10-32 characters. Be warned that in most case using IAM service credentials (via the var.service_credential_names) is sufficient to control access to the RabbitMQ instance. This blocks creates native RabbitMQ database users, more info on that can be found here https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-user-management"
}

variable "disk_mb" {
  description = "Allocated disk per member. For more information, see https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling"
  type        = number
  default     = 1024
}

variable "cpu_count" {
  description = "Allocated dedicated CPU per member. For shared CPU, set to 0. For more information, see https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-resources-scaling"
  type        = number
  default     = 0
}

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
  description = "Optional rules to allow the database to increase resources in response to usage. Only a single autoscaling block is allowed. Make sure you understand the effects of autoscaling, especially for production environments. See https://cloud.ibm.com/docs/messages-for-rabbitmq?topic=messages-for-rabbitmq-autoscaling in the IBM Cloud Docs."
  default     = null
}
