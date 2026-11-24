# Example spec (filled in from the template)

# M2-11 Production line: layout + server flow · agent A (Standard tier), Heavy-reviewed · reviewer: lead
Goal: items travel a fixed route through stations (mine, smelter, forge, dock) with limited belt capacity; the server computes throughput and income.
Read first: `Systems/Production_Line.md` (the contract), `Systems/Contracts.md`, the current config table and production service.

1. New `config/Layout`: route polyline through the zones, station positions, slot list per station, belt segments that unlock with upgrades. Add a `Station` field to each machine entry; belts get `BeltCapacity` / `BeltSpeed`.
2. Production service: implement the flow math from the contract on top of the existing heat logic (keep heat, venting, multipliers, event hooks). Publish state attributes every tick, only when values change.
3. Keep the pacing target: run the economy simulation script and check the time-to-milestones table.

Out of scope: visuals, UI.
Acceptance checks: project check command prints nothing; simulation still hits the pacing target.
Files: config/Layout (new), config/Upgrades, services/Production, tools/sim.
