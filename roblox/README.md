# Roblox module (optional)

`./init-project.sh /path/to/project --roblox` additionally installs `vault/Workflow/Studio_Protocol.md`
(shared Roblox Studio etiquette for several agents) and `tools/check-luau.sh` (luau-lsp syntax/unknown-global check).

Suggested lines for the "Project rules" section of `AGENTS.md`:

- Luau, `--!strict` in every new module.
- Before every commit run `tools/check-luau.sh .` (needs rojo + luau-lsp, e.g. via rokit, and a `globalTypes.d.luau` next to the script or in `LUAU_DEFS`). It must print nothing.
- Server-authoritative: the client only sends intent; the server validates money, cooldowns, ownership and rate limits.
- Content is data (config tables); one service per system on the server, one controller per system on the client.
- Never put notes inside `src/`; never put code inside `vault/`.
