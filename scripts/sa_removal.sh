#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Prompt for the project ID
while true; do
  read -r -p "Enter your GCP Project ID (where the service account resides): " PROJECT_ID
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

# Remove Folder Roles
echo -e "${YELLOW}Removing Folder Roles...${NC}"
for ROLE in "${FOLDER_ROLES[@]}"; do
  gcloud resource-manager folders remove-iam-policy-binding "$FOLDER_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="$ROLE" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Removed role '$ROLE' from $SERVICE_ACCOUNT_EMAIL on folder '$FOLDER_ID'${NC}"
  else
    echo -e "${RED}Failed to remove role '$ROLE' from $SERVICE_ACCOUNT_EMAIL on folder '$FOLDER_ID'. You need the 'roles/resourcemanager.folderIamAdmin' role or equivalent permissions on the folder.${NC}"
  fi
done

# Remove Project Roles
echo -e "${YELLOW}Removing Project Roles...${NC}"
for ROLE in "${PROJECT_ROLES[@]}"; do
  gcloud projects remove-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="$ROLE" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Removed role '$ROLE' from $SERVICE_ACCOUNT_EMAIL on project '$PROJECT_ID'${NC}"
  else
    echo -e "${RED}Failed to remove role '$ROLE' from $SERVICE_ACCOUNT_EMAIL on project '$PROJECT_ID'.  You need the 'roles/owner' or 'roles/iam.securityAdmin' role or equivalent permissions on the project.${NC}"
  fi
done

# Remove Organization Roles
echo -e "${YELLOW}Removing Organization Roles...${NC}"
for ROLE in "${ORGANIZATION_ROLES[@]}"; do
  gcloud organizations remove-iam-policy-binding "$ORGANIZATION_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="$ROLE" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Removed role '$ROLE' from $SERVICE_ACCOUNT_EMAIL on organization '$ORGANIZATION_ID'${NC}"
  else
    echo -e "${RED}Failed to remove role '$ROLE' from $SERVICE_ACCOUNT_EMAIL on organization '$ORGANIZATION_ID'.  You need the 'roles/resourcemanager.organizationAdmin' or 'roles/iam.securityAdmin' role or equivalent permissions on the organization.${NC}"
  fi
done

# Check if the service account exists
if check_service_account_exists; then
  # Delete the service account
  echo -e "${YELLOW}Deleting Service Account '$SERVICE_ACCOUNT_EMAIL'...${NC}"
  gcloud iam service-accounts delete "$SERVICE_ACCOUNT_EMAIL" --project="$PROJECT_ID" -q > /dev/null 2>&1 # -q for quiet, skip confirmation
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Service account '$SERVICE_ACCOUNT_EMAIL' deleted successfully.${NC}"
  else
    echo -e "${RED}Failed to delete service account '$SERVICE_ACCOUNT_EMAIL'. You need the 'roles/iam.serviceAccountAdmin' role or equivalent permissions on the project.${NC}"
  fi
else
  echo -e "${YELLOW}Service account '$SERVICE_ACCOUNT_EMAIL' does not exist. Nothing to delete.${NC}"
fi

echo "Cleanup completed (attempted)."