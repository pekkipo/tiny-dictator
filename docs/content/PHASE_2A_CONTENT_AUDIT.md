# Phase 2A Content Audit

**Milestone:** 2B-1 — Voice Bible and Production Scaffolding
**Generated:** 2026-07-16T08:21:00
**Country:** ministan
**Manifest version:** 1

> Machine-readable source of truth: [`data/content_manifest.json`](../data/content_manifest.json)
> Regenerate: `godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit`

## 1. Executive inventory

| Metric | Current cataloged | Approved | 2B target | Gap |
|---|---:|---:|---:|---:|
| Decisions | 114 | 58 | 330 | 272 |
| Major Arcs | 4 | 0 | 18 | 18 |
| Short Chains | 3 | 0 | 32 | 32 |
| Crises | 6 | 0 | 18 | 18 |
| Laws | 28 | 0 | 50 | 50 |
| Endings | 11 | 0 | 50 | 50 |
| Palace Upgrades | 0 | 0 | 24 | 24 |
| Ruler Identities | 7 | 0 | 12 | 12 |

**Approved decision count:** 58 (voice bible complete; approval requires rubric ≥16/20 per batch).
**Draft decision count:** 0

## 2. Decision-class quota gaps (approved vs target)

| Primary content class | Cataloged | Integrated | Approved | Target | Gap |
|---|---:|---:|---:|---:|---:|
| onboarding | 10 | 10 | 10 | 10 | 0 |
| standalone | 53 | 49 | 48 | 72 | 24 |
| short_chain | 13 | 11 | 0 | 80 | 80 |
| major_arc | 25 | 25 | 0 | 96 | 96 |
| crisis | 6 | 5 | 0 | 28 | 28 |
| recovery | 4 | 0 | 0 | 24 | 24 |
| endgame | 3 | 0 | 0 | 20 | 20 |

## 3. Distribution reports

### by_status

- **approved:** 58
- **integrated:** 42
- **deferred:** 7
- **needs_rewrite:** 7

### by_primary_content_class

- **standalone:** 53
- **major_arc:** 25
- **crisis:** 6
- **onboarding:** 10
- **short_chain:** 13
- **endgame:** 3
- **recovery:** 4

### by_primary_category

- **public_life:** 22
- **military:** 16
- **economy:** 16
- **infrastructure:** 13
- **administration:** 3
- **science:** 13
- **follow_up:** 9
- **politics:** 4
- **absurd_law:** 1
- **media:** 15
- **government:** 2

### by_primary_category_canonical

- **public_life:** 36
- **military_and_order:** 16
- **economy:** 16
- **infrastructure:** 13
- **bureaucracy:** 5
- **science_and_technology:** 13
- **media_and_propaganda:** 15

### by_primary_speaker

- **auntie_olga:** 19
- **general_boom:** 20
- **sir_profit:** 9
- **luna_news:** 23
- **minister_penny:** 20
- **clerk_zero:** 9
- **comrade_whiskers:** 2
- **doctor_maybe:** 12

### by_primary_run_stage

- **instability:** 5
- **establishment:** 81
- **escalation:** 23
- **endgame:** 5

## 3b. Category quota (canonical)

| Dimension | Cataloged | Approved | Draft | Target | Gap |
|---|---:|---:|---:|---:|---:|
| economy | 16 | 10 | 0 | 50 | 40 |
| public_life | 36 | 11 | 0 | 48 | 37 |
| military_and_order | 16 | 9 | 0 | 38 | 29 |
| media_and_propaganda | 15 | 9 | 0 | 34 | 25 |
| science_and_technology | 13 | 9 | 0 | 40 | 31 |
| business_and_privatization | 0 | 0 | 0 | 32 | 32 |
| bureaucracy | 5 | 1 | 0 | 32 | 31 |
| cats_and_animals | 0 | 0 | 0 | 26 | 26 |
| infrastructure | 13 | 9 | 0 | 30 | 21 |

## 3c. Speaker quota

| Dimension | Cataloged | Approved | Draft | Target | Gap |
|---|---:|---:|---:|---:|---:|
| general_boom | 20 | 8 | 0 | 38 | 30 |
| minister_penny | 20 | 10 | 0 | 40 | 30 |
| luna_news | 23 | 10 | 0 | 38 | 28 |
| auntie_olga | 19 | 8 | 0 | 42 | 34 |
| doctor_maybe | 12 | 9 | 0 | 38 | 29 |
| sir_profit | 9 | 7 | 0 | 36 | 29 |
| comrade_whiskers | 2 | 1 | 0 | 34 | 33 |
| clerk_zero | 9 | 5 | 0 | 36 | 31 |
| guest_and_system | 0 | 0 | 0 | 28 | 28 |

## 3d. Stage quota

| Dimension | Cataloged | Approved | Draft | Target | Gap |
|---|---:|---:|---:|---:|---:|
| establishment | 81 | 32 | 0 | 83 | 51 |
| escalation | 23 | 19 | 0 | 99 | 80 |
| instability | 5 | 4 | 0 | 89 | 85 |
| endgame | 5 | 3 | 0 | 59 | 56 |

## 4. Decision IDs by primary content class

### standalone (53)

- `absurd_civic_sweeping`
- `boom_hostile_coup_rumor`
- `bridge_toll_concession`
- `cabinet_hypothesis_board`
- `cat_voting_proposal`
- `catchphrase_registry`
- `ceremonial_tank_florists`
- `civilian_marching_band`
- `clinic_maybe_pilot`
- `cloud_relocation_trial`
- `commemorative_debt_sale`
- `crisis_reframing_desk`
- `daily_cabinet_briefing`
- `elevator_wifi_mandate`
- `emergency_salute_protocol`
- `escalation_only_rival_parade`
- `flag_traffic_system`
- `free_coffee_morning`
- `generic_minister_disagreement`
- `honor_guard_crosswalk`
- `lab_coat_streetlights`
- `licensed_rumor_bureau`
- `long_setup_grand_canal`
- `lottery_treasury_fund`
- `loyalty_variety_hour`
- `luxury_chair_tax`
- `national_anthem_remix`
- `national_bedtime_decree`
- `national_clock_sync`
- `national_nap_grid`
- `neighborhood_noise_complaint`
- `no_weekends_proposal`
- `official_queue_etiquette`
- `official_statistics_festival`
- `olga_loyal_council`
- `one_headline_policy`
- `palace_bus_routes`
- `palace_curfew_drill`
- `palace_room_rental`
- `perfumed_sewage_reform`
- `postal_pigeon_reform`
- `predictive_toaster_admin`
- `privatize_rainwater`
- `propaganda_smile_campaign`
- `prototype_scooter_fleet`
- `public_compliment_quota`
- `science_grant_request`
- `sponsored_potholes`
- `treasury_tip_jar`
- `universal_birthday_holiday`
- `volunteer_night_watch`
- `wage_freeze_mandate`
- `weather_optimism_bulletin`

### major_arc (25)

- `army_snack_budget`
- `boom_emergency_powers_demand`
- `boom_failed_coup`
- `boom_loyal_protector`
- `cat_limited_council`
- `cat_party_banned`
- `cat_party_enters_parliament`
- `cat_politics_fish_budget`
- `cat_protest`
- `cat_republic_declared`
- `cat_voting_rights`
- `cats_return_to_boxes`
- `fake_smile_industry`
- `happiness_arc_quiet`
- `happiness_arc_reformed`
- `happiness_backlash`
- `happiness_bureau_crackdown`
- `happiness_golden_decree`
- `mandatory_smiling_proposal`
- `maybe_containment_protocol`
- `maybe_golden_age`
- `maybe_lab_runaway`
- `maybe_moon_dust_trial`
- `military_parade`
- `parade_budget_boost`

### crisis (6)

- `bank_run`
- `budget_meltdown_crisis`
- `cat_parliament_occupation`
- `cheese_shortage_crisis`
- `mass_protest`
- `national_power_outage`

### onboarding (10)

- `border_parade_dispute`
- `bureaucracy_expansion`
- `cat_treaty_offer`
- `luna_good_news_only`
- `olga_bridge_repair`
- `palace_roof_leak`
- `pantry_moth_crisis`
- `privatize_palace_garden`
- `science_gamble`
- `window_tax_proposal`

### short_chain (13)

- `cat_fish_budget`
- `cat_parliament`
- `cheese_shortage`
- `free_pizza_friday`
- `pineapple_referendum`
- `pizza_union_strike`
- `robot_cabinet_proposal`
- `robot_government_installed`
- `switch_off_traffic_lights`
- `traffic_complaint`
- `traffic_lights_restored`
- `traffic_military_resolved`
- `traffic_tank_solution`

### endgame (3)

- `endgame_final_audit`
- `endgame_legacy_statue`
- `endgame_succession_debate`

### recovery (4)

- `recovery_elite_dinner`
- `recovery_international_bank`
- `recovery_martial_law_pause`
- `recovery_national_smile_day`

## 5. Non-decision catalogs

### arcs (6)

- `cat_politics` — status: integrated
- `traffic_military` — status: integrated
- `mandatory_happiness` — status: integrated
- `general_boom_arc` — status: integrated
- `doctor_maybe_arc` — status: integrated
- `robot_government` — status: deferred

### chains (4)

- `free_pizza_consequences` — status: integrated
- `traffic_military` — status: integrated
- `robot_government` — status: deferred
- `cat_politics_followups` — status: integrated

### crises (7)

- `national_power_outage` — status: integrated
- `budget_meltdown` — status: deferred
- `cheese_shortage_crisis` — status: integrated
- `mass_protest` — status: integrated
- `bank_run` — status: integrated
- `cat_parliament_occupation` — status: integrated
- `pantry_moth_crisis` — status: integrated

### laws (28)

- `free_pizza_friday` — status: integrated
- `mandatory_smiling` — status: integrated
- `window_tax` — status: integrated
- `cat_voting_rights` — status: integrated
- `tank_traffic_control` — status: integrated
- `emergency_broadcast_priority` — status: integrated
- `no_weekends` — status: integrated
- `fake_smile_standard` — status: integrated
- `emergency_martial_law` — status: integrated
- `national_happiness_index` — status: integrated
- `scientific_experiment_permit` — status: integrated
- `fish_emergency_reserve` — status: integrated
- `luxury_chair_tax` — status: integrated
- `national_bedtime` — status: integrated
- `national_clock_law` — status: integrated
- `queue_etiquette_law` — status: integrated
- `compliment_quota_law` — status: integrated
- `flag_traffic_law` — status: integrated
- `rival_parade_response_act` — status: integrated
- `palace_curfew_act` — status: integrated
- `emergency_salute_law` — status: integrated
- `one_headline_policy` — status: integrated
- `public_rumor_license` — status: integrated
- `predictive_toaster_act` — status: integrated
- `ceremonial_tank_florist_act` — status: integrated
- `weather_optimism_act` — status: integrated
- `catchphrase_registry_act` — status: integrated
- `labcoat_lighting_act` — status: integrated

### endings (11)

- `elite_coup` — status: integrated
- `revolution` — status: integrated
- `chaos_country` — status: integrated
- `bankrupt_leader` — status: integrated
- `nation_in_darkness` — status: integrated
- `cat_republic` — status: integrated
- `survived_the_prototype` — status: integrated
- `content_exhausted` — status: integrated
- `eternal_smile_state` — status: integrated
- `general_boom_coup` — status: integrated
- `accidental_moon_replacement` — status: integrated

### advisors (8)

- `general_boom` — status: integrated
- `minister_penny` — status: integrated
- `luna_news` — status: integrated
- `auntie_olga` — status: integrated
- `doctor_maybe` — status: integrated
- `sir_profit` — status: integrated
- `comrade_whiskers` — status: integrated
- `clerk_zero` — status: integrated

### ruler_identities (7)

- `the_smiling_tyrant` — status: integrated
- `the_spreadsheet_emperor` — status: integrated
- `supreme_cat_servant` — status: integrated
- `the_chaotic_reformer` — status: integrated
- `the_technocratic_accident` — status: integrated
- `the_golden_oligarch` — status: integrated
- `the_accidental_ruler` — status: integrated

### palace_upgrades (3)

- `gold_desk` — status: needs_rewrite
- `propaganda_studio` — status: needs_rewrite
- `emergency_bunker` — status: needs_rewrite

## 6. Quality findings

### Static diagnostics summary

- **unreachable_decisions:** 83
- **dominant_choice_options:** 0
- **cards_no_meaningful_effects:** 0
- **endings_impossible:** 4
- **excessive_advisor_concentration:** 4
- **excessive_tag_concentration:** 1
- **branches_no_continuation:** 0

### Duplicate or similar premise groups

- **cat_voting_duplicate:** ["cat_voting_proposal", "cat_voting_rights"] — Both propose cat voting rights; core card may be legacy duplicate of arc entry.
- **smile_happiness_cluster:** ["mandatory_smiling_proposal", "propaganda_smile_campaign", "fake_smile_industry"] — Multiple mandatory-smile premises across standalone, affinity, and arc paths.
- **traffic_cluster:** ["switch_off_traffic_lights", "traffic_tank_solution", "traffic_complaint"] — Connected traffic/military chain; expected repetition within chain.

### Simulation never-selected (1000-run snapshot)

- `boom_loyal_protector`
- `happiness_backlash`

### Missing visual hooks (major_arc / onboarding without visual_tags)

- `army_snack_budget`
- `boom_failed_coup`
- `boom_loyal_protector`
- `cat_limited_council`
- `cat_party_banned`
- `cat_party_enters_parliament`
- `cat_politics_fish_budget`
- `cat_protest`
- `cat_republic_declared`
- `cats_return_to_boxes`
- `happiness_arc_quiet`
- `happiness_arc_reformed`
- `happiness_backlash`
- `maybe_containment_protocol`
- `maybe_moon_dust_trial`
- `military_parade`
- `olga_bridge_repair`
- `parade_budget_boost`

### Missing visual tags (all decisions)

- `army_snack_budget`
- `boom_failed_coup`
- `boom_loyal_protector`
- `budget_meltdown_crisis`
- `cat_fish_budget`
- `cat_limited_council`
- `cat_parliament`
- `cat_party_banned`
- `cat_party_enters_parliament`
- `cat_politics_fish_budget`
- `cat_protest`
- `cat_republic_declared`
- `cat_voting_proposal`
- `cats_return_to_boxes`
- `cheese_shortage`
- `cheese_shortage_crisis`
- `daily_cabinet_briefing`
- `endgame_final_audit`
- `endgame_legacy_statue`
- `endgame_succession_debate`
- `free_pizza_friday`
- `generic_minister_disagreement`
- `happiness_arc_quiet`
- `happiness_arc_reformed`
- `happiness_backlash`
- `maybe_containment_protocol`
- `maybe_moon_dust_trial`
- `military_parade`
- `national_power_outage`
- `olga_bridge_repair`
- `parade_budget_boost`
- `pineapple_referendum`
- `pizza_union_strike`
- `postal_pigeon_reform`
- `propaganda_smile_campaign`
- `recovery_elite_dinner`
- `recovery_international_bank`
- `recovery_martial_law_pause`
- `recovery_national_smile_day`
- `robot_cabinet_proposal`
- `robot_government_installed`
- `traffic_complaint`
- `traffic_lights_restored`

### Untested content (manual_test_status = untested)

- `border_parade_dispute`
- `bureaucracy_expansion`
- `cat_fish_budget`
- `cat_parliament`
- `cat_treaty_offer`
- `cat_voting_proposal`
- `cheese_shortage`
- `daily_cabinet_briefing`
- `free_pizza_friday`
- `generic_minister_disagreement`
- `luna_good_news_only`
- `olga_bridge_repair`
- `palace_roof_leak`
- `pantry_moth_crisis`
- `pineapple_referendum`
- `pizza_union_strike`
- `postal_pigeon_reform`
- `privatize_palace_garden`
- `propaganda_smile_campaign`
- `robot_cabinet_proposal`
- `robot_government_installed`
- `traffic_complaint`
- `traffic_lights_restored`
- `traffic_military_resolved`
- `traffic_tank_solution`
- `window_tax_proposal`

### Missing review status (any gate not pass)

- `absurd_civic_sweeping`
- `army_snack_budget`
- `bank_run`
- `boom_emergency_powers_demand`
- `boom_failed_coup`
- `boom_hostile_coup_rumor`
- `boom_loyal_protector`
- `border_parade_dispute`
- `bridge_toll_concession`
- `budget_meltdown_crisis`
- `bureaucracy_expansion`
- `cabinet_hypothesis_board`
- `cat_fish_budget`
- `cat_limited_council`
- `cat_parliament`
- `cat_parliament_occupation`
- `cat_party_banned`
- `cat_party_enters_parliament`
- `cat_politics_fish_budget`
- `cat_protest`
- `cat_republic_declared`
- `cat_treaty_offer`
- `cat_voting_proposal`
- `cat_voting_rights`
- `catchphrase_registry`
- `cats_return_to_boxes`
- `ceremonial_tank_florists`
- `cheese_shortage`
- `cheese_shortage_crisis`
- `civilian_marching_band`
- `clinic_maybe_pilot`
- `cloud_relocation_trial`
- `commemorative_debt_sale`
- `crisis_reframing_desk`
- `daily_cabinet_briefing`
- `elevator_wifi_mandate`
- `emergency_salute_protocol`
- `endgame_final_audit`
- `endgame_legacy_statue`
- `endgame_succession_debate`
- `escalation_only_rival_parade`
- `fake_smile_industry`
- `flag_traffic_system`
- `free_coffee_morning`
- `free_pizza_friday`
- `generic_minister_disagreement`
- `happiness_arc_quiet`
- `happiness_arc_reformed`
- `happiness_backlash`
- `happiness_bureau_crackdown`
- `happiness_golden_decree`
- `honor_guard_crosswalk`
- `lab_coat_streetlights`
- `licensed_rumor_bureau`
- `long_setup_grand_canal`
- `lottery_treasury_fund`
- `loyalty_variety_hour`
- `luna_good_news_only`
- `luxury_chair_tax`
- `mandatory_smiling_proposal`
- `mass_protest`
- `maybe_containment_protocol`
- `maybe_golden_age`
- `maybe_lab_runaway`
- `maybe_moon_dust_trial`
- `military_parade`
- `national_anthem_remix`
- `national_bedtime_decree`
- `national_clock_sync`
- `national_nap_grid`
- `national_power_outage`
- `neighborhood_noise_complaint`
- `no_weekends_proposal`
- `official_queue_etiquette`
- `official_statistics_festival`
- `olga_bridge_repair`
- `olga_loyal_council`
- `one_headline_policy`
- `palace_bus_routes`
- `palace_curfew_drill`
- `palace_roof_leak`
- `palace_room_rental`
- `pantry_moth_crisis`
- `parade_budget_boost`
- `perfumed_sewage_reform`
- `pineapple_referendum`
- `pizza_union_strike`
- `postal_pigeon_reform`
- `predictive_toaster_admin`
- `privatize_palace_garden`
- `privatize_rainwater`
- `propaganda_smile_campaign`
- `prototype_scooter_fleet`
- `public_compliment_quota`
- `recovery_elite_dinner`
- `recovery_international_bank`
- `recovery_martial_law_pause`
- `recovery_national_smile_day`
- `robot_cabinet_proposal`
- `robot_government_installed`
- `science_gamble`
- `science_grant_request`
- `sponsored_potholes`
- `switch_off_traffic_lights`
- `traffic_complaint`
- `traffic_lights_restored`
- `traffic_military_resolved`
- `traffic_tank_solution`
- `treasury_tip_jar`
- `universal_birthday_holiday`
- `volunteer_night_watch`
- `wage_freeze_mandate`
- `weather_optimism_bulletin`
- `window_tax_proposal`

### Review status distribution

#### voice_review_status

- **not_reviewed:** 114

#### balance_review_status

- **partial:** 114

#### manual_test_status

- **pass:** 58
- **partial:** 30
- **untested:** 26

#### graph_validation_status

- **partial:** 83
- **pass:** 31

## 7. Rewrite, defer, and reclassify recommendations

### Needs rewrite

- `endgame_final_audit`
- `endgame_legacy_statue`
- `endgame_succession_debate`
- `recovery_elite_dinner`
- `recovery_international_bank`
- `recovery_martial_law_pause`
- `recovery_national_smile_day`

### Deferred (extra beyond 2A-9 required set)

- `budget_meltdown_crisis`
- `cat_voting_proposal`
- `daily_cabinet_briefing`
- `postal_pigeon_reform`
- `propaganda_smile_campaign`
- `robot_cabinet_proposal`
- `robot_government_installed`

### Reclassification notes

- Minor arcs (`traffic_military`, `robot_government`) count toward **short_chain**, not major_arc.
- `generic_minister_disagreement` is **standalone** fallback filler.
- `cat_voting_proposal` remains **standalone** with duplicate-premise flag vs `cat_voting_rights`.
- `chain_id` values are manifest-invented; runtime JSON has no chain field yet.

## 8. Assumptions and unresolved issues

1. **Planning catalogs** — [`MINISTAN_ARC_CATALOG.md`](MINISTAN_ARC_CATALOG.md), [`MINISTAN_CHAIN_CATALOG.md`](MINISTAN_CHAIN_CATALOG.md), [`MINISTAN_CRISIS_CATALOG.md`](MINISTAN_CRISIS_CATALOG.md) are authoritative for 2B production inventory.
2. **Voice bible complete** — approval still requires per-card rubric ≥16/20 during batch review.
3. **Unreachable diagnostics** — 42 optimistic-graph warnings expected for arc-gated cards.
4. **Resource-failure endings** — `bankrupt_leader`, `revolution`, `elite_coup`, `chaos_country` flagged impossible from day-1 by design.
5. **Guest speakers** — 0 of 6 target in runtime; voice cards in voice bible only.
6. **Simulation snapshot** — embedded from Phase 2A 1000-run report (seed 20260715).
7. **Onboarding pack** — Milestone 2B-2 complete: 10 approved onboarding decisions with Content Director bias.

## 9. Manifest maintenance

1. After any content JSON change, run:
   ```bash
   godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit
   ```
2. Run `tests/test_content_manifest.gd` in CI or before content PRs.
3. Update per-record `status` and review gates manually during batch review (2B-1+).
4. Only `approved` decisions count toward the 330 strong-launch target.
5. `quota_report` is always recomputed from manifest records — never edit gaps by hand.

## 10. Manual test checklist

1. `godot --headless --path . -s tests/run_content_manifest.gd` — quota includes draft/category/speaker/stage gaps
2. `godot --headless --path . -s tests/test_content_manifest.gd` — manifest sync passes
3. `godot --headless --path . -s tests/test_content_scaffolding.gd` — voice bible + catalogs complete
4. `godot --headless --path . -s tests/test_content_validation.gd` — 74 decisions, 0 validator errors
5. `godot --headless --path . -s tests/run_phase_2a_qa.gd` — full QA matrix passes
6. Open `data/content_manifest.json` — 74 decision records, no duplicate IDs
7. Spot-read each advisor in `MINISTAN_CHARACTER_VOICE_BIBLE.md` — 5 proposals/results/out-of-character present
8. Spot-read arc/chain/crisis catalogs — 18/32/18 entries with required fields
9. Confirm `docs/content/drafts/` has no runtime JSON; no new `data/decisions/*.json`
10. Confirm canonical examples marked NOT RUNTIME
11. Launch editor — boot run, resolve 3 decisions — behavior unchanged

## 11. Manifest validation status

**PASS** — manifest syncs with runtime content.

