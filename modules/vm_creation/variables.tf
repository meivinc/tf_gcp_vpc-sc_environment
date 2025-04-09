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


variable "instance_name" {
  description = "Name of the Instance to create"
  type        = string
}

variable "machine_type" {
  description = "type of VMs"
  type        = string
}


variable "subnet_uri" {
  description = "subnet URI for VM deployment"
  type        = string

}


variable "network_tags" {
  description = "List network tag needed for VM"
  type        = list(string)
  default     = [null]
}

variable "project_id" {
  description = "Project where VM have to be created"
  type        = string

}

variable "iap_binding_member" {
  description = "member or groups to allow for IAP"
  type        = string

}

variable "allow_update" {
  description = "allow update of VM from Tf"
  type        = string
  default     = false

}

variable "instance_prefix" {
  description = "Prefix of Compute engine"
  type        = string
  default     = "ins"
}

variable "instance_env" {
  description = "environment of instance creation"
  type        = string
}

variable "instance_region" {
  type        = string
  default     = "europe-west3"
  description = "Default network region "
}

variable "subnet_prefix" {
  type        = string
  default     = "sb"
  description = "Subnet default prefix"
}


variable "public_access" {
  type        = bool
  default     = true
  description = "determine if an instance should have a public IP or not"
}
