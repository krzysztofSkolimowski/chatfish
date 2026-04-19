#!/usr/bin/env bash
# Hook: PostToolUse — Edit|Write
# When:  After Claude edits or writes any file in the repository
# Why:   Catch go vet / gofmt errors immediately so they never accumulate;
#        faster feedback than waiting for the Stop hook or a manual CI run
# How:   Reads the edited file path from stdin (Claude pipes the tool-call
#        JSON here), skips if the path is outside backend/, otherwise runs
#        scripts/ci/backend-vet.sh which checks both go vet and gofmt
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

file_path=$(jq -r '.tool_input.file_path // ""')
echo "$file_path" | grep -q '/backend/' || exit 0

bash "$REPO/scripts/ci/backend-vet.sh" 2>&1
