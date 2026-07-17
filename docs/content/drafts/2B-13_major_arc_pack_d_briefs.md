# Milestone 2B-13 — Major-Arc Pack D Briefs

**Status:** Implementation briefs  
**Pack target:** 24 approved major-arc decisions (exactly 4 per arc × 6 arcs)  
**Pre-pack approved:** 72 / 96  
**Post-pack target:** 96 / 96 major-arc decisions; 18 / 18 major arcs  
**Do not start:** Milestone 2B-14  

Quota reconciliation: older planning summed to 33 Pack D cards. Global total of 96 takes precedence → **4 cards × 6 arcs**.

Card lock:
1. Comrade Whiskers — The Cat Revolution — 4
2. Clerk Zero — The Government of Forms — 4
3. Cat Politics — 4 (rewrite from 8 integrated)
4. National Festival Economy — 4
5. International Cheese Crisis — 4
6. Palace Renovation Scandal — 4

---

## Arc 1: Comrade Whiskers — The Cat Revolution

```text
Arc ID: whiskers_cat_revolution
Planning ID: arc_whiskers_cat_revolution
Title: The Cat Revolution
Arc type: advisor
Primary advisor: comrade_whiskers
Secondary advisors: auntie_olga, clerk_zero
Primary category: cats_and_animals
Primary stage range: establishment → escalation
Core fantasy: Whiskers transforms a reasonable cat-policy demand into a serious political movement — constitutional dignity, dominance, or compromise — without cats being automatically morally correct.
Setup: Civic demand (cushion charter / fish reserve access) framed as treaty negotiation, not voting rights retread.
Escalation: Movement grows; naps interrupt ministries; public splits between affection and chaos.
Player conflict: Constitutional recognition vs revolutionary cat dominance vs compromise/rejection.
Branch A: constitutional_path — peaceful charter; costly Order/Treasury; populist seal.
Branch B: dominance_path — cats seize symbolic power; purrfect_transfer / cat_republic pressure.
Branch C: compromise_reject — boxes truce or abandon; Whiskers hostility variant.
Resolution A: whiskers_charter_seal — positive/ambiguous costly seal.
Resolution B: whiskers_transfer — purrfect_transfer ending.
Resolution C: whiskers_boxes_truce — quiet compromise; affinity hit possible.
Failure/abandonment: Refuse demand early → abandon; Whiskers affinity −.
Possible endings: purrfect_transfer, whiskers_boxes_truce (seal flag); soft cat_republic feed via cats_control_parliament only on dominance
Required laws: cat_cushion_charter (new); interact fish_emergency_reserve / mouse_protection_law
Required flags: whiskers_rev_live, whiskers_constitutional, whiskers_dominance, whiskers_compromise, whiskers_rev_complete
Blocked arcs/flags: exclusive_groups cat_governance_arc vs cat_politics
Affinity interactions: Whiskers + on respect; − on hose/reject; Olga + on compromise; Clerk − on dominance chaos
Trait interactions: populist, chaotic, cat-friendly counters
Crisis interaction: may start cat_parliament_occupation on dominance overreach
Visual hooks: cats_in_square, fish_treaty, cushion_charter_plaza, revolutionary_nap_banner
Card count: 4
Reachability risks: Mutex with cat_politics; all three forks force to shared resolution with path flags
Repeated-joke risks: No voting-rights-as-setup; no automatic moral cats; distinct from fish_currency short chain
How branching works in 4 cards: setup seeds path flags; escalation references choice; 3-opt fork locks mutex branch; resolution options gated by path flags via narrative + any_flags + distinct ending outcomes
```

### Card graph (4)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `whiskers_political_demand` | setup / starts_arc | 3-opt; refuse abandons |
| 2 | `whiskers_movement_escalation` | escalation | soft delayed; references path |
| 3 | `whiskers_path_fork` | climax | 3-opt constitutional / dominance / compromise |
| 4 | `whiskers_revolution_resolution` | resolution | state-dependent endings/seals |

Debug: Force demand → escalation → fork → resolution. Test mutex vs cat_faction_proposal.

---

## Arc 2: Clerk Zero — The Government of Forms

```text
Arc ID: zero_government_of_forms
Planning ID: arc_zero_government_of_forms
Title: The Government of Forms
Arc type: advisor
Primary advisor: clerk_zero
Secondary advisors: minister_penny, auntie_olga, doctor_maybe
Primary category: bureaucracy
Primary stage range: establishment → endgame window
Core fantasy: Genuine admin reform makes bureaucracy useful, then powerful, then possibly sovereign — efficiency, form-rule, or simplification rebellion.
Setup: Backlog crisis — genuine administrative problem (not Form-to-Request-Forms retread).
Escalation: Reform works; ministries demand more stamps; public services improve then ossify.
Player conflict: Useful efficiency vs bureaucracy controls government vs simplification/rebellion.
Branch A: efficiency_path — Order/Treasury gains; bureaucratic identity.
Branch B: form_sovereignty — government_by_form / final_stamp.
Branch C: simplify_rebel — clerk_zero_closes_file or public rebellion; Olga +.
Resolution A: zero_efficiency_seal — positive costly seal.
Resolution B: zero_form_rule — government_by_form or final_stamp.
Resolution C: zero_simplify — clerk_zero_closes_file / recovery.
Failure/abandonment: Refuse reform → abandon; Clerk affinity −.
Possible endings: government_by_form (reuse+strengthen), final_stamp (new), clerk_zero_closes_file (new)
Required laws: administrative_reform_act, form_sovereignty_act; interact form_request_form_act / triple_stamp_requirement
Required flags: zero_forms_live, zero_efficiency, zero_sovereignty, zero_simplify, zero_forms_complete
Blocked arcs/flags: soft distinct from fake_election_accident (no accidental democracy)
Affinity interactions: Clerk + on reform/efficiency; − on burn-forms; Penny + on efficiency; Olga + on simplify
Trait interactions: bureaucratic; authoritarian on sovereignty; populist on simplify
Crisis interaction: optional mass_protest on burn-forms overreach
Visual hooks: ministry_of_forms, numbered_queues, sovereignty_stamp_tower, empty_filing_room
Card count: 4
Reachability risks: Must not require short-chain completion; strengthen government_by_form flags
Repeated-joke risks: No Form F-0 origin story retread; Kafka-lite not form-pun spam
```

### Card graph (4)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `zero_admin_reform` | setup / starts_arc | 3-opt |
| 2 | `zero_bureaucracy_expand` | escalation | soft delayed |
| 3 | `zero_control_fork` | climax | efficiency / sovereignty / simplify |
| 4 | `zero_forms_resolution` | resolution | endings + seals |

---

## Arc 3: Cat Politics

```text
Arc ID: cat_politics
Planning ID: arc_cat_politics
Title: Cat Politics
Arc type: national
Primary advisor: minister_penny
Secondary advisors: auntie_olga, sir_profit, luna_news, general_boom
Primary category: cats_and_animals
Primary stage range: establishment
Core fantasy: Human and cat factions compete over representation, rights, cynical political use of cats, and public backlash — serious resource stakes under absurd premise.
Setup: Representation proposal (tax/fur contribution → seats) — Penny ledger framing, not Whiskers treaty.
Escalation: Factions form — rights lobby, Profit lobby-as-mascot, Olga neighborhood backlash.
Player conflict: Rights-based path vs cynical political-use vs backlash/compromise.
Branch A: rights_path — cat_voting_rights; fish budget stakes; cat_republic possible.
Branch B: cynical_use — Profit/Luna spin cats as brand; elite loyalty; public cynicism.
Branch C: backlash_compromise — ban or boxes compromise; Boom/Olga.
Resolution A: cat_republic path (reuse ending with cats_control_parliament).
Resolution B: cynical_seal — cats as lobby only; ambiguous.
Resolution C: ban/boxes seal — Order recovery; Happiness hit.
Failure/abandonment: Early reject without negotiation → abandon.
Possible endings: cat_republic; soft ban/compromise seals (not Whiskers purrfect_transfer)
Required laws: cat_voting_rights (keep), cat_lobby_registry (new), fish_emergency_reserve (interact)
Required flags: cat_pol_live, cat_rights_path, cat_cynical_path, cat_backlash_path, cat_pol_complete
Blocked arcs: cat_governance_arc vs whiskers; government_replacement_arc vs robot_government
Affinity interactions: Penny/Profit/Olga/Boom variants; Whiskers not primary speaker
Trait interactions: populist, capitalist (cynical), authoritarian (ban)
Crisis interaction: cat_parliament_occupation on rights overreach
Visual hooks: cats_in_square, fish_treaty, lobby_cushion_booth, lint_roller_squad
Card count: 4
Reuse: best beats from 8-card graph (voting stake, fish budget, ban, boxes, republic)
Reject/retire decision IDs: cat_voting_rights (decision), cat_protest, cat_limited_council, cat_party_enters_parliament, cat_politics_fish_budget, cat_republic_declared, cat_party_banned, cats_return_to_boxes
Keep law ID: cat_voting_rights
```

### Card graph (4)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `cat_faction_proposal` | setup / starts_arc | replaces cat_voting_rights decision |
| 2 | `cat_faction_escalation` | escalation | factions solidify |
| 3 | `cat_political_fork` | climax | 3-opt rights / cynical / backlash |
| 4 | `cat_politics_resolution` | resolution | republic / seal / ban |

---

## Arc 4: National Festival Economy

```text
Arc ID: national_festival_economy
Planning ID: arc_national_festival_economy
Title: National Festival Economy
Arc type: national
Primary advisor: luna_news
Secondary advisors: sir_profit, auntie_olga, minister_penny
Primary category: public_life
Primary stage range: escalation
Core fantasy: Stimulus-through-spectacle — tourism success, permanent unsustainable festival, or cancel/reform/citizen-led path.
Setup: Plausible economic stimulus (festival weekends to fill empty plazas / boost vendors).
Escalation: Tourism works; Profit wants permanent; Olga notes sleep and stampede risk.
Player conflict: Sustainable tourism vs eternal festival vs cancel/reform.
Branch A: tourism_success — Treasury/Happiness balance; populist/capitalist soft.
Branch B: permanent_festival — eternal_national_festival; stampede crisis.
Branch C: cancel_reform — beloved_retirement or citizen calendar reform.
Resolution A: festival_tourism_seal — positive costly.
Resolution B: eternal festival ending.
Resolution C: beloved_retirement or reform seal.
Failure/abandonment: Refuse stimulus → abandon.
Possible endings: eternal_national_festival, beloved_retirement
Required laws: festival_stimulus_act, permanent_festival_act, three_day_weekend
Required flags: festival_econ_live, festival_tourism, festival_permanent, festival_reform, festival_econ_complete
Blocked arcs/flags: soft avoid while dog_apology_festival live joke collision
Affinity interactions: Luna + on spectacle; Profit + on permanent; Olga + on reform; Penny − on permanent spend
Trait interactions: populist, chaotic, capitalist, propagandist
Crisis interaction: national_festival_stampede (new)
Visual hooks: birthday_banners, festival_vendor_row, stampede_plaza, quiet_calendar_reform
Card count: 4
```

### Card graph (4)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `festival_stimulus_proposal` | setup / starts_arc | 3-opt |
| 2 | `festival_economy_boom` | escalation | soft delayed success |
| 3 | `festival_sustainability_fork` | climax | tourism / permanent / reform; may start stampede |
| 4 | `festival_economy_resolution` | resolution | endings |

---

## Arc 5: International Cheese Crisis

```text
Arc ID: international_cheese_crisis
Planning ID: arc_international_cheese_crisis
Title: International Cheese Crisis
Arc type: national
Primary advisor: foreign_ambassador (guest)
Secondary advisors: minister_penny, palace_chef (guest), sir_profit
Primary category: economy
Primary stage range: escalation
Core fantasy: Comprehensible trade/ceremonial cheese incident becomes diplomacy, domestic substitute science, or national-pride escalation — not puns alone.
Setup: Tinyria notes ceremonial cheese shortfall / trade disagreement after pizza policy or pantry shortage.
Escalation: National response — buy, substitute, or pride embargo.
Player conflict: Diplomatic settlement vs domestic substitute vs pride escalation.
Branch A: diplomatic_path — great_cheese_settlement.
Branch B: substitute_path — cheese_substitute_act; Doctor Maybe optional; Treasury hit.
Branch C: pride_path — embargo; elite loyalty; may start cheese_shortage_crisis modifier.
Resolution A: settlement ending.
Resolution B: substitute seal (ambiguous positive).
Resolution C: pride seal or costly embargo.
Failure/abandonment: Ignore note → abandon; Ambassador cool.
Possible endings: great_cheese_settlement (new); cheese_pride_embargo soft seal
Required laws: emergency_cheese_bonds, cheese_substitute_act; interact free_pizza_friday
Required flags: cheese_arc_live, cheese_diplomacy, cheese_substitute, cheese_pride, cheese_arc_complete
Blocked arcs/flags: do not replace cheese_shortage follow-up; arc owns diplomacy story
Affinity interactions: Penny/Profit/Chef; Ambassador guest no affinity meter
Trait interactions: bureaucratic (diplomacy), scientific (substitute), propagandist (pride)
Crisis interaction: start cheese_shortage_crisis on pride/shortage path (modifier)
Visual hooks: embassy_queue_protest, cheese_bond_banner, lab_cheese_tray, embargo_stamp
Card count: 4
```

### Card graph (4)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `cheese_diplomatic_incident` | setup / starts_arc | guest ambassador |
| 2 | `cheese_national_response` | escalation | Penny/Chef |
| 3 | `cheese_path_fork` | climax | diplomacy / substitute / pride |
| 4 | `cheese_crisis_resolution` | resolution | settlement / seals |

---

## Arc 6: Palace Renovation Scandal

```text
Arc ID: palace_renovation_scandal
Planning ID: arc_palace_renovation_scandal
Title: Palace Renovation Scandal
Arc type: national
Primary advisor: sir_profit
Secondary advisors: minister_penny, auntie_olga, clerk_zero, palace_chef
Primary category: public_life
Primary stage range: escalation → endgame
Core fantasy: Legitimate renovation need becomes modest practical upgrade, luxurious corruption, or public-use transparency — expensive options not automatically wrong.
Setup: Roof leak / structural need (reuse palace_leaks visual; not gift-shop retread).
Escalation: Costs rise; Profit offers subscription plan; Clerk finds invoice delay; Chef notes kitchen closed.
Player conflict: Modest practical vs luxury corruption vs public transparency tours.
Branch A: modest_path — costly Treasury; Order/Happiness modest gains; positive seal.
Branch B: luxury_path — palace_beautiful_empty; elite loyalty; delayed discovery invoice.
Branch C: transparency_path — renovation_reveals_truth; Olga +; public tours.
Resolution A: modest_seal — palace works; meta soft (upgrade adjacency).
Resolution B: beautiful empty ending.
Resolution C: reveals truth ending.
Failure/abandonment: Refuse renovation → leak continues; abandon.
Possible endings: palace_beautiful_empty, renovation_reveals_truth
Required laws: palace_subscription_plan, palace_public_tour_act
Required flags: palace_reno_live, palace_modest, palace_luxury, palace_transparent, palace_invoice_found, palace_reno_complete
Blocked arcs/flags: distinct from palace_gift_shop short chain
Affinity interactions: Profit + luxury; Penny + modest; Olga + transparency; Clerk + audits; Chef kitchen dignity
Trait interactions: capitalist, bureaucratic, populist
Crisis interaction: optional mass_protest if luxury exposed without transparency
Visual hooks: palace_leaks, gold_scaffolding, hollow_ballroom, public_tour_rope
Card count: 4
Palace/meta hooks: delayed invoice discovery; soft flags for gift-shop/upgrade adjacency (palace_gift_shop_soft / gold_desk_soft) without requiring meta purchase
```

### Card graph (4)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `palace_renovation_proposal` | setup / starts_arc | 3-opt |
| 2 | `palace_cost_escalation` | escalation | soft + delayed discovery follow-up flag |
| 3 | `palace_scandal_fork` | climax | modest / luxury / transparency |
| 4 | `palace_renovation_resolution` | resolution | endings; invoice variants |

---

## Pack-wide mechanical quotas

| Quota | Target | Plan coverage |
|-------|--------|---------------|
| Main advisors primary/secondary | all 8 | Whiskers, Clerk, Penny, Olga, Profit, Luna, Boom (cat ban), Maybe (forms/cheese soft) |
| Guests | ambassador, chef, (+ judge unused) | Cheese + Palace |
| Affinity changes | ≥8 | every arc |
| Trait changes | ≥8 | every arc |
| Laws interacted | ≥10 | new + existing |
| Delayed events | ≥6 | soft follow-ups across arcs |
| Follow-up types | hard + soft + pool | force_next / soft delay / festival_noise_pool etc. |
| 3-option decisions | ≥6 | all setups + all forks |
| State-dependent variants | ≥8 | resolution path flags |
| Crises/modifiers | ≥3 | cat occupation, festival stampede, cheese shortage |
| Ending connections | ≥10 | listed above |
| Mutex branches | ≥6 | three per several arcs |
| Positive/ambiguous | ≥3 | charter, efficiency, tourism, modest reno, substitute |
| Loyalty/hostility variants | ≥3 | Whiskers/Clerk/Olga/Profit |
| Endgame-resolution | ≥3 | forms, palace, festival permanent |
| Palace/meta hooks | ≥2 | palace reno invoice + soft upgrade flags |

---

## Retired / deferred

| Item | Disposition |
|------|-------------|
| Cat Politics 8-card IDs | Retire from major-arc runtime |
| Catalog 5–6 card Pack D targets | Reconciled to 4 |
| Full 2B-14 crisis pack | Deferred |
| nation_in_darkness cheese combo | Deferred (not forced) |
| supreme_cat_servant | Ruler trait identity, not ending |
