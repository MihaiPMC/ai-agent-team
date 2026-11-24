## Global token-saving rules (ai-agent-team)

Spend expensive models only where they change the result; keep quality with specs and tiered review.

<!-- MODEL-TABLE: edit the model names below to match what you have access to -->
- Light (gemini-4-neon / carbon / hydrogen, low effort): config/data, boilerplate, renames, simple wiring, notes.
- Standard (gemini-4, medium effort): a feature from a clear spec, UI, controllers, tests.
- Heavy (gemini-4-neon / hydrogen, high effort): architecture, persistence, money/balance, networking/security, tricky bugs, reviews of Standard work.
- If Gemini quota is low, Antigravity can use the Claude models it offers: Light claude-sonnet-5-5-low, Standard claude-sonnet-5-5-medium, Heavy claude-opus-5-5-high.
- Latest generation only; lower effort instead of older models. Escalate a tier after 2 failed attempts.

- Work as an orchestrator: split tasks, give Light/Standard pieces to subagents, keep Heavy parts, review their output.
- Review ladder: Light by Standard, Standard by Heavy, Heavy by another agent. Reviewers read the diff and the spec.
- Spec before code (goal, files, interface, acceptance checks). Search first, read line ranges, trim output, no scope creep.
- Short messages (bullets, `path:line` links). Batch independent calls.
- If a project has `vault/00_StartHere.md` and `AGENTS.md`, read them first (Board, Messages, branches, specs).
