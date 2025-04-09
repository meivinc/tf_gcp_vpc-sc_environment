terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.28.0"
    }
  }
}

provider "google" {
  # Configuration options
  billing_project             = var.api_project
  user_project_override       = true
  impersonate_service_account = var.automation_sa
}