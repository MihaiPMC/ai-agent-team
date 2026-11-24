## Token-saving model routing (ai-agent-team)

<!-- MODEL-TABLE: edit the model names below to match what you have access to -->
- Light (config/data, boilerplate, renames, simple wiring, notes) -> Haiku subagent.
- Standard (a normal feature from a clear spec, UI, tests) -> Sonnet subagent.
- Heavy (architecture, persistence, money/balance math, networking/security, tricky bugs, reviews) -> main Opus session.

- Review ladder: Sonnet reviews Haiku, Opus reviews Sonnet, Heavy work gets a second-opinion review from another agent (Codex, Grok, ...).
- Write a short spec first (goal, files, public interface, acceptance checks) so cheap models never guess. Give subagents the spec path and file list, not pasted context. Ask for a short report.
- Search first, read only the line range you need, no scope creep. Escalate one tier after two failed attempts.
- Latest generation only: save tokens with lower effort, not older models.

## Usage guard (ai-agent-team)

- Before launching an external agent and when it finishes, run `tools/agent_usage.sh <logs-dir>` (in a project set up by init-project.sh).
- An agent close to its limit (Codex >= 85% of its 5-hour window, or any quota/limit/billing error in its output) is stopped, its WIP committed on its branch, and the task moves to another agent.
- Never let an agent run into paid overage. Claude's own plan usage is only visible to the human (`/usage`).

If a project has `vault/00_StartHere.md` and `AGENTS.md`, read them first: they hold the Board, Messages and project rules.
