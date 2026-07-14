# Tiny Dictator — Phase 1 Core Gameplay and State PRD

**Scope:** Core loop, runtime state, effect application, laws, flags, counters, endings  
**Dependency:** `00_PHASE_1_MASTER_PRD.md`

---

## 1. Objective

This PRD defines the exact gameplay behavior of the Phase 1 prototype.

The implementation must create a reliable deterministic loop:

```text
Initialize run
→ Select valid decision
→ Present decision
→ Resolve selected option
→ Update state
→ Present feedback
→ Check ending
→ Continue or end
```

The system must be designed so that future content can be added without changing core gameplay code.

---

## 2. Run lifecycle

A run has the following states:

```text
NOT_STARTED
INITIALIZING
AWAITING_DECISION
RESOLVING_DECISION
SHOWING_RESULT
CHECKING_ENDING
ENDED
```

Recommended enum:

```gdscript
enum RunPhase {
    NOT_STARTED,
    INITIALIZING,
    AWAITING_DECISION,
    RESOLVING_DECISION,
    SHOWING_RESULT,
    CHECKING_ENDING,
    ENDED
}
```

### State rules

- Player input is accepted only during `AWAITING_DECISION`.
- Selecting an option immediately moves the run to `RESOLVING_DECISION`.
- The same decision cannot be resolved twice.
- UI buttons are disabled during resolution.
- Ending checks occur after all immediate effects are applied.
- Day increments only if the run continues.
- If the run ends, no new decision is selected.

---

## 3. Run initialization

Starting a new run must:

1. Clear existing runtime state.
2. Set the country ID to `ministan`.
3. Set day to `1`.
4. Set all four resources to default values.
5. Clear active laws.
6. Clear flags.
7. Clear counters.
8. Clear used one-time decisions.
9. Clear decision history.
10. Clear current decision.
11. Initialize random seed.
12. Select the first valid decision.
13. Move phase to `AWAITING_DECISION`.

### Default state

```json
{
  "country_id": "ministan",
  "day": 1,
  "resources": {
    "treasury": 55,
    "happiness": 55,
    "order": 55,
    "elite_loyalty": 55
  },
  "active_laws": [],
  "flags": [],
  "counters": {},
  "used_decision_ids": [],
  "decision_history": [],
  "current_decision_id": "",
  "run_phase": "AWAITING_DECISION"
}
```

---

## 4. RunState data model

Recommended file:

```text
scripts/core/RunState.gd
```

Recommended design:

- `RunState` should be a plain RefCounted class or Resource.
- It should not inherit from Control or Node unless there is a strong reason.
- It must not contain UI node references.
- It should expose serialization helpers.

Suggested typed fields:

```gdscript
class_name RunState
extends RefCounted

var country_id: String = "ministan"
var day: int = 1

var treasury: int = 55
var happiness: int = 55
var order: int = 55
var elite_loyalty: int = 55

var active_laws: Array[String] = []
var flags: Array[String] = []
var counters: Dictionary = {}
var used_decision_ids: Array[String] = []
var decision_history: Array[Dictionary] = []

var current_decision_id: String = ""
var run_phase: int
var random_seed: int
```

### Required methods

```gdscript
func reset() -> void
func get_resource(resource_id: String) -> int
func set_resource(resource_id: String, value: int) -> void
func change_resource(resource_id: String, delta: int) -> int
func has_law(law_id: String) -> bool
func add_law(law_id: String) -> bool
func remove_law(law_id: String) -> bool
func has_flag(flag_id: String) -> bool
func add_flag(flag_id: String) -> bool
func remove_flag(flag_id: String) -> bool
func get_counter(counter_id: String) -> int
func change_counter(counter_id: String, delta: int) -> int
func mark_decision_used(decision_id: String) -> void
func add_history_entry(entry: Dictionary) -> void
func to_dictionary() -> Dictionary
func from_dictionary(data: Dictionary) -> void
```

### Resource clamping

Every resource must be clamped after mutation:

```text
minimum = 0
maximum = 100
```

A method should return the actual applied delta after clamping.

Example:

- Current Treasury = 95
- Effect = +10
- Final Treasury = 100
- Actual applied change = +5

This allows correct feedback text.

---

## 5. Decision resolution

When the player selects an option:

1. Confirm run phase is `AWAITING_DECISION`.
2. Disable further input.
3. Set phase to `RESOLVING_DECISION`.
4. Retrieve selected option data.
5. Capture pre-resolution snapshot.
6. Apply resource effects.
7. Apply laws.
8. Remove laws if configured.
9. Apply flags.
10. Remove flags if configured.
11. Apply counters.
12. Queue forced follow-up if configured.
13. Store history entry.
14. Mark decision used if one-time.
15. Produce a `DecisionResult`.
16. Update visual state.
17. Set phase to `SHOWING_RESULT`.
18. After result display, check ending.
19. If no ending, increment day.
20. Select next decision.
21. Set phase to `AWAITING_DECISION`.

---

## 6. DecisionResult model

The UI should receive a normalized result object instead of interpreting raw option data.

Recommended shape:

```gdscript
class_name DecisionResult
extends RefCounted

var decision_id: String
var selected_side: String
var choice_label: String
var resource_changes: Dictionary
var added_laws: Array[String]
var removed_laws: Array[String]
var added_flags: Array[String]
var removed_flags: Array[String]
var counter_changes: Dictionary
var result_text: String
var triggered_ending_id: String
```

Example normalized result:

```json
{
  "decision_id": "free_pizza_friday",
  "selected_side": "right",
  "choice_label": "Give them pizza",
  "resource_changes": {
    "treasury": -10,
    "happiness": 14,
    "order": 0,
    "elite_loyalty": -2
  },
  "added_laws": ["free_pizza_friday"],
  "removed_laws": [],
  "added_flags": ["pizza_policy_active"],
  "removed_flags": [],
  "counter_changes": {},
  "result_text": "Citizens celebrate. The Treasury receives a very large cheese invoice.",
  "triggered_ending_id": ""
}
```

---

## 7. Immediate effects

Phase 1 must support:

```json
"effects": {
  "treasury": -10,
  "happiness": 14,
  "order": 0,
  "elite_loyalty": -2
}
```

Rules:

- Missing resources mean no change.
- Unknown resource IDs must be logged as errors and ignored in release-safe behavior.
- Effects are applied before laws and flags.
- The UI displays actual applied deltas after clamping.

---

## 8. Laws

Option data may include:

```json
"add_laws": ["free_pizza_friday"],
"remove_laws": ["window_tax"]
```

Rules:

- A law cannot appear twice.
- Adding an already active law returns false and does not duplicate it.
- Removing an inactive law is non-fatal.
- Law data must exist in the law catalog.
- Unknown law IDs should be logged.
- The active law order should reflect activation order.
- The active laws bar may show a maximum number and provide overflow text.

---

## 9. Flags

Option data may include:

```json
"add_flags": ["traffic_lights_off"],
"remove_flags": ["traffic_system_normal"]
```

Rules:

- Flags are unique.
- Flags are not displayed unless a debug mode is active.
- Unknown flags are allowed because flags may be content-defined.
- Flag naming must use lowercase snake_case.
- Flags should describe persistent facts, not temporary UI states.

Good:

```text
traffic_lights_off
cats_enfranchised
general_controls_police
```

Bad:

```text
button_clicked
show_red_animation
temporary_value
```

---

## 10. Counters

Counters support repeated behavior and special endings.

Example option data:

```json
"counter_changes": {
  "military_laws_approved": 1,
  "public_scandals": 1
}
```

Counters default to zero.

Phase 1 should support integer counters only.

Potential uses:

- Number of military laws
- Number of pizza-related laws
- Number of propaganda choices
- Number of decisions rejected
- Number of advisor proposals accepted

Counters may be visible only in debug mode.

---

## 11. Decision history

Each decision resolution must append a history record.

Recommended record:

```json
{
  "day": 3,
  "decision_id": "switch_off_traffic_lights",
  "advisor_id": "minister_penny",
  "selected_side": "right",
  "choice_label": "Switch them off",
  "resource_before": {
    "treasury": 50,
    "happiness": 60,
    "order": 45,
    "elite_loyalty": 55
  },
  "resource_after": {
    "treasury": 58,
    "happiness": 56,
    "order": 35,
    "elite_loyalty": 57
  },
  "added_laws": [],
  "added_flags": ["traffic_lights_off"]
}
```

Phase 1 uses history for:

- End summary
- Debugging
- Future newspaper generation
- Determining the most important decision

---

## 12. Day progression

Rules:

- The first decision is shown on Day 1.
- After a non-ending choice resolves, day increments by one.
- The next card is shown under the new day number.
- Forced follow-ups still consume a day.
- If an ending is triggered, day does not increment after the fatal decision.
- The ending screen shows the day on which the run ended.

---

## 13. Ending system

Ending checks occur after all immediate effects and state changes are applied.

### Priority order

Recommended ending priority:

1. Explicit ending triggered by selected option
2. Special ending conditions
3. Resource collapse endings
4. Maximum-day prototype ending
5. Content-exhaustion fallback ending

This priority prevents a special event from being replaced by a generic zero-resource ending.

### Resource collapse endings

```text
treasury <= 0 → bankrupt_leader
happiness <= 0 → revolution
order <= 0 → chaos_country
elite_loyalty <= 0 → elite_coup
```

If multiple resources reach zero from one decision:

- Use ending priority configured in ending data.
- Phase 1 default priority:
  1. elite_coup
  2. revolution
  3. chaos_country
  4. bankrupt_leader

The ending screen may mention all collapsed resources in the summary.

---

## 14. Special ending conditions

Phase 1 must contain at least one data-driven special ending.

Example: Cat Republic

Conditions:

```json
{
  "all_laws": ["cat_voting_rights"],
  "all_flags": ["cats_control_parliament"],
  "minimum_counters": {
    "cat_favor_choices": 3
  }
}
```

Special ending definition:

```json
{
  "id": "cat_republic",
  "title": "The Purrfect Transfer of Power",
  "type": "special",
  "priority": 100,
  "description": "Parliament voted unanimously to replace you with a cat.",
  "conditions": {
    "all_laws": ["cat_voting_rights"],
    "all_flags": ["cats_control_parliament"],
    "minimum_counters": {
      "cat_favor_choices": 3
    }
  }
}
```

Phase 1 condition operators:

- `all_flags`
- `any_flags`
- `blocked_flags`
- `all_laws`
- `any_laws`
- `minimum_resources`
- `maximum_resources`
- `minimum_counters`
- `maximum_counters`
- `minimum_day`
- `maximum_day`

Do not implement a general scripting language.

---

## 15. Explicit ending trigger

An option may directly trigger an ending:

```json
"trigger_ending": "abdicated_for_pizza"
```

Rules:

- Explicit endings are checked first.
- Ending ID must exist.
- Explicit ending may occur even if no resource reaches zero.
- The option can still apply effects for final summary.

---

## 16. Maximum day

The Phase 1 prototype should support a configurable maximum day.

Recommended:

```text
prototype_max_day = 30
```

At the end of Day 30, if no other ending occurs:

```text
ending = survived_the_prototype
```

This prevents runs from continuing indefinitely with limited content.

The maximum day should be configurable in country/scenario data, not hardcoded in UI.

---

## 17. Content exhaustion

If the Decision Engine cannot find any valid decision:

1. Attempt to use a fallback generic decision.
2. If no fallback exists, trigger `content_exhausted`.
3. Log the full current state and selection reason.
4. Do not crash or show an empty decision panel.

Example fallback ending:

> “The ministers ran out of ideas. For the first time in history, the country experienced peace.”

This ending is for development safety and should be rare.

---

## 18. Forced follow-ups

An option may queue one specific next decision:

```json
"force_next_decision": "traffic_tank_solution"
```

Rules:

- Forced decision is attempted before weighted random selection.
- Its prerequisites must still be validated unless `ignore_requirements` is explicitly allowed.
- If invalid, log an error and fall back to normal selection.
- Only one forced decision needs to be supported at a time in Phase 1.

Optional future queueing is out of scope.

---

## 19. Delayed effects

Phase 1 may support a minimal delayed-effect model if implementation remains clean.

Example:

```json
"delayed_effects": [
  {
    "days_from_now": 3,
    "effects": {
      "treasury": -8,
      "happiness": -3
    },
    "result_text": "The free pizza invoice finally arrives."
  }
]
```

Recommended state representation:

```json
"pending_effects": [
  {
    "trigger_day": 6,
    "source_decision_id": "free_pizza_friday",
    "effects": {
      "treasury": -8
    },
    "result_text": "The cheese supplier demands payment."
  }
]
```

Rules:

- Pending effects are applied at the start of a day before selecting a decision.
- Pending effects can trigger endings.
- Pending effects do not require a separate card in Phase 1.
- UI shows a short notification.
- If delayed effects complicate the first implementation, they may be postponed until the rest of Phase 1 is stable.

---

## 20. Choice feedback

Every option should support:

```json
"result_text": "Citizens celebrate. The Treasury receives a very large cheese invoice."
```

After choosing:

- Decision buttons become disabled.
- Resource deltas animate or update.
- Result text appears for approximately 0.8–1.5 seconds or until the player taps continue.
- Added laws are visually announced.
- The next decision does not replace the current card before the player sees the result.

For the simplest prototype, use a `Continue` button after result display.

Recommended Phase 1 flow:

```text
Choose option
→ Show result text and deltas
→ Show Continue button
→ Continue
→ Ending check or next decision
```

This is easier to debug than automatic timing.

---

## 21. Signals

Recommended EventBus signals:

```gdscript
signal run_started(run_state)
signal decision_presented(decision)
signal decision_resolved(result)
signal resources_changed(changes)
signal law_added(law_id)
signal law_removed(law_id)
signal flag_added(flag_id)
signal country_visual_state_changed(state)
signal ending_triggered(ending_data)
signal run_ended(summary)
signal run_reset()
```

UI should react to signals or explicit refresh calls, but the architecture must avoid UI owning core state.

---

## 22. Error handling

Development behavior:

- Use `push_error()` for invalid required content.
- Use `push_warning()` for non-fatal inconsistencies.
- Show safe fallback UI rather than crashing.

Errors that must be detectable:

- Duplicate decision IDs
- Missing advisor
- Missing law
- Missing required choice fields
- Invalid resource ID
- Invalid ending ID
- Invalid forced follow-up
- Empty decision pool

---

## 23. Core gameplay acceptance criteria

The system passes when:

1. Starting a run resets all prior state.
2. A decision cannot be resolved twice.
3. Resource values never exceed 100 or fall below 0.
4. Added laws do not duplicate.
5. Flags correctly affect future eligibility.
6. A one-time decision does not repeat.
7. Forced follow-ups appear correctly.
8. A zero resource triggers the correct ending.
9. A special ending overrides a generic failure ending when higher priority.
10. Restart returns to Day 1 with default state.
11. Decision history matches actual selected choices.
12. Content exhaustion never leaves the UI unusable.
