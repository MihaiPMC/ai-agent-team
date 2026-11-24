#!/bin/sh
# Usage guard for the agent team. Run before launching an external agent and when it finishes.
# Usage: tools/agent_usage.sh [logs-dir]
#   logs-dir  directory holding headless run logs named <agent>-*.out (agent = codex grok agy claude gemini).
#             Default: ./.agent-logs
# Codex: exact % from its session logs (~/.codex/sessions). Others: no headless usage API, so the
# run logs are scanned for quota / rate-limit / billing errors.
# Env: CODEX_LIMIT_PCT (default 85) = warn threshold for the Codex 5-hour window.
set -eu

LOGDIR="${1:-./.agent-logs}"
LIMIT="${CODEX_LIMIT_PCT:-85}"

f=""
for x in $(ls -t "$HOME"/.codex/sessions/*/*/*/*.jsonl 2>/dev/null | head -10); do
  if grep -q '"rate_limits"' "$x"; then f=$x; break; fi
done
if [ -n "$f" ] && command -v python3 >/dev/null 2>&1; then
  python3 - "$f" "$LIMIT" <<'PY'
import json, sys, time
last = None
def find(o):
    if isinstance(o, dict):
        if isinstance(o.get("rate_limits"), dict):
            return o["rate_limits"]
        for v in o.values():
            r = find(v)
            if r: return r
    elif isinstance(o, list):
        for v in o:
            r = find(v)
            if r: return r
    return None
for line in open(sys.argv[1]):
    if '"rate_limits"' in line:
        try:
            r = find(json.loads(line))
            if r and r.get("primary"): last = r
        except Exception:
            pass
if last:
    p = last["primary"]; s = last.get("secondary") or {}; c = last.get("credits") or {}
    at = lambda t: time.strftime("%H:%M", time.localtime(t)) if t else "?"
    pct = p.get("used_percent", 0)
    flag = "  <-- STOP: over threshold, hand its task to another agent" if pct >= float(sys.argv[2]) else ""
    print("codex: 5h %.0f%% (resets %s), week %.0f%%, paid credits: %s balance %s%s" % (
        pct, at(p.get("resets_at")), s.get("used_percent", 0), c.get("has_credits"), c.get("balance"), flag))
else:
    print("codex: no rate-limit info in the latest session")
PY
else
  echo "codex: no session logs found"
fi

for name in codex grok agy gemini claude; do
  hits=$(cat "$LOGDIR"/"$name"-*.out 2>/dev/null \
    | grep -iE "rate.?limit|quota|exhausted|insufficient|billing|payment|credits? (are )?(exhausted|depleted)|usage limit|429" \
    | grep -viE "token rules|usage guard" | tail -3 || true)
  if [ -n "$hits" ]; then
    printf '%s: WARNING\n%s\n' "$name" "$hits"
  elif ls "$LOGDIR"/"$name"-*.out >/dev/null 2>&1; then
    echo "$name: no quota/limit errors in its run logs"
  fi
done
echo "plan % for Claude/Grok/Antigravity is not readable headless: check /usage or the app."
