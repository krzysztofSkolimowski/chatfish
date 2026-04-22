#!/usr/bin/env bash
set -uo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPTS="$REPO/scripts/ci"
mkdir -p "$REPO/scripts/out"
rm -f "$REPO/scripts/out"/*.txt   # always start clean
SUMMARY="$REPO/scripts/out/run-ci.txt"

# CI_SCOPE: "backend" | "site" | "all" (default: "all")
# Set by callers (e.g. stop hook) to limit which scripts run.
SCOPE="${CI_SCOPE:-all}"
[[ "$SCOPE" == "all" || "$SCOPE" == "backend" || "$SCOPE" == "site" ]] \
  || SCOPE="all"

[[ "$SCOPE" != "all" ]] && echo "[run-ci] scope: $SCOPE" >> "$SUMMARY"

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

# Backend + docker scripts run in parallel (skipped when scope=site)
if [[ "$SCOPE" != "site" ]]; then
  for script in "$SCRIPTS"/backend-*.sh "$SCRIPTS"/docker-*.sh; do
    [[ -f "$script" ]] || continue
    names+=("$(basename "$script")")
    bash "$script" > /dev/null &
    pids+=($!)
  done
fi

# site-test covers site-build (superset), so skip site-build locally (skipped when scope=backend)
if [[ "$SCOPE" != "backend" ]]; then
  for script in "$SCRIPTS"/site-test.sh; do
    [[ -f "$script" ]] || continue
    name="$(basename "$script")"
    bash "$script" > /dev/null
    record "$name" $?
  done
fi

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
