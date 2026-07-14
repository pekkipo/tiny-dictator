# Tiny Dictator — Phase 1 Content Data and Decision Engine PRD

**Scope:** JSON formats, validation, decision eligibility, weighting, follow-ups, catalogs  
**Dependency:** Core gameplay and UI PRDs

---

## 1. Objective

All Phase 1 game content must be data-driven.

A designer or future Cursor task should be able to add a new decision by editing JSON without modifying:

- GameScreen code
- DecisionCard code
- Effect Resolver code
- Ending Resolver code

The content system must be strict enough to prevent broken cards and simple enough to author manually.

---

## 2. Data folder structure

```text
data/
  countries/
    ministan.json
  advisors/
    advisors.json
  decisions/
    ministan_core.json
    ministan_followups.json
  laws/
    laws.json
  endings/
    endings.json
  visual_states/
    country_visual_map.json
```

Phase 1 may combine some files, but the loader should support multiple decision files.

---

## 3. ID rules

All IDs must:

- Use lowercase snake_case
- Be unique within their catalog
- Remain stable once used
- Avoid spaces and punctuation
- Prefer descriptive names

Examples:

```text
free_pizza_friday
switch_off_traffic_lights
general_boom
cat_republic
```

IDs are internal and are not localized.

---

## 4. Country schema

File:

```text
data/countries/ministan.json
```

Example:

```json
{
  "id": "ministan",
  "display_name": "Ministan",
  "description": "A tiny republic with a large palace and several unresolved budget problems.",
  "starting_resources": {
    "treasury": 55,
    "happiness": 55,
    "order": 55,
    "elite_loyalty": 55
  },
  "max_day": 30,
  "decision_files": [
    "res://data/decisions/ministan_core.json",
    "res://data/decisions/ministan_followups.json"
  ],
  "fallback_decision_id": "generic_minister_disagreement",
  "survival_ending_id": "survived_the_prototype"
}
```

Required fields:

- `id`
- `display_name`
- `starting_resources`
- `max_day`
- `decision_files`

---

## 5. Advisor schema

File:

```text
data/advisors/advisors.json
```

Example:

```json
[
  {
    "id": "general_boom",
    "display_name": "General Boom",
    "role": "Military Advisor",
    "short_description": "Believes every problem can be solved with a parade.",
    "portrait_path": "res://assets/placeholders/advisors/general_boom.png",
    "placeholder_icon": "🪖",
    "accent_key": "military"
  }
]
```

Required:

- `id`
- `display_name`
- `role`

Optional:

- `short_description`
- `portrait_path`
- `placeholder_icon`
- `accent_key`

Unknown portrait paths must not invalidate the advisor.

---

## 6. Law schema

File:

```text
data/laws/laws.json
```

Example:

```json
[
  {
    "id": "free_pizza_friday",
    "display_name": "Free Pizza Friday",
    "short_name": "Free Pizza",
    "description": "Citizens receive free pizza every Friday. Nobody knows who pays.",
    "placeholder_icon": "🍕",
    "visual_tags": ["pizza_stalls"],
    "category": "public_life"
  }
]
```

Required:

- `id`
- `display_name`

Optional:

- `short_name`
- `description`
- `placeholder_icon`
- `visual_tags`
- `category`

---

## 7. Ending schema

File:

```text
data/endings/endings.json
```

Example:

```json
[
  {
    "id": "revolution",
    "type": "resource_failure",
    "priority": 50,
    "title": "People Had Enough",
    "description": "The people stormed the palace, mostly because it had the only working air conditioner.",
    "newspaper_masthead": "THE MINISTAN TIMES",
    "placeholder_icon": "✊",
    "conditions": {
      "maximum_resources": {
        "happiness": 0
      }
    }
  }
]
```

Required:

- `id`
- `type`
- `priority`
- `title`
- `description`

Optional:

- `conditions`
- `newspaper_masthead`
- `placeholder_icon`
- `legacy_template`
- `unlock_key`

---

## 8. Decision schema

A decision is the core content unit.

Example:

```json
{
  "id": "switch_off_traffic_lights",
  "advisor_id": "minister_penny",
  "category": "infrastructure",
  "proposal": "We can save money by switching off all traffic lights. Red and green are expensive colors.",
  "one_time": true,
  "weight": 10,
  "minimum_day": 1,
  "maximum_day": 20,
  "requirements": {
    "all_flags": [],
    "any_flags": [],
    "blocked_flags": ["traffic_lights_off"],
    "all_laws": [],
    "any_laws": [],
    "blocked_laws": [],
    "minimum_resources": {},
    "maximum_resources": {},
    "minimum_counters": {},
    "maximum_counters": {}
  },
  "left": {
    "label": "Keep them on",
    "effects": {
      "treasury": -2,
      "happiness": 2,
      "order": 3,
      "elite_loyalty": 0
    },
    "visible_effects": ["treasury", "happiness", "order"],
    "result_text": "The lights stay on. Minister Penny begins calculating the cost of colors."
  },
  "right": {
    "label": "Switch them off",
    "effects": {
      "treasury": 8,
      "happiness": -4,
      "order": -10,
      "elite_loyalty": 2
    },
    "visible_effects": ["treasury", "order"],
    "add_flags": ["traffic_lights_off"],
    "counter_changes": {
      "reckless_savings": 1
    },
    "force_next_decision": "traffic_tank_solution",
    "result_text": "The Treasury saves money. Every intersection becomes a philosophical debate."
  },
  "tags": ["economy", "traffic", "setup"]
}
```

---

## 9. Required decision fields

Mandatory:

- `id`
- `advisor_id`
- `proposal`
- `left`
- `right`

Mandatory option fields:

- `label`
- `result_text`

At least one option effect or state change is recommended.

Optional decision fields:

- `category`
- `one_time`
- `weight`
- `minimum_day`
- `maximum_day`
- `requirements`
- `tags`
- `fallback`
- `debug_only`

---

## 10. Option schema

Supported option fields:

```json
{
  "label": "Give them pizza",
  "effects": {
    "treasury": -10,
    "happiness": 14
  },
  "visible_effects": ["treasury", "happiness"],
  "add_laws": ["free_pizza_friday"],
  "remove_laws": [],
  "add_flags": ["pizza_policy_active"],
  "remove_flags": [],
  "counter_changes": {
    "pizza_choices": 1
  },
  "force_next_decision": "",
  "trigger_ending": "",
  "result_text": "Citizens celebrate. The Treasury receives a very large cheese invoice."
}
```

Unknown optional keys should be logged in development but may be ignored.

---

## 11. Requirement schema

Supported fields:

```json
"requirements": {
  "all_flags": [],
  "any_flags": [],
  "blocked_flags": [],
  "all_laws": [],
  "any_laws": [],
  "blocked_laws": [],
  "minimum_resources": {},
  "maximum_resources": {},
  "minimum_counters": {},
  "maximum_counters": {},
  "minimum_day": 1,
  "maximum_day": 30,
  "not_used_decisions": [],
  "used_decisions": []
}
```

### Logic

A decision is valid only if every configured requirement passes.

#### `all_flags`

All listed flags must exist.

#### `any_flags`

At least one listed flag must exist. Empty means no restriction.

#### `blocked_flags`

None may exist.

#### `all_laws`

All listed laws must be active.

#### `any_laws`

At least one must be active.

#### `blocked_laws`

None may be active.

#### `minimum_resources`

Current value must be greater than or equal to threshold.

#### `maximum_resources`

Current value must be less than or equal to threshold.

#### `minimum_counters`

Counter must be greater than or equal to threshold.

#### `maximum_counters`

Counter must be less than or equal to threshold.

#### `used_decisions`

All listed decisions must already exist in history.

#### `not_used_decisions`

None may already exist in history.

---

## 12. Decision eligibility algorithm

Recommended order:

1. Decision data is structurally valid.
2. Advisor ID exists.
3. Current day is within range.
4. If one-time, decision has not been used.
5. Required flags pass.
6. Blocked flags pass.
7. Required laws pass.
8. Blocked laws pass.
9. Resource conditions pass.
10. Counter conditions pass.
11. Used/not-used history conditions pass.
12. Decision is not the same as current or immediately previous decision unless allowed.
13. Decision is not marked debug-only in normal mode.

Pseudocode:

```gdscript
func is_decision_valid(decision: Dictionary, state: RunState) -> bool:
    if not validator.is_structurally_valid(decision):
        return false
    if decision.get("one_time", true) and state.used_decision_ids.has(decision.id):
        return false
    if state.day < decision.get("minimum_day", 1):
        return false
    if state.day > decision.get("maximum_day", 9999):
        return false
    return requirements_evaluator.matches(
        decision.get("requirements", {}),
        state
    )
```

---

## 13. Weighted selection

After filtering valid decisions, select using weight.

Default:

```text
weight = 10
```

Rules:

- Weight must be a positive integer.
- Missing weight uses default.
- Forced decision bypasses weighting.
- Fallback decision is not included unless no normal decision is valid.
- Immediate repetition should be avoided.

Weighted random pseudocode:

```gdscript
var total_weight := 0
for decision in candidates:
    total_weight += decision.weight

var roll := rng.randi_range(1, total_weight)
var cursor := 0

for decision in candidates:
    cursor += decision.weight
    if roll <= cursor:
        return decision
```

---

## 14. Random seed

A run must store a random seed.

Requirements:

- New run generates a seed.
- Debug mode can force a seed.
- The same seed and same choices should ideally reproduce the same selection sequence, provided content order is stable.
- Seed is printed in debug summary.

This greatly improves bug reproduction.

---

## 15. Forced follow-up design

Example chain:

### Setup decision

`switch_off_traffic_lights`

Right option:

```json
"force_next_decision": "traffic_tank_solution"
```

### Follow-up decision

```json
{
  "id": "traffic_tank_solution",
  "advisor_id": "general_boom",
  "proposal": "Traffic is chaos. I can place tanks at every intersection.",
  "one_time": true,
  "requirements": {
    "all_flags": ["traffic_lights_off"],
    "blocked_flags": ["military_controls_traffic"]
  },
  "left": {
    "label": "Absolutely not",
    "effects": {
      "order": -8,
      "happiness": 2
    },
    "result_text": "The tanks stay home. The cars continue negotiating right of way."
  },
  "right": {
    "label": "Deploy the tanks",
    "effects": {
      "treasury": -12,
      "order": 14,
      "happiness": -8,
      "elite_loyalty": 5
    },
    "add_laws": ["tank_traffic_control"],
    "add_flags": ["military_controls_traffic"],
    "result_text": "Traffic becomes extremely orderly and slightly terrified."
  }
}
```

---

## 16. Reusable decisions

A decision may set:

```json
"one_time": false
```

Use sparingly.

Phase 1 reusable examples:

- Generic minister budget dispute
- Minor public complaint
- Routine parade request

Rules:

- Reusable decisions should still avoid immediate repetition.
- They should not add duplicate laws every time.
- They should have moderate weight.
- Most authored story decisions should remain one-time.

---

## 17. Fallback decision

Every country should define a fallback decision.

Requirements:

- Must always be structurally valid.
- Should not depend on specific flags or laws.
- Should be reusable.
- Should not trigger an endless resource-neutral loop.

Example:

```json
{
  "id": "generic_minister_disagreement",
  "advisor_id": "auntie_olga",
  "proposal": "Two ministers are arguing over who gets the larger office.",
  "one_time": false,
  "weight": 1,
  "fallback": true,
  "left": {
    "label": "Give it to neither",
    "effects": {
      "order": 2,
      "elite_loyalty": -4
    },
    "result_text": "Both ministers become equally offended."
  },
  "right": {
    "label": "Build another office",
    "effects": {
      "treasury": -5,
      "elite_loyalty": 4
    },
    "result_text": "The government expands by one office and zero useful employees."
  }
}
```

---

## 18. Content validation

Validation must run:

- At game startup in development
- When debug reload is requested
- Before first run starts

### Validation checks

#### Decision catalog

- IDs unique
- Advisor exists
- Proposal non-empty
- Left and right exist
- Labels non-empty
- Result text non-empty
- Resource IDs valid
- Law IDs valid
- Ending IDs valid
- Forced decision IDs valid
- Weight valid
- Day range valid
- Requirement fields valid

#### Advisor catalog

- IDs unique
- Display names non-empty

#### Law catalog

- IDs unique
- Display names non-empty

#### Ending catalog

- IDs unique
- Priorities numeric
- Titles and descriptions non-empty
- Conditions valid

### Validation output

Provide summary:

```text
Content validation complete:
- 30 decisions loaded
- 4 advisors loaded
- 6 laws loaded
- 5 endings loaded
- 0 errors
- 2 warnings
```

If blocking errors exist, Start button should be disabled in debug build and errors shown.

---

## 19. Prototype decision set

Phase 1 should include at least the following narrative chains.

### Chain A — Traffic savings

1. Switch off traffic lights
2. Traffic chaos
3. Tanks at intersections
4. Optional public complaint

### Chain B — Free pizza

1. Free Pizza Friday
2. Cheese shortage
3. Pizza tax or pizza nationalization

### Chain C — Mandatory smiling

1. Mandatory smiling law
2. Citizens learn fake smiles
3. Media reports 100% happiness
4. Potential happiness collapse

### Chain D — Cat politics

1. Cat voting rights
2. Cat party enters parliament
3. Cats demand fish budget
4. Special cat ending setup

These chains are enough to prove persistent consequence.

---

## 20. Recommended Phase 1 content inventory

### Advisors

- general_boom
- minister_penny
- luna_news
- auntie_olga

### Laws

- free_pizza_friday
- mandatory_smiling
- window_tax
- cat_voting_rights
- tank_traffic_control
- no_weekends

### Endings

- bankrupt_leader
- revolution
- chaos_country
- elite_coup
- cat_republic
- survived_the_prototype
- content_exhausted

### Flags

- traffic_lights_off
- military_controls_traffic
- pizza_policy_active
- cheese_shortage
- mandatory_smiling_active
- cats_enfranchised
- cats_control_parliament
- media_declares_total_happiness

---

## 21. Authoring rules

Each decision should:

- Be understandable in under five seconds
- Use one advisor voice
- Offer two meaningfully different choices
- Affect at least one resource
- Include result text
- Avoid more than four displayed stat changes unless it is a crisis
- Use short choice labels
- Avoid real-world political references
- Avoid dependencies deeper than three steps in Phase 1

### Character limits

Recommended:

- Proposal: 50–220 characters
- Choice label: 2–32 characters
- Result text: 20–180 characters
- Ending title: 2–60 characters
- Ending description: 30–240 characters

Validator should warn rather than fail for length violations.

---

## 22. Decision Engine acceptance criteria

1. Loads decisions from multiple files.
2. Rejects duplicate IDs.
3. Filters one-time decisions correctly.
4. Applies day conditions.
5. Applies law and flag requirements.
6. Applies resource and counter requirements.
7. Selects by weight.
8. Honors forced follow-up.
9. Falls back safely.
10. Supports fixed random seed.
11. Never returns invalid data to UI.
12. Logs why no candidates were found.
13. Can reload content in debug mode.
14. New valid JSON decision appears without code changes.
