# Batch Report — Milestone 2B-6 Sub-batch B (Short-Chain Pack A)

**Batch ID:** 2B-6B  
**Date:** 2026-07-16  
**Result:** **10 approved** short-chain decisions across **4 chains**  
**Milestone total after B:** **20 decisions / 8 chains**  
**Did not start:** Milestone 2B-7  

---

## 1. Changed files (this sub-batch)

- `data/decisions/ministan_short_chain_pack_a.json` (+10 cards; file now 20)
- `data/decisions/ministan_standalone_pack_a.json` (removed elevator, potholes, canal seeds; bus routes flag update)
- `data/laws/laws.json` (+`palace_gift_shop_act`, `sponsored_potholes_act`)
- `data/visual_states/country_visual_map.json`
- `data/content_manifest.json` (regenerated)
- `scripts/dev/ContentManifestBuilder.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/drafts/2B-6B_short_chain_pack_a_plan.md`
- `docs/content/MINISTAN_CHAIN_CATALOG.md`
- `docs/content/MINISTAN_CONTENT_STYLE_GUIDE.md` (pizza defer → 2B-7+)
- `docs/content/PHASE_2A_CONTENT_AUDIT.md`
- `docs/content/BATCH_REPORTS/2B-6B_short_chain_pack_a.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. Approved decisions (2B-6B)

| Chain | IDs | Speakers |
|-------|-----|----------|
| Palace Gift Shop (2) | `palace_gift_shop_opening`, `gift_shop_merch_scandal` | Profit |
| Elevator Wi-Fi (2) | `elevator_wifi_mandate`, `elevator_wifi_trap` | Maybe, Luna |
| Pothole Naming Rights (3) | `sponsored_potholes`, `pothole_brand_war`, `pothole_naming_resolution` | Profit, Boom |
| Bridge to Nowhere (3) | `long_setup_grand_canal`, `bridge_budget_overrun`, `bridge_to_nowhere_resolution` | Penny, Clerk |

---

## 3. Reuse matrix (B)

| Action | IDs |
|--------|-----|
| **REWRITE** | `elevator_wifi_mandate`, `sponsored_potholes`, `long_setup_grand_canal` |
| **NEW** | palace_gift_shop_opening, gift_shop_merch_scandal, elevator_wifi_trap, pothole_brand_war, pothole_naming_resolution, bridge_budget_overrun, bridge_to_nowhere_resolution |

---

## 4. Quality scores

All 10 score **≥16/20**. Mean ≈16.6.

---

## 5. Simulation (seed 20260715, 1000 runs) — full library after B

| Metric | Value |
|--------|------:|
| Average run length | 26.3 |
| Content exhaustion | **0** |
| Fallback usage | **0** |
| Never selected | `boom_loyal_protector`, `happiness_backlash` |

### B chain selection counts

| ID | Count |
|----|------:|
| `long_setup_grand_canal` | 184 |
| `palace_gift_shop_opening` | 178 |
| `sponsored_potholes` | 148 |
| `elevator_wifi_mandate` | 134 |
| `bridge_to_nowhere_resolution` | 109 |
| `pothole_brand_war` | 88 |
| `pothole_naming_resolution` | 88 |
| `elevator_wifi_trap` | 75 |
| `bridge_budget_overrun` | 61 |
| `gift_shop_merch_scandal` | 57 |

All 10 B cards selected ≥1×.

---

## 6. Manual test checklist (2B-6B)

- [ ] Gift shop open → soft scandal; expand vs recall
- [ ] Elevator pilot → hard trap; reboot vs floating office
- [ ] Potholes sponsor → soft brand war (Boom) → resolution
- [ ] Bridge break ground → overrun → resolution; paper path soft → resolution

---

## 7. Confirmations

- Pack A complete: **20 / 8**
- Milestone 2B-7 **not started**
