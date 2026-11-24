#!/bin/sh
# Install the global ai-agent-team rule snippets into the agents' home config files.
# Usage: ./setup.sh [--dry-run] [--claude]
# Content is written between markers and replaced in place on re-runs; nothing outside the markers is touched.
set -eu

START='<!-- ai-agent-team:start -->'
END='<!-- ai-agent-team:end -->'
HERE=$(cd "$(dirname "$0")" && pwd)
DRY=0
CLAUDE=0
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    --claude) CLAUDE=1 ;;
    -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
    *) echo "unknown option: $a" >&2; exit 2 ;;
  esac
done

# install_block <snippet> <target-file>
install_block() {
  snip=$1; target=$2; dir=$(dirname "$target")
  if [ ! -d "$dir" ]; then echo "skip   $target ($dir does not exist)"; return 0; fi
  if [ -f "$target" ] && grep -qF "$START" "$target"; then
    if ! grep -qF "$END" "$target"; then
      echo "ERROR  $target has a start marker but no end marker; fix it by hand" >&2; return 1
    fi
    echo "update $target (replace existing block)"
    [ "$DRY" = 1 ] && return 0
    tmp=$(mktemp)
    awk -v s="$START" -v e="$END" -v f="$snip" '
      $0 == s { print s; while ((getline l < f) > 0) print l; print e; skip = 1; next }
      skip && $0 == e { skip = 0; next }
      !skip { print }' "$target" > "$tmp"
    cat "$tmp" > "$target"; rm -f "$tmp"
  else
    echo "append $target"
    [ "$DRY" = 1 ] && return 0
    { [ -s "$target" ] && echo; echo "$START"; cat "$snip"; echo "$END"; } >> "$target"
  fi
}

install_block "$HERE/global/codex.md"  "$HOME/.codex/AGENTS.md"
install_block "$HERE/global/gemini.md" "$HOME/.gemini/GEMINI.md"
install_block "$HERE/global/grok.md"   "$HOME/.grok/AGENTS.md"

if [ "$CLAUDE" = 1 ]; then
  install_block "$HERE/global/claude.md" "$HOME/.claude/CLAUDE.md"
else
  cat <<MSG

Claude Code: not touched. Either re-run with --claude (writes the notes into ~/.claude/CLAUDE.md
between the same markers), or paste the contents of:
  $HERE/global/claude.md
into your Claude Code memory / CLAUDE.md yourself.
MSG
fi
[ "$DRY" = 1 ] && echo "(dry run: nothing was written)"
echo "Next: ./init-project.sh /path/to/your/project [--roblox]"
