[//]: # (BEGIN_TF_DOCS)
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.28.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.1 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.0 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.28.0 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_prj_sec_compute"></a> [prj\_sec\_compute](#module\_prj\_sec\_compute) | terraform-google-modules/project-factory/google | ~> 18.0 |
| <a name="module_prj_sec_storage"></a> [prj\_sec\_storage](#module\_prj\_sec\_storage) | terraform-google-modules/project-factory/google | ~> 18.0 |
| <a name="module_prj_std_testing"></a> [prj\_std\_testing](#module\_prj\_std\_testing) | terraform-google-modules/project-factory/google | ~> 18.0 |
| <a name="module_secured_instance_1"></a> [secured\_instance\_1](#module\_secured\_instance\_1) | ./modules/vm_creation | n/a |
| <a name="module_secured_vpc"></a> [secured\_vpc](#module\_secured\_vpc) | terraform-google-modules/network/google | ~> 10.0 |
| <a name="module_standard_instance_1"></a> [standard\_instance\_1](#module\_standard\_instance\_1) | ./modules/vm_creation | n/a |
| <a name="module_standard_vpc"></a> [standard\_vpc](#module\_standard\_vpc) | terraform-google-modules/network/google | ~> 10.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_project"></a> [api\_project](#input\_api\_project) | Project billing where to apply things | `string` | `null` | no |
| <a name="input_authorized_member"></a> [authorized\_member](#input\_authorized\_member) | user or group to allow to IAP and VPC-SC | `string` | `""` | no |
| <a name="input_automation_sa"></a> [automation\_sa](#input\_automation\_sa) | Name of SA used to deploy terraform code | `string` | `null` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects. | `bool` | `true` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Name prefix to use for state bucket created. | `string` | `"bkt"` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region to create resources where applicable. | `string` | `"europe-west1"` | no |
| <a name="input_firewall_prefix"></a> [firewall\_prefix](#input\_firewall\_prefix) | Firewall Access default prefix | `string` | `"fw"` | no |
| <a name="input_folder_prefix"></a> [folder\_prefix](#input\_folder\_prefix) | Name prefix to use for folders created. Should be the same in all steps. | `string` | `"fldr"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | GCP Organization ID | `string` | n/a | yes |
| <a name="input_parent_folder"></a> [parent\_folder](#input\_parent\_folder) | Parent folder ID | `string` | n/a | yes |
| <a name="input_personal_ip"></a> [personal\_ip](#input\_personal\_ip) | Personal IP to allow access through VPC-SC | `list(string)` | `[]` | no |
| <a name="input_policy_deletion"></a> [policy\_deletion](#input\_policy\_deletion) | Default value to allow destroy as it is test env | `string` | `"DELETE"` | no |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | Name prefix to use for projects created. Should be the same in all steps. Max size is 3 characters. | `string` | `"prj"` | no |
| <a name="input_security_prefix"></a> [security\_prefix](#input\_security\_prefix) | Name prefix to use for security project | `string` | `"sec"` | no |
| <a name="input_standard_prefix"></a> [standard\_prefix](#input\_standard\_prefix) | Name prefix to use for standard project | `string` | `"std"` | no |
| <a name="input_subnet_prefix"></a> [subnet\_prefix](#input\_subnet\_prefix) | Name prefix to use for subnet | `string` | `"sb"` | no |
| <a name="input_vpc_prefix"></a> [vpc\_prefix](#input\_vpc\_prefix) | Name prefix to use for vpc | `string` | `"vpc"` | no |
## Resources

| Name | Type |
|------|------|
| [google_access_context_manager_access_level.secured_access_level](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/access_context_manager_access_level) | resource |
| [google_access_context_manager_access_policy.folder_policy](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/access_context_manager_access_policy) | resource |
| [google_access_context_manager_service_perimeter.service_perimeter](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/access_context_manager_service_perimeter) | resource |
| [google_compute_firewall.demo_allow_apis](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.demo_allow_ssh](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.demo_allow_ssh_external](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.demo_allow_std_ssh](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.demo_deny_egress](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.demo_deny_ingress](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_network_peering.peering_secured_to_standard](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_network_peering) | resource |
| [google_compute_network_peering.peering_standard_to_secured](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/compute_network_peering) | resource |
| [google_dns_managed_zone.private_zone](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.private_google](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/dns_record_set) | resource |
| [google_dns_record_set.public_cname](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/dns_record_set) | resource |
| [google_folder.secured_folder](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/folder) | resource |
| [google_project_iam_member.sa_sec_storage_admin](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.sa_std_storage_admin](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/project_iam_member) | resource |
| [google_storage_bucket.secured_bucket](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.standard_bucket](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.secured_object](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/storage_bucket_object) | resource |
| [google_storage_bucket_object.standard_object](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/resources/storage_bucket_object) | resource |
| [random_string.compute_secured_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.secured_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.standard_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.vpc_sc_destroy_wait_300_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_project.api_project](https://registry.terraform.io/providers/hashicorp/google/6.28.0/docs/data-sources/project) | data source |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secured_bucket"></a> [secured\_bucket](#output\_secured\_bucket) | Bucket name |
| <a name="output_secured_instance"></a> [secured\_instance](#output\_secured\_instance) | Instance Name |
| <a name="output_standard_bucket"></a> [standard\_bucket](#output\_standard\_bucket) | Bucket name |
| <a name="output_standard_instance"></a> [standard\_instance](#output\_standard\_instance) | Instance Name |

[//]: # (END_TF_DOCS)