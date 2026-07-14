# Tiny Dictator — Phase 2A Narrative and Systems Design PRD

**Suggested repository path:** `docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md`  
**Document status:** Ready for staged implementation  
**Phase:** 2A — Narrative and systems foundation  
**Depends on:** Phase 1 prototype milestones 1–10  
**Engine:** Godot 4.x  
**Language:** GDScript  
**Primary IDE:** Cursor  
**Primary country in this phase:** Ministan  
**Art policy:** Placeholder graphics remain acceptable  
**Content policy:** Representative content only; mass content production belongs to Phase 2B  

---

# 1. Purpose

Phase 1 proves that Tiny Dictator can run a complete decision-based game loop.

Phase 2A must transform that technically functional prototype into a system capable of supporting a coherent, replayable, authored game experience.

The central problem Phase 2A solves is:

> How do we prevent Tiny Dictator from feeling like an endless sequence of unrelated random cards?

Phase 2A introduces the narrative architecture, pacing logic, character framework, country structure, progression model, balance rules, content taxonomy, authoring rules, debug tools, and schema extensions needed before producing the full content library in Phase 2B.

Phase 2A is not primarily about writing hundreds of decisions. It is about creating the systems and specifications that make hundreds of decisions manageable, meaningful, testable, and replayable.

---

# 2. Phase boundary

## 2.1 Phase 1 outcome

Phase 1 should already support:

- Starting and ending a run.
- Four visible national resources.
- Data-driven decisions.
- Two choices per normal decision.
- Resource effects.
- Laws.
- Flags.
- Counters.
- Conditional eligibility.
- Forced follow-ups.
- Basic endings.
- Placeholder country reactions.
- Debug controls.
- Basic persistence.
- Content validation.

Phase 2A must reuse these systems rather than replacing them without necessity.

## 2.2 Phase 2A outcome

At the end of Phase 2A, the game must support:

- Coherent narrative chains.
- Multiple concurrent story arcs.
- Advisor personalities and recurring relationships.
- Run pacing divided into stages.
- Crisis events.
- Soft and hard follow-ups.
- Delayed consequences.
- Mutually exclusive story branches.
- Country-specific content pools.
- Special endings produced by accumulated behavior.
- A defined meta-progression model.
- Content repetition prevention.
- Narrative-aware decision selection.
- Content coverage and balance diagnostics.
- Representative content proving every new system.

## 2.3 Phase 2B outcome

Phase 2B will use the systems designed here to produce:

- The full Ministan content library.
- Rich character writing.
- Long story arcs.
- Numerous crises and endings.
- Progression rewards.
- Additional countries or scenario packs.
- First serious external playtest build.

## 2.4 Phase 3 outcome

Phase 3 replaces placeholder presentation with final art, animation, sound, effects, and release polish.

---

# 3. Product goals

## Goal A — Choices feel remembered

The player must regularly encounter consequences that clearly reference earlier decisions.

Examples:

- Turning off traffic lights later produces traffic chaos.
- Granting cats voting rights later introduces the Cat Party.
- Mandatory smiling later leads to fake-happiness propaganda.
- Selling the national moon later causes a science or religious crisis.

## Goal B — Advisors feel like characters

Advisors must have:

- Distinct motives.
- Consistent speech patterns.
- Recurring relationships with the player.
- Opinions about prior decisions.
- Their own story chains.
- The ability to approve, resent, betray, or support the ruler.

## Goal C — Runs have shape

A run must not feel equally random from Day 1 to Day 30.

It should move through:

1. Establishment.
2. Escalation.
3. Crisis.
4. Endgame.

## Goal D — Replay produces different stories

Different runs should produce different combinations of:

- Advisor arcs.
- Laws.
- Crises.
- Special endings.
- Country states.
- Ruler identity.

## Goal E — Content can scale safely

Phase 2B must be able to add large amounts of content without:

- Breaking the decision engine.
- Creating impossible chains.
- Producing contradictory states.
- Showing the same ideas repeatedly.
- Requiring changes to UI scripts for each card.

---

# 4. Non-goals

Phase 2A does not include:

- Final art.
- Final sound.
- Production monetization.
- Ads.
- In-app purchases.
- Account registration.
- Cloud save.
- Live operations.
- Server-delivered content.
- Multiplayer.
- User-generated scenarios.
- Runtime AI-generated stories.
- Full localization.
- Final marketing copy.
- Hundreds of production-ready decisions.
- Final balance.

Representative placeholder content is required only to prove the systems.

---

# 5. Core design principles

## 5.1 The player is creating a story, not answering a quiz

There is no single correct choice.

Each option should express a style of rule:

- Populist.
- Authoritarian.
- Chaotic.
- Greedy.
- Idealistic.
- Technocratic.
- Cowardly.
- Cat-friendly.

The run should gradually reveal what kind of ruler the player has become.

## 5.2 Consequences must be legible

Not every effect must be predictable, but later consequences must feel connected.

Good:

> You replaced traffic lights with patriotic flags. Three days later, traffic is chaos.

Bad:

> You replaced traffic lights. Ten days later, an unrelated volcano destroys the economy with no narrative connection.

## 5.3 Randomness selects stories; it must not destroy stories

Random selection is allowed between valid content candidates.

Randomness must not:

- Interrupt a forced follow-up.
- Show the ending of an arc before its setup.
- Repeat the same joke.
- Contradict an active law.
- Introduce too many unrelated arcs at once.

## 5.4 Advisors are narrative anchors

The same advisors should return repeatedly.

A player should learn:

- General Boom always wants order through force.
- Minister Penny always finds absurd savings.
- Luna News always controls interpretation.
- Auntie Olga always reflects practical public consequences.

## 5.5 The game should be surprising but mechanically simple

Complexity should live in content interaction and state, not in difficult controls.

Most turns remain:

```text
Read
→ Choose
→ See result
→ Continue
```

---

# 6. Target run structure

## 6.1 Recommended standard run length

Target standard run:

```text
20–35 decisions
```

Hard maximum for Ministan:

```text
40 days
```

Typical first-time run:

```text
10–18 decisions before failure
```

Experienced successful run:

```text
25–40 decisions
```

## 6.2 Run stages

Every run is divided into four stages.

### Stage 1 — Establishment

Recommended days:

```text
1–7
```

Purpose:

- Introduce advisors.
- Establish early laws.
- Start one or two arcs.
- Avoid immediate catastrophic effects.
- Teach the player that choices persist.

Content rules:

- No more than one severe crisis.
- High probability of setup decisions.
- Recovery options should be common.
- Avoid requiring deep prior state.

### Stage 2 — Escalation

Recommended days:

```text
8–16
```

Purpose:

- Bring back earlier consequences.
- Introduce conflicts between advisors.
- Start second-level follow-ups.
- Increase trade-offs.
- Introduce first major crisis.

Content rules:

- At least one active arc should advance every three days.
- New setup arcs remain possible.
- Repeat generic cards become less common.
- Medium effects become common.

### Stage 3 — Instability

Recommended days:

```text
17–27
```

Purpose:

- Force consequences of accumulated laws.
- Increase crisis frequency.
- Present mutually exclusive priorities.
- Enable special endings.
- Test the player’s governing identity.

Content rules:

- At least one crisis every four to six days.
- Major arc beats receive higher priority.
- Recovery choices become more expensive.
- Severe effects become possible.

### Stage 4 — Endgame

Recommended days:

```text
28–40
```

Purpose:

- Resolve active arcs.
- Produce special endings.
- Deliver final betrayals or triumphs.
- Avoid content that cannot conclude before maximum day.

Content rules:

- Do not start long arcs.
- Prioritize resolution cards.
- Increase special-ending probability.
- Suppress minor filler cards unless no resolution is valid.

## 6.3 Stage derivation

The current stage should be derived from:

- Day.
- Number of completed arcs.
- Number of active crises.
- Resource danger.
- Country-specific configuration.

Recommended country data:

```json
{
  "run_stages": [
    {
      "id": "establishment",
      "minimum_day": 1,
      "maximum_day": 7
    },
    {
      "id": "escalation",
      "minimum_day": 8,
      "maximum_day": 16
    },
    {
      "id": "instability",
      "minimum_day": 17,
      "maximum_day": 27
    },
    {
      "id": "endgame",
      "minimum_day": 28,
      "maximum_day": 40
    }
  ]
}
```

---

# 7. Narrative content hierarchy

Phase 2A defines six levels of narrative content.

## 7.1 Atomic decision

A standalone card that does not require a follow-up.

Example:

> Minister Penny proposes taxing umbrellas.

Use for:

- Variety.
- Resource tuning.
- Character reinforcement.
- Light humor.
- Recovery opportunities.

Atomic cards should not dominate the whole game.

Target in full Ministan library:

```text
30–40% of decisions
```

## 7.2 Follow-up pair

A setup decision followed by one consequence.

Example:

1. Turn off traffic lights.
2. Traffic becomes chaos.

Target:

```text
15–20% of decisions
```

## 7.3 Short chain

Three to five connected decisions.

Example:

1. Give cats voting rights.
2. Cat Party enters parliament.
3. Fish subsidy demand.
4. Cats control government.
5. Cat Republic ending.

Target:

```text
20–30% of decisions
```

## 7.4 Advisor arc

A recurring story centered on one advisor.

Example General Boom arc:

1. Parade proposal.
2. Military budget conflict.
3. General gains public influence.
4. General demands emergency powers.
5. Player promotes, restrains, humiliates, or loses to him.

Advisor arcs may overlap with national systems.

## 7.5 National arc

A major multi-character storyline affecting the whole country.

Examples:

- Cat political revolution.
- Hyperinflation.
- AI government experiment.
- National happiness campaign.
- Moon privatization.
- Permanent festival economy.

A run should normally contain:

```text
1 major national arc
1–2 advisor arcs
several short chains
```

## 7.6 Crisis

A high-impact event with urgent presentation and stronger consequences.

Examples:

- National power outage.
- Mass protest.
- Bank run.
- Invasion by one confused soldier.
- Cheese shortage.
- Parliament occupied by cats.
- Palace scandal.

Crises should feel exceptional through:

- Distinct card presentation.
- Larger effect range.
- More choice options where appropriate.
- Strong visual reaction.
- Higher chance of ending or major state change.

---

# 8. Narrative graph model

Every multi-step story is represented as a narrative graph.

## 8.1 Arc definition

Suggested file:

```text
data/arcs/ministan_arcs.json
```

Example:

```json
{
  "id": "cat_politics",
  "display_name": "The Cat Political Movement",
  "country_id": "ministan",
  "arc_type": "national",
  "priority": 60,
  "minimum_start_stage": "establishment",
  "maximum_start_stage": "escalation",
  "maximum_concurrent_runs": 1,
  "exclusive_groups": ["government_replacement_arc"],
  "entry_decision_ids": ["cat_voting_rights"],
  "resolution_decision_ids": [
    "cat_republic_declared",
    "cat_party_banned",
    "cats_return_to_boxes"
  ],
  "tags": ["cats", "politics", "absurd"]
}
```

## 8.2 Arc state

Each arc can be:

```gdscript
enum ArcStatus {
    NOT_STARTED,
    ACTIVE,
    PAUSED,
    COMPLETED,
    FAILED,
    ABANDONED
}
```

Runtime arc state:

```json
{
  "arc_id": "cat_politics",
  "status": "active",
  "current_step": 2,
  "branch_id": "support_cats",
  "started_day": 4,
  "last_advanced_day": 9,
  "completed_day": null,
  "history": [
    "cat_voting_rights",
    "cat_party_enters_parliament"
  ]
}
```

## 8.3 Arc rules

- An entry card starts an arc.
- A decision may advance one or more arcs.
- A choice may select a branch.
- A decision may pause or fail an arc.
- A resolution decision completes it.
- Completed arcs cannot restart in the same run unless explicitly configured.
- No more than the configured number of major arcs may be active.
- Minor chains do not always require explicit arc objects.

---

# 9. Content Director

Phase 1 uses weighted random selection.

Phase 2A introduces a `ContentDirector` that chooses what type of content should appear next before selecting a specific card.

## 9.1 Responsibilities

The Content Director must:

- Respect forced follow-ups.
- Respect queued consequences.
- Advance neglected active arcs.
- Control crisis frequency.
- Control new arc starts.
- Avoid repetition.
- Select content appropriate to run stage.
- Preserve resource recovery opportunities.
- Prefer resolution content in endgame.
- Avoid starting too many simultaneous stories.

## 9.2 Selection layers

Recommended order:

1. Fatal or explicit immediate follow-up.
2. Forced next decision.
3. Due delayed event.
4. Mandatory crisis.
5. Arc resolution required by stage.
6. Arc advancement.
7. Advisor relationship event.
8. New arc setup.
9. Recovery decision if resources are dangerous.
10. Standalone decision.
11. Fallback decision.

## 9.3 Selection request

The Content Director should output a content request:

```json
{
  "request_type": "advance_arc",
  "arc_id": "cat_politics",
  "preferred_advisor_id": "comrade_whiskers",
  "required_tags": ["cat_politics"],
  "excluded_tags": ["minor_filler"],
  "priority": 80
}
```

The Decision Engine then selects a valid card matching that request.

## 9.4 Why this separation matters

The Content Director answers:

> What kind of narrative beat is needed now?

The Decision Engine answers:

> Which valid card can deliver that beat?

Do not combine both responsibilities in one giant method.

---

# 10. Follow-up types

Phase 2A must support three follow-up types.

## 10.1 Hard follow-up

The next decision must be a specific decision.

```json
"follow_up": {
  "type": "hard",
  "decision_id": "traffic_tank_solution"
}
```

Use only when immediate continuity is essential.

## 10.2 Soft follow-up

A consequence becomes highly likely within a time window.

```json
"follow_up": {
  "type": "soft",
  "decision_id": "cheese_shortage",
  "minimum_delay_days": 2,
  "maximum_delay_days": 5,
  "priority": 70
}
```

Use for believable delayed consequences.

## 10.3 Pool follow-up

One of several thematically related consequences should appear.

```json
"follow_up": {
  "type": "pool",
  "pool_id": "free_pizza_consequences",
  "minimum_delay_days": 2,
  "maximum_delay_days": 6,
  "priority": 60
}
```

Pool definition:

```json
{
  "id": "free_pizza_consequences",
  "decision_ids": [
    "cheese_shortage",
    "pizza_union_strike",
    "pineapple_referendum"
  ]
}
```

---

# 11. Narrative event queue

RunState must gain a queue for future narrative events.

Suggested model:

```json
{
  "event_id": "evt_4f8a",
  "source_decision_id": "free_pizza_friday",
  "event_type": "soft_follow_up",
  "decision_id": "cheese_shortage",
  "pool_id": null,
  "earliest_day": 6,
  "latest_day": 9,
  "priority": 70,
  "required_flags": ["pizza_policy_active"],
  "blocked_flags": ["pizza_program_cancelled"],
  "status": "pending"
}
```

Statuses:

```text
pending
eligible
consumed
cancelled
expired
```

Rules:

- Queue entries are evaluated at the start of each day.
- An entry may become eligible at `earliest_day`.
- Priority rises as `latest_day` approaches.
- If blocked, the entry is cancelled.
- If the latest day passes and the event remains valid, it becomes mandatory unless a higher-priority event exists.
- Consumed entries remain in run history for debugging.

---

# 12. Decision schema v2

Phase 2A must extend the decision schema while preserving Phase 1 compatibility.

## 12.1 Normalized options

Phase 1 decisions may use:

```json
"left": {},
"right": {}
```

Phase 2A internally normalizes them to:

```json
"options": [
  {
    "id": "left",
    "label": "Reject",
    "effects": {}
  },
  {
    "id": "right",
    "label": "Approve",
    "effects": {}
  }
]
```

New content should use `options`.

## 12.2 Full decision example

```json
{
  "id": "cat_voting_rights",
  "schema_version": 2,
  "country_id": "ministan",
  "card_type": "normal",
  "advisor_id": "comrade_whiskers",
  "category": "public_life",
  "proposal": "Cats pay taxes in fur and emotional support. They demand voting rights.",
  "one_time": true,
  "base_weight": 10,

  "narrative": {
    "arc_id": "cat_politics",
    "beat_type": "setup",
    "step": 1,
    "branch_id": null,
    "starts_arc": true,
    "advances_arc": false,
    "resolves_arc": false,
    "importance": "major"
  },

  "pacing": {
    "allowed_stages": ["establishment", "escalation"],
    "minimum_day": 2,
    "maximum_day": 14,
    "cooldown_group": "animal_politics",
    "cooldown_days": 4
  },

  "requirements": {
    "all_flags": [],
    "blocked_flags": ["cats_enfranchised"],
    "all_laws": [],
    "blocked_laws": [],
    "minimum_resources": {},
    "maximum_resources": {},
    "minimum_counters": {},
    "maximum_counters": {},
    "active_arcs": [],
    "blocked_arcs": ["robot_government"]
  },

  "options": [
    {
      "id": "reject",
      "label": "Cats cannot vote",
      "effects": {
        "happiness": -3,
        "order": 2,
        "elite_loyalty": 1
      },
      "advisor_affinity": {
        "comrade_whiskers": -2,
        "auntie_olga": 1
      },
      "counter_changes": {
        "anti_cat_choices": 1
      },
      "arc_actions": [
        {
          "arc_id": "cat_politics",
          "action": "fail"
        }
      ],
      "result_text": "Cats respond by knocking every government document onto the floor."
    },
    {
      "id": "approve",
      "label": "One cat, one vote",
      "effects": {
        "happiness": 7,
        "order": -3,
        "elite_loyalty": -2
      },
      "add_laws": ["cat_voting_rights"],
      "add_flags": ["cats_enfranchised"],
      "advisor_affinity": {
        "comrade_whiskers": 3,
        "general_boom": -1
      },
      "counter_changes": {
        "cat_favor_choices": 1
      },
      "arc_actions": [
        {
          "arc_id": "cat_politics",
          "action": "advance",
          "branch_id": "support_cats"
        }
      ],
      "follow_up": {
        "type": "soft",
        "decision_id": "cat_party_enters_parliament",
        "minimum_delay_days": 2,
        "maximum_delay_days": 5,
        "priority": 70
      },
      "result_text": "The first cat voter immediately sleeps through election day."
    }
  ],

  "tags": ["cats", "politics", "arc_setup"],
  "visual_tags": ["cats_in_square"]
}
```

---

# 13. Card types

Phase 2A must support the following card types.

## 13.1 Normal

- Usually two options.
- Standard presentation.
- Most common.

## 13.2 Crisis

- Two or three options.
- Distinct visual treatment.
- Larger effects.
- May trigger ending.
- May temporarily suspend normal selection.

## 13.3 Advisor

- Focused on relationship with one advisor.
- Often lower national impact.
- May change affinity or arc state.

## 13.4 Consequence

- Explicitly references a prior decision.
- Usually selected from narrative queue.
- Should display a small label such as `CONSEQUENCE`.

## 13.5 Resolution

- Completes an arc.
- High narrative priority.
- May unlock ending or meta reward.

## 13.6 Recovery

- Helps a player escape a dangerous resource state.
- Must still carry a cost.
- Selected more often when a resource is under the danger threshold.

## 13.7 Ending setup

- Moves the player toward a special ending.
- Must not reveal the exact ending condition.

---

# 14. Crisis system

## 14.1 Crisis definition

A crisis is a temporary urgent condition.

Runtime model:

```json
{
  "crisis_id": "national_power_outage",
  "status": "active",
  "started_day": 12,
  "severity": 2,
  "maximum_duration_days": 3,
  "resolution_required": true
}
```

## 14.2 Crisis rules

- Only one major crisis may be active in Phase 2A.
- Minor consequences may occur during a crisis if they are directly related.
- A crisis should be resolved within one to three cards.
- Crisis cards may have three options.
- Crisis choices should create meaningful cost differences.
- Some crises may become endings if ignored.

## 14.3 Crisis frequency

Recommended target:

```text
Stage 1: 0–1 crisis
Stage 2: 1 crisis
Stage 3: 1–2 crises
Stage 4: resolution or final crisis
```

## 14.4 Example crisis

```json
{
  "id": "national_power_outage",
  "card_type": "crisis",
  "advisor_id": "doctor_maybe",
  "proposal": "The entire country is dark. The palace generator powers only one national service.",
  "options": [
    {
      "id": "hospital",
      "label": "Power hospitals",
      "effects": {
        "happiness": 8,
        "treasury": -8,
        "elite_loyalty": -4
      },
      "result_text": "Hospitals return to life. Television executives declare this an attack on culture."
    },
    {
      "id": "television",
      "label": "Power television",
      "effects": {
        "happiness": 2,
        "order": 6,
        "elite_loyalty": 4
      },
      "add_flags": ["propaganda_powered_during_blackout"],
      "result_text": "Citizens cannot cook, but they can watch a documentary explaining why this is good."
    },
    {
      "id": "palace",
      "label": "Power the palace",
      "effects": {
        "happiness": -12,
        "order": -5,
        "elite_loyalty": 8
      },
      "result_text": "The palace chandelier remains magnificent over a completely dark nation."
    }
  ]
}
```

---

# 15. Advisor and character framework

Phase 2A must define a consistent advisor roster and voice system.

## 15.1 Core Ministan roster

Recommended full first-country roster:

1. General Boom
2. Minister Penny
3. Luna News
4. Auntie Olga
5. Doctor Maybe
6. Sir Profit
7. Comrade Whiskers
8. Clerk Zero

### General Boom

**Role:** Military and national order  
**Core desire:** More authority, more parades, more visible strength  
**Voice:** Short, confident, tactical, and often wrong  
**Typical effects:** Order up, Elite Loyalty up, Treasury down, Happiness down  
**Arc possibilities:** Loyal protector, popular general, failed coup, successful coup, ceremonial mascot

### Minister Penny

**Role:** Treasury and public spending  
**Core desire:** Save money regardless of human consequences  
**Voice:** Precise, enthusiastic about tiny savings, euphemistic about cuts  
**Typical effects:** Treasury up, Happiness down, Order variable  
**Arc possibilities:** Austerity miracle, economic collapse, window-tax rebellion, accounting takeover

### Luna News

**Role:** Media and propaganda  
**Core desire:** Control the national story  
**Voice:** Smooth, optimistic, always reframing disaster  
**Typical effects:** Order up, temporary Happiness up, delayed truth cost  
**Arc possibilities:** Total media control, public distrust, accidental truth campaign, popularity coup

### Auntie Olga

**Role:** Ordinary citizens  
**Core desire:** Keep practical life functioning  
**Voice:** Sarcastic, grounded, specific, unimpressed  
**Typical effects:** Happiness up, Treasury down, Elite Loyalty down, reveals hidden consequences  
**Arc possibilities:** Citizen movement, palace advisor, protest leader, reluctant prime minister

### Doctor Maybe

**Role:** Science and experimental policy  
**Core desire:** Test ideas before knowing whether they are safe  
**Voice:** Curious, uncertain, excited by side effects  
**Typical effects:** Large variance, delayed consequences, special flags  
**Arc possibilities:** AI government, moon replacement, robot bureaucracy, scientific golden age

### Sir Profit

**Role:** Business and oligarch interests  
**Core desire:** Privatize every public object  
**Voice:** Polite, confident, calls corruption “alignment”  
**Typical effects:** Treasury up, Elite Loyalty up, Happiness down, future recurring costs  
**Arc possibilities:** Sell the moon, privatize air, corporate state, oligarch betrayal

### Comrade Whiskers

**Role:** Cat Union and absurd minority politics  
**Core desire:** Fish, warm furniture, political recognition  
**Voice:** Formal revolutionary rhetoric combined with cat behavior  
**Typical effects:** Happiness up, Order down, cat laws and endings  
**Arc possibilities:** Cat Party, Cat Republic, anti-vacuum campaign, fish-budget crisis

### Clerk Zero

**Role:** Bureaucracy and administration  
**Core desire:** Create forms, procedures, ministries, and stamps  
**Voice:** Emotionless, literal, procedural  
**Typical effects:** Order up, Treasury down, Happiness down, bureaucracy counters  
**Arc possibilities:** Ministry expansion, paperwork collapse, self-governing bureaucracy, robot reveal

---

# 16. Advisor affinity

Each advisor receives a hidden affinity value.

Range:

```text
-5 to +5
```

Starting value:

```text
0
```

Meaning:

```text
-5: Active enemy
-3 to -4: Hostile
-1 to -2: Disappointed
0: Neutral
+1 to +2: Supportive
+3 to +4: Loyal
+5: Devoted or dangerously empowered
```

## 16.1 Why affinity is hidden

The player should understand relationships through:

- Dialogue.
- Expressions.
- Follow-up cards.
- Betrayals.
- Support actions.

Do not display eight additional meters in the main UI.

A debug screen may show exact values.

## 16.2 Affinity effects

Affinity may affect:

- Advisor event eligibility.
- Advisor support in crises.
- Coup or rescue events.
- Arc endings.
- Dialogue variants.
- Special ending conditions.

## 16.3 Affinity constraints

- Normal choice change: ±1.
- Strong personal choice: ±2.
- Arc resolution: up to ±3.
- Clamp to -5…+5.
- Do not let affinity replace national resources.

---

# 17. Ruler identity and hidden playstyle traits

Phase 2A should track hidden behavioral counters that describe the player’s rule.

Recommended traits:

- authoritarian
- populist
- capitalist
- chaotic
- scientific
- propagandist
- bureaucratic
- cat_friendly

These are integer counters, not visible stats.

Example:

```json
"trait_changes": {
  "authoritarian": 2,
  "propagandist": 1
}
```

Uses:

- Ending selection.
- Run summary.
- Newspaper legacy.
- Advisor reactions.
- Future meta achievements.

End-of-run label examples:

- The Smiling Tyrant
- The Spreadsheet Emperor
- Supreme Cat Servant
- The Chaotic Reformer
- The Technocratic Accident

---

# 18. Country design framework

## 18.1 Country as content configuration

A country defines:

- Starting resources.
- Run stages.
- Advisor availability.
- Decision files.
- Arc files.
- Crisis pool.
- Law pool.
- Ending pool.
- Visual theme.
- Country-specific rule.
- Maximum day.
- Content pacing.

## 18.2 Ministan identity

Ministan is the base country.

Theme:

```text
A tiny post-imperial republic with a disproportionately large palace and institutions held together by forms, favors, and optimism.
```

Gameplay identity:

- Balanced starting resources.
- Broad variety of absurd policies.
- All core advisors.
- Good tutorial country.
- Moderate difficulty.
- Many possible endings.

Country-specific rule for Phase 2A:

```text
None required
```

Ministan should validate the general game framework.

## 18.3 Future country templates

Phase 2A should design but not fully implement:

### Oilvania

- High Treasury.
- Low Happiness.
- Powerful elite.
- Business and military arcs.

### Happyland

- Public Happiness legally mandatory.
- Propaganda and social-conformity arcs.
- Happiness value becomes less trustworthy.

### Catagonia

- Cats already possess political power.
- Cat affinity is central.
- Fish economy replaces some standard events.

### Robo Republic

- Automation, efficiency, and machine bureaucracy.
- Doctor Maybe and Clerk Zero are central.
- Order is easy to increase; humanity is difficult to preserve.

### Moon Colony 7

- Scarce resources.
- Scientific crises.
- Environmental systems.

Each future country must use the same engine with country-specific configuration rather than custom hardcoded logic wherever possible.

---

# 19. Meta-progression design

Phase 2A defines the structure. Full implementation may be staged.

## 19.1 Meta goals

Meta-progression should encourage:

- Starting another run.
- Trying different choices.
- Discovering endings.
- Completing arcs.
- Unlocking countries.
- Personalizing the palace.

It must not make early runs feel intentionally weak.

## 19.2 Ending collection

Every unique ending becomes an entry in the Archive.

Entry fields:

```json
{
  "ending_id": "cat_republic",
  "unlocked": true,
  "first_unlocked_at": "timestamp",
  "times_reached": 2,
  "best_day": 31
}
```

The player should see:

- Locked silhouette.
- Ending title after unlock.
- Description.
- A vague achievement hint where appropriate.
- Number of times reached.

## 19.3 Legacy currency

Working name:

```text
Medals
```

Earned after each run.

Sources:

- Survived days.
- New ending.
- Completed arc.
- First-time law.
- Crisis survived.

Recommended prototype formula:

```text
base medals = floor(days_survived / 3)
new ending bonus = 5
completed major arc = 3
completed minor arc = 1
```

Phase 2A should implement the formula as configurable data, not final balance.

## 19.4 Palace progression

The palace is a cosmetic meta screen.

Possible upgrades:

- Gold desk.
- Propaganda studio.
- Emergency bunker.
- Cat advisor chair.
- Ministry of Forms.
- Moon ownership certificate.

Initial Phase 2A implementation can use:

- Upgrade IDs.
- Costs.
- Unlock conditions.
- Placeholder labels.
- Save persistence.

No final palace art is required.

## 19.5 Unlocks

Possible unlock types:

- Country.
- Advisor variant.
- Ruler title.
- Palace object.
- Challenge.
- Starting modifier.

Phase 2A should support data-driven unlock definitions.

## 19.6 Permanent gameplay perks

Avoid strong permanent power in the initial design.

Allowed mild perks:

- One reroll per run.
- Reveal one hidden effect.
- Start with +3 to one resource.
- One emergency recovery option.

These are optional future content and are not required for Phase 2A completion.

---

# 20. Replayability systems

## 20.1 Run modifiers

A run may eventually begin with one modifier.

Examples:

- Empty Treasury.
- Beloved Ruler.
- Suspicious Elite.
- Cats Everywhere.
- Experimental Economy.

Phase 2A should define the schema but does not need the full UI.

## 20.2 Daily challenge

Deferred to a later phase.

The architecture should not prevent:

- Fixed seed.
- Fixed country.
- Fixed modifier.
- Shared challenge date.

## 20.3 Ending hints

After reaching an ending, the Archive may reveal one hint toward another ending.

Do not provide exact walkthroughs.

## 20.4 Advisor relationship replay

Different affinity paths should unlock different advisor resolutions.

A player should not see every advisor outcome in one run.

---

# 21. Repetition control

Repetition is one of the largest risks in a card-based game.

## 21.1 One-time content

Most narrative cards remain one-time per run.

## 21.2 Cooldown groups

Cards can share a cooldown group.

```json
"cooldown_group": "tax_policy",
"cooldown_days": 4
```

After one tax card appears, another tax card should not appear for four days unless forced.

## 21.3 Tag fatigue

RunState tracks recently shown tags.

```json
{
  "cats": 3,
  "military": 1,
  "economy": 0
}
```

The Content Director reduces weight for repeatedly shown tags.

Suggested penalty:

```text
Each recent occurrence within the last 5 cards:
-20% effective weight
```

Do not reduce forced or arc-resolution content.

## 21.4 Advisor fatigue

Avoid showing the same advisor too often.

Rules:

- The same advisor should not normally appear more than twice in a row.
- After two consecutive appearances, apply a strong weight penalty.
- Hard follow-up may override.

## 21.5 Joke repetition

Every decision should have a `humor_tags` field.

Examples:

- pizza
- forms
- propaganda_reframe
- cats_knock_things_over
- military_overreaction

The validator or diagnostic report should identify excessive joke concentration.

## 21.6 Content freshness target

In a standard 20-card run:

- At least 15 unique cards.
- No one-time card repeated.
- No more than three reusable cards.
- At least three advisors.
- At least two narrative chains.
- At least one crisis or special consequence.

---

# 22. Balance framework

## 22.1 Effect magnitude

Suggested bands:

```text
Tiny: 1–3
Small: 4–6
Medium: 7–10
Large: 11–15
Critical: 16–25
```

Normal cards should mostly use Small and Medium effects.

Crises may use Large effects.

Critical effects should be rare and clearly framed.

## 22.2 Choice quality

Avoid obvious dominant options.

A choice is suspicious if:

- It improves every visible resource.
- It has no hidden cost.
- It gives law or affinity benefits with no trade-off.
- The alternative is worse in all dimensions.

The content validator may generate a warning when one option is strictly better across all immediate visible effects.

## 22.3 Recovery system

When any resource is below:

```text
20
```

The Content Director increases the probability of Recovery cards.

Recovery cards must still require a cost.

Example:

> International Bank offers rescue money.

Options:

- Accept: Treasury +18, Elite Loyalty -8.
- Refuse: Happiness +4, Treasury -4.

## 22.4 Death-spiral prevention

Do not allow every low-resource state to automatically create more negative cards.

At least one valid recovery path should normally exist unless the player deliberately triggered an ending chain.

## 22.5 Ending distribution targets

For early external playtests:

```text
Resource failure endings: 50–65%
Special endings: 20–30%
Maximum-day or success endings: 10–20%
Content exhaustion: 0%
```

---

# 23. Content inventory for Phase 2A

Phase 2A does not need full production volume.

It must include representative content proving each system.

## Advisors

```text
8 advisor definitions
```

## Decisions

```text
40–55 total representative decisions
```

Suggested composition:

- 12 atomic decisions.
- 8 follow-up-pair cards.
- 12 short-chain cards.
- 8 advisor-arc cards.
- 5 crisis cards.
- 5 recovery or endgame cards.

## Arcs

At least:

1. Cat Politics national arc.
2. Traffic and Military short chain.
3. Mandatory Happiness national arc.
4. General Boom advisor arc.
5. Doctor Maybe advisor arc.

## Laws

At least:

```text
12 laws
```

## Endings

At least:

- 4 resource failures.
- 3 special arc endings.
- 2 ruler-identity endings.
- 1 maximum-day ending.
- 1 development fallback ending.

## Crises

At least:

- National Power Outage.
- Cheese Shortage.
- Mass Protest.
- Bank Run.
- Cat Parliament Occupation.

## Meta

At least:

- Ending Archive data model.
- Medals calculation.
- Three placeholder palace upgrades.

---

# 24. Content production workflow

## 24.1 Step 1 — Concept brief

Each arc begins as a short brief.

Template:

```text
Arc ID:
Working title:
Primary advisor:
Secondary advisors:
Setup:
Escalation:
Core player conflict:
Possible branches:
Possible resolutions:
Possible endings:
Required laws/flags:
Visual opportunities:
Repeated-joke risks:
```

## 24.2 Step 2 — Graph outline

Create nodes before writing final dialogue.

Example:

```text
Cat voting rights
├── Reject
│   └── Cat protest
│       ├── Suppress → Cats disappear / public anger
│       └── Negotiate → Limited cat council
└── Approve
    └── Cat Party
        ├── Fund fish → Cat Republic
        └── Ban party → Palace scratched / order restored
```

## 24.3 Step 3 — Mechanical review

Before writing:

- Verify every branch can trigger.
- Verify flags are consistent.
- Verify no impossible requirements.
- Verify endings have sufficient setup.
- Verify effects create meaningful trade-offs.

## 24.4 Step 4 — Character voice writing

Write proposals and results in the relevant advisor’s voice.

## 24.5 Step 5 — JSON authoring

Convert the approved graph into schema v2.

## 24.6 Step 6 — Validation

Run:

- Structural validator.
- Reference validator.
- Graph reachability report.
- Effect-dominance warnings.
- Text-length warnings.
- Repetition report.

## 24.7 Step 7 — Forced-path testing

Use debug tools to play every branch.

## 24.8 Step 8 — Natural-run testing

Run with normal selection and verify that the arc appears naturally.

---

# 25. Content validation extensions

Phase 2A validator must add:

## Narrative validation

- Arc ID exists.
- Arc step is valid.
- Entry card starts the arc.
- Resolution card resolves the arc.
- Branch IDs are valid.
- Follow-up decision exists.
- Follow-up pool exists.
- Queue delays are valid.
- Card stage is valid.
- Endgame does not start long arcs.
- Exclusive arcs do not run together.

## Option validation

- Option IDs are unique.
- At least two options.
- Maximum three options in Phase 2A.
- Result text exists.
- Advisor-affinity IDs exist.
- Arc actions reference valid arcs.
- Follow-up type is valid.
- Trait IDs are valid.

## Graph diagnostics

Create a debug report showing:

- Unreachable decisions.
- Arcs with no resolution.
- Branches with no continuation.
- Endings with impossible conditions.
- Follow-ups blocked by their own setup.
- Circular forced-follow-up loops.

## Balance diagnostics

Warn when:

- One option dominates another.
- A resource effect exceeds the configured normal range.
- A card has no meaningful effect.
- Too many cards use the same advisor or tag.
- The recovery pool is empty.
- The endgame resolution pool is empty.

---

# 26. Debug and authoring tools

Phase 2A must extend the debug overlay.

Required tools:

- Force decision.
- Force card type.
- Start arc.
- Set arc status.
- Set arc branch.
- Advance arc.
- Complete arc.
- Add queued event.
- Advance day.
- View event queue.
- View active arcs.
- View advisor affinity.
- View ruler traits.
- View recent tags.
- Force crisis.
- Force recovery state.
- Generate content coverage report.
- Simulate 100 runs without UI.

## 26.1 Simulation mode

A headless or fast simulation should:

- Start a run.
- Select random valid choices.
- Continue until ending.
- Repeat N times.
- Output aggregate results.

Report:

```text
Runs: 1,000
Average length: 17.4 days
Ending distribution:
- revolution: 23%
- coup: 19%
- bankruptcy: 17%
- chaos: 14%
- cat_republic: 8%
- other special: 12%
- max-day: 7%

Content never selected: 3 decisions
Arcs never completed: 1
Content exhaustion: 0
```

This is a development tool, not a production feature.

---

# 27. Data structure additions

RunState must add:

```gdscript
var current_stage_id: String
var active_arcs: Dictionary
var completed_arc_ids: Array[String]
var failed_arc_ids: Array[String]
var narrative_event_queue: Array[Dictionary]
var active_crisis: Dictionary
var advisor_affinity: Dictionary
var ruler_traits: Dictionary
var recent_decision_ids: Array[String]
var recent_advisor_ids: Array[String]
var recent_tags: Array[String]
var earned_meta_rewards: Dictionary
```

Save data must add:

```gdscript
var unlocked_ending_ids: Array[String]
var ending_records: Dictionary
var medals: int
var unlocked_country_ids: Array[String]
var palace_upgrades: Dictionary
```

All new fields require default values and migration-safe loading.

---

# 28. New core services

Recommended files:

```text
scripts/core/
  ContentDirector.gd
  ArcManager.gd
  NarrativeEventQueue.gd
  CrisisManager.gd
  AdvisorRelationshipManager.gd
  RulerTraitManager.gd
  MetaProgressionManager.gd
  ContentDiagnostics.gd
```

## 28.1 ContentDirector

Owns narrative-intent selection.

Must not:

- Mutate resources.
- Display UI.
- Write save files directly.

## 28.2 ArcManager

Owns arc lifecycle and branch state.

Required methods:

```gdscript
func start_arc(arc_id: String, branch_id: String = "") -> bool
func advance_arc(arc_id: String, decision_id: String, branch_id: String = "") -> bool
func pause_arc(arc_id: String) -> bool
func complete_arc(arc_id: String, resolution_id: String) -> bool
func fail_arc(arc_id: String, reason: String = "") -> bool
func get_active_arcs() -> Array[Dictionary]
func can_start_arc(arc_id: String) -> bool
```

## 28.3 NarrativeEventQueue

Owns delayed and soft follow-ups.

Required methods:

```gdscript
func add_event(event_data: Dictionary) -> String
func cancel_events_from_source(source_decision_id: String) -> void
func update_for_day(day: int, state: RunState) -> void
func get_due_events(state: RunState) -> Array[Dictionary]
func consume_event(event_id: String) -> void
```

## 28.4 CrisisManager

Owns active-crisis state.

Required methods:

```gdscript
func can_start_crisis(crisis_id: String, state: RunState) -> bool
func start_crisis(crisis_id: String) -> bool
func resolve_crisis(crisis_id: String, resolution_id: String) -> bool
func fail_crisis(crisis_id: String) -> bool
func has_active_crisis() -> bool
```

## 28.5 AdvisorRelationshipManager

Owns hidden advisor affinity.

## 28.6 RulerTraitManager

Owns hidden playstyle counters and final ruler identity.

## 28.7 MetaProgressionManager

Calculates run rewards and persists unlocks.

---

# 29. UI changes

Phase 2A placeholder UI must support the new systems.

## 29.1 Variable option count

DecisionCard must support:

```text
2 options for normal cards
2–3 options for crises
```

Use a vertical options container if three horizontal buttons would be too cramped.

## 29.2 Card labels

Possible labels:

- CONSEQUENCE
- CRISIS
- ADVISOR
- FINAL DECISION
- NEW LAW

## 29.3 Advisor relationship feedback

Do not show exact affinity.

Possible feedback:

```text
General Boom approves.
Auntie Olga looks disappointed.
Luna News will remember this.
```

## 29.4 Arc feedback

When an arc advances:

```text
Story advanced: The Cat Political Movement
```

This can appear only in prototype/debug builds initially.

## 29.5 Run-end summary

Add:

- Ruler identity.
- Completed arcs.
- Key advisor relationship.
- New endings.
- Medals earned.
- Most influential laws.

---

# 30. Phase 2A implementation milestones

Phase 2A must be implemented incrementally.

## Milestone 2A-1 — Schema v2 and option normalization

Implement:

- Decision schema versioning.
- `options` array.
- Backward compatibility for `left/right`.
- Two-to-three-option UI.
- Updated validation.
- Representative converted cards.

Do not implement arcs yet.

Acceptance:

- Existing Phase 1 content still works.
- New `options` content works.
- A three-option crisis placeholder displays correctly.
- Effect resolution accepts option ID rather than only left/right.

## Milestone 2A-2 — Run stages and Content Director skeleton

Implement:

- Run-stage configuration.
- Stage derivation.
- ContentDirector request types.
- Stage-aware selection.
- Recovery request when a resource is low.
- Endgame suppression of long setups.

Acceptance:

- Debug overlay shows current stage.
- Content selection changes by stage.
- Recovery cards become more likely under threshold.
- Endgame does not start configured long arcs.

## Milestone 2A-3 — Arc Manager

Implement:

- Arc catalog.
- Arc runtime state.
- Start, advance, branch, complete, fail.
- Arc requirements in decision eligibility.
- Arc actions in options.
- Debug arc controls.

Acceptance:

- Cat Politics arc can be played from start to resolution.
- Branches lead to different cards.
- Completed arc cannot restart.
- Exclusive-arc rule works.

## Milestone 2A-4 — Narrative event queue

Implement:

- Hard, soft, and pool follow-ups.
- Earliest/latest day.
- Priority growth.
- Cancellation conditions.
- Queue debug view.

Acceptance:

- Free Pizza setup queues a delayed consequence.
- Consequence appears within the configured window.
- Cancelling the pizza program cancels the queued consequence.
- An expired mandatory event does not disappear silently.

## Milestone 2A-5 — Crises

Implement:

- Crisis definitions.
- One active major crisis.
- Crisis card type.
- Three-option support.
- Crisis resolution.
- Crisis failure path.
- Crisis pacing rules.

Acceptance:

- National Power Outage can be forced and resolved.
- Unrelated setup cards do not interrupt a mandatory crisis.
- Crisis can trigger an ending.
- UI clearly distinguishes a crisis.

## Milestone 2A-6 — Advisors and ruler identity

Implement:

- Eight advisor definitions.
- Affinity range.
- Affinity effects.
- Advisor-requirement conditions.
- Hidden ruler traits.
- Final ruler-identity calculation.
- Debug visibility.

Acceptance:

- Advisor affinity changes after choices.
- High or low affinity unlocks different cards.
- Run summary shows ruler identity.
- Main UI does not expose exact affinity.

## Milestone 2A-7 — Meta-progression skeleton

Implement:

- Ending Archive.
- Ending records.
- Medals calculation.
- Three placeholder palace upgrades.
- Save migration.
- Run reward summary.

Acceptance:

- A new ending is persisted.
- Reaching the same ending updates its record.
- Medals persist.
- A placeholder upgrade can be purchased and persists.
- An old Phase 1 save migrates safely.

## Milestone 2A-8 — Diagnostics and simulation

Implement:

- Graph diagnostics.
- Content-coverage report.
- Balance warnings.
- 100/1,000-run simulation.
- Unreachable-content detection.
- Ending-distribution report.

Acceptance:

- Simulation completes without UI.
- Content exhaustion is reported.
- An unreachable test card is detected.
- A forced-follow-up cycle is detected.
- Report can be exported to text or JSON.

## Milestone 2A-9 — Representative content pack

Implement:

- 40–55 representative decisions.
- Five arcs.
- Five crises.
- Eight advisors.
- Twelve laws.
- Eleven endings.
- Recovery cards.
- Endgame resolutions.

Acceptance:

- Every Phase 2A system is exercised naturally.
- At least five distinct run stories are possible.
- No content-validation errors.
- No content exhaustion across 1,000 simulated runs.

## Milestone 2A-10 — Phase 2A QA and freeze

Perform:

- Manual branch testing.
- Natural-run testing.
- Simulation review.
- Save-migration testing.
- Schema documentation.
- Known-limitations documentation.
- Git tag.

Acceptance:

- All acceptance criteria in this PRD pass.
- Phase 2B can add normal content without engine changes.

---

# 31. Exact Cursor implementation protocol

For each milestone, Cursor must:

1. Read this PRD.
2. Read the Phase 1 architecture PRDs.
3. Inspect the current implementation before editing.
4. Preserve working Phase 1 behavior.
5. Implement one milestone only.
6. Avoid rewriting unrelated systems.
7. Avoid external plugins.
8. Use typed GDScript.
9. Add or update tests.
10. Add representative data.
11. List every changed file.
12. Explain manual Godot steps.
13. State what was actually executed.
14. Report unresolved assumptions.
15. Commit only after Godot testing.

---

# 32. Cursor prompt — Milestone 2A-1

```text
Read:

- docs/00_PHASE_1_MASTER_PRD.md
- docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md
- docs/03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md
- docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md
- docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md

Implement only Phase 2A Milestone 2A-1:
Schema v2 and option normalization.

Before editing:

1. Inspect the current Phase 1 implementation.
2. Identify how left/right choices are currently represented.
3. Preserve all existing content compatibility.
4. Do not implement arcs, crises, affinity, meta progression, or event queues yet.

Requirements:

- Add decision schema_version support.
- Add an options array as the canonical internal representation.
- Normalize legacy left/right decisions into options with IDs "left" and "right".
- Update EffectResolver to resolve by option ID.
- Preserve existing choose_left and choose_right wrappers if current UI depends on them.
- Update DecisionCard to render two options from the normalized model.
- Add support for a maximum of three options.
- When three options exist, render them in a vertical container suitable for portrait mobile.
- Add card_type field with default "normal".
- Add prototype labels for card types.
- Update content validation:
  - minimum two options
  - maximum three options
  - unique option IDs
  - label required
  - result_text required
- Convert at least three existing decisions to schema v2.
- Add one three-option crisis placeholder only to prove rendering; do not implement CrisisManager yet.
- Update technical documentation for schema v2.

Do not:

- Remove support for legacy content.
- Implement narrative arcs.
- Implement event queues.
- Implement advisor affinity.
- Implement new save data.
- Implement final UI art.

After implementation:

1. List all changed files.
2. Explain compatibility behavior.
3. Explain any manual Godot steps.
4. Provide exact tests for:
   - legacy two-choice card
   - schema v2 two-choice card
   - schema v2 three-choice card
   - option effect resolution
5. State anything that could not be run or verified.
```

---

# 33. Generic Cursor prompt for later milestones

```text
Read:

- docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md
- all Phase 1 PRDs relevant to the requested system

Implement only Phase 2A Milestone [NUMBER AND NAME].

Before changing files:

- Inspect the existing implementation.
- Preserve all working earlier milestones.
- Identify required migrations.
- Do not implement later milestones.

Requirements:
[copy only the requested milestone requirements]

Testing:
[copy the milestone acceptance criteria]

After implementation:

- List all created and modified files.
- Explain manual Godot steps.
- Explain data migration.
- Provide a test checklist.
- Report assumptions and limitations.
- Do not claim successful execution unless it was actually validated.
```

---

# 34. Phase 2A acceptance criteria

Phase 2A is complete only when:

## Narrative

- Runs contain coherent chains.
- Earlier choices are referenced later.
- At least five arcs work.
- Arc branches produce different outcomes.
- Endgame resolves active stories.
- No impossible arc is present.

## Selection and pacing

- Content Director respects run stage.
- Forced and delayed consequences work.
- Crises occur at sensible frequency.
- Recovery content appears in danger states.
- The same advisor and tags do not dominate.
- Endgame does not start unresolved long arcs.

## Characters

- Eight advisors have distinct voices and motives.
- Affinity affects content.
- Ruler traits produce a final identity.
- Character systems remain hidden from the main UI unless narratively communicated.

## Meta

- Endings persist.
- Medals persist.
- Placeholder palace upgrades persist.
- Save migration works.

## Technical

- Legacy Phase 1 content remains valid.
- Schema v2 works.
- Two and three choices work.
- Simulation runs without UI.
- Diagnostics detect unreachable content.
- No content exhaustion occurs in 1,000 representative simulations.
- Restart remains clean.
- No blocking validation errors remain.

## Content

- 40–55 representative cards.
- Five arcs.
- Five crises.
- Twelve laws.
- Eleven endings.
- Eight advisors.
- Multiple recovery cards.
- Multiple endgame cards.

---

# 35. Definition of ready for Phase 2B

Phase 2B may begin when:

- Normal new content can be added only through data.
- New arcs can be authored without GDScript changes.
- New crises can be authored without UI changes.
- New advisors can be added through data and placeholder assets.
- The event queue is stable.
- The Content Director produces coherent runs.
- Debug tools can force every narrative path.
- Simulation identifies balance and coverage problems.
- Save data supports the planned meta loop.
- The team no longer expects major schema changes.

At that point, Phase 2B becomes primarily a content-production, balance, and playtesting effort rather than an engine redesign.
