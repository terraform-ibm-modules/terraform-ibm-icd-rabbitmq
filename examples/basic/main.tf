##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.2.1"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# RabbitMQ
##############################################################################

module "database" {
  source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/icd-rabbitmq/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  resource_group_id = module.resource_group.resource_group_id
  name              = "${var.prefix}-rabbitmq"
  region            = var.region
  tags              = var.resource_tags
  access_tags       = var.access_tags
  rabbitmq_version  = var.rabbitmq_version
  service_endpoints = var.service_endpoints
}
