# Studio protocol (agents with the Roblox Studio MCP)

Several agents share one machine and one Roblox Studio app. Rules so nobody breaks anyone else's test:

## Which Studio instance is yours
- `list_roblox_studios` shows every open instance; pick by the **file name**, never by guess.
- **MAIN = the published/live place** (Rojo live-synced to `main`, owned by the lead). Other agents may only **read** it in Edit mode: `screen_capture`, `get_console_output`, `inspect_instance`, `search_game_tree`, `script_read`. **Never** Play/Stop, `execute_luau`, `multi_edit`, insert or save on MAIN.
- **Your own test place** (exactly ONE window per agent, never more):
  ```sh
  rojo build -o test-<agent>.rbxl
  pkill -9 -f "localPlaceFile .*test-<agent>.rbxl" ; sleep 2; rm -f test-<agent>.rbxl.lock          # close only YOUR previous test window
  /Applications/RobloxStudio.app/Contents/MacOS/RobloxStudio -localPlaceFile "$PWD/test-<agent>.rbxl" >/dev/null 2>&1 &
  ```
  **Never use `open -a RobloxStudio ...`**: it asks the already-running Studio to open the file and leaves an empty Home window behind.
  Wait (poll `list_roblox_studios` every ~5 s, up to 60 s) until `test-<agent>.rbxl` appears with mode Edit, then use ONLY that `studio_id`. After code changes: rebuild + the same three commands (same file name). When done: `pkill -9 -f "localPlaceFile .*test-<agent>.rbxl"`.
  (Adjust the Studio path on Windows/Linux setups.)

## Rojo
- Only MAIN is connected to Rojo (`rojo serve` from the main repo = `main` branch). Test places already contain your branch code from `rojo build`: never connect them (that would overwrite your code with main and duplicate scripts).

## How to test well (and cheaply)
- Play, wait, `get_console_output` (filter errors/warnings + your prints), `screen_capture` aimed at what you built, Stop.
- Expose Studio-only dev hooks (e.g. a `ServerStorage` BindableFunction that grants test currency) and call them from `execute_luau` instead of waiting for in-game progress.
- Attach your best screenshot path in your spec note before asking for review.
- Do not edit scripts inside Studio: the files in git are the source of truth.
- Max ~3 Play cycles per task unless you are debugging a real failure.
- Close test windows with `pkill -9` (a plain kill leaves Studio stuck on a hidden "Save changes?" dialog). Test places are rebuilt from git, nothing is lost.
- After any kill, delete `test-<agent>.rbxl.lock` (the launch snippet does it). A stale lock makes Studio show "This file is currently in use by another Studio instance or is read only".
- Never launch the same test file twice; check `list_roblox_studios` first.
