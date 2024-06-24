module "rabbitmq_database" {
  source                        = "../../"
  resource_group_id             = var.resource_group_id
  instance_name                 = var.instance_name
  region                        = var.region
  skip_iam_authorization_policy = var.skip_iam_authorization_policy
  endpoints                     = "private"
  rabbitmq_version              = var.rabbitmq_version
  kms_encryption_enabled        = true
  existing_kms_instance_guid    = var.existing_kms_instance_guid
  kms_key_crn                   = var.kms_key_crn
  tags                          = var.tags
  access_tags                   = var.access_tags
  cbr_rules                     = var.cbr_rules
  memory_mb                     = var.memory_mb
  disk_mb                       = var.disk_mb
  cpu_count                     = var.cpu_count
  members                       = var.members
  admin_pass                    = var.admin_pass
  users                         = var.users
  service_credential_names      = var.service_credential_names
  auto_scaling                  = var.auto_scaling
  backup_crn                    = var.backup_crn
}
