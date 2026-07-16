# Batch Report — Milestone 2B-6 Short-Chain Pack A (Final)

**Milestone:** 2B-6  
**Date:** 2026-07-16  
**Result:** **20 approved short-chain decisions** across **8 complete short chains**  
**Sub-batches:** [2B-6A](2B-6A_short_chain_pack_a.md), [2B-6B](2B-6B_short_chain_pack_a.md)  
**Did not start:** Milestone 2B-7  

---

## 1. Changed files

### Content
- `data/decisions/ministan_short_chain_pack_a.json` (new — 20 cards)
- `data/decisions/ministan_standalone_pack_a.json` (5 seeds moved/rewired)
- `data/follow_up_pools/follow_up_pools.json` (+ coffee + benches pools)
- `data/laws/laws.json` (+6 laws)
- `data/endings/endings.json` (+`corporate_ministan`)
- `data/visual_states/country_visual_map.json`
- `data/countries/ministan.json`
- `data/content_manifest.json`

### Tools / tests / docs
- `scripts/dev/ContentManifestBuilder.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/MINISTAN_CHAIN_CATALOG.md`
- `docs/content/MINISTAN_CONTENT_STYLE_GUIDE.md`
- `docs/content/PHASE_2A_CONTENT_AUDIT.md`
- `docs/content/drafts/2B-6A_short_chain_pack_a_plan.md`
- `docs/content/drafts/2B-6B_short_chain_pack_a_plan.md`
- `docs/content/BATCH_REPORTS/2B-6A_short_chain_pack_a.md`
- `docs/content/BATCH_REPORTS/2B-6B_short_chain_pack_a.md`
- `docs/content/BATCH_REPORTS/2B-6_short_chain_pack_a_final.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. All eight chains and branches

| Chain | Cards | Pattern | Speakers |
|-------|------:|---------|----------|
| Umbrella Tax | 2 | hard | Penny |
| National Coffee Reserve | 3 | pool + soft | Olga → Luna → Clerk |
| Privatized Public Benches | 3 | pool + soft | Profit → Olga → Profit |
| Lottery Budget | 2 | soft + crisis start | Penny |
| Palace Gift Shop | 2 | soft | Profit |
| Elevator Wi-Fi | 2 | hard | Maybe → Luna |
| Pothole Naming Rights | 3 | soft + soft | Profit → Boom → Profit |
| Bridge to Nowhere | 3 | soft (dig/paper state) | Penny → Clerk → Penny |

### Branch summary

1. **Umbrella:** tax → enforce (buckets vs repeal); rainy-day / refuse end chain early.  
2. **Coffee:** fund → pool hoarding → reserve vs end; half-price soft → resolution; deny ends.  
3. **Benches:** subscription → backlash → keep (ending flag) vs renationalize; elite lounge soft → resolution; keep public ends.  
4. **Lottery:** launch → odds (bail / print+bank_run / shut); ban / palace-only end early.  
5. **Gift shop:** open → scandal (recall vs expand merch); pop-up / no shop end early.  
6. **Elevator:** pilot → hard trap (reboot vs floating office); plain buttons ends.  
7. **Potholes:** sponsor → brand war → civic plaques vs permanent brands; public repair ends.  
8. **Bridge:** dig → overrun → finish/monument; paper → resolution; postpone ends.

---

## 3. Reuse / rewrite / new / reject / defer

| Action | IDs |
|--------|-----|
| **REWRITE (5)** | `free_coffee_morning`, `lottery_treasury_fund`, `elevator_wifi_mandate`, `sponsored_potholes`, `long_setup_grand_canal` |
| **NEW (15)** | umbrella×2, coffee follow-ups×2, benches×3, lottery odds, gift shop×2, elevator trap, pothole follow-ups×2, bridge follow-ups×2 |
| **REJECTED** | — |
| **DEFER** | Pizza legacy refactor → 2B-7+; remaining 24 catalog chains |

Standalone approved **72 → 67** (intentional reclassification of five seeds).

---

## 4. Quality-rubric scores

All 20 score **≥16/20**. Typical range 16–17. Mean ≈16.7.

---

## 5. Simulation results

### Sub-batch A (after 10 cards)

| Metric | Value |
|--------|------:|
| Average run length | 26.3 |
| Content exhaustion | 0 |
| Fallback usage | 0 |
| `corporate_ministan` ending | 43 |

### Sub-batch B / final (20 cards)

| Metric | Value |
|--------|------:|
| Average run length | 26.3 |
| Content exhaustion | **0** |
| Fallback usage | **0** |
| Never selected (global) | `boom_loyal_protector`, `happiness_backlash` |
| `corporate_ministan` | 47 |
| Lottery→`bank_run` | observed in sims |

All **20** Pack A short-chain decisions selected ≥1× in final 1000-run sim.

**Rarest branches:** `coffee_hoarding_crisis` (32), `bench_subscription_backlash` (39), `umbrella_tax_enforcement` (40) — pool/hard paths.

---

## 6. Mechanical quota (Pack A)

| Requirement | Result |
|-------------|--------|
| ≥6 speakers | Penny, Olga, Profit, Luna, Clerk, Maybe, Boom (7) |
| ≥4 laws | umbrella_tax, national_coffee_reserve, bench_subscription_act, national_lottery_budget, palace_gift_shop_act, sponsored_potholes_act (6) |
| ≥4 affinity / traits | Across setups and resolutions |
| ≥3 soft follow-ups | coffee, lottery, benches, gift, potholes, bridge |
| ≥2 hard | umbrella, elevator |
| ≥2 pools | coffee_reserve_consequences, bench_privatization_consequences |
| ≥2 state-dependent | coffee free/discount; bridge dig/paper |
| ≥2 three-option | coffee, benches, gift, bridge |
| Ending influence | benches → `corporate_ministan` |
| Crisis modifier | lottery double_down → `bank_run` start |

---

## 7. Strong-launch quota report (updated)

| Dimension | Approved | Target | Gap |
|-----------|---------:|-------:|----:|
| **Short-chain decisions** | **20** | 80 | 60 |
| **Short chains** | **8** | 32 | 24 |
| Standalone | **67** | 72 | 5 (reclass) |
| Onboarding | 10 | 10 | 0 |
| Decisions approved total | **97** | 330 | 233 |

---

## 8. Debug / manual test paths

F1 Force Decision by ID for each setup; follow forced/queued cards:

| Chain | Debug path |
|-------|------------|
| Umbrella | `umbrella_tax_proposal` / pass_tax → forced `umbrella_tax_enforcement` |
| Coffee | `free_coffee_morning` / fund_coffee → wait pool → hoarding → resolution |
| Benches | `privatized_benches_proposal` / full_subscription → backlash → keep_privatization |
| Lottery | `lottery_treasury_fund` / launch → `lottery_odds_collapse` / double_down |
| Gift shop | `palace_gift_shop_opening` / open_shop → `gift_shop_merch_scandal` |
| Elevator | `elevator_wifi_mandate` / pilot_wifi → forced `elevator_wifi_trap` |
| Potholes | `sponsored_potholes` / approve → brand war → resolution |
| Bridge | `long_setup_grand_canal` / dig → overrun → resolution |

---

## 9. Minimal system / tooling fixes

| Fix | Why |
|-----|-----|
| `palace_bus_routes` any_flags includes `bridge_groundbroken` | Canal seed rewritten to bridge flags |
| Scaffolding expected decision count 76→151; phase → `2b_6_short_chain_pack_a` | Stale 2B-1 baseline after content growth |

No gameplay engine changes.

---

## 10. Confirmations

- Exactly **8** approved short chains  
- Exactly **20** approved short-chain decisions  
- No forced-follow-up or narrative-event cycles in diagnostics  
- Exhaustion 0, fallback 0  
- Milestone 2B-7 **not started**
