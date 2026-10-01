#!/usr/bin/env bash

# Input checks and error raising
set -euo pipefail # Immediate abort if any command fails
sops --version # check command availability
age --version

# Data disk: the hdd btrfs filesystem mica-pool (mounted at /srv/mica-pool) hosts
# the share in its "@nimbo" subvolume, mounted at /srv/nimbo

# Variable definition
export PASS="$(sops --decrypt --extract '["PASS"]' secrets.yaml)"

# Docker deployment
docker compose up -d
