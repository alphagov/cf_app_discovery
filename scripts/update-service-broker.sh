#!/usr/bin/env bash

# Note: you need to be a cloud foundry admin to run this script

set -euo pipefail

usage="Usage: $0 <space> <service-broker-app-name> <service-broker-name>"
space=${1:?$usage}
service_broker_app_name=${2:?$usage}
service_broker_name=${3:?$usage}

cf target -s "$space"
service_broker_app_env=$(cf env "$service_broker_app_name")
username=$(sed -n 's|.*"UAA_USERNAME": "\([^"]*\)".*|\1|p' <<< "$service_broker_app_env")
password=$(sed -n 's|.*"UAA_PASSWORD": "\([^"]*\)".*|\1|p' <<< "$service_broker_app_env")
cf update-service-broker "$service_broker_name" "$username" "$password" "https://$service_broker_app_name.cloudapps.digital"

