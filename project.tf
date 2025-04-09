# /******************************************
#   SERVICE PERIMETER PROJECT
# *****************************************/


module "prj_sec_compute" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${var.project_prefix}-${var.security_prefix}-compute"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  folder_id                = resource.google_folder.secured_folder.id
  activate_apis = [
    "billingbudgets.googleapis.com",
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "dns.googleapis.com",
    "accesscontextmanager.googleapis.com"
  ]
  deletion_policy = var.policy_deletion
}

module "prj_sec_storage" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${var.project_prefix}-${var.security_prefix}-storage"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  folder_id                = resource.google_folder.secured_folder.id
  activate_apis = [
    "billingbudgets.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "storage.googleapis.com",
    "iap.googleapis.com",
    "dns.googleapis.com"
  ]
  deletion_policy = var.policy_deletion

}


# /******************************************
#   STANDARD PERIMETER PROJECT
# *****************************************/


module "prj_std_testing" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${var.project_prefix}-${var.standard_prefix}-compute"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  folder_id                = var.parent_folder

  activate_apis = [
    "billingbudgets.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "storage.googleapis.com",
    "iap.googleapis.com"
  ]
  deletion_policy = var.policy_deletion

}