# Ministan Crisis Catalog

**Phase:** 2B-1 planning document (not runtime)  
**Target:** 18 crisis definitions, 28 crisis-class decisions (10 two-decision + 8 one-decision)  
**Spec:** [09_PHASE_2B](../09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md) §10

Structure key: **2-card** = entry + resolution decision; **1-card** = single crisis decision.

---

## Phase 2A integrated crises

| Planning ID | Runtime ID | Structure | Status |
|---|---|---|---|
| `crisis_national_power_outage` | `national_power_outage` | 1-card (expand to 2 in 2B-14) | integrated |
| `crisis_bank_run` | `bank_run` | 1-card | integrated |
| `crisis_mass_protest` | `mass_protest` | 1-card | integrated |
| `crisis_cheese_shortage` | `cheese_shortage_crisis` | 1-card | integrated |
| `crisis_cat_parliament_occupation` | `cat_parliament_occupation` | 1-card | integrated |
| `crisis_currency_collapse` | `budget_meltdown` | deferred alias | deferred |

---

## Crisis inventory (18 definitions)

### crisis_national_power_outage

- **Title:** National Power Outage
- **Status:** partial
- **Target cards:** 2 (expand from 1 integrated)
- **Primary speaker:** luna_news
- **Category:** infrastructure
- **Intended stage:** escalation
- **Premise:** Grid fails; propaganda struggles in the dark.
- **Dependencies:** Content Director crisis activation
- **Likely laws:** emergency_broadcast_priority modifies options
- **Likely endings:** nation_in_darkness
- **Known risks:** Existing single card needs resolution sibling
- **Runtime mapping:** `national_power_outage`

### crisis_bank_run

- **Title:** Bank Run
- **Status:** partial
- **Target cards:** 2
- **Primary speaker:** sir_profit
- **Category:** economy
- **Intended stage:** escalation
- **Premise:** Citizens empty accounts; oligarchs offer “solutions.”
- **Dependencies:** Low treasury trigger
- **Likely laws:** emergency_cheese_bonds ironic option
- **Likely endings:** bankrupt_leader
- **Known risks:** Treasury recovery overlap
- **Runtime mapping:** `bank_run`

### crisis_mass_protest

- **Title:** Mass Protest
- **Status:** partial
- **Target cards:** 2
- **Primary speaker:** auntie_olga
- **Category:** public_life
- **Intended stage:** instability
- **Premise:** Square fills with citizens Olga warned about.
- **Dependencies:** Low happiness
- **Likely laws:** mandatory_applause worsens option
- **Likely endings:** revolution, velvet_coup
- **Known risks:** Olga voice must stay grounded not preachy
- **Runtime mapping:** `mass_protest`

### crisis_cheese_shortage

- **Title:** Cheese Shortage
- **Status:** partial
- **Target cards:** 2
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** escalation
- **Premise:** Dairy diplomacy fails; pizza chain collateral damage.
- **Dependencies:** free_pizza_friday law optional
- **Likely laws:** free_pizza_friday, fish_emergency_reserve
- **Likely endings:** great_cheese_settlement
- **Known risks:** cheese_shortage chain name collision
- **Runtime mapping:** `cheese_shortage_crisis`

### crisis_palace_fire

- **Title:** Palace Fire
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** instability
- **Premise:** Fire threatens palace; martial response vs evacuation comedy.
- **Dependencies:** —
- **Likely laws:** emergency_martial_law
- **Likely endings:** palace_beautiful_empty
- **Known risks:** Dark tone cap — keep absurd not tragic

### crisis_government_data_leak

- **Title:** Government Data Leak
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** escalation
- **Premise:** Forms published accidentally; secrets are boring but embarrassing.
- **Dependencies:** bureaucracy counters
- **Likely laws:** permit_for_complaints
- **Likely endings:** democracy_by_administrative_error
- **Known risks:** Real-world hack allegory — stay fictional

### crisis_military_mutiny

- **Title:** Military Mutiny
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** instability
- **Premise:** Troops question parade budget; Boom loyalty branch.
- **Dependencies:** general_boom_arc affinity
- **Likely laws:** mandatory_marching
- **Likely endings:** general_boom_coup, general_becomes_mascot
- **Known risks:** Overlap with boom arc resolution cards

### crisis_cat_parliament_occupation

- **Title:** Cat Occupation of Parliament
- **Status:** partial
- **Target cards:** 2
- **Primary speaker:** comrade_whiskers
- **Category:** cats_and_animals
- **Intended stage:** escalation
- **Premise:** Cats seize legislature; humans negotiate treats.
- **Dependencies:** cat_voting_rights law
- **Likely laws:** cat_parliament_seats
- **Likely endings:** cat_republic
- **Known risks:** cat_parliament_occupation integrated as 1-card
- **Runtime mapping:** `cat_parliament_occupation`

### crisis_national_internet_outage

- **Title:** National Internet Outage
- **Status:** outlined
- **Target cards:** 1
- **Primary speaker:** youth_representative (guest)
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Offline nation panics; memes go analog.
- **Dependencies:** ministry_of_memes law optional
- **Likely laws:** ministry_of_memes
- **Likely endings:** —
- **Known risks:** Guest speaker quota (28 guest decisions total)

### crisis_water_supply_turns_blue

- **Title:** Water Supply Turns Blue
- **Status:** outlined
- **Target cards:** 1
- **Primary speaker:** doctor_maybe
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Maybe's dye trial reaches taps.
- **Dependencies:** maybe arc partial
- **Likely laws:** scientific_experiment_permit
- **Likely endings:** experiment_leaves
- **Known risks:** Gross-out vs charm balance

### crisis_international_border_confusion

- **Title:** International Border Confusion
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** foreign_ambassador (guest)
- **Category:** military_and_order
- **Intended stage:** escalation
- **Premise:** Border markers moved by parade tanks.
- **Dependencies:** border_parade chain
- **Likely laws:** border_parade_act
- **Likely endings:** smallest_superpower, everyone_moves_next_door
- **Known risks:** neighboring_president guest pairing

### crisis_currency_collapse

- **Title:** Currency Collapse
- **Status:** deferred
- **Target cards:** 2
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** instability
- **Premise:** Coupons and coins fail simultaneously.
- **Dependencies:** hyperinflation arc
- **Likely laws:** coupon_salaries
- **Likely endings:** hyperinflation_millionaires, bankrupt_leader
- **Known risks:** budget_meltdown deferred runtime crisis — rename at integration
- **Runtime mapping:** `budget_meltdown` (deferred)

### crisis_public_transport_strike

- **Title:** Public Transport Strike
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** workers_union_leader (guest)
- **Category:** public_life
- **Intended stage:** instability
- **Premise:** Buses stop; tanks offer rides poorly.
- **Dependencies:** antigravity_buses chain optional
- **Likely laws:** antigravity_transit
- **Likely endings:** —
- **Known risks:** Strike tone — solidarity comedy not realism

### crisis_ai_cabinet_lockout

- **Title:** AI Cabinet Lockout
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** clerk_zero
- **Category:** science_and_technology
- **Intended stage:** endgame
- **Premise:** Robot ministers lock humans out of scheduling app.
- **Dependencies:** arc_ai_government deferred
- **Likely laws:** ai_cabinet_pilot
- **Likely endings:** ai_accepts_resignation
- **Known risks:** robot_government chain dependency

### crisis_moon_ownership_dispute

- **Title:** Moon Ownership Dispute
- **Status:** outlined
- **Target cards:** 1
- **Primary speaker:** neighboring_president (guest)
- **Category:** business_and_privatization
- **Intended stage:** escalation
- **Premise:** Two tiny countries claim same moon corner.
- **Dependencies:** arc_sell_the_moon
- **Likely laws:** moon_replacement_research
- **Likely endings:** moon_new_owner
- **Known risks:** accidental_moon_replacement ending alignment

### crisis_bureaucrat_general_strike

- **Title:** Bureaucrat General Strike
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** instability
- **Premise:** No stamps issued; nation freezes politely.
- **Dependencies:** ministry_of_waiting chain
- **Likely laws:** ministry_of_waiting
- **Likely endings:** government_by_form
- **Known risks:** Player frustration — offer absurd resolutions

### crisis_fake_news_panic

- **Title:** Fake News Panic
- **Status:** outlined
- **Target cards:** 1
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** escalation
- **Premise:** Rumor license backfires; everyone publishes everything.
- **Dependencies:** arc_luna_media_reality soft
- **Likely laws:** public_rumor_license
- **Likely endings:** day_everyone_stopped_believing
- **Known risks:** Real-world “fake news” phrase — fictional framing only

### crisis_national_festival_stampede

- **Title:** National Festival Stampede
- **Status:** outlined
- **Target cards:** 2
- **Primary speaker:** auntie_olga
- **Category:** public_life
- **Intended stage:** instability
- **Premise:** Eternal festival overcrowds; safety vs ratings.
- **Dependencies:** arc_national_festival_economy
- **Likely laws:** three_day_weekend
- **Likely endings:** eternal_national_festival (ironic fail state)
- **Known risks:** Crowd tragedy tone — keep cartoon slapstick

---

## Structure verification

| Structure | Crises | Decisions |
|---|---:|---:|
| 2-card | 10 | 20 |
| 1-card | 8 | 8 |
| **Total** | **18** | **28** |

**2-card crises (10):** `crisis_national_power_outage`, `crisis_bank_run`, `crisis_mass_protest`, `crisis_cheese_shortage`, `crisis_palace_fire`, `crisis_government_data_leak`, `crisis_military_mutiny`, `crisis_cat_parliament_occupation`, `crisis_international_border_confusion`, `crisis_bureaucrat_general_strike`

**1-card crises (8):** `crisis_national_internet_outage`, `crisis_water_supply_turns_blue`, `crisis_currency_collapse`, `crisis_public_transport_strike`, `crisis_ai_cabinet_lockout`, `crisis_moon_ownership_dispute`, `crisis_fake_news_panic`, `crisis_national_festival_stampede`

Update per-entry **Target cards** to match this split during 2B-14 integration.

---

## Revision history

| Version | Date | Notes |
|---|---|---|
| 1.0 | 2026-07-15 | Milestone 2B-1 — 18 crisis planning entries |
