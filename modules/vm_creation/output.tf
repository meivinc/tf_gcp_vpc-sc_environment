output "instance_name" {
  value       = google_compute_instance.compute-instance.name
  description = "Instance Name"

}
output "network_ip" {
  value       = google_compute_instance.compute-instance.network_interface[0].network_ip
  description = "Internal IP address of the instance."
}

output "nat_ip" {
  value       = length(google_compute_instance.compute-instance.network_interface[0].access_config) > 0 ? google_compute_instance.compute-instance.network_interface[0].access_config[0].nat_ip : null
  description = "External IP address (NAT IP) of the instance.  Null if not assigned."
}

output "instance_service_account" {
  value       = google_compute_instance.compute-instance.service_account[0].email
  description = "Used Service account"

}