# /******************************************
#   SERVICE PERIMETER PROJECT
# *****************************************/

module "secured_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 10.0"

  project_id              = module.prj_sec_compute.project_id # Replace this with your project ID in quotes
  network_name            = "${var.vpc_prefix}-${var.security_prefix}"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  mtu                     = 1460
  subnets = [
    {
      subnet_name           = "${var.subnet_prefix}-${var.security_prefix}-euw1-compute"
      subnet_ip             = "192.168.0.0/24"
      subnet_region         = var.default_region
      subnet_private_access = "true"
    },
  ]

}


resource "google_compute_network_peering" "peering_secured_to_standard" {
  name         = "npr-${var.security_prefix}-to-${var.standard_prefix}"
  network      = module.secured_vpc.network_self_link
  peer_network = module.standard_vpc.network_self_link
}

# /******************************************
#   STANDARD PERIMETER PROJECT
# *****************************************/

module "standard_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 10.0"

  project_id              = module.prj_std_testing.project_id # Replace this with your project ID in quotes
  network_name            = "${var.vpc_prefix}-${var.standard_prefix}"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  mtu                     = 1460
  subnets = [
    {
      subnet_name   = "${var.subnet_prefix}-${var.standard_prefix}-euw1-compute"
      subnet_ip     = "172.16.0.0/24"
      subnet_region = var.default_region
    },
  ]
}


resource "google_compute_network_peering" "peering2" {
  name         = "npr-${var.security_prefix}-to-${var.standard_prefix}"
  network      = module.standard_vpc.network_self_link
  peer_network = module.secured_vpc.network_self_link
}
