#!/bin/bash

# Step 1 - Create upload file (is an archive file ending in .tar.gz)
UPLOAD_FILE_NAME="./tf-$(date +%s).tar.gz"

tar -zcvf "$UPLOAD_FILE_NAME" -C "$CONTENT_DIRECTORY" .
echo $UPLOAD_FILE_NAME

echo "Getting workspace ID"

# Step 2 - Get the Workspace ID. The workspace is what will run our TF code.
WORKSPACE_ID=($(curl \
  -s \
  -S \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$WORKSPACE_NAME \
  | jq -r '.data.id'))


echo $WORKSPACE_ID
echo "Creating Configuration Version"

# Step 3 - Create config_version. This tracks your terraform configuration version.

echo '{"data":{"type":"configuration-versions", "attributes": "auto-queue-runs": true}}' > ./create_config_version.json


echo "Getting Upload URL for Config Version"

UPLOAD_URL=($(curl \
  -s \
  -S \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @create_config_version.json \
  https://app.terraform.io/api/v2/workspaces/$WORKSPACE_ID/configuration-versions \
  | jq -r '.data.attributes."upload-url"'))

# Upload Terraform Config
echo UPLOAD_URL

echo "Uploading Terraform Config"

curl \
  -s \
  -S \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @"$UPLOAD_FILE_NAME" \
  $UPLOAD_URL
