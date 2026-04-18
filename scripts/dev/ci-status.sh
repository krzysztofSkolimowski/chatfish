#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../_lib.sh"

SHA=$(git -C "$REPO" rev-parse HEAD)
echo "=== $(git -C "$REPO" log -1 --oneline) ==="
echo ""

runs=$(gh run list --commit "$SHA" --json databaseId,workflowName,status,conclusion,createdAt,url)

if [ "$(echo "$runs" | jq 'length')" -eq 0 ]; then
  echo "No CI runs found for this commit."
  exit 0
fi

echo "$runs" | jq -r '.[].databaseId' | while read -r id; do
  gh run view "$id" --json name,url,jobs \
    --jq '"── \(.name)  \(.url)\n" + ([.jobs[] | "   \(.name): \(.conclusion // .status)"] | join("\n"))'
  echo ""

  failed=$(gh run view "$id" --json jobs --jq '[.jobs[] | select(.conclusion == "failure")] | length')
  if [ "$failed" -gt 0 ]; then
    echo "   [failed job logs]"
    gh run view "$id" --log-failed | sed 's/^/   /'
    echo ""
  fi
done
