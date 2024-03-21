#!/bin/bash

# DISPLAY NAME OF THE APPLICATION REGISTRATION AND SERVICE PRINCIPAL
export DISPLAYNAME="<insert the name of the Azure Service Principal (or app registration) that you created>"

# PICK YOUR GITHUB REPOSITORY
export GH_ORGANISATION="<Your github username (or organisation).>"
export GH_REPO="<our copy of this github repository (private) where you are running this code from.>"
export GH_BRANCH="<Set the branch where you will run the github actions from (default `master`)>"
export PAT_GITHUB="<insert your github personal access token>"
export GH_REPOSITORY="${GH_ORGANISATION}/${GH_REPO}"

# SET AZURE VARIABLES
export LOCATION="<insert azure region where you would like to deploy resources>"
export PUB_RG="<insert name of resource group containing ARO>"
export IDP_NAME="<the desired display name of the OpenShift oauth provider - e.g. EntraID or AAD>"
export AAD_ADMIN_GROUP_ID="<insert the id of the AAD group containing openshift administrators - az ad group show -g <MY AAD GROUP NAME> --query id -o tsv>"

# SET THE NAME FOR THE AZURE CONTAINER INSTANCE RUNNER
export CONTAINER_BUILD_NAME="aro-github-runner:1"

#-------------------------------------------------------------------------------
# AUTO FILLED VARIABLES - NO NEED TO MODIFY THESE VALUES
#-------------------------------------------------------------------------------
export KEYVAULT_NAME=$(jq -r '.parameters.keyVaultName.value' action_params/keyvault.parameters.json)
# echo "KEYVAULT_NAME=$KEYVAULT_NAME"
export AZURE_SUBSCRIPTION=$(az account show --query id -o tsv)
# echo "AZURE_SUBSCRIPTION=$AZURE_SUBSCRIPTION"
export TENANT_ID=$(az account show --query 'tenantId' -o tsv)
# echo "TENANT_ID=$TENANT_ID"
export ACR_USERNAME=00000000-0000-0000-0000-000000000000
# echo "ACR_USERNAME=$ACR_USERNAME"
export CLUSTER_NAME=$(jq -r '.parameters.clusterName.value' action_params/aro_public.parameters.json)
# echo "CLUSTER_NAME=$CLUSTER_NAME"
export DOMAIN=$(jq -r '.parameters.domain.value' action_params/aro_public.parameters.json)
# echo "DOMAIN=$DOMAIN"
export SERVICE_ACCOUNT_ISSUER="https://token.actions.githubusercontent.com"
# echo "SERVICE_ACCOUNT_ISSUER=$SERVICE_ACCOUNT_ISSUER"
export AAD_APP_CLIENT_ID=$(az ad app list --filter "displayname eq '$DISPLAYNAME'" --query '[].appId' -o tsv)
# echo "AAD_APP_CLIENT_ID=$AAD_APP_CLIENT_ID"
export AAD_SP_OBJECT_ID=$(az ad sp show --id $AAD_APP_CLIENT_ID --query id -o tsv)
# echo "AAD_SP_OBJECT_ID=$AAD_SP_OBJECT_ID"
export AAD_APP_REG_OBJECT_ID=$(az ad app show --id $AAD_APP_CLIENT_ID --query id -o tsv)
# echo "AAD_APP_REG_OBJECT_ID=$AAD_APP_REG_OBJECT_ID"
export GRAPH_URL=https://graph.microsoft.com/v1.0/applications/$AAD_APP_REG_OBJECT_ID
# echo "GRAPH_URL=$GRAPH_URL"
export REDIRECT_URL=https://oauth-openshift.apps.$DOMAIN.$LOCATION.aroapp.io/oauth2callback/AAD
# echo "REDIRECT_URL=$REDIRECT_URL"
export PULL_SECRET=$(cat pull-secret.json | sed 's/"/\\"/g')
# echo "PULL_SECRET=$PULL_SECRET"
export AAD_ARO_PROVIDER_ID=$(az provider show -n Microsoft.RedHatOpenShift --query "authorizations[0].applicationId" -o tsv)
# echo "AAD_ARO_PROVIDER_ID=$AAD_ARO_PROVIDER_ID"
export ARO_RP_OB_ID=$(az ad sp show --id $AAD_ARO_PROVIDER_ID --query id -o tsv)
# echo "ARO_RP_OB_ID=$ARO_RP_OB_ID"