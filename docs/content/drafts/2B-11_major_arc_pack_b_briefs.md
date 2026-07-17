# Milestone 2B-11 — Major-Arc Pack B Briefs

**Status:** Approved — runtime JSON shipped  
**Pack target:** 24 approved major-arc decisions (exactly 6 per arc × 4 arcs)  
**Do not start:** Milestone 2B-12  

Card lock:
1. Luna Media Reality — 6
2. Olga Citizen Movement — 6
3. Mandatory Happiness — 6 (rewrite/trim existing 7 + absorb smile cluster)
4. Fake Election Accident — 6

---

## Arc 1: Luna News — The Media Becomes Reality

```text
Arc ID: luna_media_reality
Planning ID: arc_luna_media_reality
Title: The Media Becomes Reality
Arc type: advisor
Primary advisor: luna_news
Secondary advisors: clerk_zero, auntie_olga
Primary category: media_and_propaganda
Primary stage range: establishment → escalation
Core fantasy: Luna News becomes so powerful that government announcements, entertainment, and reality begin to merge — without reducing every choice to truth vs lies.
Setup: Plausible media-management proposal — unify evening bulletin and policy brief so citizens hear one coherent story (luna_narrative_brief). Not smile/applause/weather jokes.
Escalation: First broadcast success raises public confidence while actual services lag (luna_ratings_spike); narrative power expands into scheduled "reality segments" (luna_reality_segments).
Player conflict: Keep Luna as loyal communications advisor vs let her define national reality vs risk credibility collapse when citizens stop believing.
Branch A: loyal_comms — Luna remains advisor; Order/Happiness soft wins; delayed honesty cost manageable.
Branch B: reality_control — Luna effectively scripts the nation; broadcast-state ending path.
Optional Branch C: credibility_collapse — overreach / hostile affinity; citizens stop believing official information.
Resolution A: luna_loyal_anchor — loyal communications path; arc complete; soft endgame seed.
Resolution B: luna_broadcast_state — nation_becomes_broadcast ending option.
Resolution C / Failure: luna_stopped_believing — day_everyone_stopped_believing; crisis_fake_news_panic soft link.
Failure/abandonment: Demote Luna / restore competing headlines → abandon; no mandatory unresolved state.
Possible ending: nation_becomes_broadcast, day_everyone_stopped_believing (optional seed luna_makes_you_immortal only if flagged, not a sixth card)
Required laws: one_headline_policy, ministry_of_memes (soft), national_reality_show (reality_control), emergency_broadcast_priority (crisis beat)
Required flags: luna_media_live, luna_loyal_path, luna_reality_path, luna_credibility_fracture, luna_media_complete
Blocked arcs/flags: soft blocked_flags mandatory_smiling_active, media_declares_total_happiness, eternal_smile_active (Luna ≠ smile cluster); do not require applause/weather/meme chain flags
Affinity interactions: Luna +/− on grant/restrain; Olga − on reality_control; Clerk Zero + on filing-friendly one-headline policy; hostile Luna ≤−2 weights credibility path
Trait interactions: propagandist, populist (loyal spin), authoritarian (reality_control)
Crisis interaction: luna_credibility_test can start or modify crisis_fake_news_panic; crisis communication beat uses emergency_broadcast_priority
Visual hooks: single_headline_banner, ratings_confetti_studio, reality_show_plaza, blank_tv_static_square
Card count: 6
Reachability risks: All three branch resolutions must be force_next / branch gated; avoid step-matching mid-cards; mutex with Happiness climax
Repeated-joke risks: Distinct from applause quotas, weather censorship, talent show, state memes, mandatory smiling
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `luna_narrative_brief` | setup / starts_arc | 3-opt: unify / cautious dual feed / delay(abandon soft) |
| 2 | `luna_ratings_spike` | escalation | soft delayed; confidence vs performance gap |
| 3 | `luna_reality_segments` | escalation | narrative power grows; affinity-sensitive |
| 4 | `luna_media_fork` | climax | 3-opt: loyal / reality_control / open mic (credibility seed) |
| 5 | `luna_credibility_test` | crisis/credibility | soft/hard; crisis_fake_news_panic or modifier |
| 6 | `luna_media_resolution` | resolution | state-dependent: loyal / broadcast / stopped_believing |

Debug: Force `luna_narrative_brief` → ratings → segments → fork → credibility test → resolution.

---

## Arc 2: Auntie Olga — The Citizen Movement

```text
Arc ID: olga_citizen_movement
Planning ID: arc_olga_citizen_movement
Title: The Citizen Movement
Arc type: advisor
Primary advisor: auntie_olga
Secondary advisors: luna_news, general_boom, clerk_zero
Primary category: public_life
Primary stage range: establishment → escalation (may extend early instability)
Core fantasy: Olga’s practical complaints gradually become a popular citizen movement capable of reforming or replacing the government — without treating citizens as uniformly irrational.
Setup: Relatable everyday problem — broken neighborhood bridge / endless bread queue (olga_everyday_complaint).
Escalation: Practical campaign wins a small fix (olga_practical_campaign); movement emerges with petitions and kitchen-table councils (olga_movement_forms).
Player conflict: Cooperate on reform vs hostile crackdown vs invite Olga into formal power she may refuse.
Branch A: cooperative_reform — work with Olga; palace_hears_the_street / peoples cabinet path.
Branch B: hostile_protest — Boom/Order response; mass_protest soft; removal risk.
Optional Branch C: reject_power — Olga refuses formal office; sends ruler home or settles as street voice.
Resolution A: olga_peoples_resolution — cabinet / street heard positive or ambiguous.
Resolution B: olga_confrontation_resolution — protest / removal / compromise under pressure.
Resolution C: olga_rejects_power — peaceful; Olga stays citizen; olga_sends_you_home ending option.
Failure/abandonment: Ignore complaint permanently / bribe silence → abandon with Happiness cost; recovery via soft reform flag.
Possible ending: olga_peoples_cabinet, palace_hears_the_street, olga_sends_you_home
Required laws: queue_etiquette_law (reuse/interact), compliment_quota_law (ironic), complaint_permit_act (hostile bureaucratic path optional)
Required flags: olga_movement_live, olga_reform_path, olga_hostile_path, olga_rejects_office, olga_movement_complete
Blocked arcs: none hard; soft avoid concurrent traffic_military_control martial climax (blocked_flags traffic_martial_path preferred)
Affinity interactions: Olga + on cooperate; − on crackdown; Boom + on hostile; Luna reframes movement; hostile Olga ≤−2 weights confrontation
Trait interactions: populist, reformist (use populist + bureaucratic), authoritarian on crackdown
Crisis interaction: hostile path may start mass_protest; cooperative path can reduce protest weight
Visual hooks: repaired_bridge_bunting, kitchen_table_petition, citizen_banner_plaza, empty_palace_steps
Card count: 6
Reachability risks: Affinity-gated loyalty variants on beat 5; ensure reject_power is not dead; protest not required for completion
Repeated-joke risks: Not traffic checkpoints; not compliment quota as sole joke; not generic angry mob
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `olga_everyday_complaint` | setup / starts_arc | bridge/queue; 3-opt |
| 2 | `olga_practical_campaign` | escalation | soft delayed small win |
| 3 | `olga_movement_forms` | escalation | movement measurable |
| 4 | `olga_government_response` | climax | 3-opt: reform / crackdown / co-opt |
| 5 | `olga_loyalty_test` | loyalty/confrontation | affinity-gated variants |
| 6 | `olga_movement_resolution` | resolution | cabinet / protest / reject power |

Debug: Force complaint → campaign → movement → response → loyalty → resolution; set Olga affinity ± for variants.

---

## Arc 3: Mandatory Happiness

```text
Arc ID: mandatory_happiness
Planning ID: arc_mandatory_happiness
Title: Mandatory Happiness
Arc type: national
Primary advisor: luna_news
Secondary advisors: clerk_zero, auntie_olga
Primary category: media_and_propaganda
Primary stage range: establishment → escalation
Core fantasy: The government improves public happiness through laws, measurements, propaganda, and absurd enforcement — distinguishing real wellbeing from measured happiness.
Setup: Seemingly harmless initiative — National Wellbeing Week / optional smile-friendly workplaces (rewrite mandatory_smiling_proposal → happiness_wellbeing_initiative).
Escalation: Measurement system via National Happiness Index (happiness_measurement_bureau); then enforcement vs voluntary vs bureaucracy fork.
Player conflict: Voluntary positive path vs authoritarian enforcement vs bureaucratic measurement theater.
Branch A: voluntary_wellbeing — soft reform; real Happiness↑ without eternal smile.
Branch B: enforce_happiness — crackdown / golden decree / eternal_smile_state.
Optional Branch C: measure_everything — index hits 100% on paper (happiness_reaches_100_percent) while streets frown.
Resolution A: happiness_arc_reformed — repeal / voluntary success; positive.
Resolution B: happiness_golden_path — eternal_smile_state option.
Resolution C: happiness_index_victory — measured 100%; ending happiness_reaches_100_percent.
Failure/abandonment: Reject initiative early → quiet spin resolution; arc abandon.
Possible ending: eternal_smile_state, happiness_reaches_100_percent
Required laws: mandatory_smiling, fake_smile_standard, national_happiness_index; soft interact mandatory_applause only as optional weight not premise
Required flags: happiness_arc_live, happiness_voluntary, happiness_enforce, happiness_measure, happiness_backlash_ready, happiness_arc_complete
Blocked arcs/flags: soft blocked while luna_reality_path / luna_media_live climax (mutex with Luna reality_control); reject standalone propaganda_smile_campaign as duplicate (absorb premise into escalation beat)
Affinity interactions: Luna + on propaganda; Olga + on reform/− on enforce; Clerk Zero + on measurement
Trait interactions: propagandist, authoritarian, bureaucratic, populist
Crisis interaction: enforcement + low true Happiness can modify or weight a public unrest / fake_news adjacent crisis
Visual hooks: wellbeing_week_banners, happiness_index_billboard, frown_fine_booth, perfect_100_scoreboard
Card count: 6 (rewrite from 7; remove orphan quiet-only mid redundancy; fix happiness_backlash reachability)
Reachability risks: happiness_backlash must be force_next or soft with required_flags — no orphan queue_only; trim happiness_arc_quiet into abandon option on setup or fold into resolution
Repeated-joke risks: Expand beyond smile/applause; measurement and enforcement comedy; absorb propaganda_smile_campaign
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `happiness_wellbeing_initiative` | setup / starts_arc | rewrite smiling proposal; 3-opt |
| 2 | `happiness_measurement_bureau` | escalation | rewrite fake_smile_industry toward index |
| 3 | `happiness_policy_fork` | climax | voluntary / enforce / measure (absorb smile campaign) |
| 4 | `happiness_branch_consequence` | branch consequence | path-specific; may force backlash |
| 5 | `happiness_backlash` | national reaction | FIXED reachability |
| 6 | `happiness_arc_resolution` | resolution | reform / eternal / 100% / quiet |

Debug: Force initiative → bureau → fork → consequence → backlash → resolution.

Reuse map: mandatory_smiling_proposal → happiness_wellbeing_initiative (rewrite ID or keep ID with rewrite); fake_smile_industry → measurement; happiness_bureau_crackdown / golden / reformed / quiet / backlash consolidated into 6 IDs above. Deferred propaganda_smile_campaign → REJECT as standalone (premise absorbed).

---

## Arc 4: Fake Election Accident

```text
Arc ID: fake_election_accident
Planning ID: arc_fake_election_accident
Title: Fake Election Accident
Arc type: national
Primary advisor: clerk_zero
Secondary advisors: chief_judge (guest), luna_news, auntie_olga, general_boom
Primary category: bureaucracy
Primary stage range: escalation → instability
Core fantasy: A ceremonial or controlled election accidentally develops real political consequences.
Setup: Believable admin reason — National Filing Week requires a "civic preference form" that looks like a ballot (election_filing_proposal).
Escalation: Candidate/process setup with solemn chief_judge (election_ballot_setup); campaign escalation with advisor influence (election_campaign_noise).
Player conflict: Keep election managed vs accidental democracy vs cancel via administrative error.
Branch A: managed_election — Palace candidate "wins"; Order/Elite; soft risk of exposure.
Branch B: accidental_democracy — real tallies leak; peaceful_accidental_democracy / democracy_by_administrative_error.
Optional Branch C: cancel_filing_error — void by stamp mistake; coup/institutional crisis if Boom hostile or Order low.
Resolution A: election_managed_close — quiet ceremonial success or ambiguous.
Resolution B: election_democracy_resolution — peaceful or admin-error democracy endings.
Resolution C / Failure: election_institutional_crisis — Boom pressure / Order collapse risk.
Failure/abandonment: Cancel before ballots printed → abandon; treasury/Order cost.
Possible ending: democracy_by_administrative_error, peaceful_accidental_democracy
Required laws: national_filing_week (new), complaint_permit_act (optional interact)
Required flags: election_arc_live, election_managed, election_accidental, election_cancelled, election_arc_complete
Blocked arcs: none hard; soft stage gate instability preferred for climax
Affinity interactions: Zero + on procedure; Olga + on accidental fair count; Boom + on cancel/martial; Luna spins whichever path; state-dependent on propagandist/authoritarian/populist traits
Trait interactions: bureaucratic, populist, authoritarian
Crisis interaction: cancel/martial path can start institutional Order crisis or weight mass_protest; ≥1 peaceful resolution required
Visual hooks: filing_week_ballot_boxes, solemn_judge_desk, accidental_tally_board, void_stamp_banner
Card count: 6
Reachability risks: Guest chief_judge must validate; trait-gated options on unexpected result; keep fictional
Repeated-joke risks: No real-world elections/politicians; not pure paperwork fatigue of Zero Forms arc
```

### Card graph (6)

| Step | ID | Role | Notes |
|------|-----|------|-------|
| 1 | `election_filing_proposal` | setup / starts_arc | Filing Week ballot-form; 3-opt |
| 2 | `election_ballot_setup` | process | chief_judge guest |
| 3 | `election_campaign_noise` | escalation | Luna/Olga/Boom influence |
| 4 | `election_unexpected_result` | unexpected result | state-dependent tallies |
| 5 | `election_government_response` | response | 3-opt: accept / void / martial |
| 6 | `election_arc_resolution` | resolution | managed / democracy / crisis |

Debug: Force filing → ballot → campaign → result → response → resolution; vary traits/affinity.

---

## Pack-wide mechanical plan

| Requirement | Plan |
|-------------|------|
| ≥7 speakers | Luna, Olga, Clerk Zero, Boom, Penny (guest beat optional), chief_judge, Doctor Maybe or Profit on ≥1 cross beat |
| ≥8 affinity changes | Across all four arcs (≥2 per arc) |
| ≥8 trait changes | propagandist, populist, authoritarian, bureaucratic, reformist→populist+bureaucratic, chaotic |
| ≥8 laws | one_headline, memes, reality_show, emergency_broadcast; smile trio; queue/compliment/complaint; national_filing_week |
| ≥6 delayed events | soft on Luna ratings, Olga campaign, Happiness consequence, Election campaign; ≥1 pool |
| hard/soft/pooled | hard on climaxes; soft on escalations; one pool (e.g. luna_media_side_effects or election_noise_pool) |
| ≥6 three-option | setup/climax on each arc |
| ≥6 state-dependent | Luna affinity; Olga affinity; Happiness branch flags; Election traits/flags |
| ≥2 crises | Luna fake_news; Olga mass_protest; Happiness unrest mod; Election institutional |
| ≥6 endings | nation_becomes_broadcast, day_everyone_stopped_believing, olga_peoples_cabinet, palace_hears_the_street, olga_sends_you_home, eternal_smile_state, happiness_reaches_100_percent, democracy_by_administrative_error, peaceful_accidental_democracy |
| ≥4 mutex branches | loyal vs reality vs credibility; reform vs hostile vs reject; voluntary vs enforce vs measure; managed vs accidental vs cancel |
| ≥3 positive/ambiguous | Luna loyal; Olga reform/reject; Happiness voluntary; Election peaceful democracy |
| ≥3 loyalty/hostility | Luna affinity; Olga affinity; Boom on election/hostile Olga |
| ≥2 endgame | Luna broadcast seed; Election democracy; Olga cabinet |

## Quota after pack

- Major-arc decisions approved: 48 / 96 (gap 48)
- Major arcs approved: 8 / 18 (gap 10)
- Packs C–D remain 24 each
- Global target unchanged: 96
- Do not start Milestone 2B-12
