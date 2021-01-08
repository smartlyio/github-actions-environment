#!/usr/bin/env bash

UPSTREAM_TEMPLATE="/home/sjagoe/workspace/other/github/virtual-environments/images/linux/ubuntu1804.json"
BUILDER_FILE="/home/sjagoe/active-repos/github-actions-environment/builder-definition.json"

VARIABLES="$(
    jq . < "$UPSTREAM_TEMPLATE" |
       jq '.variables | .vm_size = "c5.large" | .ubuntu_version = "18.04" | .ubuntu_codename = "bionic"'
)"

PACKER_TEMPLATE="$(
    jq . < "$UPSTREAM_TEMPLATE" |
       jq --argjson builder "$(< "$BUILDER_FILE")" --argjson variables "$VARIABLES" '. | .builders = [$builder] | .variables = $variables'
)"

echo "$PACKER_TEMPLATE" | jq .
