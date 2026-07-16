# Batch Report — Milestone 2B-6 Sub-batch A (Short-Chain Pack A)

**Batch ID:** 2B-6A  
**Date:** 2026-07-16  
**Result:** **10 approved** short-chain decisions across **4 chains**  
**Did not start:** Sub-batch B until this report  

---

## 1. Changed files (this sub-batch)

- `data/decisions/ministan_short_chain_pack_a.json` (new — 10 cards)
- `data/decisions/ministan_standalone_pack_a.json` (removed coffee + lottery seeds)
- `data/follow_up_pools/follow_up_pools.json` (+2 pools)
- `data/laws/laws.json` (+4 laws)
- `data/endings/endings.json` (+`corporate_ministan`)
- `data/visual_states/country_visual_map.json`
- `data/countries/ministan.json` (register pack)
- `data/content_manifest.json` (regenerated)
- `scripts/dev/ContentManifestBuilder.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/drafts/2B-6A_short_chain_pack_a_plan.md`
- `docs/content/MINISTAN_CHAIN_CATALOG.md` (4 chains → approved)
- `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/BATCH_REPORTS/2B-6A_short_chain_pack_a.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. Approved decisions (2B-6A)

| Chain | IDs | Speakers |
|-------|-----|----------|
| Umbrella Tax (2) | `umbrella_tax_proposal`, `umbrella_tax_enforcement` | Penny |
| National Coffee Reserve (3) | `free_coffee_morning`, `coffee_hoarding_crisis`, `coffee_reserve_resolution` | Olga, Luna, Clerk |
| Privatized Public Benches (3) | `privatized_benches_proposal`, `bench_subscription_backlash`, `bench_policy_resolution` | Profit, Olga |
| Lottery Budget (2) | `lottery_treasury_fund`, `lottery_odds_collapse` | Penny |

**Speakers A:** Penny, Olga, Profit, Luna, Clerk (5) — B adds Maybe (+ Boom)  
**Follow-ups:** hard (umbrella), pool (coffee, benches), soft (coffee resolution, lottery, benches resolution)  
**Ending:** benches → `corporate_ministan` (43 hits / 1000)  
**Crisis modifier:** lottery double-down → `bank_run` start after treasury hit  

---

## 3. Reuse / rewrite / reject matrix (A)

| Action | IDs |
|--------|-----|
| **REWRITE** | `free_coffee_morning`, `lottery_treasury_fund` |
| **NEW** | umbrella_tax_proposal, umbrella_tax_enforcement, coffee_hoarding_crisis, coffee_reserve_resolution, privatized_benches_proposal, bench_subscription_backlash, bench_policy_resolution, lottery_odds_collapse |
| **REJECTED** | — |
| **DEFER** | Pack B chains; pizza legacy refactor |

---

## 4. Quality-rubric scores

All 10 score **≥16/20**. Mean ≈16.7. No zero on clarity, voice, choice quality, or technical validity.

---

## 5. Simulation (seed 20260715, 1000 runs)

| Metric | Value |
|--------|------:|
| Average run length | 26.3 |
| Content exhaustion | **0** |
| Fallback usage | **0** |
| Never selected (global) | `boom_loyal_protector`, `happiness_backlash` |

### Pack A chain selection counts

| ID | Count |
|----|------:|
| `lottery_treasury_fund` | 199 |
| `free_coffee_morning` | 141 |
| `umbrella_tax_proposal` | 133 |
| `privatized_benches_proposal` | 125 |
| `coffee_reserve_resolution` | 95 |
| `bench_policy_resolution` | 85 |
| `lottery_odds_collapse` | 69 |
| `coffee_hoarding_crisis` | 53 |
| `umbrella_tax_enforcement` | 44 |
| `bench_subscription_backlash` | 38 |

All 10 cards selected ≥1×. Rarest: pool members / hard enforcement (expected).

**Chain start / completion (proxy via setup vs complete flags in selection):**  
- Starts: setups selected 133–199×  
- Resolutions: umbrella 44, coffee 95, benches 85, lottery 69 — all chains reach resolution paths  

---

## 6. Quota snapshot

| Dimension | Approved | Target | Gap |
|-----------|---------:|-------:|----:|
| Short-chain decisions | **10** | 80 | 70 |
| Short chains (catalog) | **4** | 32 | 28 |
| Standalone | **70** | 72 | 2 (intentional reclass) |
| Decisions approved total | **90** | 330 | 240 |

---

## 7. Manual test checklist (2B-6A)

### Umbrella Tax
- [ ] Force `umbrella_tax_proposal` → Tax umbrellas → forced `umbrella_tax_enforcement`
- [ ] Enforcement: tax buckets vs repeal (removes law)

### Coffee Reserve
- [ ] Force `free_coffee_morning` → Fund → pool → `coffee_hoarding_crisis` → soft → resolution
- [ ] Half-price path soft → `coffee_reserve_resolution` (state-dependent)
- [ ] Deny path: no follow-up

### Benches
- [ ] Force `privatized_benches_proposal` → subscription → pool → backlash → resolution
- [ ] Keep privatization → `corporate_benches_empire` (ending path)
- [ ] Elite lounge soft → resolution

### Lottery
- [ ] Force `lottery_treasury_fund` → Launch → soft → `lottery_odds_collapse`
- [ ] Print more tickets: treasury hit + may start `bank_run`

**Debug:** F1 Force Decision by ID; Cancel Queue if testing cancel paths.

---

## 8. Confirmations

- Exactly **10** approved short-chain decisions in 2B-6A
- Exactly **4** approved Pack A chains so far
- Exhaustion **0**, fallback **0**
- Sub-batch B **not started** until after this report
