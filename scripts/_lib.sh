# Sourced by every script. Sets REPO. Locally also tees output to scripts/out/.
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -z "${CI:-}" ]; then
  OUT="$REPO/scripts/out/$(basename "${BASH_SOURCE[1]}" .sh).txt"
  mkdir -p "$REPO/scripts/out"
  > "$OUT"
  exec > >(tee "$OUT") 2>&1
fi
