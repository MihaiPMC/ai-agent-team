## Agent rules (ai-agent-team)

Spend expensive models only where they change the result. Every piece of code is reviewed by a stronger or different model.

<!-- MODEL-TABLE: edit the model names below to match what you have access to -->
- Light: config, boilerplate, renames, simple wiring, notes. Model: grok-4.7-build-fast.
- Standard: a feature from a clear spec, UI, controllers, tests. Model: grok-4.7, medium effort.
- Heavy: architecture, saving, economy, networking, anti-exploit, tricky bugs, reviews of Standard work. Model: grok-4.7, high effort.
- Latest generation only; lower effort instead of older models. If a Light/Standard attempt fails twice, move it up one tier.

- Work as an orchestrator: write the plan, keep Heavy parts, hand Light/Standard pieces to subagents, review what they return.
- Review: Light at Standard, Standard at Heavy, Heavy (data, money, remotes, security) by another agent. Reviewer reads diff + spec.
- Short spec before code. Search first, read line ranges, no drive-by refactors.
- Messages stay at or under 5 lines; link paths instead of pasting code. Batch independent tool calls.
- If a project has `vault/00_StartHere.md` and `AGENTS.md`, read them first (Board, Messages, branches, specs).
