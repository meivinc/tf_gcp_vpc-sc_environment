- [VPC Service Controls (VPC-SC) Scenarios on GCP](#vpc-service-controls-vpc-sc-scenarios-on-gcp)
  - [What is VPC Service Controls?](#what-is-vpc-service-controls)
  - [Scenarios](#scenarios)
  - [Prerequisites](#prerequisites)
  - [IAM Requirements](#iam-requirements)
  - [Getting Started](#getting-started)
  - [Contributing](#contributing)

# VPC Service Controls (VPC-SC) Scenarios on GCP

This repository provides Terraform configurations and scripts to help you understand and practice various Virtual Private Cloud Service Controls (VPC-SC) scenarios on Google Cloud Platform (GCP).

## What is VPC Service Controls?

VPC Service Controls (VPC-SC) is a robust security feature on GCP that allows you to establish a secure perimeter around your cloud resources.  This perimeter mitigates the risk of data exfiltration by controlling resource access based on the network origin of the request.  Think of it as a secure boundary that restricts who and what can access your sensitive data, enhancing your overall security posture.

## Scenarios

This repository is organized to showcase different VPC-SC configurations. Each scenario resides in its own dedicated directory and includes:

*   Terraform configuration files (`.tf`) for deploying the scenario's infrastructure.
*   A `README.md` file that explains the scenario's purpose, setup instructions, and key considerations.

## Prerequisites

Before diving into the scenarios, ensure you have the following prerequisites in place:

*   **A GCP Project:** You'll need a Google Cloud project with billing enabled. This project will serve as the deployment origin for your Terraform configurations.
*   **A GCP Folder:** You'll need a Google Cloud Folder to organize and manage the VPC-SC environment and its associated resources.
*   **Enabled APIs:** The following GCP APIs must be enabled within your project:
    *   `accesscontextmanager.googleapis.com`
    *   `iam.googleapis.com`
    *   `cloudresourcemanager.googleapis.com`
*   **GCP CLI (gcloud):** The `gcloud` command-line tool must be installed and properly configured to interact with your GCP project. This includes authentication and setting the active project.
*   **Terraform:** Terraform must be installed on your local machine to deploy and manage the infrastructure.  Ensure you have a compatible version.
*   **IAM Permissions:** You need sufficient IAM permissions to bind permissions, a critical step for service account configuration.  Consider the following:
    *   **Folder Level:** `resourcemanager.folders.setIamPolicy`
    *   **Project Level:** `resourcemanager.projects.setIamPolicy`
    *   **Organization Level:** `resourcemanager.organizations.setIamPolicy`

> [!TIP]
> If you lack the necessary permissions to bind IAM policies to the service account, collaborate with an administrator who possesses those privileges to perform the delegation.

## IAM Requirements

The following IAM roles are required for both the Service Account and the User performing the deployments. Carefully review and grant those permissions to ensure successful execution of the Terraform configurations.

**User:**

*   **Organization Level:**
    *   `roles/accesscontextmanager.policyAdmin`
    *   `roles/resourcemanager.organizationViewer`
    *   `roles/resourcemanager.organizationAdmin` # Optional
*   **Folder Level:**
    *   `roles/viewer`
    *   `roles/resourcemanager.folderAdmin`
    *   `roles/compute.networkAdmin` 
> [!CAUTION]
> When using Service account through Terraform provider, network admin role doesn't work
> 
> Any tips related to this would be appreciated :) 
*   **Project Level (where Terraform is executed):**
    *   `roles/iam.serviceAccountTokenCreator`
    *   `roles/iam.serviceAccountAdmin`
    *   `roles/serviceusage.serviceUsageAdmin`
*   **Billing Account:**
    *   `roles/billing.user`


**Service Account:**

*   **Organization Level:**
    *   `roles/accesscontextmanager.policyEditor`
    *   `resourcemanager.projects.setIamPolicy`
*   **Folder Level:**
    *   `roles/compute.admin`
    *   `roles/compute.networkAdmin`
    *   `roles/compute.securityAdmin`
    *   `roles/resourcemanager.folderAdmin`
    *   `roles/iam.serviceAccountAdmin`
    *   `roles/resourcemanager.projectCreator`
    *   `roles/resourcemanager.projectDeleter`
    *   `roles/storage.admin`
    *   `roles/iap.admin`
    *   `roles/dns.admin`
    *   `roles/serviceusage.serviceUsageAdmin`
*   **Project Level (where Terraform is executed):**
    *   `roles/serviceusage.serviceUsageAdmin`
*   **Billing Account:**
    *   `roles/billing.user`
> [!IMPORTANT]  
> The script which creates the Service Account and role binding doesn't take in consideration Billing User association. 
> Please ensure to bind billing User of the freshly created service account to your corresponding Billing account



## Getting Started

Follow these steps to begin working with the VPC-SC scenarios:

1.  **Clone the Repository:**

```bash
git clone https://github.com/meivinc/tf_gcp_vpc-sc_environment.git
cd tf_gcp_vpc-sc_scenarios
```

1.  **Create a Service Account for Terraform:**

    Terraform will use a service account to manage resources within your GCP project. Set up the service account as follows:

  a.  **Select Your Project:**

```bash
gcloud config set project YOUR_PROJECT_ID
# Replace `YOUR_PROJECT_ID` with your actual GCP project ID.
```
  b.  **Enable Required APIs:**

```bash
gcloud services enable accesscontextmanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
```

  c.  **Make the Script Executable:**

```bash
chmod +x scripts/sa_creation.sh
```

  d.  **Run the Script:**

```bash
./scripts/sa_creation.sh
```

*   The `sa_creation.sh` script will prompt you for:
    *   Folder ID
    *   Project ID
    *   Organization ID
*   Ensure that the `sa_creation.sh` script is located in your current working directory.

:tada: Congratulation ! Your service account has been automatically created ! :tada:

> [!NOTE]  
> service account is in format name : terraform-deployer@\<project-ID\>.iam.gserviceaccount.com
>
> Don't forget to associate Billing Account User role 

3.  **Deploy VPC-SC Environment:**

  a.  **Configure terraform.tfvars:** 
    Configure your terraform.tfvars file to deploy environment
```bash
cp terraform.tfvars.example terraform.tfvars
```
Fill all the required information. once done, you can go next step

  b.  **Initialize Terraform:**

```bash
terraform init
```

  c.  **Plan the Deployment:**

```bash
terraform plan
```

  d.  **Apply the Configuration:**

```bash
terraform apply
```



4. **Destroy VPC-SC Environment:**
  a. **Destroy terraform configuration:**
```bash
terraform destroy
```

  b. **delete Service Account:**
```bash
chmod +x scripts/sa_removal.sh
```
  c. **run the script:**
```bash
./scripts/sa_removal.sh
```

*   The `sa_removal.sh` script will prompt you for:
    *   Folder ID
    *   Project ID
    *   Organization ID
*   Ensure that the `sa_removal.sh` script is located in your current working directory.

:tada: Congratulation ! Your service account has been automatically removed ! :tada:



## Contributing

Your contributions are highly valued! If you have ideas for new scenarios, enhancements to existing ones, or bug fixes, we encourage you to:

*   Open an issue to discuss your proposal and gather feedback.
*   Submit a pull request with your changes.  Please ensure your code adheres to the project's coding standards and includes relevant documentation.
*   

