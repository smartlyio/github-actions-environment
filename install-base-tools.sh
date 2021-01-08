#!/bin/bash

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update

# Install requirements
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

add-apt-repository ppa:git-core/ppa
apt-get update

apt-get install -y curl jq git
