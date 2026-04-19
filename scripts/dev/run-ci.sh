#!/usr/bin/env bash
set -uo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPTS="$REPO/scripts/ci"
SUMMARY="$REPO/scripts/out/run-ci.txt"
mkdir -p "$REPO/scripts/out"
> "$SUMMARY"

names=()
pids=()
failed=()
passed=()

record() {
  local name="$1" ok="$2"
  if [ "$ok" -eq 0 ]; then
    passed+=("$name")
    echo "ok  $name" >> "$SUMMARY"
  else
    failed+=("$name")
    echo "FAIL $name → scripts/out/$(basename "$name" .sh).txt" >> "$SUMMARY"
  fi
}

# Backend + docker scripts run in parallel
for script in "$SCRIPTS"/backend-*.sh "$SCRIPTS"/docker-*.sh; do
  [[ -f "$script" ]] || continue
  names+=("$(basename "$script")")
  bash "$script" > /dev/null &
  pids+=($!)
done

# Site scripts run sequentially — they share node_modules and port 8080
for script in "$SCRIPTS"/site-*.sh; do
  [[ -f "$script" ]] || continue
  name="$(basename "$script")"
  bash "$script" > /dev/null
  record "$name" $?
done

# Collect parallel results
for i in "${!names[@]}"; do
  wait "${pids[$i]}"
  record "${names[$i]}" $?
done

echo "" >> "$SUMMARY"
echo "${#passed[@]} passed, ${#failed[@]} failed" >> "$SUMMARY"

echo "========================================"
cat "$SUMMARY"
echo "========================================"

[ ${#failed[@]} -eq 0 ]
