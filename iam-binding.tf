
locals {
  sa_compute_email = {
    "sa1" = "serviceAccount:${module.prj_sec_compute.project_number}-compute@developer.gserviceaccount.com",
    "sa2" = "serviceAccount:${module.prj_std_testing.project_number}-compute@developer.gserviceaccount.com",
  }
}


# /******************************************
#   SERVICE PERIMETER ENVIRONMENT
# *****************************************/

resource "google_project_iam_member" "sa_sec_storage_admin" {
  for_each = tomap(local.sa_compute_email)
  project  = module.prj_sec_storage.project_id
  role     = "roles/storage.admin"
  member   = each.value
}

# /******************************************
#   STANDARD PERIMETER ENVIRONMENT
# *****************************************/


resource "google_project_iam_member" "sa_std_storage_admin" {
  for_each = tomap(local.sa_compute_email)

  project = module.prj_std_testing.project_id
  role    = "roles/storage.admin"
  member  = each.value
}
