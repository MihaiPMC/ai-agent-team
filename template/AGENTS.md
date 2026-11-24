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
No fixed specialties: **every agent can implement anything** (systems/backend, UI, visuals, world building, research) and review anything.

| Agent | Role |
|---|---|
| Claude Code | Lead (architecture, specs, final review, merges into `main`, usage checks) **and** worker (via its subagents) |
| Codex | Worker + reviewer, any kind of task |
| Antigravity | Worker + reviewer, any kind of task |
| Grok | Worker + reviewer, any kind of task |

The lead assigns each Board task by availability, remaining usage, task tier and continuity (whoever built a system extends it most cheaply). Anyone may also claim an unassigned task. Heavy work is always reviewed by a different agent than its author. Edit this table to match the agents you actually use.

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
