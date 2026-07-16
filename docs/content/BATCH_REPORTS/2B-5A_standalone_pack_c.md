# Batch Report — Milestone 2B-5 Sub-batch A (Standalone Policy Pack C)

**Batch ID:** 2B-5A  
**Date:** 2026-07-16  
**Result:** **12 approved** standalone decisions — Business 4 / Bureaucracy 4 / Cats 4  
**Did not start:** Sub-batch B until this report  

---

## 1. Changed files (this sub-batch)

- `data/decisions/ministan_standalone_pack_c.json` (new — 12 cards)
- `data/decisions/ministan_generic_fill.json` (removed `daily_cabinet_briefing`, `postal_pigeon_reform`)
- `data/decisions/ministan_core.json` (removed rejected `cat_voting_proposal`)
- `data/laws/laws.json` (+7 laws)
- `data/visual_states/country_visual_map.json` (+13 visual tags)
- `data/countries/ministan.json` (register pack C)
- `data/content_manifest.json` (regenerated)
- `scripts/dev/ContentManifestBuilder.gd`
- `scripts/dev/ContentManifestAuditWriter.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/drafts/2B-5A_standalone_pack_c_plan.md`
- `docs/content/REJECTED_IDEAS.md`
- `docs/content/MINISTAN_CONTENT_STYLE_GUIDE.md` (cat_voting duplicate resolved)
- `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/BATCH_REPORTS/2B-5A_standalone_pack_c.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. Approved decisions (2B-5A)

### Business and privatization (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `capital_square_naming_rights` | sir_profit | NEW | 17 |
| `citizen_service_subscription` | sir_profit | NEW | 17 |
| `national_biscuit_ipo` | sir_profit | NEW | 16 |
| `express_sidewalk_franchise` | sir_profit | NEW | 16 |

### Bureaucracy (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `daily_cabinet_briefing` | clerk_zero | REWRITE | 17 |
| `complaint_permit_office` | clerk_zero | NEW | 16 |
| `contradictory_signage_act` | clerk_zero | NEW | 17 |
| `department_of_renaming` | clerk_zero | NEW | 16 |

### Cats and animals (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `postal_pigeon_reform` | clerk_zero | REWRITE + reclassify | 16 |
| `public_cat_baskets` | comrade_whiskers | NEW | 16 |
| `mouse_protection_act` | comrade_whiskers | NEW | 17 |
| `fish_market_subsidy` | comrade_whiskers | NEW | 17 |

**Speakers:** sir_profit, clerk_zero, comrade_whiskers (3) — B adds Penny, Olga, Boom  
**Stages:** establishment, escalation  

---

## 3. Reuse / rewrite / reject matrix (A)

| Action | IDs |
|--------|-----|
| **REWRITE** | `daily_cabinet_briefing`, `postal_pigeon_reform` |
| **NEW** | capital_square_naming_rights, citizen_service_subscription, national_biscuit_ipo, express_sidewalk_franchise, complaint_permit_office, contradictory_signage_act, department_of_renaming, public_cat_baskets, mouse_protection_act, fish_market_subsidy |
| **REJECTED** | `cat_voting_proposal` (duplicate of arc `cat_voting_rights`; removed from runtime) |
| **DEFER (unchanged)** | `propaganda_smile_campaign` (smile cluster → 2B-11) |

---

## 4. Quality-rubric scores

All 12 score **≥16/20**. Mean ≈16.6. No zero on clarity, voice, choice quality, or technical validity.

---

## 5. Simulation (seed 20260715, 1000 runs)

| Metric | Value |
|--------|------:|
| Average run length | 24.7 |
| Content exhaustion | 155 |
| Fallback usage | 372 |
| Never selected (global) | `boom_loyal_protector`, `happiness_backlash` |

**Note:** Exhaustion/fallback rose vs Pack B (0/0) after removing two **repeatable** generic fillers (`daily_cabinet_briefing`, `postal_pigeon_reform`) and replacing them with one-time standalones. Sub-batch B (+12) is expected to reduce late-pool emptiness. Not a core bug.

### Pack C-A selection counts

| ID | Count |
|----|------:|
| `fish_market_subsidy` | 370 |
| `department_of_renaming` | 352 |
| `national_biscuit_ipo` | 344 |
| `capital_square_naming_rights` | 222 |
| `postal_pigeon_reform` | 205 |
| `daily_cabinet_briefing` | 204 |
| `complaint_permit_office` | 199 |
| `express_sidewalk_franchise` | 189 |
| `citizen_service_subscription` | 143 |
| `public_cat_baskets` | 100 |
| `contradictory_signage_act` | 26 |
| `mouse_protection_act` | 20 |

All 12 selected ≥1×. Rare cards are state-gated (`contradictory_signage_act`, `mouse_protection_act`) — intended.

---

## 6. Quota snapshot after 2B-5A

| Standalone category | Approved | Target |
|---------------------|---------:|-------:|
| Business | 4 | 8 |
| Bureaucracy | 4 | 8 |
| Cats and animals | 4 | 8 |
| **Standalone total** | **60** | **72** |

---

## 7. Manual test checklist (2B-5A)

- [ ] `capital_square_naming_rights` — sell / lease / keep paths; square signs
- [ ] `citizen_service_subscription` — tiers vs public; sets `palace_tour_unlocked`
- [ ] `national_biscuit_ipo` — full / partial / keep; three options
- [ ] `express_sidewalk_franchise` — order hit on express lanes
- [ ] `daily_cabinet_briefing` — audit path adds law; useful bureaucracy
- [ ] `complaint_permit_office` — sets `apology_notarization_unlocked`
- [ ] `contradictory_signage_act` — appears after briefing/permit flags; clarity audit costs treasury
- [ ] `department_of_renaming` — three options; letterhead freeze
- [ ] `postal_pigeon_reform` — category cats; treasury cost
- [ ] `public_cat_baskets` — sets `palace_pet_unlocked`; Whiskers voice
- [ ] `mouse_protection_act` — after baskets/pigeon; cats not auto-favored
- [ ] `fish_market_subsidy` — serious treasury hit

---

## 8. Stop line

Sub-batch A complete. Proceed to **2B-5B** only. Do not start Milestone 2B-6.
