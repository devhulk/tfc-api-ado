#!/bin/bash

UPLOAD_FILE_NAME="./content-$(date +%s).tar.gz"
tar -zcvf "$UPLOAD_FILE_NAME" -C "$CONTENT_DIRECTORY" .

echo "Getting workspace ID"

WORKSPACE_ID=($(curl \
  -s \
  -S \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$WORKSPACE_NAME \
  | jq -r '.data.id'))


echo "Creating Configuration Version"

echo '{"data":{"type":"configuration-versions"}}' > ./create_config_version.json


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

echo "Uploading Terraform Config"

curl \
  -s \
  -S \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @"$UPLOAD_FILE_NAME" \
  $UPLOAD_URL
