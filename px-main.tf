data "ibm_iam_api_key" "api_key" {
  apikey_id = "ApiKey-903cb05c-999e-4f87-b0eb-682394e42200"
}

module "portworx_enterprise" {
  # IBM Provider Configuration
  #LMA source           = "../../"
  source = "github.com/portworx/terraform-ibm-portworx-enterprise"
  region           = var.region
  # LMA ibmcloud_api_key = var.ibmcloud_api_key
  ibmcloud_api_key = data.ibm_iam_api_key.api_key.apikey

  # IKS Cluster Configuration
  #LMA cluster_name   = var.iks_cluster_name
  cluster_name = ibm_container_vpc_cluster.iks_cluster.name
  #LMA px_cluster_name   = var.px_cluster_name
  px_cluster_name   = ibm_container_vpc_cluster.iks_cluster.name
  #LMA resource_group = var.resource_group
  resource_group = ibm_resource_group.group.name
  classic_infra  = var.classic_infra

  # External ETCD Configuration
  etcd_options = {
    use_external_etcd            = var.use_external_etcd
    etcd_secret_name             = var.etcd_secret_name
    external_etcd_connection_url = var.external_etcd_connection_url
  }

  # Portworx Enterprise Configuration
  pwx_plan              = var.pwx_plan
  portworx_version      = var.portworx_version
  upgrade_portworx      = var.upgrade_portworx
  portworx_csi          = var.portworx_csi
  portworx_service_name = var.portworx_service_name
  secret_type           = var.secret_type
  delete_strategy       = var.delete_strategy
  namespace             = var.namespace
  install_autopilot = var.install_autopilot
  autopilot_scale_percentage_threshold = var.autopilot_scale_percentage_threshold
  autopilot_scale_percentage = var.autopilot_scale_percentage
  autopilot_max_capacity = var.autopilot_max_capacity

  # Cloud Drives Configuration
  use_cloud_drives = var.use_cloud_drives
  cloud_drive_options = {
    max_storage_node_per_zone = var.max_storage_node_per_zone
    num_cloud_drives          = var.num_cloud_drives
    cloud_drives_sizes        = var.cloud_drives_sizes
    storage_classes           = var.storage_classes
  }
}
