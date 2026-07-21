# Milestone 2B-18 — Manual Test Matrix

**Date:** 2026-07-20  
**Debug UI:** F1 Debug Overlay (`scripts/ui/DebugOverlay.gd`)  
**Commands:** force decision / add law / add flag / set stage / set resource / force crisis / force ending  

High-risk paths marked **EXECUTED** were verified via automated debug proof or headless force eligibility. Remaining rows are exact playable debug recipes.

---

## 1. Major arcs (18) — entry force paths

| # | Arc ID | Force entry decision | Expected |
|---:|---|---|---|
| 1 | `cat_politics` | `debug force decision cat_faction_proposal` | Arc starts; resolve to `cat_politics_resolution` |
| 2 | `mandatory_happiness` | `debug force decision mandatory_smiling_proposal` | Arc starts; resolution `happiness_arc_resolution` |
| 3 | `luna_media_reality` | `debug force decision luna_narrative_brief` | Arc starts; `luna_media_resolution` |
| 4 | `olga_citizen_movement` | `debug force decision olga_everyday_complaint` | Arc starts; `olga_movement_resolution` |
| 5 | `fake_election_accident` | `debug force decision election_filing_proposal` | Arc starts; `election_arc_resolution` |
| 6 | `general_boom_arc` | `debug force decision military_parade` | Arc starts; one of boom resolutions |
| 7 | `doctor_maybe_arc` | `debug force decision science_gamble` | Arc starts; `maybe_experimental_resolution` |
| 8 | `robot_government` | `debug force decision ai_admin_pilot` | Arc starts; `ai_government_resolution` |
| 9 | `profit_corporate_state` | `debug force decision profit_partnership_brief` | Mid-beats force through; `profit_corporate_resolution` **EXECUTED** (sim complete &gt;0) |
| 10 | `sell_the_moon` | `debug force decision moon_budget_proposal` | Arc starts; `moon_arc_resolution` |
| 11 | `traffic_military_control` | `debug force decision traffic_gridlock_brief` | Convoy force valid; civilian/martial resolution **EXECUTED** |
| 12 | `penny_austerity_arc` | `debug force decision penny_deficit_briefing` | Trimming force valid; miracle/resolution **EXECUTED** |
| 13 | `hyperinflation_arc` | `debug force decision hyperinflation_price_spiral` | `hyperinflation_resolution` |
| 14 | `whiskers_cat_revolution` | `debug force decision whiskers_political_demand` | `whiskers_revolution_resolution` |
| 15 | `zero_government_of_forms` | `debug force decision zero_admin_reform` | `zero_forms_resolution` |
| 16 | `national_festival_economy` | `debug force decision festival_stimulus_proposal` | `festival_economy_resolution` |
| 17 | `international_cheese_crisis` | `debug force decision cheese_diplomatic_incident` | `cheese_crisis_resolution` |
| 18 | `palace_renovation_scandal` | `debug force decision palace_renovation_proposal` | `palace_renovation_resolution` |

---

## 2. Short chains (32) — entry IDs

Force the first card of each chain (from packs A–D). Spot-check branches after entry.

| Chain ID | Typical entry force |
|---|---|
| `umbrella_tax` | `umbrella_tax_proposal` |
| `national_coffee_reserve` | `free_coffee_morning` |
| `privatized_public_benches` | `privatized_benches_proposal` |
| `lottery_budget` | `lottery_treasury_fund` |
| `palace_gift_shop` | `palace_gift_shop_opening` |
| `elevator_wifi` | `elevator_wifi_mandate` |
| `pothole_naming_rights` | `sponsored_potholes` |
| `bridge_to_nowhere` | `long_setup_grand_canal` |
| `coin_shortage` | `coin_shortage_crisis` |
| `national_clock_reform` | `national_clock_sync` |
| `weekend_abolition` | `no_weekends_proposal` |
| `state_meme_department` | `state_meme_department` |
| `weather_censorship` | `weather_censorship_mandate` |
| `national_talent_show` | `national_talent_show` |
| `applause_quotas` | `applause_quotas_mandate` |
| `artificial_sun` | (pack B/C science entry) |
| `antigravity_buses` | pack science entry |
| `national_clone_day` | pack science entry |
| `traffic_flags` | pack military entry |
| `robot_queue_manager` | pack sci/bureau entry |
| `pigeon_air_force` | pack military entry |
| `camouflage_uniform_scandal` | pack military entry |
| `border_parade` | `border_parade_escalation` |
| `tank_parking_crisis` | pack military entry |
| `salaries_paid_in_coupons` | pack economy entry |
| `perfumed_sewage` | pack infra entry |
| `form_to_request_forms` | pack bureau entry |
| `fish_currency_experiment` | pack cats entry |
| `ministry_of_waiting` | pack bureau entry |
| `stamp_shortage` | pack bureau entry |
| `antivacuum_referendum` | `antivacuum_referendum_proposal` |
| `national_nap_hour` | pack public-life entry |

Full ID list matches manifest `catalogs.chains` (32 approved).

---

## 3. Crises (18) — force start

| Crisis ID | Debug |
|---|---|
| `national_power_outage` | `debug force crisis national_power_outage` → resolve or timeout → `nation_in_darkness` |
| `bank_run` | force crisis `bank_run` |
| `mass_protest` | force crisis `mass_protest` |
| `palace_fire` | force crisis `palace_fire` |
| `military_mutiny` | force crisis `military_mutiny` |
| `government_data_leak` | force crisis `government_data_leak` |
| `cat_parliament_occupation` | force crisis `cat_parliament_occupation` |
| `water_supply_turns_blue` | force crisis `water_supply_turns_blue` |
| `public_transport_strike` | force crisis `public_transport_strike` |
| `cheese_shortage_crisis` | force crisis `cheese_shortage_crisis` |
| `international_border_confusion` | force crisis `international_border_confusion` |
| `bureaucrat_general_strike` | force crisis `bureaucrat_general_strike` |
| `national_internet_outage` | force crisis `national_internet_outage` |
| `fake_news_panic` | force crisis `fake_news_panic` |
| `budget_meltdown` | force crisis `budget_meltdown` |
| `ai_cabinet_lockout` | force crisis `ai_cabinet_lockout` |
| `moon_ownership_dispute` | force crisis `moon_ownership_dispute` |
| `national_festival_stampede` | force crisis `national_festival_stampede` |

All 18 activated in 10k sims (**EXECUTED** coverage).

---

## 4. Endings (50 collectible) — representative forces

Generic collapses:

- Set `treasury=0` → `bankrupt_leader`
- Set `happiness=0` → `revolution`
- Set `order=0` → `chaos_country`
- Set `elite_loyalty=0` → `elite_coup`

Specials: complete matching arc resolution / set required flags then advance day past `minimum_day` (28–30).

Secrets (**EXECUTED** via `tests/run_2b17_secret_debug_proof.gd`):

| Secret ending | Debug recipe |
|---|---|
| `toaster_elected_president` | laws `ai_cabinet_pilot`; force `endgame_secret_toaster_election` |
| `wrong_map_republic` | law `border_parade_act`; flag `cheese_arc_complete`; force `endgame_secret_wrong_map` |
| `palace_micronation` | law `palace_subscription_plan`; flag `palace_reno_complete`; force `endgame_secret_palace_micronation` |
| `forms_become_citizens` | law `form_request_form_act`; flag `zero_forms_complete`; force `endgame_secret_forms_awaken` |
| `cat_republic` | cat arc resolution declare path / flags |
| `accidental_moon_replacement` | flag `moon_replacement_pending`; day 30; or moon resolution brighter path |

---

## 5. Ruler identities (runtime 7 / PRD 12)

Force trait combinations until identity resolves (or inspect `RunSummary.ruler_identity_id`):

1. `the_smiling_tyrant`
2. `the_spreadsheet_emperor`
3. `supreme_cat_servant`
4. `the_chaotic_reformer`
5. `the_technocratic_accident`
6. `the_golden_oligarch`
7. `the_accidental_ruler`

**Gap:** 5 PRD identities not yet authored (known limitation; not added in 2B-18).

---

## 6. Recovery decisions (24)

Force with matching low resource, e.g. `treasury=15` then `debug force decision recovery_international_bank`.

IDs:  
`recovery_foreign_picnic_grant`, `recovery_austerity_clipboards`, `recovery_maybe_miracle_bond`, `recovery_workers_shift_relief`, `recovery_civic_half_day`, `recovery_endgame_hope_reel`, `recovery_whiskers_alley_truce`, `recovery_boom_cone_grid`, `recovery_endgame_quiet_hours`, `recovery_prestige_fountain`, `recovery_shared_blame_board`, `recovery_endgame_title_lottery`, `recovery_international_bank`, `recovery_sell_palace_wing`, `recovery_emergency_stamp_tax`, `recovery_national_smile_day`, `recovery_olga_soup_line`, `recovery_maybe_mood_pilot`, `recovery_martial_law_pause`, `recovery_olga_block_captains`, `recovery_zero_queue_charter`, `recovery_elite_dinner`, `recovery_cabinet_nameplates`, `recovery_controlled_audit_show`

---

## 7. Palace upgrades (24)

Meta screen purchase with Medals ≥ cost; confirm persistence after reload.

`gold_desk`, `velvet_throne`, `audience_carpet`, `portrait_wall`, `ceremonial_gavel`, `echo_balcony`, `propaganda_studio`, `cue_card_printer`, `applause_track`, `headline_carousel`, `emergency_bunker`, `map_table`, `sealed_archive`, `red_phone`, `triple_intray`, `stamp_museum`, `quiet_hours_lamp`, `form_fountain`, `prototype_shelf`, `moon_whiteboard`, `ai_coffee_bot`, `cushion_throne`, `fish_dispenser`, `nap_observatory`

Palace-gated content check: without `propaganda_studio`, `anthem_sponsor_reads` must not appear; after purchase, force eligibility.

---

## 8. Law contradictions / systems

1. Enact contradictory pair (pizza vs coupons path) → blocked card absent.  
2. Law popup shows downstream unlock/block facts.  
3. Old-save migration: load v1/v2 save → resources/laws intact.  
4. Corrupt-save: truncate save file → boot falls back safely.  
5. Restart mid-run: confirm run/meta separation (Medals persist; run resets).  
6. Runtime vs meta: buy palace upgrade → new run sees unlock; ending archive increments.

---

## 9. High-risk execution log (2B-18)

| Path | Result |
|---|---|
| Secret debug proof (6 secrets) | PASS (`failures=0`) |
| Profit / traffic / penny arc completion in sims | PASS |
| All 18 crises activated in 10k | PASS |
| All 18 major arcs started + completed path | PASS |
| Manifest rebuild / validation | PASS |
| Content exhaustion in 10k | 0 |
