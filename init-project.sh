#!/bin/sh
# Copy the project template (rules + vault) into a project. Never overwrites existing files.
# Usage: ./init-project.sh <path> [--roblox] [--dry-run]
set -eu

HERE=$(cd "$(dirname "$0")" && pwd)
TARGET=""; ROBLOX=0; DRY=0
for a in "$@"; do
  case "$a" in
    --roblox) ROBLOX=1 ;;
    --dry-run) DRY=1 ;;
    -h|--help) sed -n '2,3p' "$0"; exit 0 ;;
    -*) echo "unknown option: $a" >&2; exit 2 ;;
    *) TARGET=$a ;;
  esac
done
[ -n "$TARGET" ] || { echo "usage: $0 <path> [--roblox] [--dry-run]" >&2; exit 2; }
[ -d "$TARGET" ] || { [ "$DRY" = 1 ] || mkdir -p "$TARGET"; }
NAME=$(basename "$TARGET" | sed 's/[^A-Za-z0-9._ -]/_/g')
[ "$NAME" = "." ] && NAME=$(basename "$(pwd)" | sed 's/[^A-Za-z0-9._ -]/_/g')

# put <source-file> <dest-file>
put() {
  src=$1; dst=$2
  if [ -e "$dst" ]; then echo "exists $dst (kept)"; return 0; fi
  echo "create $dst"
  [ "$DRY" = 1 ] && return 0
  mkdir -p "$(dirname "$dst")"
  sed "s|{{PROJECT_NAME}}|$NAME|g" "$src" > "$dst"
  [ -x "$src" ] && chmod +x "$dst"
  return 0
}

( cd "$HERE/template" && find . -type f | sort ) | while read -r f; do
  put "$HERE/template/$f" "$TARGET/${f#./}"
done
put "$HERE/tools/agent_usage.sh" "$TARGET/tools/agent_usage.sh"

if [ "$ROBLOX" = 1 ]; then
  put "$HERE/roblox/Studio_Protocol.md" "$TARGET/vault/Workflow/Studio_Protocol.md"
  put "$HERE/tools/check-luau.sh" "$TARGET/tools/check-luau.sh"
  echo "Roblox: see vault/Workflow/Studio_Protocol.md; add your Luau code rules to AGENTS.md (see roblox/README.md)."
fi
[ "$DRY" = 1 ] && echo "(dry run: nothing was written)"
echo "Done. Next: fill vault/00_StartHere.md and the 'Project rules' section of AGENTS.md."
