#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../_lib.sh"
docker build -t chatfish "$REPO/backend"
