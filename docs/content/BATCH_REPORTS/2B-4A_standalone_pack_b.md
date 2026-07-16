# Batch Report — Milestone 2B-4 Sub-batch A (Standalone Policy Pack B)

**Batch ID:** 2B-4A  
**Date:** 2026-07-16  
**Result:** **12 approved** standalone decisions — Military 4 / Media 4 / Science 4  
**Did not start:** Sub-batch 2B-4B  

---

## 1. Changed files (this sub-batch)

- `data/decisions/ministan_standalone_pack_b.json` (new — 12 cards)
- `data/decisions/ministan_stage_placeholders.json` (removed `escalation_only_rival_parade`)
- `data/decisions/ministan_generic_fill.json` (removed `national_anthem_remix`, `science_grant_request`)
- `data/laws/laws.json` (+6 laws)
- `data/visual_states/country_visual_map.json` (+12 visual tags)
- `data/countries/ministan.json` (register pack B)
- `data/content_manifest.json` (regenerated)
- `scripts/dev/ContentManifestBuilder.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/drafts/2B-4A_standalone_pack_b_plan.md`
- `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/BATCH_REPORTS/2B-4A_standalone_pack_b.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. Approved decisions (2B-4A)

### Military (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `escalation_only_rival_parade` | general_boom | REWRITE | 17 |
| `palace_curfew_drill` | general_boom | NEW | 17 |
| `emergency_salute_protocol` | general_boom | NEW | 16 |
| `civilian_marching_band` | auntie_olga | NEW | 17 |

### Media (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `national_anthem_remix` | luna_news | REWRITE | 16 |
| `one_headline_policy` | luna_news | NEW | 17 |
| `licensed_rumor_bureau` | luna_news | NEW | 17 |
| `official_statistics_festival` | clerk_zero | NEW | 16 |

### Science (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `science_grant_request` | doctor_maybe | REWRITE | 17 |
| `predictive_toaster_admin` | doctor_maybe | NEW | 17 |
| `cloud_relocation_trial` | doctor_maybe | NEW | 17 |
| `prototype_scooter_fleet` | doctor_maybe | NEW | 16 |

**Speakers:** Boom, Luna, Maybe, Olga, Clerk (5)  
**Stages:** establishment, escalation (instability/endgame deferred to 2B-4B)

---

## 3. Rubric summary

All 12 score **≥16/20**. No zero on clarity, voice, choice quality, or technical validity. Mean ≈16.75.

---

## 4. Simulation (seed 20260715, 1000 runs)

| Metric | Value |
|--------|------:|
| Average run length | 24.4 |
| Content exhaustion | 0 |
| Fallback usage | 0 |
| Never selected (global) | `boom_loyal_protector`, `happiness_backlash` |

### Pack B-A selection counts

| ID | Count |
|----|------:|
| `one_headline_policy` | 459 |
| `prototype_scooter_fleet` | 270 |
| `civilian_marching_band` | 264 |
| `science_grant_request` | 260 |
| `palace_curfew_drill` | 258 |
| `national_anthem_remix` | 230 |
| `escalation_only_rival_parade` | 226 |
| `predictive_toaster_admin` | 218 |
| `official_statistics_festival` | 195 |
| `licensed_rumor_bureau` | 155 |
| `cloud_relocation_trial` | 133 |
| `emergency_salute_protocol` | 85 |

Rare (state-gated): salute protocol, cloud trial. Dominant: one headline policy.

---

## 5. Distribution progress toward full Pack B

| Gate | After A | Need |
|------|--------:|-----:|
| Speakers | 5 | ≥6 |
| Stages | est+esc | all 4 |
| Laws | 6 | ≥6 |
| Affinity | ≥6 | ≥6 |
| Traits | ≥6 | ≥6 |
| State gates | 2 | ≥4 |
| Soft follow-ups | 4 | ≥4 |
| Three-option | 5 | ≥4 |
| Non-auth military | 2 | ≥2 |
| Media non-happiness | 2 | ≥2 |
| Science costly success | 2 | ≥2 |

---

## 6. Manual test checklist (2B-4A)

- [ ] Rival parade: nine tanks / flower gift / ignore
- [ ] Palace curfew: enforce / symbolic / skip
- [ ] Marching band → soft queue salute (if flag set)
- [ ] Salute protocol appears only with band/curfew/parade flag
- [ ] Anthem remix release vs classic
- [ ] One headline: one / three / chaos
- [ ] Rumor bureau → soft queue headline
- [ ] Statistics festival: fund / paper / cancel
- [ ] Science grant full fund → soft cloud trial
- [ ] Cloud trial gated on `cloud_shape_grant`
- [ ] Toaster admin → soft scooter fleet
- [ ] Scooter: roll out / pilot / shelve
- [ ] Visual tags appear in law bar / diorama placeholders
- [ ] No mandatory chain required for any card

---

## 7. Quota snapshot

- Standalone approved: **36 / 72**
- Military/media/science standalone approved: **4 / 4 / 4** (of 8 each)
- Total decisions: 103; laws: 24
