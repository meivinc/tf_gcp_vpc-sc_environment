[//]: # (BEGIN_TF_DOCS)
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_update"></a> [allow\_update](#input\_allow\_update) | allow update of VM from terraform | `string` | `false` | no |
| <a name="input_iap_binding_member"></a> [iap\_binding\_member](#input\_iap\_binding\_member) | member or groups to allow for IAP | `string` | n/a | yes |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | environment of instance creation | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the Instance to create | `string` | n/a | yes |
| <a name="input_instance_prefix"></a> [instance\_prefix](#input\_instance\_prefix) | Prefix of Compute engine | `string` | `"ins"` | no |
| <a name="input_instance_region"></a> [instance\_region](#input\_instance\_region) | Default network region | `string` | `"europe-west3"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | type of VMs | `string` | n/a | yes |
| <a name="input_network_tags"></a> [network\_tags](#input\_network\_tags) | List network tag needed for VM | `list(string)` | <pre>[<br/>  null<br/>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project where VM have to be created | `string` | n/a | yes |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | determine if an instance should have a public IP or not | `bool` | `true` | no |
| <a name="input_subnet_prefix"></a> [subnet\_prefix](#input\_subnet\_prefix) | Subnet default prefix | `string` | `"sb"` | no |
| <a name="input_subnet_uri"></a> [subnet\_uri](#input\_subnet\_uri) | subnet URI for VM deployment | `string` | n/a | yes |
## Resources

| Name | Type |
|------|------|
| [google_compute_instance.compute-instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_iap_tunnel_instance_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_tunnel_instance_iam_member) | resource |
| [google_project_iam_member.oslogin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.sa_user_consumption](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [random_integer.zone_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |
| [google_project.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | Instance Name |
| <a name="output_instance_service_account"></a> [instance\_service\_account](#output\_instance\_service\_account) | Used Service account |
| <a name="output_nat_ip"></a> [nat\_ip](#output\_nat\_ip) | External IP address (NAT IP) of the instance.  Null if not assigned. |
| <a name="output_network_ip"></a> [network\_ip](#output\_network\_ip) | Internal IP address of the instance. |

[//]: # (END_TF_DOCS)