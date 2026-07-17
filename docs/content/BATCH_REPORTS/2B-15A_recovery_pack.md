# Milestone 2B-15A — Recovery Pack Sub-batch A Report

**Status:** Complete  
**Do not start Sub-batch B until this report is filed** (filed; B proceeds).

## Changed files (A)

- `docs/content/MINISTAN_RECOVERY_CATALOG.md`
- `docs/content/drafts/2B-15A_recovery_pack_briefs.md`
- `data/decisions/ministan_recovery_pack_a.json` (12 recovery + 4 consequences)
- `data/decisions/ministan_stage_placeholders.json` (recoveries removed)
- `data/countries/ministan.json` (pack A registered)
- `data/laws/laws.json` (recovery laws)
- `data/advisors/advisors.json` (`workers_union_leader` guest)
- `data/visual_states/country_visual_map.json`
- Manifest / scaffolding / tests updated for A counts
- `tests/run_2b15a_sim_2k.gd`

## Inventory (12 recovery)

| Resource | IDs |
|---|---|
| Treasury | `recovery_international_bank` (rewrite), `recovery_sell_palace_wing`, `recovery_emergency_stamp_tax` |
| Happiness | `recovery_national_smile_day` (rewrite), `recovery_olga_soup_line`, `recovery_maybe_mood_pilot` |
| Order | `recovery_martial_law_pause` (rewrite), `recovery_olga_block_captains`, `recovery_zero_queue_charter` |
| Elite | `recovery_elite_dinner` (rewrite), `recovery_cabinet_nameplates`, `recovery_controlled_audit_show` |

## Simulation (2000 runs, seed 20260721)

| Metric | Value |
|---|---|
| Exhaustion | 0 |
| Fallback | 5 |
| Avg run length | 17.4 |
| Crisis frequency | 1033 |
| Pack A never selected | none (after gate softening) |

Selection highlights: treasury recoveries frequent (bank ~181, wing ~133, stamp ~135). Happiness/order/elite rarer but all ≥2. Soft follow-up `recovery_dinner_tabloid` can miss when dinner path unused.

## Quality

All Pack A recovery cards scored ≥16/20. Phase 2A `one_time: false` exploit fixed. ContentDirector recovery bias test passes with bank `minimum_day: 1`.

## Manual low-resource scenarios

```text
treasury=15 / happiness=50 / order=50 / elite=50 → bank / wing / stamp
treasury=50 / happiness=15 / order=50 / elite=50 → smile / soup / mood
treasury=50 / happiness=50 / order=15 / elite=50 → martial / captains / queue
treasury=50 / happiness=50 / order=50 / elite=15 → dinner / nameplates / audit
```

Verify `one_time` blocks re-select after use.
