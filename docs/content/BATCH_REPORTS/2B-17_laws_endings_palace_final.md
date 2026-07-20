# Milestone 2B-17 — Laws, Endings, and Palace Completion

**Status:** Complete  
**Do not start:** Milestone 2B-18  
**Quota:** laws **50/50**, endings **50/50**, palace **24/24**, approved decisions **321/330** (standalone −9 deferred to 2B-18)

---

## 1. Changed files

### Content
- `data/laws/laws.json` — curated to 50
- `data/endings/endings.json` — 50 collectible + 3 system; rarity/archive_hint/subtitle/illustration_key
- `data/meta/palace_upgrades.json` — 24 upgrades with categories and content_unlocks
- `data/visual_states/country_visual_map.json` — tags for laws/palace
- `data/decisions/*.json` — law remaps, interaction gates, palace eligibility gates, self-gate fixes
- `data/content_manifest.json` — regenerated (phase `2b_17_laws_endings_palace`)

### Systems
- `scripts/core/RequirementsEvaluator.gd` — `required_palace_upgrades`
- `scripts/core/ContentValidator.gd` — rarity/archive_hint/palace category/law tags
- `scripts/core/RunSimulator.gd` — `law_activation_counts`
- `scripts/dev/ContentManifestBuilder.gd` — phase 2B-17; approve laws/endings/palace
- `scripts/ui/MetaProgressScreen.gd` — archive hints, rarity, filter non-collectible

### Docs / tests / tools
- `docs/content/MINISTAN_LAW_CATALOG.md`
- `docs/content/MINISTAN_ENDING_CATALOG.md`
- `docs/content/MINISTAN_PALACE_CATALOG.md`
- `docs/content/PHASE_3_VISUAL_ASSET_INVENTORY.md`
- `docs/content/drafts/2B-17_pre_audit.md`
- `scripts/dev/tools/curate_2b17.py`
- `tests/run_2b17_sim_10k.gd`, `run_2b17_law_check_2k.gd`, `run_2b17_secret_debug_proof.gd`
- Updated content validation/manifest/scaffolding/ending/crisis/meta tests

## 2. Final inventory confirmation

| Catalog | Count |
|---|---:|
| Approved laws | 50 |
| Approved collectible endings | 50 |
| Approved palace upgrades | 24 |
| Approved decisions | 321 |
| Runtime decisions | 343 |

## 3. Fifty approved laws by category

### economy (8)
1. `window_tax` — Window Tax
1. `umbrella_tax` — Umbrella Tax
1. `free_pizza_friday` — Free Pizza Friday
1. `coupon_salaries` — Coupon Salaries
1. `luxury_chair_tax` — Luxury Chair Levy
1. `national_lottery_budget` — National Lottery Budget
1. `coin_rounding_act` — Coin Rounding Act
1. `emergency_cheese_bonds` — Emergency Cheese Bonds

### public_life (8)
1. `mandatory_smiling` — Mandatory Smiling
1. `national_bedtime` — National Bedtime
1. `three_day_weekend` — Three-Day Weekend
1. `national_nap_hour` — National Nap Hour
1. `national_coffee_reserve` — Free Coffee Morning
1. `compliment_quota_law` — Public Compliment Quota
1. `universal_birthday` — Universal Birthday
1. `queue_etiquette_law` — Official Queue Etiquette

### order_military (6)
1. `tank_traffic_control` — Tank Traffic Control
1. `mandatory_marching` — Mandatory Marching
1. `pigeon_air_force` — Pigeon Air Force
1. `palace_curfew_act` — Palace Curfew
1. `border_parade_act` — Border Parade Act
1. `emergency_salute_law` — Emergency Salute Protocol

### media (6)
1. `ministry_of_memes` — Ministry of Memes
1. `weather_optimism_act` — Weather Optimism Act
1. `mandatory_applause` — Mandatory Applause
1. `one_headline_policy` — One Headline Policy
1. `public_rumor_license` — Public Rumor License
1. `national_reality_show` — National Reality Show

### science (6)
1. `artificial_sun_program` — Artificial Sun Program
1. `robot_civil_service` — Robot Civil Service
1. `antigravity_transit` — Anti-Gravity Transit
1. `moon_replacement_research` — Moon Replacement Research
1. `clone_holiday` — Clone Holiday
1. `ai_cabinet_pilot` — AI Cabinet Pilot

### business (5)
1. `privatize_air` — Privatize Air
1. `corporate_capital_naming` — Corporate Capital Naming
1. `sponsored_potholes_act` — Sponsored Potholes
1. `rent_a_ministry` — Rent-a-Ministry
1. `palace_subscription_plan` — Palace Subscription Plan

### bureaucracy (5)
1. `form_request_form_act` — Form Request Form Act
1. `ministry_of_waiting` — Ministry of Waiting
1. `triple_stamp_requirement` — Triple Stamp Requirement
1. `complaint_permit_act` — Permit for Complaints
1. `national_filing_week` — National Filing Week

### cats_animals (6)
1. `cat_voting_rights` — Cat Voting Rights
1. `fish_market_subsidy_act` — Fish Subsidy
1. `antivacuum_act` — Anti-Vacuum Act
1. `cat_parliament_seats` — Cat Parliament Seats
1. `mouse_protection_law` — National Mouse Protection
1. `official_nap_zones` — Official Nap Zones

## 4. Fifty approved endings by rarity

### common (12)
1. `bankrupt_leader` — Officially Broke (priority 50)
1. `revolution` — People Had Enough (priority 52)
1. `chaos_country` — Nationwide Shrug (priority 51)
1. `elite_coup` — A Very Polite Coup (priority 53)
1. `beloved_retirement` — Beloved Retirement (priority 74)
1. `country_somehow_works` — The Country Somehow Works (priority 72)
1. `peaceful_accidental_democracy` — Peaceful Accidental Democracy (priority 85)
1. `general_remains_loyal` — The Loyal Protector (priority 70)
1. `olga_sends_you_home` — Olga Sends You Home (priority 87)
1. `clerk_zero_closes_file` — Clerk Zero Closes the File (priority 72)
1. `penny_balances_final_budget` — The Balanced Miracle (priority 87)
1. `profit_buys_retirement` — Profit Buys Retirement (priority 94)

### uncommon (18)
1. `spreadsheet_state` — The Spreadsheet State (priority 92)
1. `austerity_without_citizens` — Austerity Without Citizens (priority 93)
1. `nation_becomes_broadcast` — The Broadcast State (priority 91)
1. `olga_peoples_cabinet` — Olga's People's Cabinet (priority 89)
1. `palace_hears_the_street` — The Palace Hears the Street (priority 88)
1. `experimental_republic` — The Experimental Republic (priority 95)
1. `experiment_leaves` — The Experiment Leaves (priority 95)
1. `corporate_ministan` — Corporate Ministan, LLC (priority 94)
1. `country_is_acquired` — The Country Is Acquired (priority 94)
1. `purrfect_transfer` — The Purrfect Transfer (priority 99)
1. `government_by_form` — Government by Form (priority 90)
1. `final_stamp` — The Final Stamp (priority 88)
1. `happiness_reaches_100_percent` — Happiness Reaches 100% (priority 93)
1. `tanks_direct_everything` — Tanks Direct Everything (priority 91)
1. `general_becomes_mascot` — The National Mascot General (priority 88)
1. `hyperinflation_millionaires` — Everyone Is a Millionaire (priority 86)
1. `great_cheese_settlement` — The Great Cheese Settlement (priority 86)
1. `eternal_national_festival` — Eternal National Festival (priority 91)

### rare (14)
1. `general_boom_coup` — The Parade Republic (priority 97)
1. `scientific_golden_age` — Scientific Golden Age (Preliminary) (priority 93)
1. `ai_accepts_resignation` — The AI Accepts Your Resignation (priority 93)
1. `moon_new_owner` — The Moon Has a New Owner (priority 96)
1. `democracy_by_administrative_error` — Democracy by Administrative Error (priority 84)
1. `palace_beautiful_empty` — Palace Beautiful and Empty (priority 87)
1. `renovation_reveals_truth` — Renovation Reveals the Truth (priority 85)
1. `smiling_tyrant_soft_exit` — The Soft Exit Smile (priority 78)
1. `smallest_superpower` — Smallest Superpower (priority 92)
1. `traffic_system_achieves_peace` — Traffic Achieves Peace (priority 89)
1. `day_everyone_stopped_believing` — The Day Everyone Stopped Believing (priority 90)
1. `eternal_smile_state` — The Eternal Smile Republic (priority 98)
1. `competent_successor` — The Competent Successor (priority 76)
1. `whiskers_boxes_truce` — The Boxes Truce (priority 70)

### secret (6)
1. `toaster_elected_president` — Toaster Elected President (priority 96)
1. `wrong_map_republic` — The Wrong Map Republic (priority 95)
1. `palace_micronation` — Palace Micronation (priority 94)
1. `forms_become_citizens` — Forms Become Citizens (priority 97)
1. `cat_republic` — The Purrfect Transfer of Power (priority 100)
1. `accidental_moon_replacement` — The Brighter Moon Decree (priority 96)

## 5. Twenty-four palace upgrades by category and Medal cost

### throne_room
1. `gold_desk` — Gold Desk — **5 Medals** — unlock `visual_palace_state`
1. `velvet_throne` — Velvet Throne — **12 Medals** — unlock `visual_palace_state`
1. `audience_carpet` — Audience Carpet — **18 Medals** — unlock `archive_hint`
1. `portrait_wall` — Portrait Wall — **25 Medals** — unlock `cosmetic_ending_variant`
1. `ceremonial_gavel` — Ceremonial Gavel — **35 Medals** — unlock `decision_eligibility`
1. `echo_balcony` — Echo Balcony — **45 Medals** — unlock `visual_palace_state`

### propaganda_room
1. `propaganda_studio` — Propaganda Studio — **10 Medals** — unlock `decision_eligibility`
1. `cue_card_printer` — Cue Card Printer — **22 Medals** — unlock `content_pool`
1. `applause_track` — Applause Track — **30 Medals** — unlock `visual_palace_state`
1. `headline_carousel` — Headline Carousel — **40 Medals** — unlock `archive_hint`

### emergency_bunker
1. `emergency_bunker` — Emergency Bunker — **15 Medals** — unlock `starting_modifier`
1. `map_table` — Crisis Map Table — **28 Medals** — unlock `decision_eligibility`
1. `sealed_archive` — Sealed Archive Drawer — **38 Medals** — unlock `archive_hint`
1. `red_phone` — Mostly Red Phone — **50 Medals** — unlock `cosmetic_ending_variant`

### office_bureaucracy
1. `triple_intray` — Triple In-Tray — **8 Medals** — unlock `visual_palace_state`
1. `stamp_museum` — Stamp Museum — **20 Medals** — unlock `decision_eligibility`
1. `quiet_hours_lamp` — Quiet Hours Lamp — **32 Medals** — unlock `starting_modifier`
1. `form_fountain` — Form Fountain — **48 Medals** — unlock `content_pool`

### science_laboratory
1. `prototype_shelf` — Prototype Shelf — **16 Medals** — unlock `decision_eligibility`
1. `moon_whiteboard` — Moon Whiteboard — **34 Medals** — unlock `archive_hint`
1. `ai_coffee_bot` — AI Coffee Bot — **55 Medals** — unlock `decision_eligibility`

### cat_related
1. `cushion_throne` — Cushion Throne Annex — **14 Medals** — unlock `decision_eligibility`
1. `fish_dispenser` — Diplomatic Fish Dispenser — **26 Medals** — unlock `visual_palace_state`
1. `nap_observatory` — Nap Observatory — **42 Medals** — unlock `cosmetic_ending_variant`

## 6. Rejected, merged, and deferred endings

- `survived_the_prototype`: Rejected from collectible 50 — survival runtime only.
- `content_exhausted`: Rejected from collectible 50 — fallback only.
- `nation_in_darkness`: Deferred — crisis explicit trigger; weak archive setup.
- `everyone_moves_next_door`: Rejected PRD secret — no narrative setup.
- `the_accidental_libertarian`: Rejected PRD ruler-identity ending — identity not authored.
- `the_parade_philosopher`: Rejected PRD candidate — overlaps tank/parade endings.
- `the_minister_of_everything`: Rejected PRD candidate — overlaps bureaucratic endings.
- `economic_miracle`: Rejected PRD candidate — overlaps country_somehow_works.
- `luna_news_immortal`: Rejected PRD advisor ending — covered by media endings.
- `doctor_maybe_definitely`: Deferred PRD advisor ending — covered by scientific_golden_age.
- `the_chaotic_reformer_ending`: Deferred with ruler identity gap.
- `the_sponsored_supreme_leader`: Deferred — covered by corporate_ministan.
- `the_bureaucratic_oracle`: Deferred — covered by spreadsheet/clerk endings.
- `the_last_honest_propagandist`: Rejected — overlaps Luna/broadcast paths.
- `the_peoples_favorite_problem`: Deferred PRD identity ending.

System non-collectible (outside the 50): `survived_the_prototype`, `content_exhausted`, `nation_in_darkness`.

## 7. Ending-priority rules

1. Explicit `trigger_ending` on the chosen option always wins.
2. Among condition matches, highest `priority` wins (secrets/specials typically 70–100).
3. Generic resource failures sit at 50–53 (`elite_coup` > `revolution` > `chaos_country` > `bankrupt_leader`).
4. Max-day survival (`survived_the_prototype`) if no condition match.
5. Content-exhausted fallback last.
A more specific special/secret ending therefore outranks a simultaneous resource collapse.

## 8. Law interactions and contradiction handling

- Interactions are data-driven: `add_laws` / `remove_laws` on options; `all_laws` / `any_laws` / `blocked_laws` on requirements.
- Every approved law has ≥2 downstream decision gates and ≥1 enactment path.
- Contradictory pairs use `blocked_laws` so cards gated on law A refuse to appear while law B is active (and vice versa where authored).
- Delayed consequences continue to use soft/hard follow-up queues on enacting decisions.
- Cut laws (56 extras) were remapped onto the PRD canonical 50 via thematic aliases.

## 9. Simulation report

### 10,000-run primary (random 5k + first 5k)

| Metric | Value |
|---|---:|
| Content exhaustion | 0 |
| Fallback usage | 512 |
| Avg medals / run | ~14.1 |
| Avg run length | ~19 days |
| Decision IDs selected | 308 / 343 |

**Dominant ending:** `bankrupt_leader` (~35%).  
**Dominant laws:** `artificial_sun_program`, `window_tax`, `tank_traffic_control`, `form_request_form_act`.  
**Rare / zero in 10k (pre final hooks):** `moon_replacement_research`, `privatize_air`, `rent_a_ministry`; secret `accidental_moon_replacement` = 0.

### Supplemental 2,000-run law check (after final hooks)

All previously missing focus laws activated; `accidental_moon_replacement` reached 61×; secret debug proof passed for all six secrets.

### Secret ending proof

`tests/run_2b17_secret_debug_proof.gd` — failures=0 (toaster, wrong_map, micronation, forms, accidental moon condition+trigger).

### Medal affordability

- Average ~14 Medals/run ⇒ early upgrades (5–15) in 1–2 runs; mid (20–40) in 2–3; late (48–55) in ~4 runs once unlock conditions (runs/endings) are met.

## 10. Unreachable / rare / dominant callouts

| Item | Note |
|---|---|
| `bankrupt_leader` | Dominant collapse ending |
| `artificial_sun_program` | Very frequent law |
| `accidental_moon_replacement` | Rare in open sims; debug-proven; moon-arc gated |
| Palace-gated standalones | 7 cards require purchased upgrades |
| Standalone gap −9 | Deferred to 2B-18 |

## 11. Phase 3 visual asset inventory summary

See `docs/content/PHASE_3_VISUAL_ASSET_INVENTORY.md`: 8 advisor sets × 5 expressions, 50 law icons, ~45 city props, 18 crisis effects, 24 palace states, 50 ending illustrations, 12 reusable overlays (~140 unique / ~20 reusable kits).

## 12. Manual test scenarios

1. **Law enact + popup:** Pass `window_tax_proposal` → tax windows → law appears; open law popup; confirm ≥1 unlock/block fact.
2. **Contradiction:** Enact a contradictory pair (e.g. pizza vs coupons path) and confirm blocked card does not appear.
3. **Ending archive:** Reach any ending → archive unlocks with title/description; locked entries show `archive_hint`; repeat run increments count.
4. **Ending priority:** Force happiness=0 with cat republic conditions → `cat_republic` not `revolution`.
5. **Palace purchase:** Earn Medals → buy `gold_desk`; retry purchase blocked; reload game → still purchased.
6. **Palace gate:** Without `propaganda_studio`, `anthem_sponsor_reads` should not appear; purchase upgrade → card eligible.
7. **Insufficient Medals:** 0 Medals → purchase fails; Medals unchanged.
8. **Meta reset:** Reset meta → medals/endings/upgrades cleared; restart app → still cleared.
9. **Secret debug:** Debug Overlay force `toaster_elected_president` / moon brighter_model path.
10. **Counts:** Debug content dump shows 50 laws, 24 palace, 50 collectible endings; approved decisions still 321.

## 13. Minimal system fixes

- `required_palace_upgrades` requirement key.
- Ending collectible metadata + archive UI hints.
- Validator gates for rarity/archive_hint/palace category.
- Simulator law activation aggregation.
- Removed accidental self-gating where a law-enacting card required its own law.

## 14. Explicit non-starts

- **Do not start Milestone 2B-18.**
- No final graphics, accounts, ads, IAP, cloud saves, or analytics.
- No net new approved decisions (remain 321).
