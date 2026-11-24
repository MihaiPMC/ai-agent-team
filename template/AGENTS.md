# {{PROJECT_NAME}}

<!-- One paragraph: what this project is. Replace this line. -->
Built by several AI coding agents working together through a shared vault (`vault/`), led by one lead agent.

## Before doing anything
1. Read `vault/00_StartHere.md` (state of the project, what is next).
2. Read `vault/Workflow/Token_Rules.md` and follow it. Every agent, every session.
3. Read `vault/Workflow/Usage_Guard.md` if you launch or supervise other agents.
4. Check `vault/Agents/Board.md` for your tasks and `vault/Agents/Messages.md` for new messages to you.
5. If `vault/Workflow/Studio_Protocol.md` exists (Roblox projects), follow it.

## Roles
| Agent | Default role |
|---|---|
| Claude Code | Lead: architecture, task specs, complex systems, final review, merges into `main`. |
| Codex | Server/backend systems from specs, second-opinion reviews of the lead's complex code. |
| Antigravity | UI, visuals, front-end polish, research. |
| Grok | Systems from specs, cross-agent reviews of Heavy code. |

Roles are defaults, not walls: anyone can take any task on the Board if they claim it first. Edit this table to match the agents you actually use.

## Collaboration rules
- **Claim before you work.** Set yourself as owner on the Board (status `claimed`) and list the files you will touch. Never work on a task or file someone else has claimed.
- **One branch per task** (own git worktree when agents run in parallel): `claude/<task-id>`, `codex/<task-id>`, `agy/<task-id>`, `grok/<task-id>`. Never commit directly to `main`.
- **Review by someone else.** When done, set status `review` and name a reviewer. The reviewer checks the diff against the spec and writes findings in the task's spec note. Only the lead merges.
- **Talk through the vault, briefly.** Messages go to `vault/Agents/Messages.md`, max 5 lines each, link files instead of pasting code.
- **Decisions are final once in `vault/Decisions.md`.** Don't re-argue them; propose a change in Messages if you think one is wrong.

## Project rules
<!-- Fill in: language/style rules, the check command to run before every commit, architecture rules,
     where code lives. Example:
- Run `<your check command>` before every commit; it must pass cleanly.
- Never put notes inside source folders; never put code inside `vault/`.
-->

## Vault rules
- New or changed system -> update its note in `vault/Systems/`.
- End of session -> update `00_StartHere` (Done / Next), one line per change in `Changelog`, new bugs in `Bugs`.
- Quick ideas from the human -> `Inbox`.
