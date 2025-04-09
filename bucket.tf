# /******************************************
#   SERVICE PERIMETER ENVIRONMENT
# *****************************************/



resource "random_string" "secured_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_storage_bucket" "secured_bucket" {
  name          = "${var.bucket_prefix}-${var.security_prefix}-enforced-${random_string.secured_suffix.result}"
  force_destroy = var.bucket_force_destroy
  location      = var.default_region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  project = module.prj_sec_storage.project_id
}


resource "google_storage_bucket_object" "secured_object" {
  name   = "secured_document.txt"
  bucket = google_storage_bucket.secured_bucket.name
  source = "./generated_content/secured_document.txt" # Add path to the zipped function source code
}


# /******************************************
#   STANDARD PERIMETER ENVIRONMENT
# *****************************************/


resource "random_string" "standard_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_storage_bucket" "standard_bucket" {
  name          = "${var.bucket_prefix}-${var.standard_prefix}-standard-${random_string.standard_suffix.result}"
  force_destroy = var.bucket_force_destroy
  location      = var.default_region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  project = module.prj_std_testing.project_id
}

resource "google_storage_bucket_object" "standard_object" {
  name   = "standard_document.txt"
  bucket = google_storage_bucket.standard_bucket.name
  source = "./generated_content/standard_document.txt" # Add path to the zipped function source code
}