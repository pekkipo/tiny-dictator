# Milestone 2B-10 — Major-Arc Pack A Briefs

**Status:** Approved for JSON authoring  
**Pack target:** 24 approved major-arc decisions (21 core + 3 supporting)  
**Do not start:** Milestone 2B-11  

Supporting allocations:
1. Boom `boom_ceremonial_mascot` — third resolution (humiliating, non-fatal)
2. Penny `penny_service_sunset` — earned unlivable-austerity beat + third resolution support
3. Traffic `traffic_checkpoint_hour` — civilian↔authoritarian escalation + crisis modifier

---

## Arc 1: General Boom — The General’s Rise

```text
Arc ID: general_boom_arc
Planning ID: arc_general_boom_rise
Title: The General's Rise
Arc type: advisor
Primary advisor: general_boom
Secondary advisors: luna_news, auntie_olga
Primary category: military_and_order
Primary stage range: establishment → escalation (entry may extend to early instability)
Core fantasy: General Boom converts ceremonial popularity and military authority into political power, while loyalty and ambition remain distinguishable.
Setup: Plausible public-order / ceremonial parade proposal (rewrite military_parade). Not automatically evil.
Escalation: Parade budget and army logistics (army_snack_budget, parade_budget_boost) raise Boom's profile and affinity stakes.
Player conflict: Keep Boom as loyal protector vs restrain ambition vs divert him into harmless ceremony.
Branch A: empower_boom — grant authority; loyalty path toward boom_loyal_protector.
Branch B: restrain_boom — deny emergency powers; coup tension toward boom_failed_coup / ending.
Optional Branch C: mascot_path — divert Boom into ceremonial mascot role (supporting card boom_ceremonial_mascot).
Resolution A: boom_loyal_protector — Boom remains loyal; Order/Elite up; authoritarian + parade traits; arc complete.
Resolution B: boom_failed_coup — coup attempt fails or succeeds into general_boom_coup ending.
Resolution C: boom_ceremonial_mascot — humiliating non-fatal; Boom as parade mascot; general_becomes_mascot ending seed.
Failure/abandonment: Early cancel parade / demote Boom via abandon arc_action; no mandatory unresolved state.
Possible ending: general_boom_coup, general_remains_loyal (flag/seed), general_becomes_mascot
Required laws: emergency_martial_law (empower), mandatory_marching (new or reuse salute/parade), emergency_salute_law / border_parade_act interactions
Required flags: boom_arc_active markers, boom_emergency_powers, boom_restrained, boom_mascot_mode, boom_loyal_sworn
Blocked arcs: none hard; soft avoid concurrent traffic_military_control authoritarian climax if both demand exclusive martial law (prefer soft blocked_flags)
Affinity interactions: Boom +/− on grant/deny; Olga − on martial; Luna on parade spectacle; hostile Boom affinity ≤−3 can weight coup path
Trait interactions: authoritarian, propagandist (parade), populist on restrain
Crisis interaction: optional Order crisis modifier if empower + low Happiness; not required for completion
Visual hooks: parade_columns, emergency_powers_banner, mascot_boom_float, loyal_salute_plaza
Card count: 7 (6 rewrite + 1 supporting mascot)
Reachability risks: boom_loyal_protector never-selected in prior sims — force_next / branch gates must be explicit; mascot path needs distinct branch_id
Repeated-joke risks: Do not reuse Pack C tank parking / traffic flags premises; keep parade/ceremony frame
```

### Card graph (7)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `military_parade` | setup / starts_arc | 3-opt: march (empower), cancel (abandon/restrain seed), limited drill |
| 2 | `army_snack_budget` | escalation | empower mid; logistics vs glory |
| 2b | `parade_budget_boost` | escalation | soft/hard mid; affinity-sensitive |
| 3 | `boom_emergency_powers_demand` | climax | 3-opt: grant → loyal; deny → coup; divert → mascot (supporting link) |
| 4a | `boom_loyal_protector` | resolution | empower |
| 4b | `boom_failed_coup` | resolution | restrain; ending option |
| 4c | `boom_ceremonial_mascot` | resolution (supporting) | mascot_path |

Debug: Force `military_parade` → choose branch → Force climax → Force resolution.

---

## Arc 2: Minister Penny — The Austerity Miracle

```text
Arc ID: penny_austerity_arc
Planning ID: arc_penny_austerity
Title: The Austerity Miracle
Arc type: advisor
Primary advisor: minister_penny
Secondary advisors: sir_profit, auntie_olga
Primary category: economy
Primary stage range: establishment → early escalation
Core fantasy: Penny rescues Ministan through increasingly extreme efficiency; short-term treasury wins vs long-term social cost; one path is genuinely successful.
Setup: Believable Treasury shortfall / deficit scare (penny_deficit_briefing).
Escalation: Stacked cuts to services; soft delayed happiness backlash; optional Profit “optimize further.”
Player conflict: Disciplined balanced cuts vs cut-until-empty vs compromise that slows recovery.
Branch A: disciplined_ledger — genuine successful austerity toward penny_balances_final_budget.
Branch B: cut_until_empty — budget healthy, country unlivable → penny_service_sunset → austerity_without_citizens / spreadsheet_state.
Optional Branch C: compromise_cuts — softer middle; may abandon or recover without ending.
Resolution A: penny_miracle_balanced — successful disciplined path; rare positive; ending penny_balances_final_budget optional.
Resolution B: penny_spreadsheet_state — ledger becomes religion; ending spreadsheet_state.
Resolution C: austerity_without_citizens path via sunset beat — services gone, books perfect.
Failure/abandonment: Repeal cuts / spend stimulus → abandon arc; recovery flag penny_austerity_recovery_available.
Possible ending: penny_balances_final_budget, spreadsheet_state, austerity_without_citizens
Required laws: emergency_efficiency_act (new), public_service_sunset_act (supporting), interact window_tax / coupon_salaries as optional soft gates not hard requirements
Required flags: penny_austerity_live, penny_disciplined, penny_cut_empty, penny_services_sunset, penny_austerity_complete
Blocked arcs: exclusive_groups economy_collapse with hyperinflation_arc (cannot both start while other active)
Affinity interactions: Penny +/−; Profit + on deep cuts; Olga − on service cuts
Trait interactions: bureaucratic, capitalist
Crisis interaction: soft link to budget_meltdown modifier if cut_empty + low Happiness; recovery connection via treasury recovery placeholder flag
Visual hooks: balanced_ledger_glow, empty_clinic_queue, spreadsheet_temple, coupon_salary_overlap_ok
Card count: 6 (5 core + 1 supporting sunset)
Reachability risks: Stage stagger vs Hyperinflation; do not require coupon_salaries law (optional bonus only)
Repeated-joke risks: Distinct from wage_freeze standalone and coupon short chain — focus on service cuts and ledger ideology, not coupon jokes
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `penny_deficit_briefing` | setup / starts_arc | 3-opt: disciplined / deep cuts / delay(abandon soft) |
| 2 | `penny_service_trimming` | escalation | soft follow-up social cost |
| 3 | `penny_ledger_review` | climax | branch fork; 3-opt |
| 3b | `penny_service_sunset` | escalation (supporting) | cut_until_empty only |
| 4a | `penny_miracle_balanced` | resolution | disciplined |
| 4b | `penny_austerity_resolution` | resolution | spreadsheet / empty / repeal |

Debug: Force deficit → trim → ledger → resolution; set affinity Penny ≥2 for miracle weighting.

---

## Arc 3: Traffic and Military Control

```text
Arc ID: traffic_military_control
Planning ID: arc_traffic_military_control
Title: Traffic and Military Control
Arc type: national
Primary advisor: general_boom
Secondary advisors: minister_penny, auntie_olga
Primary category: infrastructure
Primary stage range: establishment → escalation
Core fantasy: Military solutions begin as practical traffic fixes and gradually reshape civilian life.
Setup: Practical capital gridlock proposal (traffic_gridlock_brief) — not flags, not parking lots.
Escalation: Military vehicles on civilian routes → checkpoint hour (supporting) → ceremonial priority lanes.
Player conflict: Civilian compromise vs high-Order authoritarian vs absurdly effective costly system.
Branch A: civilian_compromise — lights/schedules/peace → traffic_system_achieves_peace
Branch B: martial_traffic — checkpoints, Order↑ Happiness↓ → authoritarian resolution
Branch C: absurd_efficiency — works too well at meaningful cost (treasury/elite)
Failure/abandonment: Restore civilian control / scrap military traffic → abandon
Possible ending: traffic_system_achieves_peace (new); rare distinct path to tanks_direct_everything only if martial_traffic + absurd flags (not tank_parking resolution)
Required laws: military_route_priority_act (new), traffic_checkpoint_act (supporting), interact tank_traffic_control only as blocked/exclusive not shared premise
Required flags: traffic_mil_live, traffic_civilian_path, traffic_martial_path, traffic_absurd_path, traffic_checkpoint_hour, traffic_mil_complete
Blocked arcs/flags: blocked_flags traffic_flag_corps_live, tank_parking_live; blocked legacy traffic_lights_off if set; do not start if traffic_military minor active
Affinity interactions: Boom optional boost without requiring general_boom_arc; Olga on civilian path
Trait interactions: authoritarian on martial; bureaucratic on compromise paperwork
Crisis interaction: traffic_gridlock_crisis modifier or soft mass_protest weight when martial + low Happiness
Visual hooks: convoy_crosswalk, checkpoint_umbrellas, ceremonial_priority_lane, peaceful_roundabout
Card count: 6 (5 core + 1 supporting checkpoint)
Reachability risks: Must not depend on Boom arc; Pack C exclusion must be tested
Repeated-joke risks: Distinct from traffic_flags (flag corps) and tank_parking_crisis (lots/gridlock parking)
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `traffic_gridlock_brief` | setup / starts_arc | practical jam; 3-opt |
| 2 | `traffic_military_convoy` | escalation | vehicles on routes |
| 2b | `traffic_checkpoint_hour` | escalation (supporting) | martial/absurd bridge + crisis mod |
| 3 | `traffic_control_climax` | climax | branch lock |
| 4a | `traffic_civilian_peace` | resolution | compromise |
| 4b | `traffic_martial_resolution` | resolution | authoritarian / absurd / ending |

Debug: Force gridlock → convoy → checkpoint → climax → resolution; blocked if Pack C live.

---

## Arc 4: Hyperinflation

```text
Arc ID: hyperinflation_arc
Planning ID: arc_hyperinflation
Title: Hyperinflation
Arc type: national
Primary advisor: minister_penny
Secondary advisors: sir_profit, luna_news, clerk_zero
Primary category: economy
Primary stage range: instability (entry minimum_start_stage instability)
Core fantasy: After currency rapidly loses value, Ministan tries strange solutions; temporary success, barter, recovery, and severe failure all reachable.
Setup: Clear trigger — price spiral after coupon/lottery/debt pressure OR deficit flag (hyperinflation_price_spiral); not coin shortage or fish scrip.
Escalation: Public adaptation (wheelbarrows, menu stickers); several economic responses.
Player conflict: Print/reform vs black-market barter vs freeze/peg experiments.
Branch A: reform_stabilize — temporary success then recovery opportunity
Branch B: barter_black_market — alt currency / barter path
Branch C: print_deeper — apparent boom then severe failure / millionaires absurd success
Resolution A: hyper_strange_success — hyperinflation_millionaires ending
Resolution B: hyper_recovery — recovery content connection; arc complete without ending
Resolution C / Failure: hyper_collapse — bankrupt_leader / budget_meltdown fail
Failure/abandonment: Early hard peg abandon with treasury cost; arc abandon
Possible ending: hyperinflation_millionaires, bankrupt_leader
Required laws: emergency_price_board_act (new), barter_license_act (new); soft interact coupon_salaries / national_lottery_budget as optional entry weight not hard req
Required flags: hyper_live, hyper_temp_success, hyper_barter, hyper_printed, hyper_recovered, hyper_complete
Blocked arcs: exclusive_groups economy_collapse with penny_austerity_arc; blocked_flags fish_currency_live, coin_shortage_live
Affinity interactions: Penny, Profit; Luna reframes disaster
Trait interactions: capitalist, chaotic, bureaucratic
Crisis interaction: can fail into budget_meltdown or amplify existing meltdown; recovery_treasury flag on success path
Visual hooks: price_sticker_walls, wheelbarrow_wages, barter_booth, millionaire_confetti
Card count: 5 (no supporting in this arc)
Reachability risks: Instability stage entry must be reachable in sims; exclusive with Penny austerity
Repeated-joke risks: No fish currency / coin rounding jokes; focus on prices, printing, barter, pegs
```

### Card graph (5)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `hyperinflation_price_spiral` | setup / starts_arc | cause + 3 responses |
| 2 | `hyperinflation_public_adaptation` | escalation | soft delayed |
| 3 | `hyperinflation_policy_fork` | climax | reform / barter / print |
| 4a | `hyperinflation_temp_success` | mid-resolution | apparent win → fork |
| 4b | `hyperinflation_resolution` | resolution | strange success / recovery / collapse |

Debug: Force spiral at instability → adaptation → fork → temp success → resolution.

---

## Pack-wide mechanical plan

| Requirement | Plan |
|-------------|------|
| ≥6 speakers | Boom, Penny, Profit, Olga, Luna, Clerk (+ optional) |
| ≥8 affinity changes | Across Boom/Penny/Traffic/Hyper options |
| ≥8 trait changes | authoritarian, bureaucratic, capitalist, propagandist, populist, chaotic |
| ≥8 laws | martial + marching; efficiency + sunset; route + checkpoint; price board + barter (+ reuse) |
| ≥6 delayed events | soft follow-ups on Boom mid, Penny trim, Traffic checkpoint aftermath, Hyper adaptation, pools |
| hard/soft/pooled | hard on Traffic climax or Hyper fork; soft on several; one pool (e.g. hyper_price_consequences) |
| ≥4 state-dependent | affinity Boom; Penny branch flags; Traffic Pack C blocks; Hyper coupon/lottery optional |
| ≥6 three-option | most climax/setup cards |
| ≥2 crises/modifiers | Traffic gridlock mod; Hyper→budget_meltdown |
| ≥4 endings | general_boom_coup, spreadsheet_state or austerity_without_citizens, traffic_system_achieves_peace, hyperinflation_millionaires (+ loyal/mascot seeds) |
| ≥2 recovery | Penny recovery flag; Hyper recovery path |
| ≥3 mutex branches | empower vs restrain vs mascot; disciplined vs cut_empty; civilian vs martial; reform vs barter vs print |
| ≥2 rare positives | Boom loyal; Penny miracle; Hyper recovery |
| ≥2 loyalty/hostility | Boom affinity variants; Penny/Profit |

## Quota after pack

- Major-arc decisions approved: 24 / 96 (gap 72)
- Major arcs approved: 4 / 18 (gap 14)
- Packs B–D remain 24 each
- Global target unchanged: 96
