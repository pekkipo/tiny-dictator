# Batch Report — Milestone 2B-5 Standalone Policy Pack C (Final)

**Milestone:** 2B-5  
**Date:** 2026-07-16  
**Result:** **24 approved standalone decisions** — Business 8 / Bureaucracy 8 / Cats 8  
**Standalone class total:** **72 / 72**  
**Sub-batches:** [2B-5A](2B-5A_standalone_pack_c.md), [2B-5B](2B-5B_standalone_pack_c.md)  
**Did not start:** Milestone 2B-6  

---

## 1. Changed files

### Content
- `data/decisions/ministan_standalone_pack_c.json` (new — 24 cards)
- `data/decisions/ministan_generic_fill.json` (migrated rewrites out; added `routine_form_inventory` pool valve)
- `data/decisions/ministan_core.json` (removed rejected `cat_voting_proposal`)
- `data/laws/laws.json` (+12 laws)
- `data/countries/ministan.json` (register pack C)
- `data/visual_states/country_visual_map.json` (Pack C visual tags)
- `data/content_manifest.json` (regenerated)

### Tools / tests / docs
- `scripts/dev/ContentManifestBuilder.gd`
- `scripts/dev/ContentManifestAuditWriter.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/REJECTED_IDEAS.md`
- `docs/content/MINISTAN_CONTENT_STYLE_GUIDE.md`
- `docs/content/drafts/2B-5A_standalone_pack_c_plan.md`
- `docs/content/drafts/2B-5B_standalone_pack_c_plan.md`
- `docs/content/BATCH_REPORTS/2B-5A_standalone_pack_c.md`
- `docs/content/BATCH_REPORTS/2B-5B_standalone_pack_c.md`
- `docs/content/BATCH_REPORTS/2B-5_standalone_pack_c_final.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. All 24 approved decisions (by category and speaker)

### Business and privatization (8)

| ID | Speaker | Origin |
|----|---------|--------|
| `capital_square_naming_rights` | sir_profit | NEW |
| `citizen_service_subscription` | sir_profit | NEW |
| `national_biscuit_ipo` | sir_profit | NEW |
| `express_sidewalk_franchise` | sir_profit | NEW |
| `working_palace_tours` | sir_profit | NEW |
| `anthem_sponsor_reads` | sir_profit | NEW |
| `sovereign_cookie_futures` | minister_penny | NEW |
| `border_lane_concession` | general_boom | NEW |

### Bureaucracy (8)

| ID | Speaker | Origin |
|----|---------|--------|
| `daily_cabinet_briefing` | clerk_zero | REWRITE |
| `complaint_permit_office` | clerk_zero | NEW |
| `contradictory_signage_act` | clerk_zero | NEW |
| `department_of_renaming` | clerk_zero | NEW |
| `emergency_efficiency_week` | clerk_zero | NEW |
| `notarized_apology_requirement` | clerk_zero | NEW |
| `queue_priority_auction` | minister_penny | NEW |
| `midnight_filing_amnesty` | auntie_olga | NEW |

### Cats and animals (8)

| ID | Speaker | Origin |
|----|---------|--------|
| `postal_pigeon_reform` | clerk_zero | REWRITE + reclassify |
| `public_cat_baskets` | comrade_whiskers | NEW |
| `mouse_protection_act` | comrade_whiskers | NEW |
| `fish_market_subsidy` | comrade_whiskers | NEW |
| `official_palace_pet` | comrade_whiskers | NEW |
| `dog_apology_festival` | auntie_olga | NEW |
| `squirrel_union_recognition` | comrade_whiskers | NEW |
| `crosswalk_cat_priority` | comrade_whiskers | NEW |

**Speakers used (6):** sir_profit, clerk_zero, comrade_whiskers, minister_penny, auntie_olga, general_boom  

**Stages:** establishment, escalation, instability, endgame  

---

## 3. Reuse / rewrite / new / reject / defer matrix

| Action | IDs |
|--------|-----|
| **REWRITE (2)** | `daily_cabinet_briefing`, `postal_pigeon_reform` |
| **NEW (22)** | capital_square_naming_rights, citizen_service_subscription, national_biscuit_ipo, express_sidewalk_franchise, complaint_permit_office, contradictory_signage_act, department_of_renaming, public_cat_baskets, mouse_protection_act, fish_market_subsidy, working_palace_tours, anthem_sponsor_reads, sovereign_cookie_futures, border_lane_concession, emergency_efficiency_week, notarized_apology_requirement, queue_priority_auction, midnight_filing_amnesty, official_palace_pet, dog_apology_festival, squirrel_union_recognition, crosswalk_cat_priority |
| **REJECTED** | `cat_voting_proposal` (duplicate of arc `cat_voting_rights`; removed from runtime) |
| **DEFER (unchanged)** | `propaganda_smile_campaign` (smile cluster → 2B-11) |
| **POOL VALVE (not approved)** | `routine_form_inventory` (placeholder repeatable; restores late-pool after filler migration) |

---

## 4. Quality-rubric scores

All 24 score **≥16/20**. Typical range 16–17. No zero on clarity, voice, choice quality, or technical validity. Mean ≈16.7.

---

## 5. Simulation results

### Sub-batch A (before pool valve)

| Metric | Value |
|--------|------:|
| Average run length | 24.7 |
| Content exhaustion | 155 |
| Fallback usage | 372 |
| Cause | Removed repeatable fillers when rewriting to one-time standalones |

All 12 A cards selected ≥1×. Rare: `mouse_protection_act` (20), `contradictory_signage_act` (26).

### Sub-batch B / final (after `routine_form_inventory`)

| Metric | Value |
|--------|------:|
| Average run length | 25.9 |
| Content exhaustion | **0** |
| Fallback usage | **0** |
| Never selected (global) | `boom_loyal_protector`, `happiness_backlash` (arc-gated; unchanged) |

All 24 Pack C cards selected ≥1×.

**Rare (state-gated):** notarized_apology_requirement (17), mouse_protection_act (17), working_palace_tours (26), contradictory_signage_act (28), official_palace_pet (31)

**Dominant (high selection):** emergency_efficiency_week (383), fish_market_subsidy (352), border_lane_concession (352), squirrel_union_recognition (350)

---

## 6. Strong-launch quota report (updated)

| Dimension | Approved | Target | Gap |
|-----------|---------:|-------:|----:|
| **Standalone class** | **72** | **72** | **0** |
| Business and privatization (standalone Pack C) | **8** | 8 | 0 |
| Bureaucracy (standalone Pack C) | **8** | 8 | 0 |
| Cats and animals (standalone Pack C) | **8** | 8 | 0 |
| Onboarding | 10 | 10 | 0 |
| Decisions approved (onboarding + standalones) | 82 | 330 | 248 |

Note: canonical category `bureaucracy` shows **9** approved because onboarding `bureaucracy_expansion` maps into that category. Pack C **standalone** bureaucracy count is exactly **8**.

---

## 7. Manual test checklist (full Pack C)

### Business
- [ ] Naming rights — non-privatization path; square signs
- [ ] Citizen subscription — tiers; unlocks palace tours
- [ ] Biscuit IPO — three options
- [ ] Express sidewalks — order hit
- [ ] Palace tours — gated; velvet ropes
- [ ] Anthem sponsor — endgame corporate soft
- [ ] Cookie futures — Penny; order/happiness
- [ ] Border lane — Boom; lease vs military

### Bureaucracy
- [ ] Cabinet briefing — useful audit at cost
- [ ] Complaint permits — unlocks notarized apology
- [ ] Contradictory signage — gated; clarity costs treasury
- [ ] Department of renaming — three options
- [ ] Efficiency week — useful backlog clear
- [ ] Notarized apology — gated from permits
- [ ] Queue auction — treasury economics
- [ ] Midnight amnesty — Olga; form-state soft

### Cats
- [ ] Pigeon post — reclassified; treasury cost
- [ ] Cat baskets — unlocks palace pet; order cost
- [ ] Mouse protection — gated; cats not auto-favored
- [ ] Fish subsidy — serious treasury
- [ ] Palace pet — gated; elite clash
- [ ] Dog festival — species competition
- [ ] Squirrel union — serious politics
- [ ] Cat crosswalk — endgame identity soft

---

## 8. Minimal content fix documented

| Fix | Why |
|-----|-----|
| `routine_form_inventory` placeholder repeatable | Pack C rewrites removed two healthy-pool repeatables; sims hit exhaustion/fallback until a low-weight valve was restored. Not Pack C approved; marked needs_rewrite for 2B-6+. |
| Remove `cat_voting_proposal` | Quota-gap duplicate of arc entry. |

No core engine bug fixes required.

---

## 9. Confirmations

- Exactly **8 / 8 / 8** approved Pack C standalones (Business / Bureaucracy / Cats)
- Exactly **72** approved standalones across all nine standalone categories
- Milestone 2B-6 **not started**
