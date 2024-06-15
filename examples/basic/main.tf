##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# RabbitMQ
##############################################################################

module "icd_rabbitmq" {
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  instance_name     = "${var.prefix}-rabbitmq"
  region            = var.region
  tags              = var.resource_tags
  access_tags       = var.access_tags
  rabbitmq_version  = var.rabbitmq_version
}
