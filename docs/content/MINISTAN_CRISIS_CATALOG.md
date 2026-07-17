# Ministan Crisis Catalog

**Phase:** 2B-14 crisis content pack  
**Target:** 18 crisis definitions, 28 crisis-class decisions (10 two-decision + 8 one-decision)  
**Spec:** [09_PHASE_2B](../09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md) §10

Structure key: **2-card** = entry + resolution decision; **1-card** = single crisis decision.

---

## Gap analysis (pre-integration)

| Metric | Pre-2B-14 | Target | Gap |
|---|---:|---:|---:|
| Required crisis definitions | 8 live + 1 deferred | 18 | 9 new + 1 promote |
| Crisis-class decisions | 8 reusable + 1 deferred | 28 | ~19 new / rewrite |
| Two-decision crises | 0 | 10 | 10 |
| One-decision crises | all current | 8 | reshape |
| `pantry_moth_crisis` | onboarding extra | non-quota | keep outside 18 |

### Disposition

| Item | Disposition |
|---|---|
| Power / Bank / Protest entries | Rewrite; expand to 2-card (Sub-batch A) |
| Cheese entry | Rewrite; expand to 2-card (Sub-batch B) |
| Cat / AI / Moon / Festival | Rewrite; remain 1-card |
| `budget_meltdown` | Promote as Currency Collapse; keep runtime ID |
| `pantry_moth_crisis` | Deferred from quota (onboarding) |
| Palace Fire, Data Leak, Mutiny, Border, Bureaucrat, Internet, Blue Water, Transport, Fake News | New |

---

## 2B-14 sub-batch structure (approved)

### Sub-batch A — 9 crises / 14 decisions

**2-card (5):** `national_power_outage`, `bank_run`, `mass_protest`, `palace_fire`, `military_mutiny`  
**1-card (4):** `government_data_leak`, `cat_parliament_occupation`, `water_supply_turns_blue`, `public_transport_strike`

### Sub-batch B — 9 crises / 14 decisions

**2-card (5):** `cheese_shortage_crisis`, `international_border_confusion`, `bureaucrat_general_strike`, `national_internet_outage`, `fake_news_panic`  
**1-card (4):** `budget_meltdown` (Currency Collapse), `ai_cabinet_lockout`, `moon_ownership_dispute`, `national_festival_stampede`

---

## Phase 2A integrated crises (historical)

| Planning ID | Runtime ID | Structure | Status |
|---|---|---|---|
| `crisis_national_power_outage` | `national_power_outage` | 2-card (2B-14) | approved |
| `crisis_bank_run` | `bank_run` | 2-card (2B-14) | approved |
| `crisis_mass_protest` | `mass_protest` | 2-card (2B-14) | approved |
| `crisis_cheese_shortage` | `cheese_shortage_crisis` | 2-card (2B-14) | approved |
| `crisis_cat_parliament_occupation` | `cat_parliament_occupation` | 1-card | approved |
| `crisis_currency_collapse` | `budget_meltdown` | 1-card | approved (promoted) |

---

## Crisis inventory (18 definitions)

### crisis_national_power_outage

- **Title:** National Power Outage
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** luna_news
- **Category:** infrastructure
- **Intended stage:** escalation
- **Premise:** Grid fails; propaganda struggles in the dark.
- **Dependencies:** Content Director crisis activation
- **Likely laws:** emergency_broadcast_priority modifies options
- **Likely endings:** nation_in_darkness
- **Known risks:** Hospital vs palace privilege controversy
- **Runtime mapping:** `national_power_outage`
- **Sub-batch:** A

### crisis_bank_run

- **Title:** Bank Run
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** sir_profit
- **Category:** economy
- **Intended stage:** escalation
- **Premise:** Citizens empty accounts; oligarchs offer “solutions.”
- **Dependencies:** Low treasury trigger
- **Likely laws:** emergency_cheese_bonds ironic option
- **Likely endings:** bankrupt_leader
- **Known risks:** Must stay distinct from Currency Collapse
- **Runtime mapping:** `bank_run`
- **Sub-batch:** A

### crisis_mass_protest

- **Title:** Mass Protest
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** auntie_olga
- **Category:** public_life
- **Intended stage:** instability
- **Premise:** Square fills with citizens Olga warned about.
- **Dependencies:** Low happiness
- **Likely laws:** mandatory_applause worsens option
- **Likely endings:** revolution, chaos_country
- **Known risks:** Force must not be only effective option
- **Runtime mapping:** `mass_protest`
- **Sub-batch:** A

### crisis_cheese_shortage

- **Title:** Cheese Shortage
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** escalation
- **Premise:** Dairy diplomacy fails; pizza chain collateral damage.
- **Dependencies:** free_pizza_friday law optional
- **Likely laws:** free_pizza_friday, emergency_cheese_bonds
- **Likely endings:** (soft economic seals; cheese arc separate)
- **Known risks:** cheese_shortage chain name collision
- **Runtime mapping:** `cheese_shortage_crisis`
- **Sub-batch:** B

### crisis_palace_fire

- **Title:** Palace Fire
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** instability
- **Premise:** Fire threatens palace; rescue vs records/symbols/treasury.
- **Dependencies:** —
- **Likely laws:** emergency_martial_law
- **Likely endings:** (soft ruin flags; palace renovation arc separate)
- **Known risks:** Dark tone cap — keep absurd not tragic
- **Runtime mapping:** `palace_fire`
- **Sub-batch:** A

### crisis_government_data_leak

- **Title:** Government Data Leak
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** escalation
- **Premise:** Forms published accidentally; secrets are boring but embarrassing.
- **Dependencies:** bureaucracy counters
- **Likely laws:** permit_for_complaints (if present)
- **Likely endings:** —
- **Known risks:** Real-world hack allegory — stay fictional
- **Runtime mapping:** `government_data_leak`
- **Sub-batch:** A

### crisis_military_mutiny

- **Title:** Military Mutiny
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** general_boom
- **Category:** military_and_order
- **Intended stage:** instability
- **Premise:** Troops question parade budget; Boom loyalty branch.
- **Dependencies:** general_boom affinity / Order / military laws
- **Likely laws:** mandatory_marching, emergency_martial_law
- **Likely endings:** general_boom_coup, general_becomes_mascot
- **Known risks:** Overlap with boom arc resolution cards
- **Runtime mapping:** `military_mutiny`
- **Sub-batch:** A

### crisis_cat_parliament_occupation

- **Title:** Cat Occupation of Parliament
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** comrade_whiskers
- **Category:** cats_and_animals
- **Intended stage:** escalation
- **Premise:** Cats seize legislature; humans negotiate treats.
- **Dependencies:** cat laws / flags
- **Likely laws:** cat_voting_rights
- **Likely endings:** cat_republic
- **Known risks:** Distinct from Cat Revolution arc
- **Runtime mapping:** `cat_parliament_occupation`
- **Sub-batch:** A

### crisis_national_internet_outage

- **Title:** National Internet Outage
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** luna_news
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Offline nation panics; memes go analog.
- **Dependencies:** ministry_of_memes optional
- **Likely laws:** ministry_of_memes
- **Likely endings:** —
- **Known risks:** Guest youth speaker deferred — Luna hosts
- **Runtime mapping:** `national_internet_outage`
- **Sub-batch:** B

### crisis_water_supply_turns_blue

- **Title:** Water Supply Turns Blue
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** doctor_maybe
- **Category:** science_and_technology
- **Intended stage:** escalation
- **Premise:** Maybe's dye trial reaches taps.
- **Dependencies:** scientific_experiment_permit optional
- **Likely laws:** scientific_experiment_permit
- **Likely endings:** experiment_leaves
- **Known risks:** Gross-out vs charm balance
- **Runtime mapping:** `water_supply_turns_blue`
- **Sub-batch:** A

### crisis_international_border_confusion

- **Title:** International Border Confusion
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** foreign_ambassador
- **Category:** military_and_order
- **Intended stage:** escalation
- **Premise:** Border markers moved by parade tanks.
- **Dependencies:** border_parade_act optional
- **Likely laws:** border_parade_act
- **Likely endings:** smallest_superpower
- **Known risks:** neighboring_president guest pairing deferred
- **Runtime mapping:** `international_border_confusion`
- **Sub-batch:** B

### crisis_currency_collapse

- **Title:** Currency Collapse
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** minister_penny
- **Category:** economy
- **Intended stage:** instability
- **Premise:** Coupons and coins fail simultaneously.
- **Dependencies:** Distinct from Bank Run and Hyperinflation arc
- **Likely laws:** coupon_salaries
- **Likely endings:** bankrupt_leader, hyperinflation_millionaires
- **Known risks:** Keep runtime ID `budget_meltdown` for save compatibility
- **Runtime mapping:** `budget_meltdown`
- **Sub-batch:** B

### crisis_public_transport_strike

- **Title:** Public Transport Strike
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** auntie_olga
- **Category:** public_life
- **Intended stage:** instability
- **Premise:** Buses stop; tanks offer rides poorly.
- **Dependencies:** antigravity_transit optional
- **Likely laws:** antigravity_transit
- **Likely endings:** —
- **Known risks:** Strike tone — solidarity comedy not realism
- **Runtime mapping:** `public_transport_strike`
- **Sub-batch:** A

### crisis_ai_cabinet_lockout

- **Title:** AI Cabinet Lockout
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** clerk_zero
- **Category:** science_and_technology
- **Intended stage:** endgame
- **Premise:** Robot ministers lock humans out of scheduling app.
- **Dependencies:** Soft AI flags; arc not required
- **Likely laws:** ai_cabinet_pilot
- **Likely endings:** —
- **Known risks:** Must work without AI Government arc active
- **Runtime mapping:** `ai_cabinet_lockout`
- **Sub-batch:** B

### crisis_moon_ownership_dispute

- **Title:** Moon Ownership Dispute
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** foreign_ambassador
- **Category:** business_and_privatization
- **Intended stage:** escalation
- **Premise:** Two tiny countries claim same moon corner.
- **Dependencies:** Soft moon flags; do not duplicate Sell the Moon arc
- **Likely laws:** moon_replacement_research
- **Likely endings:** moon_new_owner
- **Known risks:** accidental_moon_replacement ending alignment
- **Runtime mapping:** `moon_ownership_dispute`
- **Sub-batch:** B

### crisis_bureaucrat_general_strike

- **Title:** Bureaucrat General Strike
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** clerk_zero
- **Category:** bureaucracy
- **Intended stage:** instability
- **Premise:** No stamps issued; nation freezes politely.
- **Dependencies:** ministry_of_waiting optional
- **Likely laws:** ministry_of_waiting
- **Likely endings:** government_by_form
- **Known risks:** Player frustration — offer absurd resolutions
- **Runtime mapping:** `bureaucrat_general_strike`
- **Sub-batch:** B

### crisis_fake_news_panic

- **Title:** Fake News Panic
- **Status:** approved
- **Target cards:** 2
- **Primary speaker:** luna_news
- **Category:** media_and_propaganda
- **Intended stage:** escalation
- **Premise:** Rumor license backfires; everyone publishes everything.
- **Dependencies:** public_rumor_license optional
- **Likely laws:** public_rumor_license
- **Likely endings:** —
- **Known risks:** Real-world “fake news” phrase — fictional framing only
- **Runtime mapping:** `fake_news_panic`
- **Sub-batch:** B

### crisis_national_festival_stampede

- **Title:** National Festival Stampede
- **Status:** approved
- **Target cards:** 1
- **Primary speaker:** auntie_olga
- **Category:** public_life
- **Intended stage:** instability
- **Premise:** Eternal festival overcrowds; safety vs ratings.
- **Dependencies:** festival flags soft
- **Likely laws:** three_day_weekend
- **Likely endings:** —
- **Known risks:** Crowd tragedy tone — keep cartoon slapstick
- **Runtime mapping:** `national_festival_stampede`
- **Sub-batch:** B

---

## Non-quota onboarding crisis

### pantry_moth_crisis

- **Title:** Pantry Moth Infestation
- **Status:** onboarding (non-quota)
- **Target cards:** 1
- **Primary speaker:** auntie_olga
- **Runtime mapping:** `pantry_moth_crisis`
- **Notes:** Counts toward onboarding, not the 18 approved crisis definitions.

---

## Structure verification

| Structure | Crises | Decisions |
|---|---:|---:|
| 2-card | 10 | 20 |
| 1-card | 8 | 8 |
| **Total** | **18** | **28** |

**2-card crises (10):** `crisis_national_power_outage`, `crisis_bank_run`, `crisis_mass_protest`, `crisis_palace_fire`, `crisis_military_mutiny`, `crisis_cheese_shortage`, `crisis_international_border_confusion`, `crisis_bureaucrat_general_strike`, `crisis_national_internet_outage`, `crisis_fake_news_panic`

**1-card crises (8):** `crisis_government_data_leak`, `crisis_cat_parliament_occupation`, `crisis_water_supply_turns_blue`, `crisis_public_transport_strike`, `crisis_currency_collapse`, `crisis_ai_cabinet_lockout`, `crisis_moon_ownership_dispute`, `crisis_national_festival_stampede`

---

## Revision history

| Version | Date | Notes |
|---|---|---|
| 1.0 | 2026-07-15 | Milestone 2B-1 — 18 crisis planning entries |
| 2.0 | 2026-07-17 | Milestone 2B-14 — approved 10/8 split, sub-batches A/B, gap dispositions |
