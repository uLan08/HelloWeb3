module "bcw_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "= 9.0"

  project_id   = local.project_id
  network_name = "${local.base_name}-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "${local.base_name}-subnet-01"
      subnet_ip     = "10.1.0.0/21"
      subnet_region = local.region
    },
  ]

  secondary_ranges = {
    "${local.base_name}-subnet-01" = [
      {
        range_name    = "${local.base_name}-subnet-01-secondary-01"
        ip_cidr_range = "192.168.64.0/23"
      },
      {
        range_name    = "${local.base_name}-subnet-01-secondary-02"
        ip_cidr_range = "192.168.66.0/23"
      },
    ]
  }


  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}