/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



# Allow through IAP 

resource "google_iap_tunnel_instance_iam_member" "member" {
  count   = var.public_access ? 0 : 1 # Conditionally create the resource
  project = var.project_id
  # zone     = "${var.instance_region}-${element(data.google_compute_zones.available.names, 0)}" # Dynamically determine the zone based on the instance region
  # instance = "${google_compute_instance.compute-instance[0].name}"
  zone     = google_compute_instance.compute-instance.zone
  instance = google_compute_instance.compute-instance.name
  role     = "roles/iap.tunnelResourceAccessor"
  member   = var.iap_binding_member
}


# /* ----------------------------------------
#     BINDING 
#    ---------------------------------------- */

resource "google_project_iam_member" "oslogin" {
  project = var.project_id
  role    = "roles/compute.osLogin"
  member  = var.iap_binding_member
}

resource "google_project_iam_member" "sa_user_consumption" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = var.iap_binding_member
}

