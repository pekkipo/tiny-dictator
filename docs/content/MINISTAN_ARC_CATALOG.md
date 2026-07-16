# Ministan Arc Catalog

**Phase:** 2B-1 planning document (not runtime)  
**Target:** 18 major arcs, 96 major-arc decisions  
**Spec:** [09_PHASE_2B](../09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md) §§9.1–9.3

Planning arcs use `arc_` IDs. Runtime Phase 2A arcs may use different IDs — see **Runtime mapping** on each entry.

---

## Phase 2A mapping summary

| Planning ID | Runtime ID (2A) | Status |
|---|---|---|
| `arc_general_boom_rise` | `general_boom_arc` | 2B-10 Pack A (7 cards incl. supporting) |
| `arc_penny_austerity` | `penny_austerity_arc` | 2B-10 Pack A (6 cards incl. supporting) |
| `arc_traffic_military_control` | `traffic_military_control` (major); legacy `traffic_military` remains minor debug_only | 2B-10 Pack A (6 cards) |
| `arc_hyperinflation` | `hyperinflation_arc` | 2B-10 Pack A (5 cards) |
| `arc_maybe_experimental_republic` | `doctor_maybe_arc` | partial (4 cards) |
| `arc_cat_politics` | `cat_politics` | partial (8 cards; trim to 6 at integration) |
| `arc_mandatory_happiness` | `mandatory_happiness` | partial (6 cards; trim to 5) |
| `arc_ai_government` | `robot_government` | deferred (2 cards) |

---

## Advisor arcs (43 cards)

### arc_general_boom_rise

- **Title:** The General's Rise
- **Status:** approved (2B-10)
- **Target cards:** 7 (6 core + supporting `boom_ceremonial_mascot`)
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** establishment → escalation
- **Premise:** General Boom grows from parade requests toward emergency powers, loyalty, coup tension, or ceremonial mascot diversion.
- **Dependencies:** None for entry; affinity gates mid-arc
- **Likely laws:** mandatory_marching, emergency_martial_law, emergency_salute_law
- **Likely endings:** general_boom_coup, general_becomes_mascot, general_remains_loyal
- **Known risks:** Overlap with standalone parade cards; loyal resolution reachability
- **Runtime mapping:** `general_boom_arc`
- **Brief:** [2B-10_major_arc_pack_a_briefs.md](drafts/2B-10_major_arc_pack_a_briefs.md)

### arc_penny_austerity

- **Title:** The Austerity Miracle
- **Status:** approved (2B-10)
- **Target cards:** 6 (5 core + supporting `penny_service_sunset`)
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** establishment
- **Premise:** Penny's cuts stack until citizens rebel, the ledger becomes a religion, or a disciplined miracle balances the books.
- **Dependencies:** Optional window_tax or coupon laws; exclusive with `hyperinflation_arc` while active
- **Likely laws:** emergency_efficiency_act, public_service_sunset_act
- **Likely endings:** spreadsheet_state, austerity_without_citizens, penny_balances_final_budget
- **Known risks:** Voice overlap with standalone tax cards; stage stagger vs hyperinflation
- **Runtime mapping:** `penny_austerity_arc`
- **Brief:** [2B-10_major_arc_pack_a_briefs.md](drafts/2B-10_major_arc_pack_a_briefs.md)

### arc_luna_media_reality

- **Title:** The Media Becomes Reality
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** escalation
- **Premise:** Propaganda so effective that fiction replaces facts nationwide.
- **Dependencies:** Distinct from mandatory_happiness smile cluster
- **Likely laws:** one_headline_policy, ministry_of_memes, national_reality_show
- **Likely endings:** nation_becomes_broadcast, day_everyone_stopped_believing, luna_makes_you_immortal
- **Known risks:** Premise overlap with `arc_mandatory_happiness`; defer merge in 2B-11

### arc_olga_citizen_movement

- **Title:** The Citizen Movement
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** auntie_olga
- **Category:** public_life
- **Intended stage:** escalation → instability
- **Premise:** Olga organizes practical citizens into a movement the palace cannot ignore.
- **Dependencies:** Low happiness or failed infrastructure choices
- **Likely laws:** official_queue_etiquette, public_compliment_quota (ironic repeal path)
- **Likely endings:** olga_peoples_cabinet, palace_hears_the_street, olga_sends_you_home
- **Known risks:** Protest overlap with mass_protest crisis

### arc_maybe_experimental_republic

- **Title:** The Experimental Republic
- **Status:** partial
- **Target cards:** 6
- **Primary speaker:** doctor_maybe
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Maybe's trials escalate from lab sparks to nation-scale experiments.
- **Dependencies:** scientific_experiment_permit law optional
- **Likely laws:** artificial_sun_program, clone_holiday, ai_cabinet_pilot
- **Likely endings:** experimental_republic, experiment_leaves, scientific_golden_age
- **Known risks:** Variance balance; containment card tone (Clerk Zero co-speaker on one card OK)
- **Runtime mapping:** `doctor_maybe_arc`

### arc_profit_corporate_state

- **Title:** The Corporate State
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** sir_profit
- **Category:** business_and_privatization
- **Intended stage:** escalation → endgame
- **Premise:** Sir Profit privatizes ministries until the country is a subsidiary.
- **Dependencies:** Low treasury or prior privatization standalones
- **Likely laws:** privatize_air, rent_a_ministry, corporate_capital_naming
- **Likely endings:** corporate_ministan, country_is_acquired, profit_buys_retirement
- **Known risks:** Treasury-positive dominant options

### arc_whiskers_cat_revolution

- **Title:** The Cat Revolution
- **Status:** outlined
- **Target cards:** 6
- **Primary speaker:** comrade_whiskers
- **Category:** cats_and_animals
- **Intended stage:** establishment → escalation
- **Premise:** Cat political demands escalate from fish to parliament occupation.
- **Dependencies:** Partial overlap with national cat_politics — mutual exclusivity pair
- **Likely laws:** cat_voting_rights, cat_parliament_seats, fish_subsidy
- **Likely endings:** purrfect_transfer, cats_return_to_boxes, supreme_cat_servant
- **Known risks:** Duplicate cat voting premise with legacy `cat_voting_proposal`

### arc_zero_government_of_forms

- **Title:** The Government of Forms
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** establishment → endgame
- **Premise:** Bureaucracy expands until forms govern forms.
- **Dependencies:** bureaucracy counters from standalones
- **Likely laws:** form_request_form_act, ministry_of_waiting, triple_stamp_requirement
- **Likely endings:** government_by_form, final_stamp, clerk_zero_closes_file
- **Known risks:** Player fatigue with pure paperwork humor; pair with visual gags

---

## National arcs (53 cards)

### arc_cat_politics

- **Title:** Cat Politics
- **Status:** partial
- **Target cards:** 6
- **Primary speaker:** minister_penny (entry); multi-speaker
- **Category:** cats_and_animals
- **Intended stage:** establishment
- **Premise:** Cats enter formal politics; fish budgets and parliament seats divide the nation.
- **Dependencies:** Mutually exclusive with full cat revolution path
- **Likely laws:** cat_voting_rights, fish_emergency_reserve
- **Likely endings:** cat_republic, cats_return_to_boxes
- **Known risks:** 8 existing cards — consolidate to 6; duplicate voting premise
- **Runtime mapping:** `cat_politics`

### arc_mandatory_happiness

- **Title:** Mandatory Happiness
- **Status:** partial
- **Target cards:** 5
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** establishment → escalation
- **Premise:** Forced optimism industry grows until citizens snap or reform.
- **Dependencies:** mandatory_smiling law chain
- **Likely laws:** mandatory_smiling, fake_smile_standard, national_happiness_index
- **Likely endings:** eternal_smile_state, happiness_reaches_100_percent
- **Known risks:** Smile cluster with standalones; trim one resolution card
- **Runtime mapping:** `mandatory_happiness`

### arc_traffic_military_control

- **Title:** Traffic and Military Control
- **Status:** approved (2B-10)
- **Target cards:** 6 (5 core + supporting `traffic_checkpoint_hour`)
- **Primary speaker:** general_boom / minister_penny / auntie_olga
- **Category:** infrastructure
- **Intended stage:** establishment
- **Premise:** Practical gridlock invites military convoys, checkpoints, and ceremonial priority lanes — distinct from Pack C flag corps and tank parking.
- **Dependencies:** Soft optional Boom affinity; blocked while Pack C traffic_flags / tank_parking live
- **Likely laws:** military_route_priority_act, traffic_checkpoint_act
- **Likely endings:** traffic_system_achieves_peace; rare distinct martial path (not tank-parking ending)
- **Known risks:** Legacy minor `traffic_military` remains debug_only; must not double-count
- **Runtime mapping:** `traffic_military_control` (major); legacy `traffic_military` (minor, debug_only)
- **Brief:** [2B-10_major_arc_pack_a_briefs.md](drafts/2B-10_major_arc_pack_a_briefs.md)

### arc_ai_government

- **Title:** AI Government
- **Status:** deferred
- **Target cards:** 6
- **Primary speaker:** doctor_maybe / clerk_zero
- **Category:** science_and_technology
- **Intended stage:** escalation → endgame
- **Premise:** Robot cabinet pilot becomes actual governance.
- **Dependencies:** robot_cabinet_proposal chain deferred
- **Likely laws:** ai_cabinet_pilot, robot_civil_service
- **Likely endings:** ai_accepts_resignation, technocratic_accident
- **Known risks:** Overlap with doctor_maybe arc; defer until robot chain approved
- **Runtime mapping:** `robot_government`

### arc_sell_the_moon

- **Title:** Sell the Moon
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** sir_profit / doctor_maybe
- **Category:** business_and_privatization
- **Intended stage:** escalation
- **Premise:** Moon ownership becomes a budget line item with diplomatic fallout.
- **Dependencies:** maybe_moon_dust_trial standalone as soft entry
- **Likely laws:** moon_replacement_research
- **Likely endings:** moon_new_owner, accidental_moon_replacement
- **Known risks:** Existing ending `accidental_moon_replacement` must align conditions

### arc_hyperinflation

- **Title:** Hyperinflation
- **Status:** approved (2B-10)
- **Target cards:** 5
- **Primary speaker:** minister_penny / sir_profit / luna_news
- **Category:** economy
- **Intended stage:** instability
- **Premise:** Prices spiral; reform, barter, and printing fork into recovery, strange success, or collapse.
- **Dependencies:** Optional coupon/lottery weight; exclusive with `penny_austerity_arc`; blocked vs fish currency / coin shortage live
- **Likely laws:** emergency_price_board_act, barter_license_act
- **Likely endings:** hyperinflation_millionaires, bankrupt_leader
- **Known risks:** Distinct from coin_shortage and fish_currency_experiment; stagger vs penny austerity
- **Runtime mapping:** `hyperinflation_arc`
- **Brief:** [2B-10_major_arc_pack_a_briefs.md](drafts/2B-10_major_arc_pack_a_briefs.md)

### arc_national_festival_economy

- **Title:** National Festival Economy
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** auntie_olga / luna_news
- **Category:** public_life
- **Intended stage:** escalation
- **Premise:** Permanent festival drains treasury but boosts happiness until stampede.
- **Dependencies:** Links to crisis_national_festival_stampede
- **Likely laws:** three_day_weekend, universal_birthday
- **Likely endings:** eternal_national_festival, beloved_retirement
- **Known risks:** Free pizza legacy chain thematically adjacent

### arc_fake_election_accident

- **Title:** Fake Election Accident
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** clerk_zero / chief_judge (guest)
- **Category:** bureaucracy
- **Intended stage:** instability
- **Premise:** Administrative error creates accidental democracy scare.
- **Dependencies:** chief_judge guest appearances
- **Likely laws:** permit_for_complaints, national_filing_week
- **Likely endings:** democracy_by_administrative_error, peaceful_accidental_democracy
- **Known risks:** Legal tone vs comedy; keep chief_judge voice solemn

### arc_international_cheese_crisis

- **Title:** International Cheese Crisis
- **Status:** outlined
- **Target cards:** 5
- **Primary speaker:** foreign_ambassador / minister_penny
- **Category:** economy
- **Intended stage:** escalation
- **Premise:** Cheese diplomacy ties to pizza chain fallout and trade embargoes.
- **Dependencies:** cheese_shortage chain/crisis partial integration
- **Likely laws:** emergency_cheese_bonds, free_pizza_friday
- **Likely endings:** great_cheese_settlement, nation_in_darkness (power+cheese combo rare)
- **Known risks:** cheese_shortage_crisis already integrated — align IDs in 2B-14

### arc_palace_renovation_scandal

- **Title:** Palace Renovation Scandal
- **Status:** outlined
- **Target cards:** 6
- **Primary speaker:** sir_profit / palace_chef (guest)
- **Category:** public_life
- **Intended stage:** endgame
- **Premise:** Renovation budget reveals hollow palace truths.
- **Dependencies:** palace upgrades meta; low elite loyalty optional
- **Likely laws:** palace_subscription_plan
- **Likely endings:** palace_beautiful_empty, renovation_reveals_truth
- **Known risks:** Endgame pacing; tie to placeholder endgame cards rewrite

---

## Revision history

| Version | Date | Notes |
|---|---|---|
| 1.0 | 2026-07-15 | Milestone 2B-1 — 18 arc planning entries |
| 1.1 | 2026-07-16 | Milestone 2B-10 Pack A — Boom/Penny/Traffic/Hyper briefs; target cards 7/6/6/5 |
