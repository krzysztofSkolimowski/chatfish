#!/usr/bin/env bash
# Hook: Stop
# When:  After Claude finishes responding (the Stop event fires once per turn)
# Why:   Ensure every session ends with a clean CI baseline; catches issues
#        Claude introduced before the user switches context or comes back later
# How:   Skips if nothing changed since the last successful run (fingerprints
#        HEAD + dirty-file list). When something did change, scopes to only the
#        affected area (backend or site) so unrelated CI isn't re-run.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
mkdir -p "$REPO/scripts/out"
STATE_FILE="$REPO/scripts/out/.ci-state"

# Fingerprint = HEAD commit + sorted list of modified file paths
_head=$(git -C "$REPO" rev-parse HEAD 2>/dev/null || echo none)
_dirty=$(git -C "$REPO" diff HEAD --name-only 2>/dev/null | sort | shasum -a 256 | awk '{print $1}')
current_state="${_head}:${_dirty}"

if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "$current_state" ]]; then
  echo "[stop hook] No changes since last CI run — skipping."
  exit 0
fi

# Determine which areas have changed
_changed=$(git -C "$REPO" diff HEAD --name-only 2>/dev/null)
_run_backend=false
_run_site=false
echo "$_changed" | grep -qE '^backend/|^scripts/ci/(backend|docker)' && _run_backend=true
echo "$_changed" | grep -qE '^(site|wiki)/|^scripts/ci/site'         && _run_site=true

# Nothing categorizable (e.g. hook/script edits) → run everything
if ! $_run_backend && ! $_run_site; then
  _run_backend=true
  _run_site=true
fi

if [[ "$_run_backend" == true && "$_run_site" == true ]]; then
  export CI_SCOPE="all"
elif [[ "$_run_backend" == true ]]; then
  export CI_SCOPE="backend"
else
  export CI_SCOPE="site"
fi

bash "$REPO/scripts/dev/run-ci.sh" \
  && echo "$current_state" > "$STATE_FILE"
