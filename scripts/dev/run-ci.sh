#!/usr/bin/env bash
set -uo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPTS="$REPO/scripts/ci"
SUMMARY="$REPO/scripts/out/run-ci.txt"
mkdir -p "$REPO/scripts/out"
> "$SUMMARY"

failed=()
passed=()

for script in "$SCRIPTS"/*.sh; do
  name=$(basename "$script")
  echo "=== $name ==="
  if bash "$script"; then
    passed+=("$name")
    echo "ok  $name" >> "$SUMMARY"
  else
    failed+=("$name")
    echo "FAIL $name → scripts/out/$(basename "$script" .sh).txt" >> "$SUMMARY"
  fi
  echo ""
done

echo "" >> "$SUMMARY"
echo "${#passed[@]} passed, ${#failed[@]} failed" >> "$SUMMARY"

echo "========================================"
cat "$SUMMARY"
echo "========================================"

[ ${#failed[@]} -eq 0 ]
