#!/usr/bin/env bash

# Input checks and error raising
set -euo pipefail # Inmediate abort if any command fails
sops --version # check command availability
age --version

# Variable definition
export TS_AUTHKEY="$(sops --decrypt --extract '["TS_AUTHKEY"]' secrets.yaml)"

# Ensure paths are available, and create them if not
# TODO

# Docker deployment
docker compose up -d
