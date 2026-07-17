# Milestone 2B-12 — Major-Arc Pack C Briefs

**Status:** Approved — runtime JSON shipped  
**Pack target:** 24 approved major-arc decisions (exactly 6 per arc × 4 arcs)  
**Do not start:** Milestone 2B-13  

Card lock:
1. Doctor Maybe — The Experimental Republic — 6
2. Sir Profit — The Corporate State — 6
3. AI Government — 6
4. Sell the Moon — 6

---

## Arc 1: Doctor Maybe — The Experimental Republic

```text
Arc ID: doctor_maybe_arc
Planning ID: arc_maybe_experimental_republic
Title: The Experimental Republic
Arc type: advisor
Primary advisor: doctor_maybe
Secondary advisors: clerk_zero, minister_penny
Primary category: science_and_technology
Primary stage range: establishment → escalation (may extend early instability)
Core fantasy: Policy becomes a national laboratory — useful trials scale into dependence, with progress, recklessness, or ethical limits as real choices (not random explosions).
Setup: Useful, plausible trial (predictive queue / street-lighting pilot) after science_gamble funds phase one — NOT moon dust.
Escalation: National trial shows measurable benefit; ministries request more experiments; public/gov dependence grows.
Player conflict: Fund scientific progress vs uncontrolled expansion vs impose ethical/practical limits.
Branch A: controlled_progress — costly but genuine gains; scientific_golden_age soft path.
Branch B: reckless_republic — experiments run the state; experimental_republic ending.
Branch C: ethical_limits — Clerk/Penny oversight; containment or experiment_leaves if over-corrected.
Resolution A: maybe_progress_resolution — positive costly; arc complete; golden-age seed flags.
Resolution B: maybe_republic_resolution — experimental_republic ending.
Resolution C / Failure: maybe_limits_resolution — experiment_leaves or quiet containment abandon.
Failure/abandonment: Deny mid-arc / hard freeze funding → abandon with affinity hit; recovery via science permit soft flag.
Possible endings: experimental_republic, experiment_leaves (+ soft scientific_golden_age via flags, not artificial_sun short-chain hard dep)
Required laws: scientific_experiment_permit (interact), national_trial_oversight_act (new)
Required flags: maybe_arc_live, maybe_progress_path, maybe_reckless_path, maybe_limits_path, maybe_arc_complete
Blocked arcs/flags: soft blocked vs sell_the_moon live (no moon ownership fantasy); do not set moon_replacement_pending
Affinity interactions: Maybe + on fund/progress; − on hard limits; Clerk + on oversight; Penny − on reckless spend
Trait interactions: scientific, chaotic (reckless), bureaucratic on limits
Crisis interaction: lab trial spillover → mass_protest on reckless overreach
Visual hooks: lab_sparks, national_trial_banner, oversight_clipboard_plaza, glowing_but_stable_capital
Card count: 6
Reachability risks: science_gamble must soft-queue beat 1; all three forks force to resolution; no moon ending from this arc
Repeated-joke risks: No sentient-lab-as-default; no moon dust; distinct from artificial_sun / clone short chains
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `maybe_useful_trial` | setup continuation | replaces moon_dust; soft from science_gamble |
| 2 | `maybe_national_trial` | escalation | soft delayed national scale |
| 3 | `maybe_experiment_dependence` | escalation | ministries depend on trials |
| 4 | `maybe_ethics_fork` | climax | 3-opt: progress / reckless / limits |
| 5 | `maybe_major_consequence` | consequence/crisis | path-specific; mass_protest on reckless |
| 6 | `maybe_experimental_resolution` | resolution | state-dependent endings |

Debug: Force `science_gamble` → `maybe_useful_trial` → national → dependence → ethics fork → consequence → resolution.

Reuse: keep `doctor_maybe_arc`, entry `science_gamble`. Reject/rewrite: `maybe_moon_dust_trial`, `maybe_lab_runaway`, `maybe_golden_age`, `maybe_containment_protocol`.

---

## Arc 2: Sir Profit — The Corporate State

```text
Arc ID: profit_corporate_state
Planning ID: arc_profit_corporate_state
Title: The Corporate State
Arc type: advisor
Primary advisor: sir_profit
Secondary advisors: minister_penny, luna_news, auntie_olga
Primary category: business_and_privatization
Primary stage range: escalation → early endgame window
Core fantasy: Attractive public-private deals gradually turn institutions and symbols into commercial assets — with partnership, full corporate-state, or nationalization as real paths (not automatic corruption).
Setup: Financially attractive ministry partnership (short-term Treasury + Elite wins).
Escalation: Commercialization works; Profit expands into public institutions / naming rights.
Player conflict: Controlled PPP vs full subsidiary state vs public rejection / nationalize.
Branch A: controlled_ppp — real benefits, capped ownership; soft corporate identity.
Branch B: corporate_state — Country Is Acquired / Corporate Ministan path.
Branch C: nationalize_reject — Olga/public backlash; Profit hostility; recovery costly.
Resolution A: profit_ppp_resolution — successful costly partnership seal.
Resolution B: profit_acquisition_resolution — corporate_ministan and/or country_is_acquired.
Resolution C: profit_nationalize_resolution — profit_buys_retirement or public reclaim; affinity hostility variant.
Failure/abandonment: Cancel early deal → abandon; soft recovery via treasury patch card flags.
Possible endings: corporate_ministan (reuse + strengthen setup), country_is_acquired (new), profit_buys_retirement (new)
Required laws: privatize_air, rent_a_ministry, corporate_capital_naming (new)
Required flags: profit_corp_live, profit_ppp_path, profit_full_path, profit_nationalize_path, profit_corp_complete
Blocked arcs: soft blocked_flags vs economy_collapse live when active
Affinity interactions: Profit + on deals; − on nationalize; Penny + on PPP; Olga − on full corporate; Luna spins branding
Trait interactions: capitalist, populist (reject), bureaucratic (PPP)
Crisis interaction: ownership backlash → mass_protest on nationalize/full overreach
Visual hooks: branded_ministry_awning, lease_stamp_plaza, subsidiary_flag_swap, reclaimed_signage
Card count: 6
Reachability risks: Entry weight needs establishment+; all three resolutions reachable; do not require corporate_benches_empire
Repeated-joke risks: Not bench paywalls / garden privatization retread; avoid “every deal is scam”
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `profit_partnership_brief` | setup / starts_arc | 3-opt |
| 2 | `profit_commercial_success` | escalation | soft delayed |
| 3 | `profit_institution_lease` | escalation | public institutions |
| 4 | `profit_ownership_fork` | climax | 3-opt PPP / full / nationalize |
| 5 | `profit_identity_crisis` | consequence/crisis | mass_protest possible |
| 6 | `profit_corporate_resolution` | resolution | state-dependent |

Debug: Force partnership → commercial → lease → fork → identity → resolution.

---

## Arc 3: AI Government

```text
Arc ID: robot_government
Planning ID: arc_ai_government
Title: AI Government
Arc type: national
Primary advisor: doctor_maybe (pilot) / clerk_zero (process)
Secondary advisors: luna_news, minister_penny
Primary category: science_and_technology
Primary stage range: escalation → endgame
Core fantasy: Limited admin AI improves efficiency, then becomes indispensable, supervised, shut down, or politically powerful — useful automation ≠ cartoon evil robot.
Setup: Narrow pilot (queue routing / form triage), not cabinet coup.
Escalation: Pilot succeeds; expanded authority request; human-vs-system conflict.
Player conflict: Human-supervised efficiency vs AI political control vs shutdown/rejection.
Branch A: supervised_efficiency — Order/services up; Elite wary; stable technocracy soft.
Branch B: ai_control — AI accepts resignation / technocratic identity pressure.
Branch C: shutdown_reject — restore human clerks; short-term chaos then recovery.
Resolution A: ai_supervised_resolution — positive costly; robot_civil_service retained with oversight.
Resolution B: ai_control_resolution — ai_accepts_resignation ending.
Resolution C: ai_shutdown_resolution — arc complete; recovery flags.
Failure/abandonment: Refuse pilot → never start; mid-arc kill switch abandons with Order hit.
Possible endings: ai_accepts_resignation (new); soft technocratic identity via traits
Required laws: ai_cabinet_pilot (new), robot_civil_service (interact)
Required flags: ai_gov_live, ai_supervised_path, ai_control_path, ai_shutdown_path, ai_gov_complete
Blocked arcs: exclusive_groups government_replacement_arc (vs cat_politics); soft blocked vs maybe_reckless_path
Affinity interactions: Maybe + on expand; Clerk + on supervised / − on opaque AI; Penny + on efficiency
Trait interactions: scientific, bureaucratic; chaotic on uncontrolled; authoritarian soft on control
Crisis interaction: crisis_ai_cabinet_lockout on control path; mass_protest on shutdown panic
Visual hooks: toaster_filing_cabinets, robot_queue_kiosk, blank_terminal_cabinet, human_stamp_override
Card count: 6
Reachability risks: Remove debug_only; promote importance major; ensure cat mutex still works
Repeated-joke risks: No “robots hate humans”; distinct from robot_queue short chain and Maybe lab fantasy
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `ai_admin_pilot` | setup / starts_arc | replaces robot_cabinet_proposal |
| 2 | `ai_admin_success` | escalation | soft delayed |
| 3 | `ai_authority_expand` | escalation | expanded authority |
| 4 | `ai_human_system_fork` | climax | 3-opt supervised / control / shutdown |
| 5 | `ai_cabinet_crisis` | crisis | lockout or shutdown panic |
| 6 | `ai_government_resolution` | resolution | state-dependent |

Debug: Force ai_admin_pilot → success → expand → fork → crisis → resolution.

Disposition: remove old robot cards from cat_politics; new file ministan_ai_government_arc.json.

---

## Arc 4: Sell the Moon

```text
Arc ID: sell_the_moon
Planning ID: arc_sell_the_moon
Title: Sell the Moon
Arc type: national
Primary advisor: sir_profit
Secondary advisors: doctor_maybe, luna_news, foreign_ambassador (guest), chief_judge (guest legal beat)
Primary category: business_and_privatization
Primary stage range: escalation
Core fantasy: Monetize / claim / research the Moon for budget or prestige — commercial success, diplomatic dispute, or public-science paths — absurd but internally logical law, no real rocketry required.
Setup: Believable Treasury/prestige pitch (deed, naming rights, or “lunar reserve asset”).
Escalation: Ownership campaign; fork sale vs research vs diplomacy.
Player conflict: Cash now vs science prestige vs international legitimacy.
Branch A: commercial_sale — moon_new_owner / treasury win with elite loyalty.
Branch B: science_public — moon_replacement_research; soft accidental_moon_replacement if research overreaches.
Branch C: diplomatic_claim — dispute crisis; settlement or humiliation.
Resolution A: moon_sale_resolution — moon_new_owner.
Resolution B: moon_science_resolution — accidental_moon_replacement or research seal.
Resolution C: moon_diplomacy_resolution — dispute resolved; arc complete.
Failure/abandonment: Drop claim early → abandon; recovery via shared lunar observation soft flag.
Possible endings: moon_new_owner (new), accidental_moon_replacement (reuse; conditions owned here)
Required laws: moon_replacement_research (new)
Required flags: moon_arc_live, moon_sale_path, moon_science_path, moon_diplomacy_path, moon_arc_complete, moon_replacement_pending (science overreach only)
Blocked arcs: soft blocked vs maybe_reckless_path
Affinity interactions: Profit + on sale; Maybe + on research; Luna + on propaganda claim
Trait interactions: capitalist, scientific, chaotic (overreach), propagandist
Crisis interaction: crisis_moon_ownership_dispute
Visual hooks: lunar_deed_banner, embassy_queue_protest, fake_telescope_plaza, deed_stamp_moon
Card count: 6
Reachability risks: Ending flags only from this arc; legal argument beat must be funny + clear in 5s
Repeated-joke risks: Not Maybe water-glow moon dust; not generic space invaders
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `moon_budget_proposal` | setup / starts_arc | 3-opt |
| 2 | `moon_ownership_campaign` | escalation | legal deed / Luna spin |
| 3 | `moon_path_fork` | climax | 3-opt sale / research / diplomacy |
| 4 | `moon_international_reaction` | escalation | soft delay; ambassador |
| 5 | `moon_crisis_opportunity` | crisis/opportunity | moon ownership dispute |
| 6 | `moon_arc_resolution` | resolution | state-dependent |

Debug: Force moon_budget_proposal → ownership → fork → international → crisis → resolution.

---

## Pack-wide mechanical plan

| Requirement | Plan |
|-------------|------|
| ≥7 speakers | Maybe, Profit, Clerk, Luna, Penny, Olga, foreign_ambassador, chief_judge |
| ≥8 affinity changes | Across all four arcs (≥2 per arc) |
| ≥8 trait changes | scientific, chaotic, capitalist, bureaucratic, propagandist, populist, authoritarian |
| ≥8 laws | scientific_experiment_permit, national_trial_oversight_act, privatize_air, rent_a_ministry, corporate_capital_naming, ai_cabinet_pilot, robot_civil_service, moon_replacement_research |
| ≥6 delayed events | soft on Maybe national, Profit commercial, AI success, Moon international; ≥1 pool |
| hard/soft/pooled | hard on climaxes; soft on escalations; pools corporate_side_effects, moon_noise_pool |
| ≥6 three-option | setup/climax on each arc |
| ≥6 state-dependent | path flags + affinity on consequence/resolution cards |
| ≥3 crises | Maybe mass_protest; AI lockout; Moon dispute; Profit protest |
| ≥6 endings | experimental_republic, experiment_leaves, corporate_ministan, country_is_acquired, profit_buys_retirement, ai_accepts_resignation, moon_new_owner, accidental_moon_replacement |
| ≥4 mutex branches | progress/reckless/limits; ppp/full/nationalize; supervised/control/shutdown; sale/science/diplomacy |
| ≥3 successful costly | progress, PPP, supervised AI, science moon |
| ≥3 loyalty/hostility | Maybe/Profit/Clerk affinity gates |
| ≥2 recovery | nationalize recovery; AI shutdown recovery |
| ≥2 palace/meta | corporate naming; lunar deed gift-shop soft flags |

## Quota after pack

- Major-arc decisions approved: 72 / 96 (gap 24)
- Major arcs approved: 12 / 18 (gap 6)
- Pack D remains 24
- Global target unchanged: 96
- Do not start Milestone 2B-13
