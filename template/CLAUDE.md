@AGENTS.md

## Claude Code specifics
- Model routing: Light -> Haiku subagent, Standard -> Sonnet subagent, Heavy -> main Opus session (see `vault/Workflow/Token_Rules.md`).
- Subagent prompts: give the spec path and the files to touch, not pasted context. Ask for a short report.
- Opus reviews Sonnet diffs; Sonnet reviews Haiku diffs; Heavy work goes to another agent for a second-opinion review.
