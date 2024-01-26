data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.bcw_gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.bcw_gke.ca_certificate)
}

module "bcw_gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = local.project_id
  name                       = local.base_name
  region                     = local.region
  zones                      = local.zones
  network                    = module.bcw_vpc.network_name
  subnetwork                 = "${local.base_name}-subnet-01"
  ip_range_pods              = "${local.base_name}-subnet-01-secondary-01"
  ip_range_services          = "${local.base_name}-subnet-01-secondary-02"
  network_policy             = false
  remove_default_node_pool	 = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-micro"
      autoscaling        = false
      min_count          = 1
      max_count          = 50
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      initial_node_count = 2
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}