#!/usr/bin/env bash
set -uo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPTS="$REPO/scripts/ci"
SUMMARY="$REPO/scripts/out/run-ci.txt"
mkdir -p "$REPO/scripts/out"
> "$SUMMARY"

names=()
pids=()

for script in "$SCRIPTS"/*.sh; do
  names+=("$(basename "$script")")
  bash "$script" > /dev/null &
  pids+=($!)
done

failed=()
passed=()

for i in "${!names[@]}"; do
  name="${names[$i]}"
  if wait "${pids[$i]}"; then
    passed+=("$name")
    echo "ok  $name" >> "$SUMMARY"
  else
    failed+=("$name")
    echo "FAIL $name → scripts/out/$(basename "$name" .sh).txt" >> "$SUMMARY"
  fi
done

echo "" >> "$SUMMARY"
echo "${#passed[@]} passed, ${#failed[@]} failed" >> "$SUMMARY"

echo "========================================"
cat "$SUMMARY"
echo "========================================"

[ ${#failed[@]} -eq 0 ]
