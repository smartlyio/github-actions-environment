#!/usr/bin/env bash

if [[ "$#" -ne 1 ]]; then
    echo "Expected argument of AWS_PROFILE"
    exit 1
fi

AWS_PROFILE="$1"
export AWS_PROFILE

if [ -d virtual-environments ]; then
    (cd virtual-environments && git pull --ff-only)
else
    git clone https://github.com/actions/virtual-environments
fi

BUILD_DIRECTORY="./build"
TEMPLATE_DIRECTORY="./virtual-environments/images/linux"
UPSTREAM_TEMPLATE="${TEMPLATE_DIRECTORY}/ubuntu1804.json"
BUILDER_FILE="./builder-definition.json"
VARIABLES_FILE="./variables.json"


mkdir -p "$BUILD_DIRECTORY"
rsync -aP --delete "${TEMPLATE_DIRECTORY}/" "${BUILD_DIRECTORY}/"
sed '/waagent/ d' -i "${BUILD_DIRECTORY}/scripts/installers/configure-environment.sh"

jq . < "$UPSTREAM_TEMPLATE" |
    jq --argjson builder "$(< "$BUILDER_FILE")" --argjson variables "$(< "$VARIABLES_FILE")" '. | .builders = [$builder] | .variables = $variables' |
    jq '. | del(."sensitive-variables")' > "${BUILD_DIRECTORY}/packer-template.tmp.json"

(
    cd "$BUILD_DIRECTORY" || exit 1
    packer build packer-template.tmp.json
)
