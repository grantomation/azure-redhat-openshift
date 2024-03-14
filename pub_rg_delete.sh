#!/bin/bash

source helper_vars.sh

az group delete -n $PUB_RG -y
az keyvault purge -n $KEYVAULT_NAME