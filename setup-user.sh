#!/bin/bash

set -euo pipefail

SERVICE_USER=runner

adduser --gecos ",,," --uid 1001 --disabled-password "${SERVICE_USER}"
usermod -a -G docker "${SERVICE_USER}"
usermod -a -G docker ubuntu
