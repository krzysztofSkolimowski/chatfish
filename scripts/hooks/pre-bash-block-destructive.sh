#!/usr/bin/env bash
# Hook: PreToolUse — Bash
# When:  Before Claude runs any Bash command
# Why:   Prevent accidental data loss; irreversible operations (force-push,
#        hard-reset, rm -rf, DDL drops) should always require the user to
#        confirm explicitly rather than being executed silently
# How:   Reads the command from stdin (Claude pipes the tool-call JSON here),
#        exits 0 (allow) if no destructive pattern is found, otherwise prints
#        a block decision payload that the hook runner interprets as a veto
set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')
echo "$cmd" | grep -qE 'rm -rf|git push --force|git reset --hard|drop table|truncate' || exit 0

echo '{"decision":"block","reason":"Destructive command requires explicit user confirmation"}'
