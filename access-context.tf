# /******************************************
#   ACCESS LEVEL CONFIGURATION
# *****************************************/

resource "google_access_context_manager_access_policy" "folder_policy" {
  parent = "organizations/${var.org_id}"
  scopes = ["folders/${var.parent_folder}"]
  title  = "UseCase -  VPC SC Policy"
}


resource "google_access_context_manager_access_level" "secured_access_level" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.folder_policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.folder_policy.name}/accessLevels/secured_access_level"
  title  = "secured_access_level"
  basic {
    conditions {
      ip_subnetworks = concat(
        [
          "35.235.240.0/20",
          "2600:1900::/28"
        ],
        var.personal_ip,
      )
      #   regions = [
      # "FR",
      #   ]
    }
  }
}
