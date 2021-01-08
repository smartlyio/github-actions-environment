#!/bin/bash

set -euo pipefail

git clone https://github.com/actions/virtual-environments.git

TEMPLATEDIR="$(pwd)/virtual-environments/images/linux"
SCRIPTS="${TEMPLATEDIR}/scripts"
INSTALLERS="${SCRIPTS}/installers"
BASE="${SCRIPTS}/base"

export HELPER_SCRIPTS="${SCRIPTS}/helpers"
export METADATA_FILE=/dev/null
export DEBIAN_FRONTEND=noninteractive
export INSTALLER_SCRIPT_FOLDER="${INSTALLERS}"

cp "${TEMPLATEDIR}/toolsets/toolset-1804.json" "${INSTALLER_SCRIPT_FOLDER}/toolset.json"

BASE_TOOLS=(
    "apt.sh"
    "limits.sh"
    "repos.sh"
)

INSTALL_TOOLS=(
    "dpkg-config.sh"
    "basic.sh"
    "git.sh"
    # This pulls in Python needed by awscli
    "ansible.sh"
    "aws.sh"
    "7-zip.sh"

    "build-essential.sh"
    "nodejs.sh"
    "nvm.sh"
    "php.sh"

    "image-magick.sh"

    "firefox.sh"
    "google-chrome.sh"
    "selenium.sh"

    "docker-moby.sh"
    "docker-compose.sh"

    "cleanup.sh"
)

for script in "${BASE_TOOLS[@]}"; do
    echo "Running ${BASE}/${script}" 1>&2
    /bin/bash -e "${BASE}/${script}"
done

for script in "${INSTALL_TOOLS[@]}"; do
    echo "Running ${INSTALLERS}/${script}" 1>&2
    /bin/bash -e "${INSTALLERS}/${script}"
done
