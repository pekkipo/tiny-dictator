# Batch Report — Milestone 2B-9 Short-Chain Pack D (Final)

**Milestone:** 2B-9  
**Date:** 2026-07-16  
**Result:** **20 approved short-chain decisions** across **8 complete short chains**  
**Sub-batches:** [2B-9A](2B-9A_short_chain_pack_d.md), [2B-9B](2B-9B_short_chain_pack_d.md)  
**Did not start:** Milestone 2B-10  

---

## 1. Changed files

### Content
- `data/decisions/ministan_short_chain_pack_d.json` (new — 20 cards)
- `data/decisions/ministan_standalone_pack_a.json` (removed `perfumed_sewage_reform`)
- `data/decisions/ministan_standalone_pack_b.json` (nap grid mutual exclusion)
- `data/follow_up_pools/follow_up_pools.json` (+ fish + antivacuum pools)
- `data/laws/laws.json` (+8 laws)
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
- `docs/content/drafts/2B-9B_short_chain_pack_d_plan.md`
- `docs/content/BATCH_REPORTS/2B-9A_short_chain_pack_d.md`
- `docs/content/BATCH_REPORTS/2B-9B_short_chain_pack_d.md`
- `docs/content/BATCH_REPORTS/2B-9_short_chain_pack_d_final.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. All eight chains and branches

| Chain | Cards | Pattern | Speakers |
|-------|------:|---------|----------|
| Salaries Paid in Coupons | 2 | soft + state-dep | Penny → Profit |
| Perfumed Sewage | 2 | soft | Maybe → Olga |
| Form to Request Forms | 3 | hard + soft + ending | Clerk → Clerk → Penny |
| Fish Currency Experiment | 3 | pool + soft + crisis | Whiskers → Profit → Whiskers |
| Ministry of Waiting | 2 | soft | Clerk → Olga |
| Stamp Shortage | 2 | hard | Clerk → Profit |
| Anti-Vacuum Referendum | 3 | pool + soft + crisis/ending | Whiskers → Olga → Whiskers |
| National Nap Hour | 3 | soft + recovery link | Whiskers → Olga → Whiskers |

### Branch summary

1. **Coupons:** store-credit vs tradable → clawback / cash-out / formalize coupon economy.  
2. **Sewage:** scent pilot / partial repair → real pipes / regulate dosage / scrap (absorbs standalone).  
3. **Forms:** F-0 enact → hard backlog → deepen / **efficiency** (`government_by_form`) / repeal.  
4. **Fish:** peg/scrip → pool boom (ride unstable success) → stabilize / reserve / abandon+`bank_run`.  
5. **Waiting:** ministry founded → extend service / etiquette / dissolve (Order/public service).  
6. **Stamps:** shortage emergency → wax futures / thumbprints / import (not meta-forms).  
7. **Anti-Vacuum:** referendum → campaign (cat/mediate/spin) → quiet hours / timed compromise / reject+`mass_protest`; `cat_favor_choices` → `cat_republic`.  
8. **Nap:** mandate → productivity wave → keep / **timed compromise** / emergency rest → `recovery_national_smile_day`.

---

## 3. Reuse / rewrite / new / reject / defer

| Action | IDs |
|--------|-----|
| **REWRITE / ABSORB (1)** | `perfumed_sewage_reform` → Perfumed Sewage |
| **NEW (20)** | all Pack D cards |
| **KEEP adjacent** | `fish_market_subsidy`, `national_nap_grid`, queue etiquette, cat arc seeds |
| **REJECTED** | — |
| **DEFER** | pizza legacy → later; Milestone 2B-10 |

Standalone approved **64 → 63**. Short-chain approved **60 → 80**. Chains approved **24 → 32**.

---

## 4. Quality-rubric scores

All 20 score **≥16/20**. Typical range 16–17. Mean ≈16.7.

---

## 5. Simulation results

### Sub-batch A (after 10 cards)

| Metric | Value |
|--------|------:|
| Average run length | 25.2 |
| Content exhaustion | 0 |
| Fallback usage | 1 |

### Sub-batch B / final (20 Pack D cards)

| Metric | Value |
|--------|------:|
| Average run length | 25.4 |
| Content exhaustion | 0 |
| Fallback usage | 0 |
| Forced-follow-up cycles | 0 |
| Narrative-event cycles | 0 |
| Never-selected (global) | boom_loyal_protector, happiness_backlash |

### Pack D selection counts (final 1000 runs)

| Decision | Count |
|----------|------:|
| coupon_salaries_proposal | 137 |
| coupon_salary_market | 85 |
| perfumed_sewage_pilot | 68 |
| perfumed_sewage_fallout | 40 |
| form_request_forms_proposal | 119 |
| form_request_forms_backlog | 77 |
| form_request_forms_resolution | 77 |
| fish_currency_proposal | 70 |
| fish_currency_boom | 47 |
| fish_currency_resolution | 46 |
| ministry_of_waiting_proposal | 119 |
| ministry_of_waiting_service | 81 |
| stamp_shortage_crisis | 165 |
| stamp_shortage_workaround | 115 |
| antivacuum_referendum_proposal | 85 |
| antivacuum_campaign | 53 |
| antivacuum_referendum_result | 49 |
| national_nap_hour_proposal | 105 |
| national_nap_productivity | 71 |
| national_nap_resolution | 70 |

### Ending / recovery hits

| Ending / link | Count |
|---------------|------:|
| government_by_form | 22 |
| cat_republic | 27 |
| recovery_national_smile_day (nap link) | 69 |

Every Pack D chain starts and reaches ≥1 resolution. No Pack D ID was never-selected.

---

## 6. Mechanical quota (Pack D)

| Requirement | Result |
|-------------|--------|
| ≥6 primary speakers | Penny, Maybe, Clerk, Whiskers, Olga, Profit (6) |
| Strong feature | Penny, Clerk, Olga, Profit, Whiskers |
| ≥5 laws | 8 new: coupon_salaries, scent_mask_act, form_request_form_act, fish_currency_act, ministry_of_waiting, triple_stamp_requirement, antivacuum_act, national_nap_hour |
| ≥5 affinity / ≥5 traits | Spread across accept/resolve options |
| ≥3 soft / ≥2 hard / ≥2 pooled | Soft: coupons, sewage, waiting, nap×2, vacuum result; Hard: forms, stamps; Pools: fish, antivacuum |
| ≥3 state-dependent | Coupon type; vacuum campaign flags; nap social vs productivity |
| ≥3 three-option | Coupon market, sewage, forms, fish, waiting, stamps, vacuum, nap |
| ≥1 recovery connection | Nap emergency → `recovery_national_smile_day` |
| ≥1 crisis modifier | Fish abandon → bank_run; vacuum reject → mass_protest |
| ≥1 rare ending / identity | `government_by_form`; `cat_republic` via cat_favor |

---

## 7. Strong-launch quota report (after 2B-9)

| Dimension | Approved | Target | Gap |
|-----------|---------:|-------:|----:|
| Short-chain decisions | **80** | 80 | **0** |
| Short chains | **32** | 32 | **0** |
| Standalone | 63 | 72 | 9 |
| Onboarding | 10 | 10 | 0 |
| Decisions (approved classes) | 153 | 330 | 177 |

---

## 8. Debug and manual test paths (F1 Force Decision by ID)

1. `coupon_salaries_proposal` / store_credit_coupons → `coupon_salary_market`  
2. `perfumed_sewage_pilot` / launch_scent_pilot → `perfumed_sewage_fallout`  
3. `form_request_forms_proposal` / enact_meta_form → hard backlog → resolution / buy_form_efficiency  
4. `fish_currency_proposal` / full_fish_peg → pool boom → ride → abandon (`bank_run`)  
5. `ministry_of_waiting_proposal` / found → `ministry_of_waiting_service`  
6. `stamp_shortage_crisis` / declare → hard `stamp_shortage_workaround`  
7. `antivacuum_referendum_proposal` / schedule → pool campaign → quiet hours or reject (`mass_protest`)  
8. `national_nap_hour_proposal` / mandate → productivity → timed_nap_compromise or emergency_civic_rest → recovery  

---

## 9. System fixes

None. Data/tooling only.

---

## 10. Confirmations

- Exactly **8** Pack D chains / **20** Pack D decisions  
- Phase 2B short-chain totals: **32** chains / **80** decisions  
- Packs A–D remain valid  
- Every chain has a reachable completed path  
- No hard follow-up remains permanently queued  
- No forced-follow-up or narrative-event cycles  
- **Milestone 2B-10 not started**
