# Batch Report — Milestone 2B-5 Sub-batch B (Standalone Policy Pack C)

**Batch ID:** 2B-5B  
**Date:** 2026-07-16  
**Result:** **12 approved** standalone decisions — Business 4 / Bureaucracy 4 / Cats 4  
**Pack C complete:** Business 8 / Bureaucracy 8 / Cats 8  
**Standalone class:** **72 / 72**  

---

## 1. Changed files (this sub-batch)

- `data/decisions/ministan_standalone_pack_c.json` (+12 cards → 24 total)
- `data/decisions/ministan_generic_fill.json` (+`routine_form_inventory` low-weight repeatable pool valve; not Pack C approved)
- `data/laws/laws.json` (+5 laws)
- `data/visual_states/country_visual_map.json` (+13 visual tags)
- `data/content_manifest.json` (regenerated)
- `scripts/dev/ContentManifestBuilder.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/drafts/2B-5B_standalone_pack_c_plan.md`
- `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/BATCH_REPORTS/2B-5B_standalone_pack_c.md` (this file)

**Core systems:** no gameplay engine changes.

**Minimal content fix:** After Pack C A removed two repeatable fillers, sims showed exhaustion/fallback. Added `routine_form_inventory` (placeholder / needs_rewrite, weight 3, not Pack C approved) to restore late-pool safety. Exhaustion returned to **0**.

---

## 2. Approved decisions (2B-5B)

### Business (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `working_palace_tours` | sir_profit | NEW | 17 |
| `anthem_sponsor_reads` | sir_profit | NEW | 17 |
| `sovereign_cookie_futures` | minister_penny | NEW | 16 |
| `border_lane_concession` | general_boom | NEW | 16 |

### Bureaucracy (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `emergency_efficiency_week` | clerk_zero | NEW | 17 |
| `notarized_apology_requirement` | clerk_zero | NEW | 16 |
| `queue_priority_auction` | minister_penny | NEW | 17 |
| `midnight_filing_amnesty` | auntie_olga | NEW | 17 |

### Cats (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `official_palace_pet` | comrade_whiskers | NEW | 16 |
| `dog_apology_festival` | auntie_olga | NEW | 16 |
| `squirrel_union_recognition` | comrade_whiskers | NEW | 17 |
| `crosswalk_cat_priority` | comrade_whiskers | NEW | 17 |

**Speakers across Pack C (6):** sir_profit, clerk_zero, comrade_whiskers, minister_penny, auntie_olga, general_boom  
**Stages:** establishment, escalation, instability, endgame  

---

## 3. Simulation (seed 20260715, 1000 runs) — after pool valve

| Metric | Value |
|--------|------:|
| Average run length | 25.9 |
| Content exhaustion | 0 |
| Fallback usage | 0 |
| Never selected (global) | `boom_loyal_protector`, `happiness_backlash` |

### Pack C-B selection counts

| ID | Count |
|----|------:|
| `emergency_efficiency_week` | 383 |
| `border_lane_concession` | 352 |
| `squirrel_union_recognition` | 350 |
| `midnight_filing_amnesty` | 319 |
| `crosswalk_cat_priority` | 313 |
| `anthem_sponsor_reads` | 308 |
| `queue_priority_auction` | 133 |
| `sovereign_cookie_futures` | 108 |
| `dog_apology_festival` | 90 |
| `official_palace_pet` | 31 |
| `working_palace_tours` | 26 |
| `notarized_apology_requirement` | 17 |

All 12 selected ≥1×. Rare cards are state-gated (tours, apology, palace pet) — intended.

---

## 4. Distribution gates (full Pack C)

| Gate | Result |
|------|--------|
| Speakers ≥6 | **6** |
| All four stages | **yes** |
| Laws ≥6 | **12** Pack C laws |
| Affinity ≥6 | **yes** |
| Traits ≥6 | **yes** |
| State gates ≥4 | **5** (signage, mouse, tours, apology, palace pet) |
| Soft downstream ≥4 | **yes** |
| Three-option ≥4 | **6** (naming, biscuit, renaming, pigeon, tours, anthem, cookie, border, efficiency, apology, queue, amnesty, palace pet, dog, squirrel, crosswalk — many) |
| Non-privatization business ≥2 | naming + anthem sponsor |
| Useful bureaucracy ≥2 | briefing audit + signage clarity + efficiency + amnesty |
| Serious cats ≥2 | mouse politics + fish treasury + squirrel union |
| Identity soft per category | corporate / government_by_form / cat_identity flags |

---

## 5. Manual test checklist (2B-5B)

- [ ] `working_palace_tours` — after subscription flag; velvet tours
- [ ] `anthem_sponsor_reads` — endgame; corporate soft flag
- [ ] `sovereign_cookie_futures` — Penny; order swings
- [ ] `border_lane_concession` — Boom; lease vs military vs equal
- [ ] `emergency_efficiency_week` — useful backlog clear at cost
- [ ] `notarized_apology_requirement` — after complaint permit
- [ ] `queue_priority_auction` — three options; treasury path
- [ ] `midnight_filing_amnesty` — Olga endgame; form-state soft
- [ ] `official_palace_pet` — after baskets; elite clash
- [ ] `dog_apology_festival` — Whiskers affinity risk
- [ ] `squirrel_union_recognition` — serious politics; three opts
- [ ] `crosswalk_cat_priority` — endgame order hit; cat identity soft

---

## 6. Stop line

Pack C complete. **Do not begin Milestone 2B-6.**
