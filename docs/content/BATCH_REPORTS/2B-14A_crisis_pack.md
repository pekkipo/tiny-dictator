# Milestone 2B-14A — Crisis Pack Sub-batch A Report

**Status:** Complete  
**Do not start Sub-batch B until this report is filed** (filed; B proceeds).

## Changed files (A)

- `docs/content/MINISTAN_CRISIS_CATALOG.md`
- `data/decisions/ministan_crisis_pack_a.json` (14)
- `data/crises/ministan_crises.json` (partial A defs)
- `scripts/core/CrisisManager.gd` / `ContentValidator.gd` (`resolution_decision_id`)
- `docs/08_PHASE_2A_CONTENT_SCHEMA_REFERENCE.md`
- `tests/test_crisis_manager.gd`
- `docs/content/drafts/2B-14A_crisis_pack_briefs.md`
- `docs/content/BATCH_REPORTS/2B-14A_crisis_pack.md` (this file)

## Inventory (14)

2-card: power outage, bank run, mass protest, palace fire, military mutiny  
1-card: government data leak, cat parliament occupation, water turns blue, public transport strike

## Simulation (2000 runs, seed 20260717)

| Metric | Value |
|---|---|
| Exhaustion | 0 |
| Fallback | 11 |
| Avg run length | 17.2 |
| Crisis frequency | 1011 |
| Never selected (ordinary) | `recovery_martial_law_pause` only |

All 14 Pack A cards activated (≥1). Military mutiny rare (7/1) — gates softened after A for B/final sims.

## Quality

All Pack A cards ≥16/20. Dominant-choice hit on cat occupation rebalanced before approval.

## Debug paths

`debug_force_crisis` for each of the 9 A crisis IDs; two-card handoff verified in `test_crisis_manager.gd`.
