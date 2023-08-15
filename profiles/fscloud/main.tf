module "rabbitmq_database" {
  source                     = "../../"
  resource_group_id          = var.resource_group_id
  instance_name              = var.instance_name
  plan_validation            = var.plan_validation
  region                     = var.region
  rabbitmq_version           = var.rabbitmq_version
  endpoints                  = var.endpoints
  tags                       = var.tags
  existing_kms_instance_guid = var.existing_kms_instance_guid
  kms_key_crn                = var.kms_key_crn
  admin_pass                 = var.admin_pass
  members                    = var.members
  users                      = var.users
  disk_mb                    = var.disk_mb
  cpu_count                  = var.cpu_count
  auto_scaling               = var.auto_scaling
}
