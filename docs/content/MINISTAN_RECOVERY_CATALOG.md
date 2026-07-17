# Ministan Recovery Catalog — Milestone 2B-15

**Status:** Complete (24/24 approved)  
**Target:** 24 approved recovery decisions (exactly 6 per resource)  
**Do not start:** Milestone 2B-17 (laws/endings/palace completion beyond what 2B-16 already wired)

---

## Pre-implementation audit

### Phase 2A placeholders (rewrite in place)

| ID | Target | Speaker | Gate | Defects |
|---|---|---|---|---|
| `recovery_international_bank` | Treasury +18 | `minister_penny` | treasury ≤35 | `one_time: false`; no stage/affinity/delay; accept/refuse only |
| `recovery_national_smile_day` | Happiness +15 | `luna_news` | happiness ≤35 | same; Nap chain soft-links this ID |
| `recovery_martial_law_pause` | Order +14 | `general_boom` | order ≤35 | same; never selected in 2B-14A sims |
| `recovery_elite_dinner` | Elite +14 | `sir_profit` | elite ≤35 | same |

**Disposition:** Rewrite all four; keep IDs. Remove from `ministan_stage_placeholders.json`; ship in pack A.

### Soft-link map (connect, do not duplicate)

| Source | Flag / queue | Recovery touch |
|---|---|---|
| Nap short chain | queues `recovery_national_smile_day` | Keep ID |
| Penny austerity | `penny_austerity_recovery_available` | Gate treasury recovery variants |
| Hyperinflation | `recovery_treasury` | Gate treasury recovery |
| Profit arc | `profit_recovery_soft` | Gate elite recovery |
| AI arc | `ai_shutdown_recovery` | State-dependent recovery |
| Moon arc | `moon_recovery_soft` | State-dependent recovery |
| Doctor Maybe | `science_recovery_soft` | Gate experimental recovery |
| Nap | `civic_rest_recovery` | Soft happiness link |

### Gap after rewrites count toward 6

| Resource | After rewrite | Still need | Sub-batch A new | Sub-batch B new |
|---|---:|---:|---:|---:|
| Treasury | 1 | 5 | 2 | 3 |
| Happiness | 1 | 5 | 2 | 3 |
| Order | 1 | 5 | 2 | 3 |
| Elite Loyalty | 1 | 5 | 2 | 3 |
| **Total** | **4** | **20** | **8** | **12** |

### Content Director (no redesign)

`ContentDirector` prefers `card_type: recovery` when any resource ≤20. Cards gate with `maximum_resources`. Anti-farming via `one_time: true` + flags (engine `cooldown_days` not implemented).

---

## Final roster (locked)

### Sub-batch A (12 recovery + 4 delayed consequences)

| ID | Resource | Speaker | Disposition |
|---|---|---|---|
| `recovery_international_bank` | Treasury | `minister_penny` | Rewrite |
| `recovery_sell_palace_wing` | Treasury | `sir_profit` | New |
| `recovery_emergency_stamp_tax` | Treasury | `clerk_zero` | New |
| `recovery_national_smile_day` | Happiness | `luna_news` | Rewrite |
| `recovery_olga_soup_line` | Happiness | `auntie_olga` | New |
| `recovery_maybe_mood_pilot` | Happiness | `doctor_maybe` | New |
| `recovery_martial_law_pause` | Order | `general_boom` | Rewrite |
| `recovery_olga_block_captains` | Order | `auntie_olga` | New |
| `recovery_zero_queue_charter` | Order | `clerk_zero` | New |
| `recovery_elite_dinner` | Elite | `sir_profit` | Rewrite |
| `recovery_cabinet_nameplates` | Elite | `clerk_zero` | New |
| `recovery_controlled_audit_show` | Elite | `minister_penny` | New |

Delayed consequences (queue_only, not recovery quota):  
`recovery_bank_interest_haiku`, `recovery_smile_hangover`, `recovery_parade_sulk`, `recovery_dinner_tabloid`

### Sub-batch B (12 recovery + 4 delayed consequences)

| ID | Resource | Speaker | Notes |
|---|---|---|---|
| `recovery_foreign_picnic_grant` | Treasury | `foreign_ambassador` | Guest |
| `recovery_austerity_clipboards` | Treasury | `minister_penny` | Law/affinity |
| `recovery_maybe_miracle_bond` | Treasury | `doctor_maybe` | Endgame |
| `recovery_workers_shift_relief` | Happiness | `workers_union_leader` | Guest |
| `recovery_civic_half_day` | Happiness | `clerk_zero` | Law |
| `recovery_endgame_hope_reel` | Happiness | `luna_news` | Endgame |
| `recovery_whiskers_alley_truce` | Order | `comrade_whiskers` | Negotiation |
| `recovery_boom_cone_grid` | Order | `general_boom` | Practical restore |
| `recovery_endgame_quiet_hours` | Order | `chief_judge` | Endgame guest |
| `recovery_prestige_fountain` | Elite | `sir_profit` | Prestige |
| `recovery_shared_blame_board` | Elite | `luna_news` | Shared blame |
| `recovery_endgame_title_lottery` | Elite | `palace_chef` | Endgame guest |

Delayed consequences:  
`recovery_grant_strings`, `recovery_hope_hangover`, `recovery_cone_gridlock`, `recovery_title_grudge`

---

## Cross-pack tracker

| Requirement | Target | A | B | Total |
|---|---:|---:|---:|---:|
| Main advisors (8) | 8 | 7 | +Whiskers | 8 |
| Guest speakers | ≥4 | 0 | 4 | 4 |
| Run stages | 4 | all seeded | endgame filled | 4 |
| Law interactions | ≥8 | ≥4 | ≥4 | ≥8 |
| Affinity gates/changes | ≥8 | ≥4 | ≥4 | ≥8 |
| Trait changes | ≥8 | ≥4 | ≥4 | ≥8 |
| Delayed downsides | ≥8 | 4 | 4 | 8 |
| State-dependent | ≥8 | ≥4 | ≥4 | ≥8 |
| Three-option cards | ≥6 | 3 | 3 | 6 |
| Crisis interactions | ≥4 | 2 | 2 | 4 |
| Arc connections | ≥4 | 2 | 2 | 4 |
| Ending consequences | ≥4 | 2 | 2 | 4 |
| Endgame / resource | 4 | 0 | 4 | 4 |

---

## Runtime files

- `data/decisions/ministan_recovery_pack_a.json`
- `data/decisions/ministan_recovery_pack_b.json`
