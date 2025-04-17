# /******************************************
#   SERVICE PERIMETER ENVIRONMENT
# *****************************************/


# Deny All 
resource "google_compute_firewall" "demo_deny_egress" {
  name               = "${var.firewall_prefix}-demo-egress-deny-all"
  description        = "Deny Egress all "
  network            = module.secured_vpc.network_name
  project            = module.prj_sec_compute.project_id
  destination_ranges = ["0.0.0.0/0"]
  priority           = 65535
  direction          = "EGRESS"

  deny {
    protocol = "all"

  }
}

resource "google_compute_firewall" "demo_deny_ingress" {
  name          = "${var.firewall_prefix}-demo-ingress-deny-all"
  description   = "Deny ingress all "
  network       = module.secured_vpc.network_name
  project       = module.prj_sec_compute.project_id
  source_ranges = ["0.0.0.0/0"]
  priority      = 65535
  direction     = "INGRESS"
  deny {
    protocol = "all"

  }
}

resource "google_compute_firewall" "demo_allow_ssh" {
  name          = "${var.firewall_prefix}-demo-ingress-allow-ssh"
  description   = "Allow ingress ssh "
  network       = module.secured_vpc.network_name
  project       = module.prj_sec_compute.project_id
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-iap-ssh"]
  priority      = 1000
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "demo_allow_ssh_external" {
  name               = "${var.firewall_prefix}-demo-egress-allow-ssh"
  description        = "Allow ingress ssh "
  network            = module.secured_vpc.network_name
  project            = module.prj_sec_compute.project_id
  destination_ranges = ["172.16.0.0/24"]
  target_tags        = ["allow-iap-ssh"]
  priority           = 1000
  direction          = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}



resource "google_compute_firewall" "demo_allow_apis" {
  name               = "${var.firewall_prefix}-demo-egress-allow-apis"
  description        = "Allow ingress DNS"
  network            = module.secured_vpc.network_name
  project            = module.prj_sec_compute.project_id
  destination_ranges = ["199.36.153.4/30", "34.126.0.0/18"]
  target_tags        = ["allow-dns-google"]
  priority           = 1000
  direction          = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["53", "443"]
  }
  #   allow {
  #     protocol = "udp"
  #     ports    = ["53"]
  #   }
}

# /******************************************
#   STANDARD PERIMETER ENVIRONMENT
# *****************************************/


resource "google_compute_firewall" "demo_allow_std_ssh" {
  name          = "${var.firewall_prefix}-demo-ingress-allow-ssh"
  description   = "Allow ingress ssh "
  network       = module.standard_vpc.network_name
  project       = module.prj_std_testing.project_id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-std-ssh"]
  priority      = 1000
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}