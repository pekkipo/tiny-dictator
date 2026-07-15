# Known Issues and Limitations — Phase 2A

Intentional scope limits and known quirks at the Phase 2A architecture freeze.  
**Completion report:** [docs/PHASE_2A_COMPLETION_REPORT.md](docs/PHASE_2A_COMPLETION_REPORT.md)  
**Authoring reference:** [docs/08_PHASE_2A_CONTENT_SCHEMA_REFERENCE.md](docs/08_PHASE_2A_CONTENT_SCHEMA_REFERENCE.md)

---

## Art and presentation

- All visuals are emoji/ColorRect placeholders; no final art, typography, or theme.
- No animations or tweens (resource feedback is instant text).
- No audio of any kind.
- Country diorama states are placeholder emoji rows, not layered scenes.
- Crisis cards show a text banner (`🔥 CRISIS`); no distinct crisis art yet.

## Platform and export

- Desktop editor play only; no Android/iOS export configuration or testing yet.
- Portrait layout is responsive, but only spot-checked at 1080×1920 aspect ratios.

## Persistence

- **Meta progression** (Medals, Ending Archive, palace upgrades) persists in save **v2** at `user://save.json`.
- **No mid-run persistence** — closing the game abandons the current run.
- Save v1 migrates to v2 automatically. Corrupt saves reset safely to defaults.
- Simulations and diagnostics never modify the real player save.

## Systems deferred beyond Phase 2A

- Phase 2B mass content production (target: full writing pass, balance, more countries).
- Final graphics, audio, and mobile export polish.
- Accounts, cloud save, and player profiles (see PRD 06_ACCOUNTS).
- Ads, in-app purchases, production analytics, live operations.
- Localization and accessibility options.
- Run modifiers, daily challenge, and ending-hint UI (designed in PRD 06, not implemented).

## Content and balance notes

- Ministan ships **74 decisions**, **6 arcs**, **6 crises**, **12 laws**, **11 endings**, **8 advisors** — representative pack, not final writing.
- `robot_government` arc and `budget_meltdown` crisis are extra beyond the five required arcs/crises.
- `general_boom_arc` completes in only ~3% of random simulated runs — needs Phase 2B balance attention.
- Two branch-gated resolution cards (`boom_loyal_protector`, `happiness_backlash`) were never picked in the 1,000-run seed `20260715` simulation; they remain reachable via specific branches.
- Static diagnostics reports ~42 "unreachable" decisions — expected for arc-gated and follow-up cards; the optimistic graph does not model arc activation.

## Diagnostics and testing

- TC-013 (weighted-selection distribution over 1,000 draws) is not automated.
- `run_phase_2a_qa.gd` spawns child Godot processes; full matrix takes ~60–90 seconds.
- Debug overlay RELOAD CONTENT acts immediately; reloading mid-run keeps the displayed card until the next day.

## Minor quirks

- A fresh run reads as "tense" in the diorama summary because 55 order sits in the middle tier by design.
- Main game UI hides exact advisor affinity; debug overlay shows values.
- Repeatable filler decisions (`one_time: false`) prevent the decision pool from emptying before `max_day`; fallback card usage is near zero in simulation (by design with current content volume).
