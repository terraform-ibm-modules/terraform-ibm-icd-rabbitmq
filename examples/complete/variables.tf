variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "rabbitmq"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the rabbitmq instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details"
  default     = []
}

variable "rabbitmq_version" {
  type        = string
  description = "Version of rabbitmq to deploy"
  default     = null
}

variable "admin_pass" {
  type        = string
  default     = null
  sensitive   = true
  description = "The password for the database administrator. If the admin password is null then the admin user ID cannot be accessed. More users can be specified in a user block."
}

variable "users" {
  type = list(object({
    name     = string
    password = string
    type     = optional(string)
    role     = optional(string)
  }))
  default     = []
  sensitive   = true
  description = "A list of users that you want to create on the database. Multiple blocks are allowed. The user password must be in the range of 10-32 characters."
}

variable "auto_scaling" {
  type = object({
    disk = object({
      capacity_enabled             = optional(bool)
      free_space_less_than_percent = optional(number)
      io_above_percent             = optional(number)
      io_enabled                   = optional(bool)
      io_over_period               = optional(string)
      rate_increase_percent        = optional(number)
      rate_limit_mb_per_member     = optional(number)
      rate_period_seconds          = optional(number)
      rate_units                   = optional(string)
    })
    memory = object({
      io_above_percent         = optional(number)
      io_enabled               = optional(bool)
      io_over_period           = optional(string)
      rate_increase_percent    = optional(number)
      rate_limit_mb_per_member = optional(number)
      rate_period_seconds      = optional(number)
      rate_units               = optional(string)
    })
  })
  description = "Configure rules to allow your database to automatically increase its resources. Single block of autoscaling is allowed at once."
  default = {
    disk = {
      capacity_enabled : true,
      io_enabled : true
    }
    memory = {
      io_enabled : true,
    }
  }
}
