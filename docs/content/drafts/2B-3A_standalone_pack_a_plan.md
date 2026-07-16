# Draft Plan — Milestone 2B-3 Sub-batch A

**Batch ID:** 2B-3A  
**Target:** 12 approved standalone decisions (4 Economy, 4 Public Life, 4 Infrastructure)  
**Status:** Ready for integration  

## Phase 0 reclassification (not Pack A approved)

| ID | Action |
|----|--------|
| `cat_voting_proposal` | Deferred (duplicate of arc entry) |
| `cat_parliament`, `cat_fish_budget` | short_chain via `cat_politics_followups` |
| `happiness_backlash` | major_arc via `narrative.arc_id` |
| `maybe_moon_dust_trial` | major_arc via `narrative.arc_id` |
| Pack B/C fill cards | Remain integrated / deferred; not approved |

## Sub-batch A inventory

| ID | Action | Category | Speaker | Stage | Mechanics | Visual tag |
|----|--------|----------|---------|-------|-----------|------------|
| `privatize_rainwater` | REWRITE | economy | sir_profit | establishment | affinity + trait | `rain_bucket_protests` |
| `treasury_tip_jar` | REWRITE | economy | minister_penny | establishment | treasury gimmick + affinity | `treasury_tip_jar` |
| `no_weekends_proposal` | REWRITE | economy | minister_penny | establishment | law `no_weekends` + trait | `tired_citizens` |
| `luxury_chair_tax` | NEW | economy | minister_penny | establishment | law `luxury_chair_tax` | `taxed_chairs` |
| `neighborhood_noise_complaint` | REWRITE | public_life | auntie_olga | establishment | order/happiness trade-off | `accordion_alley` |
| `olga_loyal_council` | REWRITE | public_life | auntie_olga | escalation | affinity ≥3 gate; traits | `citizen_brigade` |
| `national_bedtime_decree` | NEW | public_life | auntie_olga | establishment | law `national_bedtime` | `curtains_drawn` |
| `free_coffee_morning` | NEW | public_life | auntie_olga | escalation | subsidy + soft follow-up flag | `coffee_kiosks` |
| `long_setup_grand_canal` | REWRITE | infrastructure | minister_penny | establishment | flag + soft queue to bus routes | `grand_canal_sign` |
| `sponsored_potholes` | NEW | infrastructure | sir_profit | establishment | privatization flag + affinity | `sponsored_potholes` |
| `perfumed_sewage_reform` | NEW | infrastructure | minister_penny | escalation | happiness vs treasury | `perfumed_sewers` |
| `national_clock_sync` | NEW | infrastructure | clerk_zero | establishment | order/bureaucracy trade; trait | `synchronized_clocks` |

## Distribution checklist (running toward full Pack A)

- Speakers so far: Penny, Olga, Profit, Clerk Zero (4) — B adds Luna, Boom, Maybe
- Laws so far: no_weekends, luxury_chair_tax, national_bedtime (3)
- Affinity: rainwater, tip jar, olga council, potholes (4)
- Traits: weeknds, rainwater, olga, clock (4)
- State gates: olga affinity ≥3 (1)
- Soft downstream: canal → soft follow_up to palace_bus_routes (B card deferred until B lands; use flag for A)

## Joke structure tags (max 2 shared)

- `tax_absurd_object`: luxury_chair_tax only in A
- `privatize_public_good`: rainwater, sponsored_potholes (2 — stop)
- `citizen_complaint`: noise, bedtime (distinct settings)
