#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../_lib.sh"
cd "$REPO/site"
npm ci
npx quartz build -d ../wiki
npx serve public -l 8080 &
SERVER_PID=$!
trap "kill $SERVER_PID 2>/dev/null || true" EXIT
npx wait-on http://localhost:8080 --timeout 30000
BASE_URL=http://localhost:8080 npx playwright test
