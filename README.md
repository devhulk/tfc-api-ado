# TFC ADO API Demo

Based on this example.[ API Driven Workflow](https://www.terraform.io/cloud-docs/run/api) 

## Pre-reqs

1. Fork Repo
2. Create Azure DevOps (ADO) Pipeline
3. Create TFC User Token
4. Create Workspace in TFC
5. Add Environment Variables to ADO Pipeline (listed below)
6. Run Pipeline (Manually or by committing to the forked repository)

## Needed ADO Pipeline Variables

* TFC_TOKEN
    - A Terraform Cloud User token with owner/admin level permissions on a TFC org.
* CONTENT_DIRECTORY
    - The path to your terraform config. In this case (product-team-a/prod)
* ORG_NAME
    - The name of the TFC org
* WORKSPACE_NAME
    - Name of the pre-created workspace. NOTE: This does not pre-create the workspace for you.
