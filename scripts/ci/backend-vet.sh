#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../_lib.sh"
cd "$REPO/backend"

echo "=== go vet ==="
go vet ./...

echo "=== gofmt ==="
unformatted=$(gofmt -l .)
if [ -n "$unformatted" ]; then
  echo "Unformatted files:"
  echo "$unformatted"
  exit 1
fi
echo "All files formatted."
