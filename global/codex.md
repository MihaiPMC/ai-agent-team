## Token efficiency across projects (ai-agent-team)

<!-- MODEL-TABLE: edit the model names below to match what you have access to -->
- Light = gpt-6.2-sol, low effort (routine edits). Standard = gpt-6.2-sol, medium effort (scoped implementation). Heavy = gpt-6.2-astra, high effort (architecture, tricky bugs, high-risk work). gpt-6.1-terra only for visual/computer-use work.
- Latest generation only. Save tokens with lower effort, not older models. Escalate one tier after two failed attempts.
- Work as an orchestrator: split tasks, hand Light/Standard pieces to subagents, keep Heavy parts, review what they return.
- Start from a short spec: goal, files in scope, public interfaces, acceptance checks.
- Search first, read only relevant files or line ranges, filter tool output, batch independent reads, run the smallest check that verifies the result.
- Stay in scope, reuse existing code, keep updates brief and link files or diffs.
- Review one tier up or with another agent; Heavy work (data, money, security) gets an independent reviewer.
- If a project has `vault/00_StartHere.md` and `AGENTS.md`, read them first (Board, Messages, branches, specs). Stop and hand over your WIP if you hit a quota or billing message.
