# Token Rules (all agents)

Goal: spend expensive models only where they change the result. Cheap work goes to cheap models, but **every piece of code gets reviewed by a stronger or different model**, so quality does not drop.

## 1. Pick the cheapest model that can do the task

<!-- MODEL-TABLE START: the one place to edit model names (also see README.md and global/*.md) -->
| Tier | What goes here | Claude Code | Codex | Antigravity | Grok |
|---|---|---|---|---|---|
| **Light** | Config/data tables, boilerplate, renames, simple wiring, notes/changelog, moving code | Haiku subagent | gpt-6.2-sol, low effort | gemini-4 (neon/carbon/hydrogen), low | grok-4.7-build-fast |
| **Standard** | A normal feature from a clear spec, a UI screen, a controller, tests | Sonnet subagent | gpt-6.2-sol, medium/high | gemini-4, medium | grok-4.7, medium |
| **Heavy** | Architecture, persistence, money/balance math, networking + security, tricky bugs, reviews of Standard work | Opus (main session) | gpt-6.2-astra, high | gemini-4 neon/hydrogen, high | grok-4.7, high |

Fallback when Gemini quota is low (Antigravity can run Claude models): Light `claude-sonnet-5-5-low`, Standard `claude-sonnet-5-5-medium`, Heavy `claude-opus-5-5-high`.
<!-- MODEL-TABLE END -->

**Every agent works as an orchestrator, not alone.** Each agent splits its task into pieces and hands Light/Standard pieces to its own subagents on cheaper models. The main agent writes the plan, keeps the Heavy parts, and reviews what its subagents return.

**Latest generation only.** Never older generations to save money; save tokens with lower reasoning effort instead.

If a Light/Standard attempt fails twice, move the task up one tier instead of retrying a third time.

## 2. Review ladder
- Light code -> reviewed by Standard.
- Standard code -> reviewed by Heavy.
- Heavy code (data, money, network input, security) -> reviewed by **another agent**. Different models catch different bugs.
- The reviewer reads the **diff + the spec**, not the whole repo.

## 3. Spec before code
Every task on the Board links to a short spec in `Agents/Specs/<task-id>.md` (max ~30 lines): goal, files to touch, public interface, acceptance checks (template: `Agents/Specs/_TEMPLATE.md`).
The implementer reads the spec + the files it names. Nothing else unless stuck.
The spec is written by a Heavy model once, so cheap models never have to guess the design.

## 4. Read narrowly
- Search first (grep), then read only the line range you need.
- Don't re-read a file after editing it.
- Trim command output (`tail`, `head`, filters). Never dump whole logs.

## 5. Write less, reuse more
- Prefer data/config over new code where the project allows it.
- No speculative features, refactors or "while I'm here" changes outside the task.
- Check for an existing helper before writing a new one.

## 6. Communicate cheaply
- Messages <= 5 lines. Link `path:line` instead of pasting code.
- Vault notes: bullets, short. Update only what changed.
- Decisions go to `Decisions.md` once, so nobody re-derives them.
- Final reports to the human: what changed, where, what is next. No essays.

## 7. Batch and parallelize
- Independent tool calls in one batch.
- Independent tasks run in parallel (different agents / subagents), each on its own branch/worktree and files.

## 8. Test smart
- Run the smallest check that verifies the change; full test runs at milestones.
- Filter output to errors/warnings and your own prints.
- Visual work: attach a screenshot to the spec note before asking for review, and state a performance budget in the spec.

## 9. Usage guard
- See `Workflow/Usage_Guard.md`. The lead checks usage before launching an agent and when it finishes; an agent near its limit is stopped and its task reassigned.
