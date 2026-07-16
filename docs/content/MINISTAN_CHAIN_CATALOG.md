# Ministan Chain Catalog

**Phase:** 2B-1 planning document (not runtime)  
**Target:** 32 short chains, 80 short-chain decisions (16×2-card + 16×3-card)  
**Spec:** [09_PHASE_2B](../09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md) §8

---

## Legacy Phase 2A chains

| Planning ID | Runtime chain_id | Cards | Status |
|---|---|---:|---|
| `chain_free_pizza_legacy` | `free_pizza_consequences` | 4 | partial — rewrite to PRD chains in 2B-6+ |
| `chain_traffic_military_legacy` | `traffic_military` | 5 | superseded by Pack C Traffic Flags + Tank Parking — `debug_only` |
| `chain_robot_government_legacy` | `robot_government` | 2 | deferred |

---

## PRD chain inventory (32 chains, 80 decisions)

### chain_umbrella_tax

- **Title:** Umbrella Tax
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** establishment
- **Premise:** Penny taxes rain gear; citizens adapt absurdly.
- **Dependencies:** None
- **Likely laws:** umbrella_tax
- **Likely endings:** —
- **Known risks:** Near-duplicate standalone tax cards
- **Decision IDs:** umbrella_tax_proposal, umbrella_tax_enforcement
- **Batch:** 2B-6A

### chain_national_coffee_reserve

- **Title:** National Coffee Reserve
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** auntie_olga
- **Category:** public_life
- **Intended stage:** establishment
- **Premise:** Free coffee morning creates hoarding and queue culture.
- **Dependencies:** free_coffee_morning rewrite from Pack A
- **Likely laws:** national_coffee_reserve
- **Likely endings:** —
- **Known risks:** Public-life tone vs Olga voice
- **Decision IDs:** free_coffee_morning, coffee_hoarding_crisis, coffee_reserve_resolution
- **Batch:** 2B-6A

### chain_privatized_public_benches

- **Title:** Privatized Public Benches
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** sir_profit
- **Category:** business_and_privatization
- **Intended stage:** escalation
- **Premise:** Sitting becomes subscription-based.
- **Dependencies:** —
- **Likely laws:** bench_subscription_act
- **Likely endings:** corporate_ministan
- **Known risks:** Happiness hit pacing
- **Decision IDs:** privatized_benches_proposal, bench_subscription_backlash, bench_policy_resolution
- **Batch:** 2B-6A

### chain_lottery_budget

- **Title:** Lottery Budget
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** establishment
- **Premise:** National lottery funds treasury until odds collapse morale.
- **Dependencies:** Links bank_run crisis modifier; soft hyperinflation flag
- **Likely laws:** national_lottery_budget
- **Likely endings:** —
- **Known risks:** Overlap with hyperinflation arc
- **Decision IDs:** lottery_treasury_fund, lottery_odds_collapse
- **Batch:** 2B-6A

### chain_coin_shortage

- **Title:** Coin Shortage
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** establishment
- **Premise:** Exact-change policy breaks commerce.
- **Dependencies:** —
- **Likely laws:** coin_rounding_act
- **Likely endings:** —
- **Known risks:** treasury_tip_jar standalone overlap
- **Decision IDs:** coin_shortage_crisis, coin_shortage_remedy
- **Batch:** 2B-7A

### chain_weekend_abolition

- **Title:** Weekend Abolition
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** minister_penny
- **Category:** public_life
- **Intended stage:** establishment
- **Premise:** no_weekends_proposal onboarding echoes into citizen burnout.
- **Dependencies:** no_weekends law (2A integrated)
- **Likely laws:** no_weekends
- **Likely endings:** —
- **Known risks:** Onboarding card `no_weekends_proposal` already exists
- **Decision IDs:** no_weekends_proposal, weekend_burnout_wave, weekend_policy_resolution
- **Batch:** 2B-7A
### chain_palace_gift_shop

- **Title:** Palace Gift Shop
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** sir_profit
- **Category:** business_and_privatization
- **Intended stage:** establishment
- **Premise:** Privatize palace garden expands into merch empire.
- **Dependencies:** Distinct from Pack C working_palace_tours
- **Likely laws:** palace_gift_shop_act
- **Likely endings:** —
- **Known risks:** Affinity card may merge into chain entry
- **Decision IDs:** palace_gift_shop_opening, gift_shop_merch_scandal
- **Batch:** 2B-6B

### chain_pothole_naming_rights

- **Title:** Pothole Naming Rights
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** sir_profit
- **Category:** infrastructure
- **Intended stage:** escalation
- **Premise:** Sponsored potholes become civic identity crisis.
- **Dependencies:** —
- **Likely laws:** sponsored_potholes_act
- **Likely endings:** —
- **Known risks:** Visual tag reuse `sponsored_potholes`
- **Decision IDs:** sponsored_potholes, pothole_brand_war, pothole_naming_resolution
- **Batch:** 2B-6B

### chain_elevator_wifi

- **Title:** Elevator Wi-Fi
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** doctor_maybe
- **Category:** infrastructure
- **Intended stage:** escalation
- **Premise:** Connectivity experiment traps ministers between floors.
- **Dependencies:** —
- **Likely laws:** —
- **Likely endings:** —
- **Known risks:** youth_representative guest cameo opportunity
- **Decision IDs:** elevator_wifi_mandate, elevator_wifi_trap
- **Batch:** 2B-6B

### chain_bridge_to_nowhere

- **Title:** Bridge to Nowhere
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** minister_penny
- **Category:** infrastructure
- **Intended stage:** establishment
- **Premise:** Cheap bridge project overshoots budget and geography.
- **Dependencies:** long_setup_grand_canal ID preserved (rewrite)
- **Likely laws:** —
- **Likely endings:** —
- **Known risks:** Infrastructure placeholder card overlap
- **Decision IDs:** long_setup_grand_canal, bridge_budget_overrun, bridge_to_nowhere_resolution
- **Batch:** 2B-6B

### chain_traffic_flags

- **Title:** Traffic Flags
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** general_boom
- **Category:** infrastructure
- **Intended stage:** establishment
- **Premise:** Replace traffic lights with flag corps.
- **Dependencies:** Supersedes traffic_military legacy (debug_only)
- **Likely laws:** traffic_flag_corps_act
- **Likely endings:** —
- **Known risks:** Distinct from Tank Parking / tank_traffic_control
- **Decision IDs:** traffic_flag_corps, traffic_flag_backlash, traffic_flag_resolution
- **Batch:** 2B-8A

### chain_perfumed_sewage

- **Title:** Perfumed Sewage
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** doctor_maybe
- **Category:** infrastructure
- **Intended stage:** escalation
- **Premise:** Scent experiment masks infrastructure failure briefly.
- **Dependencies:** Absorbs standalone perfumed_sewage_reform
- **Likely laws:** scent_mask_act
- **Likely endings:** —
- **Known risks:** Gross-out humor localization
- **Decision IDs:** perfumed_sewage_pilot, perfumed_sewage_fallout
- **Batch:** 2B-9A

### chain_salaries_paid_in_coupons

- **Title:** Salaries Paid in Coupons
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** establishment
- **Premise:** Civil servants paid in coupons; black market and morale follow the implementation.
- **Dependencies:** —
- **Likely laws:** coupon_salaries
- **Likely endings:** —
- **Known risks:** Distinct from rest/science coupon jokes
- **Decision IDs:** coupon_salaries_proposal, coupon_salary_market
- **Batch:** 2B-9A

### chain_national_clock_reform

- **Title:** National Clock Reform
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** establishment
- **Premise:** Synchronized clocks break appointments nationwide.
- **Dependencies:** —
- **Likely laws:** national_clock_law
- **Likely endings:** —
- **Known risks:** Clerk Zero flat voice needs visual gag
- **Decision IDs:** national_clock_sync, clock_appointment_chaos
- **Batch:** 2B-7A

### chain_state_meme_department

- **Title:** State Meme Department
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** escalation
- **Premise:** Ministry of Memes creates policy via viral templates.
- **Dependencies:** —
- **Likely laws:** ministry_of_memes
- **Likely endings:** —
- **Known risks:** Dated meme references — keep timeless absurd
- **Decision IDs:** state_meme_department, meme_virality_crisis, meme_department_resolution
- **Batch:** 2B-7A

### chain_weather_censorship

- **Title:** Weather Censorship
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** escalation
- **Premise:** Optimistic weather reports vs visible storms.
- **Dependencies:** —
- **Likely laws:** weather_censorship_act
- **Likely endings:** —
- **Known risks:** luna_good_news_only onboarding overlap
- **Decision IDs:** weather_censorship_mandate, weather_credibility_crisis
- **Batch:** 2B-7B

### chain_applause_quotas

- **Title:** Applause Quotas
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** escalation
- **Premise:** Mandatory applause metrics and enforcement squads.
- **Dependencies:** mandatory_happiness arc adjacent
- **Likely laws:** mandatory_applause
- **Likely endings:** eternal_smile_state (soft)
- **Known risks:** Smile cluster repetition
- **Decision IDs:** applause_quotas_mandate, applause_enforcement_squad, applause_public_adaptation
- **Batch:** 2B-7B

### chain_national_talent_show

- **Title:** National Talent Show
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** escalation
- **Premise:** Ruler judged on live TV; rigging scandal follows.
- **Dependencies:** —
- **Likely laws:** national_reality_show
- **Likely endings:** —
- **Known risks:** —
- **Decision IDs:** national_talent_show, talent_show_budget_scandal
- **Batch:** 2B-7B

### chain_artificial_sun

- **Title:** Artificial Sun
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** doctor_maybe
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Pilot sun grows; nights disappear; citizens complain.
- **Dependencies:** doctor_maybe arc partial overlap
- **Likely laws:** artificial_sun_program
- **Likely endings:** scientific_golden_age
- **Known risks:** Arc vs chain card budget — don't double-count premise
- **Decision IDs:** artificial_sun_pilot, artificial_sun_escalation, artificial_sun_resolution
- **Batch:** 2B-7B

### chain_robot_queue_manager

- **Title:** Robot Queue Manager
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** doctor_maybe
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Robot optimizes queues by rejecting humans.
- **Dependencies:** robot_government legacy deferred (distinct joke)
- **Likely laws:** robot_civil_service
- **Likely endings:** —
- **Known risks:** AI arc overlap
- **Decision IDs:** robot_queue_manager, robot_queue_incident, robot_queue_resolution
- **Batch:** 2B-8A

### chain_antigravity_buses

- **Title:** Anti-Gravity Buses
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** doctor_maybe
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Floating transit wins headlines; gravity returns inconveniently.
- **Dependencies:** —
- **Likely laws:** antigravity_transit
- **Likely endings:** —
- **Known risks:** —
- **Decision IDs:** antigravity_buses_pilot, antigravity_buses_consequence
- **Batch:** 2B-8A

### chain_national_clone_day

- **Title:** National Clone Day
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** doctor_maybe
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Duplicate citizens solve queues, confuse census.
- **Dependencies:** —
- **Likely laws:** clone_holiday
- **Likely endings:** —
- **Known risks:** —
- **Decision IDs:** national_clone_day, clone_registry_chaos
- **Batch:** 2B-8A

### chain_pigeon_air_force

- **Title:** Pigeon Air Force
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** establishment
- **Premise:** Cheap aerial defense via trained pigeons.
- **Dependencies:** postal_pigeon_reform standalone adjacent (kept distinct)
- **Likely laws:** pigeon_air_force
- **Likely endings:** —
- **Known risks:** Military comedy repetition
- **Decision IDs:** pigeon_air_force_proposal, pigeon_air_force_report
- **Batch:** 2B-8B

### chain_border_parade

- **Title:** Border Parade
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** escalation
- **Premise:** Border parade provokes neighboring president (via Luna diplomatic card).
- **Dependencies:** border_parade_dispute onboarding seed kept separate
- **Likely laws:** border_parade_act
- **Likely endings:** smallest_superpower
- **Known risks:** Guest speaker deferred; Luna frames neighbor complaint
- **Decision IDs:** border_parade_escalation, border_diplomatic_reaction, border_parade_resolution
- **Batch:** 2B-8B

### chain_camouflage_uniform_scandal

- **Title:** Camouflage Uniform Scandal
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** escalation
- **Premise:** New uniforms invisible in wrong places.
- **Dependencies:** —
- **Likely laws:** camouflage_uniform_act
- **Likely endings:** —
- **Known risks:** —
- **Decision IDs:** camouflage_uniform_rollout, camouflage_scandal_fallout
- **Batch:** 2B-8B

### chain_tank_parking_crisis

- **Title:** Tank Parking Crisis
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** establishment
- **Premise:** Tanks as traffic control overflow into parking politics.
- **Dependencies:** traffic_military legacy superseded (debug_only)
- **Likely laws:** tank_traffic_control
- **Likely endings:** tanks_direct_everything
- **Known risks:** Legacy chain merge
- **Decision IDs:** tank_parking_mandate, tank_parking_gridlock, tank_parking_resolution
- **Batch:** 2B-8B

### chain_form_to_request_forms

- **Title:** Form to Request Forms
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** establishment
- **Premise:** Meta-form bureaucracy becomes national pastime.
- **Dependencies:** bureaucracy_expansion affinity seed
- **Likely laws:** form_request_form_act
- **Likely endings:** government_by_form
- **Known risks:** Pure paperwork fatigue
- **Decision IDs:** form_request_forms_proposal, form_request_forms_backlog, form_request_forms_resolution
- **Batch:** 2B-9A

### chain_ministry_of_waiting

- **Title:** Ministry of Waiting
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** establishment
- **Premise:** Queues receive cabinet-level attention.
- **Dependencies:** Distinct from robot_queue_manager
- **Likely laws:** ministry_of_waiting
- **Likely endings:** —
- **Known risks:** —
- **Decision IDs:** ministry_of_waiting_proposal, ministry_of_waiting_service
- **Batch:** 2B-9B

### chain_stamp_shortage

- **Title:** Stamp Shortage
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** establishment
- **Premise:** Triple-stamp law meets supply collapse.
- **Dependencies:** Distinct from form_to_request_forms
- **Likely laws:** triple_stamp_requirement
- **Likely endings:** —
- **Known risks:** —
- **Decision IDs:** stamp_shortage_crisis, stamp_shortage_workaround
- **Batch:** 2B-9B

### chain_antivacuum_referendum

- **Title:** Anti-Vacuum Referendum
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** comrade_whiskers
- **Category:** cats_and_animals
- **Intended stage:** escalation
- **Premise:** Cats ban vacuum hours; referendum divides species.
- **Dependencies:** cat politics partial; feeds cat_republic
- **Likely laws:** antivacuum_act
- **Likely endings:** cat_republic
- **Known risks:** Cat arc overlap
- **Decision IDs:** antivacuum_referendum_proposal, antivacuum_campaign, antivacuum_referendum_result
- **Batch:** 2B-9B

### chain_fish_currency_experiment

- **Title:** Fish Currency Experiment
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** comrade_whiskers
- **Category:** cats_and_animals
- **Intended stage:** escalation
- **Premise:** Fish-backed currency roils treasury and cats alike.
- **Dependencies:** Distinct from fish_market_subsidy; mutual exclusion via blocked_laws
- **Likely laws:** fish_currency_act
- **Likely endings:** —
- **Known risks:** Economy simulation balance
- **Decision IDs:** fish_currency_proposal, fish_currency_boom, fish_currency_resolution
- **Batch:** 2B-9A

### chain_national_nap_hour

- **Title:** National Nap Hour
- **Status:** approved
- **Target cards:** 3
- **Primary speaker:** comrade_whiskers
- **Category:** cats_and_animals
- **Intended stage:** establishment
- **Premise:** Mandatory nap synchronizes nation; productivity satire.
- **Dependencies:** Mutual exclusion with national_nap_grid (`nap_grid_live`)
- **Likely laws:** national_nap_hour
- **Likely endings:** —
- **Known risks:** Public-life overlap with three_day_weekend
- **Decision IDs:** national_nap_hour_proposal, national_nap_productivity, national_nap_resolution
- **Batch:** 2B-9B

---

## Card count verification

| Length | Count | Cards |
|---|---:|---:|
| 2-card chains | 16 | 32 |
| 3-card chains | 16 | 48 |
| **Total** | **32** | **80** |

---

## Revision history

| Version | Date | Notes |
|---|---|---|
| 1.0 | 2026-07-15 | Milestone 2B-1 — 32 chain planning entries |
| 1.1 | 2026-07-16 | Milestone 2B-6 — Pack A eight chains approved |
| 1.2 | 2026-07-16 | Milestone 2B-7 — Pack B eight chains approved |
| 1.3 | 2026-07-16 | Milestone 2B-8 — Pack C eight chains approved |
| 1.4 | 2026-07-16 | Milestone 2B-9A — Coupons, Sewage, Forms, Fish approved; salaries catalog entry added |
| 1.5 | 2026-07-16 | Milestone 2B-9B — Waiting, Stamps, Anti-Vacuum, Nap Hour approved; Pack D complete (32/80) |
| 1.5 | 2026-07-16 | Milestone 2B-9B — Waiting, Stamps, Anti-Vacuum, Nap Hour approved; Pack D complete (32/80) |
