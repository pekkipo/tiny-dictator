# Milestone 2B-15B — Recovery Pack Sub-batch B Report

**Status:** Complete

## Changed files (B)

- `docs/content/drafts/2B-15B_recovery_pack_briefs.md`
- `data/decisions/ministan_recovery_pack_b.json` (12 recovery + 4 consequences)
- `data/countries/ministan.json` (pack B registered)
- `data/visual_states/country_visual_map.json` (B visual tags)
- `tests/run_2b15b_sim_2k.gd`
- Manifest / scaffolding / tests updated for full 24 recovery + 326 decisions

## Inventory (12 recovery)

| Resource | IDs |
|---|---|
| Treasury | `recovery_foreign_picnic_grant`, `recovery_austerity_clipboards`, `recovery_maybe_miracle_bond` |
| Happiness | `recovery_workers_shift_relief`, `recovery_civic_half_day`, `recovery_endgame_hope_reel` |
| Order | `recovery_whiskers_alley_truce`, `recovery_boom_cone_grid`, `recovery_endgame_quiet_hours` |
| Elite | `recovery_prestige_fountain`, `recovery_shared_blame_board`, `recovery_endgame_title_lottery` |

## Simulation (2000 runs, seed 20260722)

| Metric | Value |
|---|---|
| Exhaustion | 0 |
| Fallback | 9 |
| Avg run length | 17.6 |
| Pack B never selected | none |

Endgame-eligible cards opened to instability+endgame (min day 17) so they remain reachable with ~17-day average runs while still endgame-capable.

## Guests used

`foreign_ambassador`, `workers_union_leader`, `chief_judge`, `palace_chef`
