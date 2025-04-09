# /******************************************
#   SERVICE PERIMETER ENVIRONMENT
# *****************************************/

resource "random_string" "compute_secured_suffix" {
  length  = 4
  special = false
  upper   = false
}

module "secured_instance_1" {
  source = "./modules/vm_creation"
  # Specify only name of the instance 
  instance_name      = "${var.security_prefix}-${random_string.compute_secured_suffix.result}"
  instance_env       = "eu"
  machine_type       = "e2-small"
  subnet_uri         = "projects/${module.prj_sec_compute.project_id}/regions/${var.default_region}/subnetworks/${var.subnet_prefix}-${var.security_prefix}-euw1-compute"
  network_tags       = ["allow-iap-ssh", "allow-dns-google"]
  project_id         = module.prj_sec_compute.project_id
  iap_binding_member = var.authorized_member
  instance_region    = var.default_region
  public_access      = false
  depends_on         = [module.secured_vpc]
}



# /******************************************
#   STANDARD PERIMETER ENVIRONMENT
# *****************************************/

module "standard_instance_1" {
  source = "./modules/vm_creation"
  # Specify only name of the instance 
  instance_name      = "${var.standard_prefix}-${random_string.compute_secured_suffix.result}"
  instance_env       = "eu"
  machine_type       = "e2-small"
  subnet_uri         = "projects/${module.prj_std_testing.project_id}/regions/${var.default_region}/subnetworks/${var.subnet_prefix}-${var.standard_prefix}-euw1-compute"
  network_tags       = ["allow-std-ssh"]
  project_id         = module.prj_std_testing.project_id
  iap_binding_member = var.authorized_member
  instance_region    = var.default_region
  depends_on         = [module.standard_vpc]
}