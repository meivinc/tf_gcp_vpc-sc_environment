# /******************************************
#   SERVICE PERIMETER ENVIRONMENT
# *****************************************/


output "secured_instance" {
  description = "Instance Name"
  value       = module.secured_instance_1
}


output "secured_bucket" {
  description = "Bucket name"
  value       = google_storage_bucket.secured_bucket.name

}

# /******************************************
#   STANDARD PERIMETER ENVIRONMENT
# *****************************************/

output "standard_instance" {
  description = "Instance Name"
  value       = module.standard_instance_1
}


output "standard_bucket" {
  description = "Bucket name"
  value       = google_storage_bucket.standard_bucket.name
}
