##############################################################################
# Locals
##############################################################################

locals {
  service_credential_names = {
    "es_admin" : "Administrator",
    "es_operator" : "Operator",
    "es_viewer" : "Viewer",
    "es_editor" : "Editor",
  }
}

##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.3.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# VPC
##############################################################################

resource "ibm_is_vpc" "example_vpc" {
  name           = "${var.prefix}-vpc"
  resource_group = module.resource_group.resource_group_id
  tags           = var.resource_tags
}

resource "ibm_is_subnet" "testacc_subnet" {
  name                     = "${var.prefix}-subnet"
  vpc                      = ibm_is_vpc.example_vpc.id
  zone                     = "${var.region}-1"
  total_ipv4_address_count = 256
  resource_group           = module.resource_group.resource_group_id
}

##############################################################################
# Key Protect All Inclusive
##############################################################################

locals {
  data_key_name    = "${var.prefix}-rabbitmq"
  backups_key_name = "${var.prefix}-rabbitmq-backups"
}

module "key_protect_all_inclusive" {
  source            = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version           = "5.1.14"
  resource_group_id = module.resource_group.resource_group_id
  # Note: Database instance and Key Protect must be created in the same region when using BYOK
  # See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok
  region                    = var.region
  key_protect_instance_name = "${var.prefix}-kp"
  resource_tags             = var.resource_tags
  keys = [
    {
      key_ring_name = "icd"
      keys = [
        {
          key_name     = local.data_key_name
          force_delete = true
        },
        {
          key_name     = local.backups_key_name
          force_delete = true
        }
      ]
    }
  ]
}

##############################################################################
# Get Cloud Account ID
##############################################################################

data "ibm_iam_account_settings" "iam_account_settings" {
}

##############################################################################
# Create CBR Zone
##############################################################################

module "cbr_zone" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.32.6"
  name             = "${var.prefix}-VPC-network-zone"
  zone_description = "CBR Network zone containing VPC"
  account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
  addresses = [{
    type  = "vpc", # to bind a specific vpc to the zone
    value = ibm_is_vpc.example_vpc.crn,
  }]
}

##############################################################################
# Rabbitmq Instance
##############################################################################

module "icd_rabbitmq" {
  source = "../../"
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/icd-rabbitmq/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  resource_group_id   = module.resource_group.resource_group_id
  name                = "${var.prefix}-rabbitmq"
  rabbitmq_version    = var.rabbitmq_version
  admin_pass          = var.admin_pass
  users               = var.users
  region              = var.region
  access_tags         = var.access_tags
  tags                = var.resource_tags
  deletion_protection = false
  auto_scaling        = var.auto_scaling
  # Example of how to use different KMS keys for data and backups
  use_ibm_owned_encryption_key = false
  use_same_kms_key_for_backups = false
  kms_key_crn                  = module.key_protect_all_inclusive.keys["icd.${local.data_key_name}"].crn
  backup_encryption_key_crn    = module.key_protect_all_inclusive.keys["icd.${local.backups_key_name}"].crn
  service_credential_names     = local.service_credential_names
  member_host_flavor           = "multitenant"
  cbr_rules = [
    {
      description      = "${var.prefix}-rabbitmq access only from vpc"
      enforcement_mode = "enabled"
      account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
      rule_contexts = [{
        attributes = [
          {
            "name" : "endpointType",
            "value" : "private"
          },
          {
            name  = "networkZoneId"
            value = module.cbr_zone.zone_id
        }]
      }]
    }
  ]
}
