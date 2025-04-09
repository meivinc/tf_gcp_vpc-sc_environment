#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Prompt for the project ID
while true; do
  read -r -p "Enter your GCP Project ID (where the service account will reside): " PROJECT_ID
  if [[ -n "$PROJECT_ID" ]]; then
    break
  else
    echo -e "${RED}Project ID cannot be empty. Please enter a valid project ID.${NC}"
  fi
done

# Prompt for the Folder ID
while true; do
  read -r -p "Enter your GCP Folder ID: " FOLDER_ID
  if [[ -n "$FOLDER_ID" ]]; then
    break
  else
    echo -e "${RED}Folder ID cannot be empty. Please enter a valid Folder ID.${NC}"
  fi
done

# Prompt for the Organization ID
while true; do
  read -r -p "Enter your GCP Organization ID: " ORGANIZATION_ID
  if [[ -n "$ORGANIZATION_ID" ]]; then
    break
  else
    echo -e "${RED}Organization ID cannot be empty. Please enter a valid Organization ID.${NC}"
  fi
done

SERVICE_ACCOUNT_NAME="terraform-deployer"
SERVICE_ACCOUNT_DISPLAY_NAME="Terraform Deployer Service Account"
SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# Roles for the Folder
FOLDER_ROLES=(
  "roles/compute.admin"
  "roles/compute.networkAdmin"
  "roles/compute.securityAdmin"
  "roles/resourcemanager.folderAdmin"
  "roles/iam.serviceAccountAdmin"
  "roles/resourcemanager.projectCreator"
  "roles/resourcemanager.projectDeleter"
  "roles/storage.admin"
  "roles/iap.admin"
  "roles/dns.admin"
  "roles/serviceusage.serviceUsageAdmin"
)

# Role for the Project
PROJECT_ROLES=(
  "roles/serviceusage.serviceUsageAdmin"
)

# Role for the Organization
ORGANIZATION_ROLES=(
  "roles/accesscontextmanager.policyEditor"
)

# Function to check if the service account exists
check_service_account_exists() {
  gcloud iam service-accounts describe "$SERVICE_ACCOUNT_EMAIL" --project="$PROJECT_ID" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    return 0 # Service account exists
  else
    return 1 # Service account does not exist
  fi
}


# Check if the service account exists
if check_service_account_exists; then
  echo -e "${YELLOW}Service account '$SERVICE_ACCOUNT_EMAIL' already exists. Continuing...${NC}"
else
  # Create the service account
  gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
      --project="$PROJECT_ID" \
      --display-name="$SERVICE_ACCOUNT_DISPLAY_NAME" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Service account '$SERVICE_ACCOUNT_EMAIL' created successfully.${NC}"
  else
      echo -e "${RED}Failed to create service account '$SERVICE_ACCOUNT_EMAIL'. You need the 'roles/iam.serviceAccountAdmin' role or equivalent permissions on the project.${NC}"
      exit 1 # Stop the script if service account creation fails.
  fi
fi

echo "Service account email: $SERVICE_ACCOUNT_EMAIL"

# Grant Folder Roles
echo -e "${YELLOW}Granting Folder Roles...${NC}"
for ROLE in "${FOLDER_ROLES[@]}"; do
  gcloud resource-manager folders add-iam-policy-binding "$FOLDER_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="$ROLE" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Granted role '$ROLE' to $SERVICE_ACCOUNT_EMAIL on folder '$FOLDER_ID'${NC}"
  else
    echo -e "${RED}Failed to grant role '$ROLE' to $SERVICE_ACCOUNT_EMAIL on folder '$FOLDER_ID'. You need the 'roles/resourcemanager.folderIamAdmin' role or equivalent permissions on the folder.${NC}"
  fi
done

# Grant Project Roles
echo -e "${YELLOW}Granting Project Roles...${NC}"
for ROLE in "${PROJECT_ROLES[@]}"; do
  gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="$ROLE" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Granted role '$ROLE' to $SERVICE_ACCOUNT_EMAIL on project '$PROJECT_ID'${NC}"
  else
    echo -e "${RED}Failed to grant role '$ROLE' to $SERVICE_ACCOUNT_EMAIL on project '$PROJECT_ID'.  You need the 'roles/owner' or 'roles/iam.securityAdmin' role or equivalent permissions on the project.${NC}"
  fi
done

# Grant Organization Roles
echo -e "${YELLOW}Granting Organization Roles...${NC}"
for ROLE in "${ORGANIZATION_ROLES[@]}"; do
  gcloud organizations add-iam-policy-binding "$ORGANIZATION_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="$ROLE" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Granted role '$ROLE' to $SERVICE_ACCOUNT_EMAIL on organization '$ORGANIZATION_ID'${NC}"
  else
    echo -e "${RED}Failed to grant role '$ROLE' to $SERVICE_ACCOUNT_EMAIL on organization '$ORGANIZATION_ID'.  You need the 'roles/resourcemanager.organizationAdmin' or 'roles/iam.securityAdmin' role or equivalent permissions on the organization.${NC}"
  fi
done

# Optional: Enable Terraform to use the Service Account without a Key

echo "Service account '$SERVICE_ACCOUNT_NAME' created (or confirmed to exist) and roles granted (attempted) successfully."
echo "To authenticate Terraform, you can either:"
echo "  1. Generate a service account key (not recommended for production)."
echo "     To do so, uncomment the following lines in the script and rerun it:"
echo "         # gcloud iam service-accounts keys create \"key.json\" \\"
echo "         #    --iam-account=\"\$SERVICE_ACCOUNT_EMAIL\" \\"
echo "         #    --project=\"\$PROJECT_ID\""
echo "         # export GOOGLE_APPLICATION_CREDENTIALS=\"key.json\""
echo "  2. Rely on implicit authentication if running in an environment where the service account is already attached (e.g., GCE instance)."
echo "  3. Impersonate the service account if needed (using gcloud auth or Terraform's impersonation feature)."