# /******************************************
#   SERVICE PERIMETER PROJECT
# *****************************************/

resource "google_folder" "secured_folder" {
  display_name        = "${var.folder_prefix}-secured"
  parent              = "folders/${var.parent_folder}"
  deletion_protection = false

}



