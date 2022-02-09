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


# AWS_MAX_ATTEMPTS defaults to 40; we need to wait much longer for the huge image we build.
export AWS_MAX_ATTEMPTS=400
# AWS_POLL_DELAY_SECONDS defaults to 2 to 5 seconds, depending on task. Set to 10s for very long wait times for image to be ready
export AWS_POLL_DELAY_SECONDS=10

mkdir -p "$BUILD_DIRECTORY"
rsync -aP --delete "${TEMPLATE_DIRECTORY}/" "${BUILD_DIRECTORY}/"
sed '/waagent/ d' -i "${BUILD_DIRECTORY}/scripts/installers/configure-environment.sh"

jq . < "$UPSTREAM_TEMPLATE" |
    jq --argjson builder "$(< "$BUILDER_FILE")" --argjson variables "$(< "$VARIABLES_FILE")" '. | .builders = [$builder] | .variables = $variables' |
    jq '. | del(."sensitive-variables") | del(.provisioners | last)' > "${BUILD_DIRECTORY}/packer-template.tmp.json"

(
    cd "$BUILD_DIRECTORY" || exit 1
    packer build packer-template.tmp.json
)
