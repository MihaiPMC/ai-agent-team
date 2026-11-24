# ai-agent-team

A clone-and-use kit for running **a lead AI agent plus several AI coding agents in parallel on one project**, without them stepping on each other and without burning expensive tokens.

What you get:

- **Shared vault** (Obsidian-style markdown folder `vault/`): project state, task Board, Messages, Decisions, Specs, system contracts. Agents talk through it instead of through you.
- **Git worktrees / one branch per task**: every agent works on its own branch, only the lead merges.
- **Token-saving model tiers** (Light / Standard / Heavy): cheap models write the simple code, strong models write the specs and review.
- **Cross-agent review**: Heavy code (data, money, security) is reviewed by a different agent, because different models catch different bugs.
- **Usage guard**: a script checks how much plan each agent has left so nobody runs into paid overage.
- Optional **Roblox module** (Rojo/Luau check script, shared Studio etiquette).

## Roles

| Role | Default agent | Does |
|---|---|---|
| Lead | Claude Code | Architecture, specs, complex systems, final review, merges into `main`, usage checks |
| Implementer | Codex, Grok | Systems from specs; second-opinion reviews |
| UI / visuals | Antigravity (`agy`) | Front-end, visuals, research |
| Subagents | each agent's own cheaper models | Light/Standard pieces of the agent's task |

Roles are defaults, not walls: anyone may take any Board task after claiming it. Edit the table in `AGENTS.md`.

## How a task flows

1. **Spec**: the lead (Heavy model) writes `vault/Agents/Specs/<id>.md` (goal, files, interface, acceptance checks, about 30 lines).
2. **Claim on Board**: an agent sets itself as owner, status `claimed`, and lists the files it will touch.
3. **Branch / worktree**: `git worktree add ../proj-<id> -b <agent>/<id>` so parallel agents never share a working tree.
4. **Subagents**: the agent splits the work, hands Light/Standard pieces to cheaper subagents, keeps the Heavy part.
5. **Check**: run the project's check command (tests, linter, type-check) until clean.
6. **Commit** on the task branch.
7. **Message**: one to five lines in `vault/Agents/Messages.md` with the branch, commit and what is unverified.
8. **Lead review / merge**: a reviewer (one tier up, or another agent for Heavy work) reads diff + spec and writes findings in the spec note; the lead merges and updates `00_StartHere`, `Changelog`, `Bugs`.

## Quick start

```sh
git clone <this-repo-url> ai-agent-team && cd ai-agent-team
./setup.sh                          # installs global rule snippets for Codex, Gemini/Antigravity, Grok
./init-project.sh /path/to/project  # copies AGENTS.md, CLAUDE.md, GEMINI.md and vault/ into your project
```

- `./setup.sh --dry-run` shows what it would do. It writes only between `<!-- ai-agent-team:start -->` and `<!-- ai-agent-team:end -->` markers, replaces that block on re-runs, never touches anything else, and skips agents whose home dir (`~/.codex`, `~/.gemini`, `~/.grok`) does not exist.
- `./setup.sh --claude` also writes the Claude Code notes (`global/claude.md`) into `~/.claude/CLAUDE.md` inside the same markers. Without it the script just tells you how to add them.
- `./init-project.sh <path> [--roblox] [--dry-run]` never overwrites existing files. `--roblox` adds `vault/Workflow/Studio_Protocol.md` and `tools/check-luau.sh`.
- Then fill `vault/00_StartHere.md` and the "Project rules" section of the project's `AGENTS.md`, and tell each agent: "Read AGENTS.md first."

## Launching agents headless

Run each in its own worktree, with output going to a logs dir so the usage guard can scan it. `<spec>` = path of the task spec.

```sh
mkdir -p .agent-logs
# Claude Code: subagents are spawned by the lead session itself (Agent tool, model haiku / sonnet).
# Standalone headless run:
claude -p --model sonnet "Implement vault/Agents/Specs/T-1.md. Short report." > .agent-logs/claude-T-1.out 2>&1

# Codex (multi_agent_v2 lets it spawn its own subagents)
codex exec -c features.multi_agent_v2=true -c model_reasoning_effort="medium" \
  "Implement vault/Agents/Specs/T-2.md. Follow AGENTS.md." > .agent-logs/codex-T-2.out 2>&1

# Antigravity (the *orchestrator* models delegate to subagents; `agy models` lists what you have)
agy -p "Implement vault/Agents/Specs/T-3.md. Follow AGENTS.md." \
  --model gemini-pro-orchestrator-neon --dangerously-skip-permissions > .agent-logs/agy-T-3.out 2>&1
# ...or on the Claude models inside Antigravity when Gemini quota is low:
#   --model claude-sonnet-5-5-high   (Heavy: claude-opus-5-5-high)

# Grok
grok -p "Implement vault/Agents/Specs/T-4.md. Follow AGENTS.md." \
  -m grok-4.7 --reasoning-effort medium --always-approve --background-wait-timeout 60 > .agent-logs/grok-T-4.out 2>&1

tools/agent_usage.sh .agent-logs   # before launching and when they finish
```

These are the exact invocations used in practice (late 2026). CLI flags change between versions: check `<agent> --help` and adjust. The auto-approve flags let agents run commands without asking: run them only inside a git worktree you can throw away.

## Customizing model names

<!-- MODEL-TABLE START: defaults, latest generation at the time of writing. Edit freely. -->
| Tier | Claude Code | Codex | Antigravity | Grok |
|---|---|---|---|---|
| Light | Haiku subagent | gpt-6.2-sol, low | gemini-4 (neon/carbon/hydrogen), low | grok-4.7-build-fast |
| Standard | Sonnet subagent | gpt-6.2-sol, medium | gemini-4, medium | grok-4.7, medium |
| Heavy | Opus (main session) | gpt-6.2-astra, high | gemini-4 neon/hydrogen, high | grok-4.7, high |
<!-- MODEL-TABLE END -->

Names appear in four places; search for `MODEL-TABLE` and keep them in sync: this README, `template/vault/Workflow/Token_Rules.md` (copied into each project), and `global/*.md` (installed by `setup.sh`; re-run it after editing, it replaces the block). Rule of thumb: always latest generation, save tokens with lower effort, not older models.

## Repository layout

```
setup.sh  init-project.sh  LICENSE
global/    claude.md codex.md gemini.md grok.md      snippets installed by setup.sh
template/  AGENTS.md CLAUDE.md GEMINI.md vault/      copied into your project
roblox/    Studio_Protocol.md README.md              optional module (--roblox)
tools/     agent_usage.sh  check-luau.sh
docs/      example-spec.md
```

## Pe scurt (RO)

Un agent lider (de ex. Claude Code) plus mai multi agenti de cod (Codex, Antigravity, Grok) lucreaza in paralel pe acelasi proiect, comunicand printr-un vault de notite markdown (Board, Messages, Specs, Decisions), fiecare pe propriul branch/worktree. Modelele ieftine fac munca simpla, cele puternice scriu specificatiile si fac review; codul critic e revizuit de alt agent. Un script de "usage guard" verifica cat mai au agentii din plan, ca sa nu se ajunga la costuri suplimentare.

Pornire rapida: `git clone ... && ./setup.sh`, apoi `./init-project.sh /calea/spre/proiect` (cu `--roblox` pentru modulul Roblox). Numele modelelor se editeaza in tabelul marcat `MODEL-TABLE`.
