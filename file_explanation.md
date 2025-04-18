- [Access context.tf](#access-contexttf)
    - [Resource: `google_access_context_manager_access_policy`](#resource-google_access_context_manager_access_policy)
    - [Resource: `google_access_context_manager_access_level`](#resource-google_access_context_manager_access_level)
- [bucket.tf](#buckettf)
    - [SERVICE PERIMETER ENVIRONMENT](#service-perimeter-environment)
      - [Resource: `random_string.secured_suffix`](#resource-random_stringsecured_suffix)
      - [Resource: `google_storage_bucket.secured_bucket`](#resource-google_storage_bucketsecured_bucket)
      - [Resource: `google_storage_bucket_object.secured_object`](#resource-google_storage_bucket_objectsecured_object)
    - [STANDARD PERIMETER ENVIRONMENT](#standard-perimeter-environment)
      - [Resource: `random_string.standard_suffix`](#resource-random_stringstandard_suffix)
      - [Resource: `google_storage_bucket.standard_bucket`](#resource-google_storage_bucketstandard_bucket)
      - [Resource: `google_storage_bucket_object.standard_object`](#resource-google_storage_bucket_objectstandard_object)
- [compute.tf](#computetf)
    - [SERVICE PERIMETER ENVIRONMENT](#service-perimeter-environment-1)
      - [Resource: `random_string.compute_secured_suffix`](#resource-random_stringcompute_secured_suffix)
      - [Module: `module.secured_instance_1`](#module-modulesecured_instance_1)
    - [STANDARD PERIMETER ENVIRONMENT](#standard-perimeter-environment-1)
      - [Module: `module.standard_instance_1`](#module-modulestandard_instance_1)
- [dns.tf](#dnstf)
    - [Resource: `google_dns_managed_zone.private_zone`](#resource-google_dns_managed_zoneprivate_zone)
    - [Resource: `google_dns_record_set.private_google`](#resource-google_dns_record_setprivate_google)
    - [Resource: `google_dns_record_set.public_cname`](#resource-google_dns_record_setpublic_cname)
- [firewall.tf](#firewalltf)
    - [SERVICE PERIMETER ENVIRONMENT (Secured Network)](#service-perimeter-environment-secured-network)
      - [Resource: `google_compute_firewall.demo_deny_egress`](#resource-google_compute_firewalldemo_deny_egress)
      - [Resource: `google_compute_firewall.demo_deny_ingress`](#resource-google_compute_firewalldemo_deny_ingress)
      - [Resource: `google_compute_firewall.demo_allow_ssh`](#resource-google_compute_firewalldemo_allow_ssh)
      - [Resource: `google_compute_firewall.demo_allow_ssh_external`](#resource-google_compute_firewalldemo_allow_ssh_external)
      - [Resource: `google_compute_firewall.demo_allow_apis`](#resource-google_compute_firewalldemo_allow_apis)
    - [STANDARD PERIMETER ENVIRONMENT](#standard-perimeter-environment-2)
      - [Resource: `google_compute_firewall.demo_allow_std_ssh`](#resource-google_compute_firewalldemo_allow_std_ssh)
- [folder.tf](#foldertf)
    - [Resource: `google_folder.secured_folder`](#resource-google_foldersecured_folder)
- [iam-binding.tf](#iam-bindingtf)
    - [Locals Block](#locals-block)
    - [SERVICE PERIMETER ENVIRONMENT - IAM Bindings](#service-perimeter-environment---iam-bindings)
      - [Resource: `google_project_iam_member.sa_sec_storage_admin`](#resource-google_project_iam_membersa_sec_storage_admin)
    - [STANDARD PERIMETER ENVIRONMENT - IAM Bindings](#standard-perimeter-environment---iam-bindings)
      - [Resource: `google_project_iam_member.sa_std_storage_admin`](#resource-google_project_iam_membersa_std_storage_admin)
- [network.tf](#networktf)
    - [SERVICE PERIMETER ENVIRONMENT (Secured Network)](#service-perimeter-environment-secured-network-1)
      - [Module: `secured_vpc`](#module-secured_vpc)
      - [Resource: `google_compute_network_peering.peering_secured_to_standard`](#resource-google_compute_network_peeringpeering_secured_to_standard)
    - [STANDARD PERIMETER ENVIRONMENT (Standard Network)](#standard-perimeter-environment-standard-network)
      - [Module: `standard_vpc`](#module-standard_vpc)
      - [Resource: `google_compute_network_peering.peering_standard_to_secured`](#resource-google_compute_network_peeringpeering_standard_to_secured)
- [output.tf](#outputtf)
    - [SERVICE PERIMETER ENVIRONMENT Outputs](#service-perimeter-environment-outputs)
      - [Output: `secured_instance`](#output-secured_instance)
      - [Output: `secured_bucket`](#output-secured_bucket)
    - [STANDARD PERIMETER ENVIRONMENT Outputs](#standard-perimeter-environment-outputs)
      - [Output: `standard_instance`](#output-standard_instance)
      - [Output: `standard_bucket`](#output-standard_bucket)
- [project.tf](#projecttf)
    - [SERVICE PERIMETER ENVIRONMENT - Secured Compute Project](#service-perimeter-environment---secured-compute-project)
      - [Module: `prj_sec_compute`](#module-prj_sec_compute)
    - [SERVICE PERIMETER ENVIRONMENT - Secured Storage Project](#service-perimeter-environment---secured-storage-project)
      - [Module: `prj_sec_storage`](#module-prj_sec_storage)
    - [STANDARD PERIMETER ENVIRONMENT - Standard Testing Project](#standard-perimeter-environment---standard-testing-project)
      - [Module: `prj_std_testing`](#module-prj_std_testing)
- [terraform.tfvars.example](#terraformtfvarsexample)
- [vpc-sc.tf](#vpc-sctf)
    - [Data Source: `google_project.api_project`](#data-source-google_projectapi_project)
    - [Resource: `google_access_context_manager_service_perimeter.service_perimeter`](#resource-google_access_context_manager_service_perimeterservice_perimeter)
    - [Resource: `time_sleep.vpc_sc_destroy_wait_300_seconds`](#resource-time_sleepvpc_sc_destroy_wait_300_seconds)



# Access context.tf
> [!NOTE]
> **Purpose:** This Terraform code defines an Access Context Manager (ACM) policy and an access level within Google Cloud Platform (GCP). The overall goal is to create a rule (`access level`) that defines specific conditions (like originating IP addresses) under which access to GCP resources should be granted. This access level can then be used, for example, in VPC Service Controls perimeters to enforce network-based access restrictions.

---

### Resource: `google_access_context_manager_access_policy`

This resource creates an Access Policy, which acts as a container for Access Levels and Service Perimeters within your GCP organization or folder.

*   **`parent`**: `organizations/${var.org_id}`
    *   **Purpose**: Specifies the GCP Organization where this Access Policy will reside. Access Policies are typically created at the organization level.
*   **`scopes`**: `["folders/${var.parent_folder}"]`
    *   **Purpose**: Defines the scope of resources this policy *can* apply to. In this case, it's limited to the resources within the specified GCP folder (`var.parent_folder`).
    > [!TIP]
    > Scoping the policy to a folder means that Service Perimeters created under this policy can only protect resources within that specific folder or its descendants. Access Levels, however, can still be referenced by perimeters outside this scope if needed.
*   **`title`**: `"UseCase - VPC SC Policy"`
    *   **Purpose**: A human-readable name for the Access Policy, making it easier to identify in the GCP console or via API/gcloud commands.

---

### Resource: `google_access_context_manager_access_level`

This resource defines an Access Level, which represents a set of conditions that must be met for a request to be considered compliant or trusted.

*   **`parent`**: `accessPolicies/${google_access_context_manager_access_policy.folder_policy.name}`
    *   **Purpose**: Links this Access Level to the previously defined Access Policy (`folder_policy`). It specifies that this level belongs *within* that policy container.
*   **`name`**: `accessPolicies/${google_access_context_manager_access_policy.folder_policy.name}/accessLevels/secured_access_level`
    *   **Purpose**: The unique, fully qualified identifier for this Access Level within GCP. It follows a specific format including the policy name.
*   **`title`**: `"secured_access_level"`
    *   **Purpose**: A human-readable name for the Access Level.
*   **`basic`**:
    *   **Purpose**: Defines a basic Access Level, which consists of one or more conditions that must *all* be met (`AND` logic).
*   **`conditions`**:
    *   **Purpose**: A block containing the specific criteria for this Access Level.
*   **`ip_subnetworks`**: `concat(...)`
    *   **Purpose**: Specifies a list of allowed IPv4 and IPv6 address ranges (CIDR blocks) from which requests must originate to satisfy this condition.
    *   **Details**: It combines a hardcoded list (`"35.235.240.0/20"`, `"2600:1900::/28"`) (GCP IP) with a list provided by the Terraform variable `var.personal_ip` using the `concat` function.
    > [!IMPORTANT]
    > This is the core restriction defined by this Access Level. Only requests originating from IPs within these specified ranges (including those in `var.personal_ip`) will satisfy this condition. This is commonly used to restrict access to corporate networks or specific Bastion host IPs.
*   **`regions`**: (Commented out)
    *   **Purpose**: If uncommented, this would add another condition requiring the request to originate from specific geographic regions (e.g., `"FR"` for France). Since it's commented out, it currently has no effect.
    > [!WARNING]
    > Relying solely on region codes for security can be imprecise as geolocation databases might not always be perfectly accurate or up-to-date. IP subnetworks provide a more direct network-level control.

---

In summary, this configuration sets up the foundation for network-based access control within a specific GCP folder, defining a reusable "secured access level" that permits access only from a defined set of IP addresses.

# bucket.tf 

> [!NOTE]
> **Purpose:** This Terraform code defines resources for two distinct environments within Google Cloud: one intended to be secured (likely by a VPC Service Controls perimeter) and another standard environment (presumably for testing or less sensitive data). Both environments involve creating a Google Cloud Storage (GCS) bucket and uploading an object to it.

---

### SERVICE PERIMETER ENVIRONMENT

This section sets up resources intended to reside within a more secure context, potentially enforced by a VPC Service Controls perimeter later in the configuration.

#### Resource: `random_string.secured_suffix`

*   **Purpose**: Generates a short, random string of lowercase letters. This is used to ensure the GCS bucket name created below is unique, preventing naming conflicts.
*   **`length`**: `4` - The generated string will be 4 characters long.
*   **`special`**: `false` - The string will not contain special characters (like `!@#$%^&*()`).
*   **`upper`**: `false` - The string will only contain lowercase letters.

#### Resource: `google_storage_bucket.secured_bucket`

*   **Purpose**: Creates a Google Cloud Storage bucket intended to hold sensitive or secured data. This bucket is likely meant to be included within a VPC Service Controls perimeter.
*   **`name`**: `"${var.bucket_prefix}-${var.security_prefix}-enforced-${random_string.secured_suffix.result}"`
    *   **Purpose**: Defines the globally unique name for the bucket.
    *   **Details**: It constructs the name by combining:
        *   `var.bucket_prefix` (default: "bkt")
        *   `var.security_prefix` (default: "sec")
        *   The literal string "-enforced-"
        *   The random string generated by `random_string.secured_suffix`.
        *   Example Name: `bkt-sec-enforced-abcd` (where `abcd` is the random suffix).
*   **`force_destroy`**: `var.bucket_force_destroy` (default: `true`)
    *   **Purpose**: Controls bucket deletion behavior.
    *   **Details**: If `true`, Terraform will delete all objects within the bucket when the bucket itself is destroyed. If `false` (and the bucket contains objects), Terraform will fail to delete the bucket. The default `true` is convenient for ephemeral test environments but should be used cautiously in production.
    > [!WARNING]
    > Setting `force_destroy` to `true` can lead to data loss if applied incorrectly in production environments.
*   **`location`**: `var.default_region` (default: "europe-west1")
    *   **Purpose**: Specifies the geographical location where the bucket's data will be stored.
*   **`storage_class`**: `"STANDARD"`
    *   **Purpose**: Sets the default storage class for objects uploaded to this bucket. `STANDARD` is suitable for frequently accessed data.
*   **`versioning`**: `{ enabled = true }`
    *   **Purpose**: Enables object versioning for the bucket. This keeps previous versions of objects when they are overwritten or deleted, providing a safety net against accidental data loss or modification.
*   **`project`**: `module.prj_sec_storage.project_id`
    *   **Purpose**: Specifies the Google Cloud Project ID where this bucket will be created. It references the output `project_id` from a Terraform module named `prj_sec_storage` (presumably defined elsewhere in the configuration), indicating this bucket belongs to a dedicated "security storage" project.

#### Resource: `google_storage_bucket_object.secured_object`

*   **Purpose**: Uploads a file as an object into the `secured_bucket`.
*   **`name`**: `"secured_document.txt"` - The name the object will have inside the bucket.
*   **`bucket`**: `google_storage_bucket.secured_bucket.name` - Specifies the target bucket created in the previous step.
*   **`source`**: `"./generated_content/secured_document.txt"` - The local path to the file that will be uploaded. Terraform will read this file from the specified path relative to the Terraform configuration's root directory.

---

### STANDARD PERIMETER ENVIRONMENT

This section sets up resources for a standard environment, potentially outside strict perimeter controls or used for general testing.

#### Resource: `random_string.standard_suffix`

*   **Purpose**: Similar to `secured_suffix`, generates a unique 4-character lowercase string for the standard bucket name.
*   **Attributes**: `length=4`, `special=false`, `upper=false`.

#### Resource: `google_storage_bucket.standard_bucket`

*   **Purpose**: Creates a GCS bucket for standard use cases or testing.
*   **`name`**: `"${var.bucket_prefix}-${var.standard_prefix}-standard-${random_string.standard_suffix.result}"`
    *   **Purpose**: Defines the bucket name using prefixes and the random suffix.
    *   **Details**: Combines:
        *   `var.bucket_prefix` (default: "bkt")
        *   `var.standard_prefix` (default: "std")
        *   The literal string "-standard-"
        *   The random string from `random_string.standard_suffix`.
        *   Example Name: `bkt-std-standard-wxyz`
*   **`force_destroy`**: `var.bucket_force_destroy` (default: `true`) - Same behavior as for the secured bucket.
*   **`location`**: `var.default_region` (default: "europe-west1") - Same location as the secured bucket by default.
*   **`storage_class`**: `"STANDARD"` - Same default storage class.
*   **`versioning`**: `{ enabled = true }` - Object versioning is also enabled here.
*   **`project`**: `module.prj_std_testing.project_id`
    *   **Purpose**: Specifies the GCP Project ID for this bucket. It references the output from a different module, `prj_std_testing`, indicating this bucket belongs to a separate "standard testing" project.

#### Resource: `google_storage_bucket_object.standard_object`

*   **Purpose**: Uploads a file into the `standard_bucket`.
*   **`name`**: `"standard_document.txt"` - The name of the object in the bucket.
*   **`bucket`**: `google_storage_bucket.standard_bucket.name` - The target standard bucket.
*   **`source`**: `"./generated_content/standard_document.txt"` - The local path to the file to upload.

---

In summary, this code block provisions two separate GCS buckets, each in a different project (implied by `module.prj_sec_storage` and `module.prj_std_testing`) and uploads a distinct file to each. The naming conventions (`security_prefix` vs. `standard_prefix`) and project separation suggest they serve different purposes related to security posture and potential VPC Service Controls application.

# compute.tf 

> [!NOTE]
> **Purpose:** This Terraform code defines two Google Compute Engine (GCE) virtual machine instances using a reusable custom module located at `./modules/vm_creation`. One instance is designated for a "secured" environment (likely intended to be protected by VPC Service Controls and accessed via IAP), and the other is for a "standard" environment (potentially with different access patterns).

---

### SERVICE PERIMETER ENVIRONMENT

This section provisions a VM intended to operate within the secured environment.

#### Resource: `random_string.compute_secured_suffix`

*   **Purpose**: Generates a 4-character random lowercase string. This is used to ensure the VM instance name is unique.
*   **Attributes**: `length=4`, `special=false`, `upper=false`.

#### Module: `module.secured_instance_1`

*   **Purpose**: Creates a GCE VM instance using the custom module `./modules/vm_creation`.
*   **`source`**: `"./modules/vm_creation"` - Specifies the path to the reusable module code defining how to create a VM.
*   **`instance_name`**: `"${var.security_prefix}-${random_string.compute_secured_suffix.result}"`
    *   **Purpose**: Sets the name of the VM instance.
    *   **Details**: Combines the `var.security_prefix` (default: "sec") with the random suffix. Example: `sec-xzyw`.
*   **`instance_env`**: `"eu"` - Likely a tag or label passed to the module for organizational purposes within the VM or related resources.
*   **`machine_type`**: `"e2-small"` - Specifies the size and family of the VM (e.g., CPU, memory). `e2-small` is a cost-effective, smaller instance type.
*   **`subnet_uri`**: `"projects/${module.prj_sec_compute.project_id}/regions/${var.default_region}/subnetworks/${var.subnet_prefix}-${var.security_prefix}-euw1-compute"`
    *   **Purpose**: Defines the specific Virtual Private Cloud (VPC) subnet the VM's network interface will connect to.
    *   **Details**: This dynamically constructs the full subnet URI, indicating the VM resides within the project managed by `module.prj_sec_compute` (presumably a dedicated "security compute" project), in the `var.default_region`, and on a subnet named according to the convention (e.g., `sb-sec-euw1-compute`).
*   **`network_tags`**: `["allow-iap-ssh", "allow-dns-google"]`
    *   **Purpose**: Assigns network tags to the VM instance. These tags are used by VPC firewall rules to control traffic.
    *   **Details**:
        *   `allow-iap-ssh`: Critical for enabling SSH access via Google's Identity-Aware Proxy (IAP). This allows connection without requiring a public IP address on the VM, enhancing security. A corresponding firewall rule allowing TCP traffic on port 22 from IAP's IP range (`35.235.240.0/20`) to instances with this tag is required.
        *   `allow-dns-google`: Likely used by a firewall rule to permit outbound traffic on UDP port 53 to Google's public DNS servers, allowing the VM to resolve domain names.
*   **`project_id`**: `module.prj_sec_compute.project_id` - Explicitly specifies the target project for VM creation, aligning with the subnet's project.
*   **`iap_binding_member`**: `var.authorized_member`
    *   **Purpose**: This input likely instructs the module to grant the specified user or group (`var.authorized_member`, e.g., `user:example@example.com`) the necessary IAM permissions (typically `roles/iap.tunnelResourceAccessor`) on *this specific VM instance* to allow them to connect via IAP.
*   **`instance_region`**: `var.default_region` (default: "europe-west1") - Specifies the GCP region where the VM instance will be created.
*   **`public_access`**: `false`
    *   **Purpose**: Explicitly configures the VM instance to *not* have an external (public) IP address. This is consistent with the secure access pattern using IAP.
*   **`depends_on`**: `[module.secured_vpc]`
    *   **Purpose**: Creates an explicit dependency. Terraform will ensure that the resources defined within the `module.secured_vpc` (presumably the VPC network and subnet) are successfully created *before* attempting to create this VM instance.

---

### STANDARD PERIMETER ENVIRONMENT

This section provisions a VM for the standard environment.

#### Module: `module.standard_instance_1`

*   **Purpose**: Creates another GCE VM instance using the same custom module `./modules/vm_creation`.
*   **`source`**: `"./modules/vm_creation"` - Reuses the same module definition.
*   **`instance_name`**: `"${var.standard_prefix}-${random_string.compute_secured_suffix.result}"`
    *   **Purpose**: Sets the name of the VM instance.
    *   **Details**: Combines `var.standard_prefix` (default: "std") with the *same* random suffix used for the secured instance. Example: `std-xzyw`. While technically allowed because they are in different projects, using separate random strings might be clearer if distinctness is paramount.
*   **`instance_env`**: `"eu"` - Same organizational tag.
*   **`machine_type`**: `"e2-small"` - Same machine type.
*   **`subnet_uri`**: `"projects/${module.prj_std_testing.project_id}/regions/${var.default_region}/subnetworks/${var.subnet_prefix}-${var.standard_prefix}-euw1-compute"`
    *   **Purpose**: Connects the VM to a different subnet.
    *   **Details**: This subnet resides in the project managed by `module.prj_std_testing` (presumably a "standard testing" project) and follows the standard naming convention (e.g., `sb-std-euw1-compute`).
*   **`network_tags`**: `["allow-std-ssh"]`
    *   **Purpose**: Assigns a different network tag.
    *   **Details**: The tag `allow-std-ssh` implies a potentially different mechanism for SSH access compared to the secured instance. It likely corresponds to a firewall rule specific to the standard environment (e.g., allowing SSH from specific jump hosts or internal ranges, *not* necessarily IAP).
*   **`project_id`**: `module.prj_std_testing.project_id` - Specifies the "standard testing" project for this VM.
*   **`iap_binding_member`**: `var.authorized_member`
    *   **Purpose**: Passes the same authorized member variable. The module might still attempt to create an IAP IAM binding.
    > [!WARNING]
    > Although an IAP binding might be created via `iap_binding_member`, actual IAP access likely won't work for this instance unless the `allow-iap-ssh` network tag *and* the corresponding IAP firewall rule are also applied. The current configuration relies on the `allow-std-ssh` tag/rule for access.
*   **`instance_region`**: `var.default_region` - Same region.
*   **`public_access`**: *Not specified*.
    *   **Purpose**: The module's default behavior for assigning public IP addresses will apply. If the module defaults to `false`, it won't have a public IP. If it defaults to `true` or doesn't manage the IP allocation explicitly (relying on subnet settings), it might get one.
*   **`depends_on`**: `[module.standard_vpc]` - Ensures the standard VPC network infrastructure exists before creating this VM.

---

In summary, this code uses a custom module to efficiently create two VMs in separate projects and networks, applying distinct network tags (`allow-iap-ssh` vs. `allow-std-ssh`) to facilitate different access control patterns suitable for "secured" and "standard" environments respectively. The secured instance is explicitly configured for IAP access without a public IP.


# dns.tf

> [!NOTE]
> **Purpose:** This Terraform code configures Google Cloud DNS resources to enable Private Google Access for Google APIs within the `secured_vpc` network. It directs API requests from within that specific VPC to Google's restricted VIP (Virtual IP) addresses, allowing communication with APIs without traffic leaving Google's network backbone. This is a common pattern used in conjunction with VPC Service Controls and VMs that lack external IP addresses.

---

### Resource: `google_dns_managed_zone.private_zone`

*   **Purpose**: Creates a private Cloud DNS managed zone. This zone will host custom DNS records specifically for the `secured_vpc` network.
*   **`name`**: `"private-google-api"` - An internal identifier for this managed zone resource within Terraform and GCP.
*   **`dns_name`**: `"googleapis.com."`
    *   **Details**: Specifies the DNS suffix that this zone is authoritative for. The trailing dot (`.`) is significant, indicating the root of this domain segment. This zone will handle DNS queries for names ending in `googleapis.com.` originating from the associated network.
*   **`description`**: `"Private DNS to Google API"` - A human-readable description of the zone's purpose.
*   **`project`**: `module.prj_sec_compute.project_id` - Specifies that this Cloud DNS zone resource will be created within the `prj_sec_compute` project.
*   **`visibility`**: `"private"`
    *   **Details**: This is **critical**. It designates the zone as private, meaning its records can only be resolved by resources within the VPC networks explicitly associated with it via `private_visibility_config`. It won't be resolvable from the public internet.
*   **`private_visibility_config`**:
    *   **Purpose**: Defines which VPC networks can resolve records within this private zone.
    *   **`networks { network_url = module.secured_vpc.network_id }`**: Explicitly attaches this private zone to the `secured_vpc` network created earlier. Only resources within `secured_vpc` will use the records defined in this zone for `googleapis.com.` lookups.

---

### Resource: `google_dns_record_set.private_google`

*   **Purpose**: Creates a specific DNS 'A' record within the `private_zone` for `restricted.googleapis.com`. This points directly to the restricted VIP addresses.
*   **`name`**: `"restricted.${google_dns_managed_zone.private_zone.dns_name}"`
    *   **Details**: Constructs the fully qualified domain name (FQDN) for the record: `restricted.googleapis.com.`.
*   **`type`**: `"A"` - Specifies this is an Address record, mapping a hostname to IPv4 addresses.
*   **`ttl`**: `300` - Sets the Time-To-Live for this record to 300 seconds (5 minutes). DNS resolvers will cache this record for this duration.
*   **`project`**: `module.prj_sec_compute.project_id` - The project where this record set resource lives.
*   **`managed_zone`**: `google_dns_managed_zone.private_zone.name` - Links this record set to the `private_zone` created above.
*   **`rrdatas`**: `["199.36.153.4", "199.36.153.5", "199.36.153.6", "199.36.153.7"]`
    *   **Details**: Provides the list of IPv4 addresses associated with the `restricted.googleapis.com` hostname. These specific IPs route traffic to Google APIs over Google's private network backbone.

---

### Resource: `google_dns_record_set.public_cname`

*   **Purpose**: Creates a wildcard 'CNAME' record within the `private_zone`. This record acts as an alias, directing *any* request for `*.googleapis.com` (that doesn't have a more specific record in this zone) to resolve to `restricted.googleapis.com`.
*   **`name`**: `"*.${google_dns_managed_zone.private_zone.dns_name}"`
    *   **Details**: Constructs the wildcard FQDN: `*.googleapis.com.`. The `*` matches any single label (e.g., `storage`, `compute`, `logging`).
*   **`managed_zone`**: `google_dns_managed_zone.private_zone.name` - Links this record set to the `private_zone`.
*   **`type`**: `"CNAME"` - Specifies this is a Canonical Name record, essentially an alias pointing one domain name to another.
*   **`ttl`**: `300` - Sets the Time-To-Live to 5 minutes.
*   **`rrdatas`**: `["restricted.${google_dns_managed_zone.private_zone.dns_name}"]`
    *   **Details**: Specifies the target of the alias. Any query matching `*.googleapis.com.` within the `secured_vpc` will be directed to resolve `restricted.googleapis.com.` instead.
*   **`project`**: `module.prj_sec_compute.project_id` - The project where this record set resource lives.

---

> [!NOTE]
> **Overall Effect:**
> 1.  A private DNS zone for `googleapis.com.` is created and made visible *only* to the `secured_vpc` network.
> 2.  Within this private zone, `restricted.googleapis.com.` is explicitly mapped to the required restricted VIP IPs (`199.36.153.4-7`).
> 3.  A wildcard CNAME record ensures that any other request to a `googleapis.com` subdomain (e.g., `storage.googleapis.com`, `compute.googleapis.com`) made from within `secured_vpc` is first redirected to `restricted.googleapis.com.` and then resolved to the restricted VIPs.
>
> This configuration forces all Google API traffic originating from the `secured_vpc` to use the private network path via the restricted VIPs, satisfying requirements for Private Google Access and often complementing VPC Service Controls implementations.

# firewall.tf

> [!NOTE]
> **Purpose:** This Terraform code defines a set of Google Cloud VPC firewall rules for both the "Secured" and "Standard" environments. Firewall rules control traffic flow to and from VM instances within a VPC network based on specified criteria like direction, source/destination IPs, protocols, ports, and target tags.

---

### SERVICE PERIMETER ENVIRONMENT (Secured Network)

This section defines firewall rules for the VPC network associated with the secured environment (`module.secured_vpc`), residing in the security compute project (`module.prj_sec_compute`). It implements a "deny by default" security posture for egress and ingress traffic, explicitly allowing only necessary connections.

#### Resource: `google_compute_firewall.demo_deny_egress`

*   **Purpose**: Blocks *all* outgoing (egress) traffic from any instance in the `secured_vpc` network by default.
*   **`name`**: `"${var.firewall_prefix}-demo-egress-deny-all"` (e.g., `fw-demo-egress-deny-all`) - Identifier for the rule.
*   **`network`**: `module.secured_vpc.network_name` - Applies to the secured VPC network.
*   **`project`**: `module.prj_sec_compute.project_id` - Rule resides in the security compute project.
*   **`destination_ranges`**: `["0.0.0.0/0"]` - Matches any destination IP address.
*   **`priority`**: `65535` - The lowest possible priority. Firewall rules are evaluated from lowest priority number (highest precedence) to highest priority number (lowest precedence). This rule acts as a catch-all denial if no higher-priority `allow` rule matches.
*   **`direction`**: `"EGRESS"` - Applies to traffic leaving VM instances.
*   **`deny`**: `{ protocol = "all" }` - Specifies the action is to DENY traffic for all protocols.

#### Resource: `google_compute_firewall.demo_deny_ingress`

*   **Purpose**: Blocks *all* incoming (ingress) traffic to any instance in the `secured_vpc` network by default.
*   **`name`**: `"${var.firewall_prefix}-demo-ingress-deny-all"` (e.g., `fw-demo-ingress-deny-all`)
*   **`network`**: `module.secured_vpc.network_name`
*   **`project`**: `module.prj_sec_compute.project_id`
*   **`source_ranges`**: `["0.0.0.0/0"]` - Matches any source IP address.
*   **`priority`**: `65535` - Lowest priority, acts as a catch-all ingress denial.
*   **`direction`**: `"INGRESS"` - Applies to traffic arriving at VM instances.
*   **`deny`**: `{ protocol = "all" }` - Denies all protocols.

> [!IMPORTANT]
> The combination of `demo_deny_egress` and `demo_deny_ingress` establishes a highly restrictive default network policy. No traffic is allowed in or out unless explicitly permitted by a higher-priority (lower number) rule.

#### Resource: `google_compute_firewall.demo_allow_ssh`

*   **Purpose**: Allows incoming SSH traffic (TCP port 22) specifically from Google's Identity-Aware Proxy (IAP) service to VMs tagged with `allow-iap-ssh`. This enables secure SSH access without exposing VMs directly to the internet.
*   **`name`**: `"${var.firewall_prefix}-demo-ingress-allow-ssh"`
*   **`network`**: `module.secured_vpc.network_name`
*   **`project`**: `module.prj_sec_compute.project_id`
*   **`source_ranges`**: `["35.235.240.0/20"]` - This is Google's documented IP range used by IAP for TCP forwarding.
*   **`target_tags`**: `["allow-iap-ssh"]` - Applies this rule *only* to VM instances that have this network tag (like `module.secured_instance_1`).
*   **`priority`**: `1000` - A higher priority (lower number) than the default deny rules, ensuring this `allow` rule takes precedence for matching traffic.
*   **`direction`**: `"INGRESS"`
*   **`allow`**: `{ protocol = "tcp", ports = ["22"] }` - Specifies the action is to ALLOW TCP traffic on port 22.

#### Resource: `google_compute_firewall.demo_allow_ssh_external` 

*   **Purpose**: Allows *outgoing* (egress) SSH traffic (TCP port 22) from VMs tagged with `allow-iap-ssh` to a specific private IP range (`172.16.0.0/24`). This might be intended to allow the secured VM to SSH into other internal resources within that range.
*   **`name`**: `"${var.firewall_prefix}-demo-egress-allow-ssh"`
*   **`network`**: `module.secured_vpc.network_name`
*   **`project`**: `module.prj_sec_compute.project_id`
*   **`destination_ranges`**: `["172.16.0.0/24"]` - Matches destination IPs within this private range.
*   **`target_tags`**: `["allow-iap-ssh"]` - Applies only to VMs with this tag initiating the connection.
*   **`priority`**: `1000` - Higher priority than the default deny egress rule.
*   **`direction`**: `"EGRESS"`
*   **`allow`**: `{ protocol = "tcp", ports = ["22"] }` - Allows TCP traffic on port 22.

#### Resource: `google_compute_firewall.demo_allow_apis`

*   **Purpose**: Allows outgoing (egress) traffic on TCP ports 53 (DNS) and 443 (HTTPS) from VMs tagged with `allow-dns-google` to specific Google IP ranges. This is crucial for VMs to resolve DNS using Google's servers and to access Google APIs (which typically use HTTPS over restricted.googleapis.com or private.googleapis.com).
*   **`name`**: `"${var.firewall_prefix}-demo-egress-allow-apis"`
*   **`description`**: "Allow ingress DNS" (Typo: Should be Egress APIs/DNS)
*   **`network`**: `module.secured_vpc.network_name`
*   **`project`**: `module.prj_sec_compute.project_id`
*   **`destination_ranges`**: `["199.36.153.4/30", "34.126.0.0/18"]`
    *   `199.36.153.4/30`: IP range for `restricted.googleapis.com`.
    *   `34.126.0.0/18`: IP range for `restricted.googleapis.com`. These allow access to Google APIs without traffic leaving Google's network, essential for VPC Service Controls.
*   **`target_tags`**: `["allow-dns-google"]` - Applies only to VMs with this tag (like `module.secured_instance_1`).
*   **`priority`**: `1000` - Higher priority than the default deny egress rule.
*   **`direction`**: `"EGRESS"`
*   **`allow`**: `{ protocol = "tcp", ports = ["53", "443"] }` - Allows TCP traffic on ports 53 and 443.
*   **Commented Out UDP Allow**: The commented-out `allow` block for UDP port 53 suggests that while DNS often uses UDP, this configuration currently restricts DNS lookups via Google APIs to TCP only. This might work for some scenarios but could cause issues if UDP DNS is required.

---

### STANDARD PERIMETER ENVIRONMENT

This section defines a single firewall rule for the standard environment's VPC network (`module.standard_vpc`) in the standard testing project (`module.prj_std_testing`). It takes a more permissive approach for SSH compared to the secured environment.

#### Resource: `google_compute_firewall.demo_allow_std_ssh`

*   **Purpose**: Allows incoming SSH traffic (TCP port 22) from *any* source IP address to VMs tagged with `allow-std-ssh`.
*   **`name`**: `"${var.firewall_prefix}-demo-ingress-allow-ssh"`
    > [!NOTE]
    > This rule has the same *base name* as the IAP SSH rule in the secured environment (`fw-demo-ingress-allow-ssh`). While allowed because they are in different projects/networks, using distinct names (e.g., `fw-demo-ingress-allow-std-ssh`) might improve clarity.
*   **`network`**: `module.standard_vpc.network_name` - Applies to the standard VPC network.
*   **`project`**: `module.prj_std_testing.project_id` - Rule resides in the standard testing project.
*   **`source_ranges`**: `["0.0.0.0/0"]` - Allows connections from any IP address on the internet or internal networks.
    > [!WARNING]
    > Allowing SSH from `0.0.0.0/0` is generally considered insecure for production environments. It exposes the SSH port on tagged VMs to the entire internet. This might be acceptable for a transient test environment but should be restricted (e.g., to specific bastion host IPs or internal ranges) otherwise.
*   **`target_tags`**: `["allow-std-ssh"]` - Applies only to VMs with this tag (like `module.standard_instance_1`).
*   **`priority`**: `1000` - Standard priority for allow rules. Note that there are no explicit `deny` rules shown for the standard network, so it likely relies on GCP's default implicit deny or potentially other lower-priority allow rules not shown here.
*   **`direction`**: `"INGRESS"`
*   **`allow`**: `{ protocol = "tcp", ports = ["22"] }` - Allows TCP traffic on port 22.

---

In summary, the secured environment employs a strict "deny all, allow specific" firewall strategy heavily reliant on IAP for access and restricted Google API endpoints. The standard environment uses a more open firewall configuration, particularly for SSH access, which is less secure but potentially simpler for basic testing scenarios.

# folder.tf

> [!NOTE]
> **Purpose:** This Terraform code defines and creates a Google Cloud Folder resource. Folders are used within a GCP Organization to group projects and other folders, allowing for hierarchical organization and application of policies (IAM, Organization Policies, potentially VPC Service Controls scope).

---

### Resource: `google_folder.secured_folder`

This resource block provisions a new folder within your GCP organization structure.

*   **`display_name`**: `"${var.folder_prefix}-secured"`
    *   **Purpose**: Sets the human-readable name for the folder as it will appear in the Google Cloud Console and when listed via gcloud/API.
    *   **Details**: The name is constructed by concatenating the value of the `var.folder_prefix` variable (default: "fldr") with the literal string "-secured".
    *   **Example Name**: If `var.folder_prefix` is "fldr", the display name will be `fldr-secured`.
*   **`parent`**: `"folders/${var.parent_folder}"`
    *   **Purpose**: Specifies the hierarchical placement of this new folder within your GCP resource hierarchy. It dictates which existing folder or organization this new folder will reside directly under.
    *   **Details**: It requires the ID of an existing folder passed via the `var.parent_folder` variable. The format `folders/FOLDER_ID` is the standard way to reference a parent folder in GCP resource names.
*   **`deletion_protection`**: `false`
    *   **Purpose**: Controls whether the folder is protected against accidental deletion.
    *   **Details**: When set to `false` (the default), the folder can be deleted using standard API calls or `terraform destroy` without additional steps, provided it's empty or permissions allow. Setting this to `true` prevents the folder from being easily deleted, requiring the flag to be disabled first.
    > [!TIP]
    > For production environments, enabling deletion protection (`true`) is often recommended as a safety measure. For development or testing, `false` allows for easier cleanup.

---

In summary, this block creates a new organizational folder named like `fldr-secured` located directly under the folder specified by `var.parent_folder`. This folder is intended to group resources (like projects) related to the "secured" environment defined in previous blocks, making it easier to manage permissions and policies for those resources collectively. It could also be used as a scope for Access Context Manager policies or VPC Service Controls.

# iam-binding.tf

> [!NOTE]
> **Purpose:** This Terraform code defines Identity and Access Management (IAM) permissions, granting specific service accounts the `roles/storage.admin` role on different Google Cloud projects. It utilizes a `locals` block to define the service account emails and `for_each` loops to apply the permissions efficiently.

---

### Locals Block

This block defines a local map variable used to simplify referencing service account emails later in the code.

*   **`locals`**: A block for defining local values within the Terraform module.
*   **`sa_compute_email`**: A map where keys (`"sa1"`, `"sa2"`) provide simple identifiers and values contain the dynamically constructed email addresses of the *default Compute Engine service accounts* for two different projects (`prj_sec_compute` and `prj_std_testing`).
    *   **`"sa1" = "serviceAccount:${module.prj_sec_compute.project_number}-compute@developer.gserviceaccount.com"`**: Constructs the email for the default Compute Engine SA of the project managed by `module.prj_sec_compute`. Note the use of `project_number`, which is required for the default Compute SA email format.
    *   **`"sa2" = "serviceAccount:${module.prj_std_testing.project_number}-compute@developer.gserviceaccount.com"`**: Constructs the email for the default Compute Engine SA of the project managed by `module.prj_std_testing`.

> [!TIP]
> The default Compute Engine service account is automatically created when the Compute Engine API is enabled in a project. VMs often run using this service account by default unless specified otherwise.

---

### SERVICE PERIMETER ENVIRONMENT - IAM Bindings

This section grants permissions *on* the **Security Storage Project** (`prj_sec_storage`).

#### Resource: `google_project_iam_member.sa_sec_storage_admin`

*   **Purpose**: Grants the `roles/storage.admin` role to specific service accounts on the `prj_sec_storage` project.
*   **`for_each`**: `tomap(local.sa_compute_email)`
    *   **Purpose**: Instructs Terraform to create multiple instances of this resource, one for each key-value pair in the `local.sa_compute_email` map.
    *   **Details**: It will create two `google_project_iam_member` bindings:
        1.  One for the service account from `prj_sec_compute`.
        2.  One for the service account from `prj_std_testing`.
*   **`project`**: `module.prj_sec_storage.project_id`
    *   **Purpose**: Specifies the target project where the IAM role binding will be applied. In this case, it's the project intended for secure storage.
*   **`role`**: `"roles/storage.admin"`
    *   **Purpose**: Defines the specific IAM role to be granted. `roles/storage.admin` provides full control over Google Cloud Storage resources (buckets and objects) within the target project.
*   **`member`**: `each.value`
    *   **Purpose**: Specifies the identity (user, group, or service account) receiving the role. `each.value` dynamically takes the service account email address from the current iteration of the `for_each` loop (e.g., `serviceAccount:PROJECT_NUMBER-compute@developer.gserviceaccount.com`).

> [!IMPORTANT]
> **Outcome**: This block grants *both* the default Compute SA from the **security compute project** *and* the default Compute SA from the **standard testing project** full admin permissions over storage resources within the **security storage project**. This allows VMs in either compute environment (running as their default SA) to manage buckets/objects in the `prj_sec_storage` project.

---

### STANDARD PERIMETER ENVIRONMENT - IAM Bindings

This section grants permissions *on* the **Standard Testing Project** (`prj_std_testing`).

#### Resource: `google_project_iam_member.sa_std_storage_admin`

*   **Purpose**: Grants the `roles/storage.admin` role to specific service accounts on the `prj_std_testing` project.
*   **`for_each`**: `tomap(local.sa_compute_email)`
    *   **Purpose**: Same as above, iterates over the two default Compute Engine service accounts defined in the `locals` block.
*   **`project`**: `module.prj_std_testing.project_id`
    *   **Purpose**: Specifies the target project for the IAM binding – the standard testing project itself.
*   **`role`**: `"roles/storage.admin"`
    *   **Purpose**: Grants full control over GCS resources within the target project.
*   **`member`**: `each.value`
    *   **Purpose**: Assigns the role to the service account email from the current loop iteration.

> [!IMPORTANT]
> **Outcome**: This block grants *both* the default Compute SA from the **security compute project** *and* the default Compute SA from the **standard testing project** full admin permissions over storage resources within the **standard testing project** itself. This allows VMs in either compute environment to manage buckets/objects in the `prj_std_testing` project.

---

In summary, this code configures cross-project permissions. It ensures that the default Compute Engine service accounts from both the dedicated security compute project and the standard testing project have administrative control over Cloud Storage resources located in *both* the dedicated security storage project and the standard testing project.

# network.tf

> [!NOTE]
> **Purpose:** This Terraform code defines the Virtual Private Cloud (VPC) network infrastructure for both the "Secured" and "Standard" environments. It utilizes the official `terraform-google-modules/network/google` module to create the networks and subnets, and then establishes a VPC Network Peering connection between them.

---

### SERVICE PERIMETER ENVIRONMENT (Secured Network)

This section defines the network resources for the secured compute environment.

#### Module: `secured_vpc`

*   **Purpose**: Creates the VPC network and associated subnet(s) for the secured environment within the security compute project (`prj_sec_compute`).
*   **`source`**: `"terraform-google-modules/network/google"`
    *   **Details**: Specifies the use of the well-maintained official Google Cloud network module for creating VPC resources.
*   **`version`**: `"~> 10.0"`
    *   **Details**: Pins the module version to the 10.x release line for stability.
*   **`project_id`**: `module.prj_sec_compute.project_id`
    *   **Details**: The VPC network will be created in the project managed by the `prj_sec_compute` module.
*   **`network_name`**: `"${var.vpc_prefix}-${var.security_prefix}"`
    *   **Details**: Assigns a name to the VPC network based on variables (e.g., `vpc-sec`).
*   **`routing_mode`**: `"GLOBAL"`
    *   **Details**: Enables dynamic routing exchange across all GCP regions for this VPC, allowing resources in different regions within this VPC to communicate without extra configuration.
*   **`auto_create_subnetworks`**: `false`
    *   **Details**: Prevents the automatic creation of default subnets in each region. Only explicitly defined subnets (in the `subnets` block) will be created, providing more control over IP addressing.
*   **`mtu`**: `1460`
    *   **Details**: Sets the Maximum Transmission Unit (MTU) for the network to 1460 bytes. This is the default and generally recommended value for compatibility.
*   **`subnets`**: `[...]`
    *   **Purpose**: Defines a list of custom subnets to create within this VPC.
    *   **Details**: Creates one subnet:
        *   **`subnet_name`**: `"${var.subnet_prefix}-${var.security_prefix}-euw1-compute"` (e.g., `sb-sec-euw1-compute`)
        *   **`subnet_ip`**: `"192.168.0.0/24"` - The primary IPv4 address range for this subnet.
        *   **`subnet_region`**: `var.default_region` (e.g., `europe-west1`) - The region where this subnet will reside.
        *   **`subnet_private_access`**: `"true"` - **Crucially enables Private Google Access** for this subnet. This allows VMs within this subnet that *do not* have external IP addresses to reach Google APIs and services (like Cloud Storage, Compute Engine APIs) using Google's internal network, which is often a requirement when using VPC Service Controls.

#### Resource: `google_compute_network_peering.peering_secured_to_standard`

*   **Purpose**: Defines one side of the VPC Network Peering connection. This resource initiates the peering configuration from the `secured_vpc` towards the `standard_vpc`.
*   **`name`**: `"npr-${var.security_prefix}-to-${var.standard_prefix}"` (e.g., `npr-sec-to-std`) - A name for the peering resource itself within GCP.
*   **`network`**: `module.secured_vpc.network_self_link` - References the network resource created by the `secured_vpc` module as the source network for this peering.
*   **`peer_network`**: `module.standard_vpc.network_self_link` - References the network resource created by the `standard_vpc` module as the target network to peer with.
*   **Key Attribute**: This resource alone does not activate the peering; a corresponding resource must be created on the `standard_vpc` pointing back to the `secured_vpc`.

---

### STANDARD PERIMETER ENVIRONMENT (Standard Network)

This section defines the network resources for the standard testing environment.

#### Module: `standard_vpc`

*   **Purpose**: Creates the VPC network and associated subnet(s) for the standard environment within the standard testing project (`prj_std_testing`).
*   **`source`**: `"terraform-google-modules/network/google"` - Uses the same module.
*   **`version`**: `"~> 10.0"`
*   **`project_id`**: `module.prj_std_testing.project_id` - Creates the network in the standard testing project.
*   **`network_name`**: `"${var.vpc_prefix}-${var.standard_prefix}"` (e.g., `vpc-std`)
*   **`routing_mode`**: `"GLOBAL"`
*   **`auto_create_subnetworks`**: `false`
*   **`mtu`**: `1460`
*   **`subnets`**: `[...]`
    *   **Purpose**: Defines the subnet for the standard network.
    *   **Details**: Creates one subnet:
        *   **`subnet_name`**: `"${var.subnet_prefix}-${var.standard_prefix}-euw1-compute"` (e.g., `sb-std-euw1-compute`)
        *   **`subnet_ip`**: `"172.16.0.0/24"` - **Important**: This IP range must not overlap with the ranges in the peered network (`192.168.0.0/24`).
        *   **`subnet_region`**: `var.default_region`
        *   **`subnet_private_access`**: Not specified, likely defaults to `false`. VMs in this subnet would need external IPs or a Cloud NAT gateway to reach Google APIs if Private Google Access is disabled.

#### Resource: `google_compute_network_peering.peering_standard_to_secured`

*   **Purpose**: Defines the *corresponding* side of the VPC Network Peering connection. This resource initiates the peering configuration from the `standard_vpc` back towards the `secured_vpc`.
*   **`name`**: `"npr-${var.security_prefix}-to-${var.standard_prefix}"` (e.g., `npr-sec-to-std`) - Typically matches the name defined from the other network's perspective for clarity.
*   **`network`**: `module.standard_vpc.network_self_link` - References the standard VPC as the source.
*   **`peer_network`**: `module.secured_vpc.network_self_link` - References the secured VPC as the target.
*   **Key Attribute**: When both this resource and `peering_secured_to_standard` are successfully created, the VPC Network Peering connection between `secured_vpc` and `standard_vpc` becomes `ACTIVE`. This allows resources in the two networks to communicate using internal IP addresses, as if they were part of the same network (subject to firewall rules in *both* networks).

---

> [!NOTE]
> This code sets up two distinct VPC networks in separate projects (`prj_sec_compute` and `prj_std_testing`) with non-overlapping subnet IP ranges (`192.168.0.0/24` and `172.16.0.0/24`). It enables Private Google Access for the secured subnet, facilitating access to Google APIs without external IPs, which is beneficial for VPC SC compliance. Finally, it establishes a bi-directional VPC Network Peering connection between these two networks, enabling direct internal IP communication between resources residing in them (e.g., allowing the secured VM to SSH into the standard VM via internal IP, provided firewall rules permit it).

# output.tf

 > [!NOTE]
> **Purpose:** This Terraform code defines `output` blocks. Outputs declare values that will be displayed to the user after Terraform successfully applies the configuration. They are useful for exposing resource identifiers (like names, IDs, IP addresses) or module outputs that might be needed for other operations, configuration, or reference.

---

### SERVICE PERIMETER ENVIRONMENT Outputs

These outputs expose details about resources created within the secured environment.

#### Output: `secured_instance`

*   **Purpose**: Makes information about the Google Compute Engine instance created by the `secured_instance_1` module available after deployment.
*   **`description`**: `"Instance Name"` - A human-readable description of what this output represents. (Note: The description is slightly misleading as the value contains more than just the name).
*   **`value`**: `module.secured_instance_1`
    *   **Details**: Exports the *entire set* of output values defined *within* the `./modules/vm_creation` module for the `secured_instance_1` instance. This could include the instance name, ID, network interface details, service account, etc., depending on what outputs the module itself defines.

#### Output: `secured_bucket`

*   **Purpose**: Makes the name of the Google Cloud Storage bucket created for the secured environment available after deployment.
*   **`description`**: `"Bucket name"` - A human-readable description.
*   **`value`**: `google_storage_bucket.secured_bucket.name`
    *   **Details**: Exports the dynamically generated, globally unique name of the `secured_bucket` GCS resource.

---

### STANDARD PERIMETER ENVIRONMENT Outputs

These outputs expose details about resources created within the standard environment.

#### Output: `standard_instance`

*   **Purpose**: Makes information about the Google Compute Engine instance created by the `standard_instance_1` module available after deployment.
*   **`description`**: `"Instance Name"` - A human-readable description. (Similar note as `secured_instance`: value is more than just the name).
*   **`value`**: `module.standard_instance_1`
    *   **Details**: Exports the *entire set* of output values defined *within* the `./modules/vm_creation` module for the `standard_instance_1` instance.

#### Output: `standard_bucket`

*   **Purpose**: Makes the name of the Google Cloud Storage bucket created for the standard environment available after deployment.
*   **`description`**: `"Bucket name"` - A human-readable description.
*   **`value`**: `google_storage_bucket.standard_bucket.name`
    *   **Details**: Exports the dynamically generated, globally unique name of the `standard_bucket` GCS resource.

---

> [!TIP]
> After running `terraform apply`, Terraform will print a summary table containing the names and values of all defined outputs (e.g., the bucket names and the detailed outputs from the VM modules). These values can also be retrieved later using the `terraform output <output_name>` command.

# project.tf 

> [!NOTE]
> **Purpose:** This Terraform code defines three separate Google Cloud Projects using the official `terraform-google-modules/project-factory/google` module. This module simplifies the creation and configuration of GCP projects. The code creates two projects intended for a 'Secured' environment (one for compute, one for storage) and one project for a 'Standard' testing environment.

---

### SERVICE PERIMETER ENVIRONMENT - Secured Compute Project

This module block creates a Google Cloud Project dedicated to hosting compute resources (like VMs) within the secured environment.

#### Module: `prj_sec_compute`

*   **`source`**: `"terraform-google-modules/project-factory/google"`
    *   **Purpose**: Specifies the use of the official Google Cloud project factory module.
*   **`version`**: `"~> 18.0"`
    *   **Purpose**: Specifies the acceptable version range for the module, ensuring compatibility and using features from version 18.x.
*   **`random_project_id`**: `true`
    *   **Purpose**: Instructs the module to generate a globally unique project ID by appending a random suffix to the `name`. This avoids naming conflicts.
*   **`random_project_id_length`**: `4`
    *   **Purpose**: Sets the length of the random suffix appended to the project ID.
*   **`default_service_account`**: `"deprivilege"`
    *   **Purpose**: Configures the module to attempt to remove default high-privilege roles (like Editor) from the automatically created default Compute Engine service account upon project creation. This follows the principle of least privilege.
*   **`name`**: `"${var.project_prefix}-${var.security_prefix}-compute"`
    *   **Purpose**: Sets the base name for the project (e.g., `prj-sec-compute`). The actual unique Project ID will be this name plus the random suffix.
*   **`org_id`**: `var.org_id`
    *   **Purpose**: Specifies the GCP Organization ID under which this project will be created.
*   **`billing_account`**: `var.billing_account`
    *   **Purpose**: The ID of the billing account to associate with this project for cost tracking and resource usage.
*   **`folder_id`**: `resource.google_folder.secured_folder.id`
    *   **Purpose**: Places this project within the previously created `secured_folder` folder. This helps organize resources and apply policies hierarchically within the secured environment.
*   **`activate_apis`**: `[...]`
    *   **Purpose**: A list of Google Cloud APIs to automatically enable within this project upon creation.
    *   **Details**: Includes APIs essential for compute (`compute.googleapis.com`), resource management (`cloudresourcemanager.googleapis.com`), IAM (`iam.googleapis.com`), secure access (`iap.googleapis.com`), logging (`logging.googleapis.com`), DNS (`dns.googleapis.com`), and VPC Service Controls (`accesscontextmanager.googleapis.com`). Enabling these upfront ensures resources needing them can be provisioned.
*   **`deletion_policy`**: `var.policy_deletion` (default: `DELETE`)
    *   **Purpose**: Determines the behavior when the project is destroyed via Terraform. `DELETE` allows Terraform to delete the GCP project. `ABANDON` would remove it from Terraform state but leave the project in GCP.

---

### SERVICE PERIMETER ENVIRONMENT - Secured Storage Project

This module block creates a Google Cloud Project dedicated to hosting storage resources (like GCS buckets) within the secured environment.

#### Module: `prj_sec_storage`

*   **`source`**: `"terraform-google-modules/project-factory/google"`
*   **`version`**: `"~> 18.0"`
*   **`random_project_id`**: `true`
*   **`random_project_id_length`**: `4`
*   **`default_service_account`**: `"deprivilege"` (Note: Primarily impacts the Compute Engine default SA, which might not be heavily used if no VMs are run here, but still good practice).
*   **`name`**: `"${var.project_prefix}-${var.security_prefix}-storage"` (e.g., `prj-sec-storage`)
*   **`org_id`**: `var.org_id`
*   **`billing_account`**: `var.billing_account`
*   **`folder_id`**: `resource.google_folder.secured_folder.id`
    *   **Purpose**: Places this project also within the `secured_folder`, alongside the secured compute project.
*   **`activate_apis`**: `[...]`
    *   **Purpose**: Enables APIs relevant for storage and management.
    *   **Details**: Includes resource management, IAM, logging, storage (`storage.googleapis.com`), IAP, and DNS. Notably omits `compute.googleapis.com` as compute resources are not the primary focus.
*   **`deletion_policy`**: `var.policy_deletion`

---

### STANDARD PERIMETER ENVIRONMENT - Standard Testing Project

This module block creates a Google Cloud Project for standard testing purposes, potentially outside the strict controls of the secured environment.

#### Module: `prj_std_testing`

*   **`source`**: `"terraform-google-modules/project-factory/google"`
*   **`version`**: `"~> 18.0"`
*   **`random_project_id`**: `true`
*   **`random_project_id_length`**: `4`
*   **`default_service_account`**: `"deprivilege"`
*   **`name`**: `"${var.project_prefix}-${var.standard_prefix}-compute"` (e.g., `prj-std-compute`) - Note: Name implies compute, but API list is more general.
*   **`org_id`**: `var.org_id`
*   **`billing_account`**: `var.billing_account`
*   **`folder_id`**: `var.parent_folder`
    *   **Purpose**: Places this project directly under the main parent folder specified by the variable, *not* inside the `secured_folder`. This reflects its different organizational placement and potentially different policy inheritance.
*   **`activate_apis`**: `[...]`
    *   **Purpose**: Enables a set of APIs suitable for general testing.
    *   **Details**: Includes resource management, IAM, logging, storage, and IAP. Omits `compute.googleapis.com`, `dns.googleapis.com`, and `accesscontextmanager.googleapis.com` compared to the secured compute project, indicating potentially different resource usage or security requirements.
*   **`deletion_policy`**: `var.policy_deletion`

---

> [!TIP]
> This code effectively sets up the foundational project structure. Using the `project-factory` module streamlines creation, ensures unique IDs, helps enforce least privilege on default service accounts, organizes projects into folders, and enables necessary APIs upfront, saving manual steps later. The separation into distinct projects (`compute`, `storage`, `testing`) allows for more granular IAM and network configurations.


# terraform.tfvars.example

> [!NOTE]
> **Purpose:** This file provides values for the variables defined in the Terraform configuration (likely in a `variables.tf` file or similar). These values customize the deployment for a specific environment or user.

---

*   **`org_id = "000000000000"`**
    *   **Purpose**: Specifies the unique identifier for your Google Cloud Organization. All resources (folders, projects) will be created under this Organization.
    *   **Format**: A 10-12 digit numerical string.
    *   **Key Attribute**: Defines the top-level entity in the GCP resource hierarchy for this deployment.

*   **`billing_account = "000000-000000-000000"`**
    *   **Purpose**: Specifies the ID of the Google Cloud Billing Account to which the newly created projects (`prj_sec_compute`, `prj_sec_storage`, `prj_std_testing`) will be linked. Resource usage costs incurred by these projects will be charged to this account.
    *   **Format**: A string typically in the format `XXXXXX-XXXXXX-XXXXXX`.
    *   **Key Attribute**: Essential for project creation, as projects must be associated with a billing account to use most GCP services.

*   **`default_region = "europe-west1"`**
    *   **Purpose**: Sets the default Google Cloud region for deploying regional resources like Compute Engine instances, VPC subnets, and Cloud Storage buckets (unless overridden).
    *   **Format**: A valid GCP region name string (e.g., `us-central1`, `europe-west1`, `asia-east1`).
    *   **Key Attribute**: Influences the location and latency of regional resources. `europe-west1` corresponds to Belgium.

*   **`authorized_member = "group:group@domain.com"`**
    *   **Purpose**: Specifies the identity (user or group) that should be granted specific access permissions within the deployed resources. In the provided configuration, this is used to grant IAP access to the secured VM (`module.secured_instance_1`).
    *   **Format**: `user:{emailid}` for a single user (e.g., `user:jane@example.com`) or `group:{emailid}` for a Google Group (e.g., `group:cloud-admins@example.com`).
    *   **Key Attribute**: Controls who can access resources secured via IAM bindings configured by Terraform (specifically IAP SSH access in this case).

*   **`automation_sa = "terraform-deployer@<project_id>.iam.gserviceaccount.com"`**
    *   **Purpose**: Defines the email address of the Service Account that Terraform itself uses to authenticate to Google Cloud and execute the deployment plan (create, modify, delete resources). This service account needs sufficient permissions on the organization/folders/projects being managed.
    *   **Format**: A service account email string, typically `SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com`.
    *   **Key Attribute**: Represents the identity performing the Terraform actions; its permissions dictate what Terraform is allowed to do.

*   **`parent_folder = "000000000000"`**
    *   **Purpose**: Specifies the unique ID of the existing Google Cloud Folder under which the `secured_folder` and the `prj_std_testing` project will be created. It defines the primary organizational location within the GCP hierarchy for this deployment.
    *   **Format**: A 10-12 digit numerical string representing a Folder ID.
    *   **Key Attribute**: Establishes the hierarchical context for newly created folders and projects.

*   **`api_project = "000000000000"`**
    *   **Purpose**: This variable wasn't explicitly used in the resource blocks provided earlier. However, it often designates a specific project used for central tasks like hosting the Terraform service account (`automation_sa`), managing shared APIs, or potentially for billing export configurations. Its exact use depends on how it's referenced elsewhere in the complete Terraform configuration.
    *   **Format**: A Project ID string (e.g., `my-shared-services-project`).
    *   **Key Attribute**: Context-dependent based on usage in the full configuration, often points to a project for shared services or administrative tasks.

*   **`personal_ip = [ "X.X.X.X/XX", "X.X.X.X/XX" ]`**
    *   **Purpose**: Provides a list of additional IP address ranges (in CIDR notation) that should be allowed access based on the Access Context Manager `secured_access_level` definition. This typically includes personal or specific bastion host IP addresses.
    *   **Format**: A list of strings, where each string is a valid IPv4 or IPv6 CIDR block (e.g., `"192.0.2.10/32"`, `"2001:db8::/32"`).
    *   **Key Attribute**: Directly influences the conditions of the `secured_access_level`, granting access from these specified networks in addition to any hardcoded ranges.
  

# vpc-sc.tf

> [!NOTE]
> **Purpose:** This Terraform code defines a VPC Service Controls (VPC SC) perimeter. VPC SC acts as a security boundary around specified Google Cloud resources (projects, networks) to control communication and prevent data exfiltration. This perimeter uses the previously defined Access Policy and Access Level to enforce fine-grained access controls.

---

### Data Source: `google_project.api_project`

*   **Purpose**: Retrieves details about the Google Cloud project specified by the `var.api_project` variable. This is necessary to get the `project_number`, which is required when listing projects within the perimeter's `resources` block.
*   **`project_id`**: `var.api_project` - The Project ID of the project whose details are being fetched.

---

### Resource: `google_access_context_manager_service_perimeter.service_perimeter`

This is the main resource defining the VPC SC perimeter configuration.

*   **`parent`**: `accessPolicies/${google_access_context_manager_access_policy.folder_policy.name}`
    *   **Purpose**: Links this perimeter to the Access Policy (`folder_policy`) created earlier. Perimeters exist within an Access Policy.
*   **`name`**: `accessPolicies/.../servicePerimeters/secured_perimeter`
    *   **Purpose**: The unique, fully qualified identifier for this Service Perimeter within GCP.
*   **`title`**: `"secured_perimeter"`
    *   **Purpose**: A human-readable name for the perimeter.
*   **`perimeter_type`**: `"PERIMETER_TYPE_REGULAR"`
    *   **Purpose**: Specifies that this is a standard perimeter, not a perimeter bridge.
*   **`spec`**: (Dry-Run Configuration Block)
    *   **Purpose**: Defines the configuration of the perimeter in dry run mode. It is not enforced.
    *   **`resources`**: `[...]`
        *   **Purpose**: Lists the Google Cloud resources *protected* by this perimeter. Traffic involving these resources is subject to the perimeter's rules.
        *   **Details**: Includes the project numbers for `prj_sec_compute`, `prj_sec_storage`, the `api_project`, and the network ID of the `secured_vpc`. Putting projects in the perimeter protects resources *within* them. Including the network explicitly can add further clarity or cover network-level interactions if needed.
    *   **`restricted_services`**: `["storage.googleapis.com", "compute.googleapis.com"]`
        *   **Purpose**: Specifies the Google APIs that are protected by this perimeter. By default, access *to* these services *from outside* the perimeter is blocked unless explicitly allowed by an ingress rule. Access *from inside* the perimeter *to* these services is generally allowed (subject to IAM and firewall rules).
        *   **Details**: Protects Cloud Storage and Compute Engine APIs from unauthorized access originating outside the perimeter boundary.
    *   **`ingress_policies`**: (Rules for traffic *entering* the perimeter)
        *   **Rule 1 (`allow Ingress - Terraform automation`)**:
            *   **Purpose**: Allows the Terraform service account (`var.automation_sa`) to access any service (`service_name = "*"`) within the protected projects, *provided* the request originates from an IP address matching the `secured_access_level`.
            *   **`ingress_from`**: Defines the source conditions.
                *   `identities`: `serviceAccount:${var.automation_sa}` - Requires the request be authenticated as this specific service account.
                *   `sources.access_level`: `google_access_context_manager_access_level.secured_access_level.id` - Requires the source IP to match the defined access level (e.g., corporate network IPs). Both identity and access level conditions must be met (AND logic).
            *   **`ingress_to`**: Defines the destination and allowed operations within the perimeter.
                *   `resources`: Targets all protected projects.
                *   `operations.service_name = "*"`: Allows calls to *any* API service.
        *   **Rule 2 (`allow from access level to compute engine`)**:
            *   **Purpose**: Allows the specified user/group (`var.authorized_member`) to access *only* the Compute Engine API (`compute.googleapis.com`) within the `prj_sec_compute` project, *provided* the request originates from an allowed source (either matching the access level OR originating logically from the secured VPC network).
            *   **`ingress_from`**:
                *   `identities`: `[var.authorized_member]` - Requires authentication as the authorized user/group.
                *   `sources { access_level = ... }`: Requires source IP to match the access level.
                *   `sources { resource = "//compute.googleapis.com/${module.secured_vpc.network_id}" }`: Requires the request to originate from the context of the secured network. The multiple `sources` blocks are generally OR'd together, while the `identities` condition is AND'd with the overall source condition.
            *   **`ingress_to`**:
                *   `resources`: Targets only the secured compute project.
                *   `operations`: Allows only calls to the `compute.googleapis.com` service, any method (`method = "*"`).
    *   **`egress_policies`**: (Rules for traffic *leaving* the perimeter)
        *   **Rule 1 (`allow Egress from sec project instance to std project `)**:
            *   **Purpose**: (Based on title, likely *intended* to allow the secured compute instance's default SA to access the standard project). 
            *   **`egress_from`**: Defines the source *within* the perimeter.
                *   `identities`: Default Compute SA of the secured compute project.
            *   **`egress_to`**: Defines the destination *outside* the perimeter.
                *   `resources`: `["projects/${module.prj_sec_compute.project_number}"]` 
                *   `operations`: Allows calls to the `compute.googleapis.com` service, any method.
        *   **Rule 2 (`allow Egress to std project - Terraform automation`)**:
            *   **Purpose**: Allows the Terraform service account (`var.automation_sa`), when operating from within the perimeter context, to access *any service* (`service_name = "*"`) in the standard testing project (`prj_std_testing`).
            *   **`egress_from`**: Source identity is the Terraform SA.
            *   **`egress_to`**: Destination resource is the standard testing project, allows any service.
*   **`use_explicit_dry_run_spec`**: `true`
    *   **Purpose**: Critically important setting. When `true`, the configuration defined in the `spec { ... }` block is treated as a **Dry-Run** configuration. The perimeter rules are evaluated, and violations are logged, but traffic is **not actually blocked**.
    *   **Key Attribute**: To enforce the perimeter, you would typically remove this line (or set it to `false`) and potentially move the configuration into a `status { ... }` block (if you wanted to keep a separate dry-run spec). Without a `status` block and with `use_explicit_dry_run_spec = false`, the `spec` block becomes `status` block, the enforced configuration.
*   **`depends_on`**: `[module.secured_vpc]`
    *   **Purpose**: Ensures that the `secured_vpc` module (which creates the network referenced in `spec.resources`) completes successfully before Terraform attempts to create the perimeter.

---

### Resource: `time_sleep.vpc_sc_destroy_wait_300_seconds`

*   **Purpose**: Introduces a delay during the `terraform destroy` process *after* the `service_perimeter` resource has been dealt with by Terraform but potentially *before* GCP has fully propagated the deletion or update.
*   **`depends_on`**: `[google_access_context_manager_service_perimeter.service_perimeter]` - This sleep resource depends on the perimeter.
*   **`destroy_duration`**: `"5m"` - When Terraform destroys this `time_sleep` resource (which happens after it handles the perimeter destruction dependency), it will pause for 5 minutes.
*   **Key Attribute**: This is a workaround for potential propagation delays in GCP. Deleting or modifying VPC SC perimeters can take time to take effect across all services. This delay helps prevent issues where Terraform might try to delete other resources (like projects within the perimeter) before the perimeter changes have fully propagated, which could lead to errors.

---

> [!NOTE]
> This configuration defines a VPC Service Controls perimeter in **Dry-Run mode**. It protects the secured compute and storage projects, the API project, and the secured VPC network, restricting access to the Storage and Compute APIs. It includes specific ingress rules to allow the Terraform SA and authorized users/groups access under certain conditions (matching Access Level IPs), and egress rules  to allow limited outbound traffic. The `time_sleep` resource adds a safety delay during destruction. To enforce the perimeter, `use_explicit_dry_run_spec = true` would need to be removed or set to `false`.