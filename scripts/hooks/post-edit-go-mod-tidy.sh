#!/usr/bin/env bash
# Hook: PostToolUse — Edit|Write
# When:  After Claude edits go.mod or go.sum
# Why:   go.mod edits that skip `go mod tidy` leave go.sum inconsistent, which
#        breaks `go build` for other developers and in CI
# How:   Reads the edited file path from stdin, skips unless it's go.mod or
#        go.sum, then runs `go mod tidy` automatically
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

file_path=$(jq -r '.tool_input.file_path // ""')
echo "$file_path" | grep -qE '/(go\.mod|go\.sum)$' || exit 0

echo "Running go mod tidy..."
cd "$REPO/backend" && go mod tidy 2>&1
