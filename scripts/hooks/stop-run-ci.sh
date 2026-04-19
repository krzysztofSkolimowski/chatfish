#!/usr/bin/env bash
# Hook: Stop
# When:  After Claude finishes responding (the Stop event fires once per turn)
# Why:   Ensure every session ends with a clean CI baseline; catches issues
#        Claude introduced before the user switches context or comes back later
# How:   Delegates entirely to scripts/dev/run-ci.sh, which runs all ci/
#        scripts and writes a pass/fail summary to scripts/out/run-ci.txt;
#        Claude reads that file to decide whether to report problems
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

bash "$REPO/scripts/dev/run-ci.sh"
