# Usage guard

Goal: no agent runs out of plan and silently bills the human's card.

- The lead runs `tools/agent_usage.sh <logs-dir>` before launching an agent and when it finishes. Headless runs write their output to `<logs-dir>/<agent>-<task>.out` so the script can scan them.
- Stop an agent when: Codex is at or above 85% of its 5-hour window (`CODEX_LIMIT_PCT`), or any quota / rate-limit / billing message appears in its output.
- Then: commit its WIP on its branch, note it in `Agents/Messages.md`, and reassign the task to an agent with headroom (a cheaper tier of the lead's own subagents is always an option).
- Claude, Grok and Antigravity plan usage is not readable headless: ask the human to check `/usage` or the app, and prefer fewer parallel instances when unsure.
- Never run an agent past its plan into paid overage.
