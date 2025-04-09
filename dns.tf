# /******************************************
#   DNS Forwarding 
# *****************************************/

resource "google_dns_managed_zone" "private_zone" {
  name        = "private-google-api"
  dns_name    = "googleapis.com."
  description = "Private DNS to Google API"
  project     = module.prj_sec_compute.project_id

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.secured_vpc.network_id
    }
  }
}

resource "google_dns_record_set" "private_google" {
  name    = "restricted.${google_dns_managed_zone.private_zone.dns_name}"
  type    = "A"
  ttl     = 300
  project = module.prj_sec_compute.project_id

  managed_zone = google_dns_managed_zone.private_zone.name

  rrdatas = [
    "199.36.153.4",
    "199.36.153.5",
    "199.36.153.6",
    "199.36.153.7",
  ]
}

resource "google_dns_record_set" "public_cname" {
  name         = "*.${google_dns_managed_zone.private_zone.dns_name}"
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["restricted.${google_dns_managed_zone.private_zone.dns_name}"]
  project      = module.prj_sec_compute.project_id

}