# Batch Report — Milestone 2B-4 Sub-batch B (Standalone Policy Pack B)

**Batch ID:** 2B-4B  
**Date:** 2026-07-16  
**Result:** **12 approved** standalone decisions — Military 4 / Media 4 / Science 4  
**Pack B complete:** Military 8 / Media 8 / Science 8  

---

## 1. Changed files (this sub-batch)

- `data/decisions/ministan_standalone_pack_b.json` (+12 cards → 24 total)
- `data/decisions/ministan_advisor_affinity.json` (removed `boom_hostile_coup_rumor`)
- `data/laws/laws.json` (+4 laws)
- `data/visual_states/country_visual_map.json` (+13 visual tags)
- `data/content_manifest.json` (regenerated)
- `scripts/dev/ContentManifestBuilder.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `docs/content/drafts/2B-4B_standalone_pack_b_plan.md`
- `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/BATCH_REPORTS/2B-4B_standalone_pack_b.md` (this file)

**Core systems:** no gameplay engine changes.

---

## 2. Approved decisions (2B-4B)

### Military (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `boom_hostile_coup_rumor` | general_boom | REWRITE | 17 |
| `ceremonial_tank_florists` | general_boom | NEW | 17 |
| `honor_guard_crosswalk` | general_boom | NEW | 16 |
| `volunteer_night_watch` | clerk_zero | NEW | 17 |

### Media (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `weather_optimism_bulletin` | luna_news | NEW | 16 |
| `loyalty_variety_hour` | luna_news | NEW | 17 |
| `catchphrase_registry` | luna_news | NEW | 17 |
| `crisis_reframing_desk` | luna_news | NEW | 17 |

### Science (4)

| ID | Speaker | Origin | Rubric |
|----|---------|--------|-------:|
| `lab_coat_streetlights` | doctor_maybe | NEW | 17 |
| `national_nap_grid` | doctor_maybe | NEW | 16 |
| `clinic_maybe_pilot` | doctor_maybe | NEW | 17 |
| `cabinet_hypothesis_board` | minister_penny | NEW | 17 |

**Speakers added:** minister_penny (6+ distinct across Pack B)  
**Stages added:** instability, endgame  

---

## 3. Simulation (seed 20260715, 1000 runs)

| Metric | Value |
|--------|------:|
| Average run length | 24.4 |
| Content exhaustion | 0 |
| Fallback usage | 0 |
| Never selected (global) | `boom_loyal_protector`, `happiness_backlash` |

### Pack B-B selection counts

| ID | Count |
|----|------:|
| `national_nap_grid` | 413 |
| `volunteer_night_watch` | 293 |
| `catchphrase_registry` | 233 |
| `honor_guard_crosswalk` | 219 |
| `clinic_maybe_pilot` | 209 |
| `ceremonial_tank_florists` | 175 |
| `cabinet_hypothesis_board` | 173 |
| `loyalty_variety_hour` | 163 |
| `lab_coat_streetlights` | 144 |
| `weather_optimism_bulletin` | 144 |
| `crisis_reframing_desk` | 111 |
| `boom_hostile_coup_rumor` | 106 |

All 12 selected ≥1×. Rarest: boom hostile rumor (affinity gate), crisis reframing (flag+endgame).

---

## 4. Distribution gates (full Pack B — closed)

| Gate | Result |
|------|--------|
| Speakers ≥6 | Boom, Luna, Maybe, Olga, Clerk, Penny |
| All four stages | yes |
| Laws ≥6 | 10 new Pack B laws |
| Affinity ≥6 | yes |
| Traits ≥6 | yes |
| State gates ≥4 | salute, clouds, boom affinity, loyalty variety, reframing, clinic, cabinet treasury |
| Soft follow-ups ≥4 | band→salute, rumor→headline, grant→clouds, toaster→scooters, weather→variety, catchphrase→reframing, coats→naps, board→clinic |
| Three-option ≥4 | many |
| Non-auth military ≥2 | marching band, volunteer watch (+ flower parade path) |
| Media non-happiness ≥2 | headline, statistics, variety, reframing |
| Science costly success ≥2 | grant, clouds, coats, clinic |
| Identity hooks | authoritarian/populist (military), propagandist (media), scientific (science) |

---

## 5. Manual test checklist (2B-4B)

- [ ] Boom rumor only when Boom affinity ≤ -3
- [ ] Tank florists / honor crosswalk / volunteer watch paths
- [ ] Weather optimism → soft variety hour
- [ ] Variety hour requires prior media flag
- [ ] Catchphrase → soft reframing desk (endgame)
- [ ] Reframing requires media flag + endgame days
- [ ] Lab coat deploy / nap grid / clinic affinity ≥2
- [ ] Cabinet hypothesis requires treasury ≥40
- [ ] No mandatory chains; soft follow-ups only
