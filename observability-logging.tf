##############################################################################
# Log Analysis Services
##############################################################################


# Log Variables
##############################################################################
variable "log_plan" {
  description = "plan type (7-day, 14-day, 30-day, hipaa-30-day and lite)"
  type        = string
  default     = "7-day"
}

variable "log_service_endpoints" {
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  default     = "private"
}

variable "log_role" {
  description = "Type of role"
  type        = string
  default     = "Administrator"
}

variable "log_bind_key" {
  description = "Flag indicating that key should be bind to log instance"
  type        = bool
  default     = true
}

variable "log_key_name" {
  description = "Name of the instance key"
  type        = string
  default     = "log-ingestion-key"
}

variable "log_private_endpoint" {
  description = "Add this option to connect to your LogDNA service instance through the private service endpoint"
  type        = bool
  default     = true
}

variable "log_enable_platform_logs" {
  type        = bool
  description = "Receive platform logs in Logdna"
  default     = false
}

# Log Resource/Instance
##############################################################################

module "logging_instance" {
  source = "terraform-ibm-modules/observability/ibm//modules/logging-instance"

  resource_group_id    = ibm_resource_group.group.id
  name                 = format("%s-%s", local.basename, "logs")
  is_sts_instance      = false
  service_endpoints    = var.log_service_endpoints
  bind_key             = var.log_bind_key
  key_name             = var.log_key_name
  plan                 = var.log_plan
  enable_platform_logs = var.log_enable_platform_logs
  region               = var.region
  tags                 = var.tags
  key_tags             = var.tags
  # role              = var.log_role
}

output "log_instance_id" {
  description = "The ID of the Log Analysis instance"
  value       = module.logging_instance.id
}

## IAM
##############################################################################

resource "ibm_iam_access_group_policy" "iam-log-analysis" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Viewer", "Standard Member"]

  resources {
    service           = "logdna"
    resource_group_id = ibm_resource_group.group.id
  }
}
