resource "google_access_context_manager_service_perimeter" "service_perimeter" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.folder_policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.folder_policy.name}/servicePerimeters/secured_perimeter"

  title          = "secured_perimeter"
  perimeter_type = "PERIMETER_TYPE_REGULAR"
  #   Service 'bigquery.googleapis.com' will be restricted.
  #   status {
  #     restricted_services = ["bigquery.googleapis.com"]
  #   }
  # SPEC = DRY RUN 
  # STATUS = ENFORCED
  spec {
    resources = [
      # "projects/<project_number", # FORMAT 
      # "//compute.googleapis.com/projects/prj-com-hpd-network-t4je/global/networks/vpc-hpd", 
      "projects/${module.prj_sec_compute.project_number}",
      "projects/${module.prj_sec_storage.project_number}",
      "projects/${data.google_project.api_project.number}",
      "//compute.googleapis.com/${module.secured_vpc.network_id}"
    ]
    restricted_services = [
      "storage.googleapis.com",
      "compute.googleapis.com",
    ]
    #Ingress ess Rule 1 -> Allow ingress All from SA
    ingress_policies {
      title = "allow Ingress - Terraform automation"


      ingress_from {
        sources {
          access_level = google_access_context_manager_access_level.secured_access_level.id
        }
        identities = ["serviceAccount:${var.automation_sa}"]
      }
      ingress_to {
        resources = [
          "projects/${module.prj_sec_compute.project_number}",
          "projects/${module.prj_sec_storage.project_number}",
          "projects/${data.google_project.api_project.number}",
        ]
        operations {
          service_name = "*"
        }
      }

    }
    #Ingress Rule 2 -> Allow access from Access level 
    ingress_policies {
      title = "allow from access level to compute engine"
      ingress_from {
        sources {
          access_level = google_access_context_manager_access_level.secured_access_level.id
        }
        sources {
          resource = "//compute.googleapis.com/${module.secured_vpc.network_id}"

        }
        identities = [var.authorized_member]
      }

      ingress_to {
        resources = [
          "projects/${module.prj_sec_compute.project_number}"
        ]
        operations {
          service_name = "compute.googleapis.com"
          method_selectors {
            method = "*"
          }

        }
      }

    }
    #Egress Rule1 -> Allow egress to compute instance only
    egress_policies {
      title = "allow Egress from sec project instance to std project "
      egress_from {
        identities = ["serviceAccount:${module.prj_sec_compute.project_number}-compute@developer.gserviceaccount.com"]
      }
      egress_to {
        resources = [
          "projects/${module.prj_sec_compute.project_number}"
        ]
        operations {
          service_name = "compute.googleapis.com"
          method_selectors {
            method = "*"
          }

        }
      }
    }
    #Egress Rule2-> Allow egress ALL to Standard project for lab purpose
    egress_policies {
      title = "allow Egress to std project - Terraform automation"
      egress_from {
        identities = ["serviceAccount:${var.automation_sa}"]
      }
      egress_to {

        resources = [
          "projects/${module.prj_std_testing.project_number}"
        ]
        operations {
          service_name = "*"

        }
      }

    }

  }
  use_explicit_dry_run_spec = true

  depends_on = [module.secured_vpc]

}

data "google_project" "api_project" {
  project_id = var.api_project # Replace with your actual project ID
}

resource "time_sleep" "vpc_sc_destroy_wait_300_seconds" {
  depends_on       = [google_access_context_manager_service_perimeter.service_perimeter]
  destroy_duration = "5m"
  # Delay to 5 min, in wait for VPC-SC propagate correctly
}