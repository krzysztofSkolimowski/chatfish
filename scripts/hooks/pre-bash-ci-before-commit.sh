#!/usr/bin/env bash
# Hook: PreToolUse — Bash
# When:  Before Claude runs any Bash command
# Why:   Keep the commit history clean; a red CI run in history is expensive
#        to fix and confusing in review — better to catch it before commit
# How:   Reads the command from stdin (Claude pipes the tool-call JSON here),
#        skips unless the command contains "git commit", then runs all CI
#        scripts via run-ci.sh; if CI fails, prints a block decision payload
#        and tells Claude to read scripts/out/run-ci.txt for the details
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cmd=$(jq -r '.tool_input.command // ""')
echo "$cmd" | grep -q 'git commit' || exit 0

bash "$REPO/scripts/dev/run-ci.sh" \
  || echo '{"decision":"block","reason":"CI failed — fix errors before committing. See scripts/out/run-ci.txt for details."}'
