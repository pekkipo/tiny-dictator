# Batch Report — Milestone 2B-9 Sub-batch A

**Batch ID:** 2B-9A  
**Date:** 2026-07-16  
**Result:** **10 approved short-chain decisions** across **4 chains**  
**Did not start:** Sub-batch B until this report existed  

---

## 1. Changed files (9A)

### Content
- `data/decisions/ministan_short_chain_pack_d.json` (new — 10 cards)
- `data/decisions/ministan_standalone_pack_a.json` (removed `perfumed_sewage_reform`)
- `data/follow_up_pools/follow_up_pools.json` (+ `fish_currency_consequences`)
- `data/laws/laws.json` (+4 laws)
- `data/endings/endings.json` (+`government_by_form`)
- `data/visual_states/country_visual_map.json`
- `data/countries/ministan.json`
- `data/content_manifest.json`

### Tools / tests / docs
- `scripts/dev/ContentManifestBuilder.gd`
- `scripts/dev/ContentScaffoldingValidator.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `tests/test_content_scaffolding.gd`
- `docs/content/MINISTAN_CHAIN_CATALOG.md`
- `docs/content/PHASE_2A_CONTENT_AUDIT.md`
- `docs/content/drafts/2B-9A_short_chain_pack_d_plan.md`
- `docs/content/BATCH_REPORTS/2B-9A_short_chain_pack_d.md` (this file)

---

## 2. Chains and branches

| Chain | Cards | Pattern | Speakers |
|-------|------:|---------|----------|
| Salaries Paid in Coupons | 2 | soft + state-dep | Penny → Profit |
| Perfumed Sewage | 2 | soft | Maybe → Olga |
| Form to Request Forms | 3 | hard + soft + ending | Clerk → Clerk → Penny |
| Fish Currency Experiment | 3 | pool + soft + crisis | Whiskers → Profit → Whiskers |

1. **Coupons:** store-credit / tradable / refuse → soft market (clawback / cash / formalize).  
2. **Sewage:** scent pilot / partial repair / pipes-only → soft fallout (real repair / regulate / scrap).  
3. **Forms:** enact / pilot / refuse → hard backlog → soft resolution (deepen / efficiency→`government_by_form` / repeal).  
4. **Fish:** full peg / scrip pilot / refuse → pool boom (ride / admit) → soft resolution (stabilize / reserve / abandon+`bank_run`).

---

## 3. Reuse / rewrite / new / reject / defer

| Action | IDs |
|--------|-----|
| **REWRITE / ABSORB** | `perfumed_sewage_reform` → Perfumed Sewage chain |
| **NEW (10)** | all 2B-9A cards |
| **KEEP adjacent** | `fish_market_subsidy` (mutual exclusion via `blocked_laws`) |
| **DEFER** | Sub-batch B chains; pizza legacy; 2B-10 |
| **REJECTED** | — |

Standalone approved **64 → 63**. Short-chain approved **60 → 70**. Chains approved **24 → 28**.

---

## 4. Quality-rubric scores

All 10 score **≥16/20**. Typical 16–17.

---

## 5. Simulation results (seed 20260715, 1000 runs)

| Metric | Value |
|--------|------:|
| Average run length | 25.2 |
| Content exhaustion | 0 |
| Fallback usage | 1 |
| Forced-follow-up cycles | 0 |
| Narrative-event cycles | 0 |
| Never-selected (global) | boom_loyal_protector, happiness_backlash |

### Pack D selection counts

| Decision | Count |
|----------|------:|
| coupon_salaries_proposal | 123 |
| coupon_salary_market | 81 |
| perfumed_sewage_pilot | 62 |
| perfumed_sewage_fallout | 49 |
| form_request_forms_proposal | 131 |
| form_request_forms_backlog | 101 |
| form_request_forms_resolution | 100 |
| fish_currency_proposal | 65 |
| fish_currency_boom | 42 |
| fish_currency_resolution | 41 |

Every 9A chain starts and reaches ≥1 resolution path. Fish abandon / form efficiency / coupon branches all reachable via F1 Force Decision.

---

## 6. Debug paths (F1 Force Decision by ID)

1. `coupon_salaries_proposal` → store_credit_coupons / tradable_coupons → `coupon_salary_market`  
2. `perfumed_sewage_pilot` → launch_scent_pilot → `perfumed_sewage_fallout`  
3. `form_request_forms_proposal` → enact_meta_form → hard `form_request_forms_backlog` → `form_request_forms_resolution` → buy_form_efficiency  
4. `fish_currency_proposal` → full_fish_peg → pool `fish_currency_boom` → ride_the_fish_boom → `fish_currency_resolution` → abandon_fish_currency (`bank_run`)

---

## 7. Strong-launch quota (after 9A)

| Dimension | Approved | Target | Gap |
|-----------|---------:|-------:|----:|
| Short-chain decisions | 70 | 80 | 10 |
| Short chains | 28 | 32 | 4 |
| Standalone | 63 | 72 | 9 |
| Decisions (approved classes) | 143 | 330 | 187 |

---

## 8. Confirmations

- Sub-batch A complete; Sub-batch B may begin.  
- Milestone 2B-10 not started.  
- Pizza legacy still deferred.
