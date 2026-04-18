#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../_lib.sh"
cd "$REPO/backend"
golangci-lint run ./...
