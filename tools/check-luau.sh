#!/bin/sh
# Optional Roblox module: type-check a Rojo project with luau-lsp.
# Usage: tools/check-luau.sh [project-root] [--types]
# Default prints only errors that break at runtime (syntax, unknown globals); --types adds all type errors.
# Needs: rojo and luau-lsp on PATH (e.g. via rokit), and a Roblox definitions file (globalTypes.d.luau).
# Set LUAU_DEFS to its path, or put it next to this script.
set -eu

ROOT="${1:-.}"
MODE="${2:-}"
HERE=$(cd "$(dirname "$0")" && pwd)
DEFS="${LUAU_DEFS:-$HERE/globalTypes.d.luau}"
[ -f "$DEFS" ] || { echo "check-luau: definitions file not found ($DEFS). Set LUAU_DEFS." >&2; exit 1; }
command -v rojo >/dev/null 2>&1 || { echo "check-luau: rojo not found on PATH" >&2; exit 1; }
command -v luau-lsp >/dev/null 2>&1 || { echo "check-luau: luau-lsp not found on PATH" >&2; exit 1; }

cd "$ROOT"
rojo sourcemap default.project.json -o sourcemap.json >/dev/null 2>&1 || true
OUT=$(luau-lsp analyze --definitions="$DEFS" --sourcemap=sourcemap.json \
  --ignore="src/**/Packages/**" --flag:LuauSolverV2=false src 2>&1 | sort -u || true)
if [ "$MODE" = "--types" ]; then
  echo "$OUT" | grep -E "Error" || true
else
  echo "$OUT" | grep -E "SyntaxError|UnknownGlobal|Unknown global|not a valid member|UnknownSymbol" || true
fi
exit 0
