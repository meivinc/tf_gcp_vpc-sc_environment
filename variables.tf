# /******************************************
#   Global Variable
# *****************************************/

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "personal_ip" {
  description = "Personal IP to allow access through VPC-SC"
  type        = list(string)
  default     = []
}

variable "parent_folder" {
  description = "Parent folder ID"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "automation_sa" {
  description = "Name of SA used to deploy terraform code"
  type        = string
  default     = null
}

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
  default     = "europe-west1"
}

variable "security_prefix" {
  description = "Name prefix to use for security project"
  type        = string
  default     = "sec"
}

variable "standard_prefix" {
  description = "Name prefix to use for standard project"
  type        = string
  default     = "std"
}



# /******************************************
#   Ressources Variable
# *****************************************/

variable "project_prefix" {
  description = "Name prefix to use for projects created. Should be the same in all steps. Max size is 3 characters."
  type        = string
  default     = "prj"
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created. Should be the same in all steps."
  type        = string
  default     = "fldr"
}

# /******************************************
#   Bucket Variable
# *****************************************/


variable "bucket_prefix" {
  description = "Name prefix to use for state bucket created."
  type        = string
  default     = "bkt"
}



variable "bucket_force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = true
}

variable "policy_deletion" {
  description = "Default value to allow destroy as it is test env"
  type        = string
  default     = "DELETE"
}


# /******************************************
#   Networking Variable
# *****************************************/

variable "vpc_prefix" {
  description = "Name prefix to use for vpc"
  type        = string
  default     = "vpc"
}

variable "subnet_prefix" {
  description = "Name prefix to use for subnet"
  type        = string
  default     = "sb"
}

variable "firewall_prefix" {
  type        = string
  default     = "fw"
  description = "Firewall Access default prefix"
}

# /******************************************
#   Instance Variable
# *****************************************/

variable "compute_prefix" {
  description = "Name prefix to use for compute instance"
  type        = string
  default     = "ins"
}

variable "authorized_member" {
  type        = string
  default     = ""
  description = "user or group to allow to IAP and VPC-SC "
}


variable "api_project" {
  type        = string
  default     = null
  description = "Project billing where to apply things"
}

