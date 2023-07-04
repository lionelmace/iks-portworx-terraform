##############################################################################
## ICD Mongo
##############################################################################
resource "ibm_database" "icd_etcd" {
  name              = format("%s-%s", local.basename, "etcd")
  service           = "databases-for-etcd"
  plan              = var.icd_etcd_plan
  version           = var.icd_etcd_db_version
  service_endpoints = var.icd_etcd_service_endpoints
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags

  # DB Settings
  adminpassword = var.icd_etcd_adminpassword
  group {
    group_id = "member"
    memory { allocation_mb = var.icd_etcd_ram_allocation }
    disk { allocation_mb = var.icd_etcd_disk_allocation }
    cpu { allocation_count = var.icd_etcd_core_allocation }
  }

}

## Service Credentials
##############################################################################
resource "ibm_resource_key" "key" {
  name                 = format("%s-%s", local.basename, "etcd-key")
  resource_instance_id = ibm_database.icd_etcd.id
  role                 = "Viewer"
}

# Database connection
##############################################################################
# data "ibm_database_connection" "etcd_db_connection" {
#     deployment_id = ibm_database.icd_etcd.id
#     endpoint_type = var.icd_etcd_service_endpoints
#     user_id = "user_id"
#     user_type = "database"
# }

# output "iks_cluster_alb" {
#   value = data.ibm_database_connection.etcd_db_connection.database
# }


## IAM
##############################################################################
# Doc at https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-iam
resource "ibm_iam_access_group_policy" "iam-etcd" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Editor"]

  resources {
    service           = "databases-for-postgresql"
    resource_group_id = ibm_resource_group.group.id
  }
}


# Variables
##############################################################################
variable "icd_etcd_plan" {
  type        = string
  description = "The plan type of the Database instance"
  default     = "standard"
}

variable "icd_etcd_adminpassword" {
  type        = string
  description = "The admin user password for the instance"
  default     = "Passw0rd01"
}

variable "icd_etcd_ram_allocation" {
  type        = number
  description = "RAM (GB/data member)"
  default     = 1024
}

variable "icd_etcd_disk_allocation" {
  type        = number
  description = "Disk Usage (GB/data member)"
  default     = 20480
}

variable "icd_etcd_core_allocation" {
  type        = number
  description = "Dedicated Cores (cores/data member)"
  default     = 0
}

variable "icd_etcd_db_version" {
  default     = "3.4"
  type        = string
  description = "The database version to provision if specified"
}

variable "icd_etcd_users" {
  default     = null
  type        = set(map(string))
  description = "Database Users. It is set of username and passwords"
}

variable "icd_etcd_service_endpoints" {
  default     = "public"
  type        = string
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
}