#!/usr/bin/env bash
# Hook: PostToolUse — Edit|Write
# When:  After Claude edits or writes any file in the repository
# Why:   Site content changes must be verified visually; a build-only check
#        can miss rendering regressions that Playwright would catch
# How:   Reads the edited file path from stdin (Claude pipes the tool-call
#        JSON here), skips unless the path is inside site/ (generated paths
#        under public/ and test files under tests/ are excluded), then prints
#        a reminder for Claude to run a Playwright smoke-test before finishing
set -euo pipefail

file_path=$(jq -r '.tool_input.file_path // ""')
echo "$file_path" | grep -q '/site/' || exit 0
echo "$file_path" | grep -q '/public/' && exit 0
echo "$file_path" | grep -q '/tests/' && exit 0

echo "Site content was modified. Before finishing, use the Playwright MCP"\
" (mcp__playwright__*) to verify the changes: start the Quartz dev server"\
" with \`cd site && npx quartz build -d ../wiki --serve\`, navigate to the"\
" affected pages, and confirm they render correctly."
