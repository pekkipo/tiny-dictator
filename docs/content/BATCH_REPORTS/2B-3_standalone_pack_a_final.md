# Batch Report — Milestone 2B-3 Standalone Policy Pack A (Final)

**Milestone:** 2B-3  
**Date:** 2026-07-15  
**Result:** **24 approved standalone decisions** — Economy 8 / Public Life 8 / Infrastructure 8  
**Sub-batches:** [2B-3A](2B-3A_standalone_pack_a.md), [2B-3B](2B-3B_standalone_pack_a.md)  
**Did not start:** Milestone 2B-4  

---

## 1. Changed files

### Content
- `data/decisions/ministan_standalone_pack_a.json` (new — 24 cards)
- `data/decisions/ministan_generic_fill.json` (removed migrated Pack A seeds)
- `data/decisions/ministan_core.json` (removed `no_weekends_proposal`)
- `data/decisions/ministan_advisor_affinity.json` (removed `olga_loyal_council`)
- `data/decisions/ministan_stage_placeholders.json` (removed `long_setup_grand_canal`)
- `data/decisions/ministan_doctor_maybe_arc.json` (narrative reclass for `maybe_moon_dust_trial`)
- `data/decisions/ministan_mandatory_happiness.json` (narrative reclass for `happiness_backlash`)
- `data/laws/laws.json` (+6 laws)
- `data/countries/ministan.json` (register pack file)
- `data/visual_states/country_visual_map.json` (new visual tags)
- `data/content_manifest.json` (regenerated)

### Tools / tests / docs
- `scripts/dev/ContentManifestBuilder.gd`
- `tests/test_content_validation.gd`
- `tests/test_content_manifest.gd`
- `tests/test_schema_v2.gd` (legacy fixture → `generic_minister_disagreement`)
- `tests/test_decision_engine.gd` (day-1 pool expectations)
- `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/drafts/2B-3A_standalone_pack_a_plan.md`
- `docs/content/drafts/2B-3B_standalone_pack_a_plan.md`
- `docs/content/BATCH_REPORTS/2B-3A_standalone_pack_a.md`
- `docs/content/BATCH_REPORTS/2B-3B_standalone_pack_a.md`
- `docs/content/BATCH_REPORTS/2B-3_standalone_pack_a_final.md` (this file)

**Core systems:** no gameplay engine changes. Test fixture updates only where content pool sizes / legacy samples shifted.

---

## 2. All 24 approved decisions (by category and speaker)

### Economy (8)

| ID | Speaker | Origin |
|----|---------|--------|
| `privatize_rainwater` | sir_profit | REWRITE |
| `treasury_tip_jar` | minister_penny | REWRITE |
| `no_weekends_proposal` | minister_penny | REWRITE + reclassify to economy |
| `luxury_chair_tax` | minister_penny | NEW |
| `commemorative_debt_sale` | sir_profit | NEW |
| `lottery_treasury_fund` | sir_profit | NEW |
| `wage_freeze_mandate` | minister_penny | NEW |
| `palace_room_rental` | sir_profit | NEW |

### Public Life (8)

| ID | Speaker | Origin |
|----|---------|--------|
| `neighborhood_noise_complaint` | auntie_olga | REWRITE |
| `olga_loyal_council` | auntie_olga | REWRITE |
| `national_bedtime_decree` | auntie_olga | NEW |
| `free_coffee_morning` | auntie_olga | NEW |
| `official_queue_etiquette` | clerk_zero | NEW |
| `universal_birthday_holiday` | luna_news | NEW |
| `public_compliment_quota` | luna_news | NEW |
| `absurd_civic_sweeping` | auntie_olga | NEW |

### Infrastructure (8)

| ID | Speaker | Origin |
|----|---------|--------|
| `long_setup_grand_canal` | minister_penny | REWRITE |
| `sponsored_potholes` | sir_profit | NEW |
| `perfumed_sewage_reform` | minister_penny | NEW |
| `national_clock_sync` | clerk_zero | NEW |
| `flag_traffic_system` | general_boom | NEW |
| `elevator_wifi_mandate` | doctor_maybe | NEW |
| `palace_bus_routes` | minister_penny | NEW |
| `bridge_toll_concession` | sir_profit | NEW |

**Speakers used (7):** minister_penny, auntie_olga, sir_profit, clerk_zero, luna_news, general_boom, doctor_maybe  

**Stages:** establishment, escalation, instability (`absurd_civic_sweeping`), endgame (`bridge_toll_concession`)

---

## 3. Reuse / rewrite / new / reject / defer matrix

| Action | IDs |
|--------|-----|
| **REWRITE (6)** | privatize_rainwater, treasury_tip_jar, no_weekends_proposal, neighborhood_noise_complaint, olga_loyal_council, long_setup_grand_canal |
| **NEW (18)** | luxury_chair_tax, national_bedtime_decree, free_coffee_morning, sponsored_potholes, perfumed_sewage_reform, national_clock_sync, commemorative_debt_sale, lottery_treasury_fund, wage_freeze_mandate, palace_room_rental, official_queue_etiquette, universal_birthday_holiday, public_compliment_quota, absurd_civic_sweeping, flag_traffic_system, elevator_wifi_mandate, palace_bus_routes, bridge_toll_concession |
| **RECLASSIFY** | cat_parliament + cat_fish_budget → short_chain; happiness_backlash + maybe_moon_dust_trial → major_arc |
| **DEFER (Pack B/C / duplicate)** | cat_voting_proposal, propaganda_smile_campaign, boom_hostile_coup_rumor, escalation_only_rival_parade, national_anthem_remix, science_grant_request, daily_cabinet_briefing, postal_pigeon_reform |
| **KEEP fallback (not approved)** | generic_minister_disagreement |
| **REJECTED this milestone** | none |

---

## 4. Quality scores

All 24 score **≥16/20**. See sub-batch reports for per-criterion tables. Summary totals: A batch 16–17/20; B batch 16–17/20. No zero on clarity, voice, choice quality, or technical validity.

---

## 5. Simulation results

### Sub-batch A (after first 12)

- Seed `20260715`, 1000 runs, avg length **21.2**, exhaustion **0**, fallback **0**
- Never-selected: boom_loyal_protector, happiness_backlash
- All 12 Pack A cards selected (rarest: olga_loyal_council 52, national_clock_sync 78)

### Sub-batch B / full Pack A (after all 24)

- Seed `20260715`, 1000 runs, avg length **23.5**, exhaustion **0**, fallback **0**
- Never-selected: boom_loyal_protector, happiness_backlash (not Pack A)
- All 24 Pack A cards selected; rarest approved: olga_loyal_council (65), luxury_chair_tax (89), national_clock_sync (88)

---

## 6. Updated quota report (excerpt)

```
Decisions: 34 approved / 330 target (gap 296)
  onboarding: 10 / 10
  standalone: 24 / 72 (gap 48)
Standalone approved by category (exact Pack A target):
  economy: 8
  public_life: 8
  infrastructure: 8
```

---

## 7. Manual test checklist

### Economy
1. [ ] `privatize_rainwater` — monetize / keep public / sell half; rain_privatized flag; Profit affinity swings
2. [ ] `treasury_tip_jar` — keep/remove jar; tip flag
3. [ ] `no_weekends_proposal` — abolish creates `no_weekends` law; keep/half-day alternatives
4. [ ] `luxury_chair_tax` — tax creates `luxury_chair_tax`; palace exemption path; reject
5. [ ] `commemorative_debt_sale` — sell vs refuse
6. [ ] `lottery_treasury_fund` — launch queues soft birthday; ban; palace-only
7. [ ] `wage_freeze_mandate` — appears only when treasury ≤45; freeze / cut palace / borrow
8. [ ] `palace_room_rental` — rent vs keep private

### Public Life
9. [ ] `neighborhood_noise_complaint` — ban / noon concerts / ignore
10. [ ] `olga_loyal_council` — only with auntie_olga affinity ≥3; empower vs supervise
11. [ ] `national_bedtime_decree` — creates `national_bedtime` law
12. [ ] `free_coffee_morning` — fund soft-queues `absurd_civic_sweeping`
13. [ ] `official_queue_etiquette` — creates `queue_etiquette_law`
14. [ ] `universal_birthday_holiday` — soft-queues compliment quota
15. [ ] `public_compliment_quota` — creates `compliment_quota_law`
16. [ ] `absurd_civic_sweeping` — instability stage only

### Infrastructure
17. [ ] `long_setup_grand_canal` — dig soft-queues `palace_bus_routes`
18. [ ] `sponsored_potholes` — sponsors vs public repair
19. [ ] `perfumed_sewage_reform` — perfume / real repair / nothing
20. [ ] `national_clock_sync` — creates `national_clock_law`
21. [ ] `flag_traffic_system` — creates `flag_traffic_law`
22. [ ] `elevator_wifi_mandate` — Doctor Maybe voice; pilot vs buttons
23. [ ] `palace_bus_routes` — only after canal/road flags; open / citizen / cancel
24. [ ] `bridge_toll_concession` — endgame stage; sell / public / abolish

### Regression
25. [ ] Fallback `generic_minister_disagreement` still works when pool empty
26. [ ] Onboarding 10 cards still approved and selectable early
27. [ ] Save load still succeeds (schema unchanged)

---

## 8. Distribution requirements verification

| Requirement | Status |
|-------------|--------|
| ≥6 speakers | **7** |
| All four run stages | establishment, escalation, instability, endgame |
| ≥6 law interactions | no_weekends, luxury_chair_tax, national_bedtime, national_clock_law, queue_etiquette_law, compliment_quota_law, flag_traffic_law (**7**) |
| ≥6 affinity changes | rainwater, tip jar, weekends, noise, olga, coffee, debt, lottery, wage, room, queue, birthday, compliment, sweep, flags, wifi, bus, toll |
| ≥6 ruler-trait changes | weekends, rainwater, olga, clock, lottery, wage, debt, room, queue, birthday, compliment, sweep, flags, wifi, bus, toll |
| ≥4 state-dependent eligibility | olga affinity; wage treasury max; bus any_flags; bridge endgame stage |
| ≥4 delayed/optional soft follow-ups | coffee→sweeping; canal→buses; lottery→birthday; birthday→compliments |
| ≥12 visual tags | 24 distinct Pack A tags mapped |
| ≤2 shared core joke structures | privatize-public-good capped at rainwater + potholes |

---

## 9. Core bug fixes

None required. Content-blocking issue avoided by:
- Targeting soft follow-ups only at existing decision IDs
- Registering new law visual tags in `country_visual_map.json`
- Updating day-1 pool and legacy schema test fixtures after content moves

---

## 10. Stop line

**Milestone 2B-3 complete. Do not begin Milestone 2B-4.**
