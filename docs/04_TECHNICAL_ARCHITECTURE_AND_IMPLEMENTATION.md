# Tiny Dictator — Phase 1 Technical Architecture and Implementation PRD

**Scope:** Godot project architecture, scripts, autoloads, responsibilities, persistence, implementation sequence  
**Target:** Cursor-assisted Godot 4 development

---

## 1. Technical objective

Create a maintainable Godot prototype that separates:

- Game state
- Content data
- Decision eligibility
- Effect application
- Ending checks
- Visual state derivation
- UI presentation
- Save persistence
- Debug tools

Cursor should be able to implement and modify systems independently without rewriting the entire project.

---

## 2. Recommended project structure

```text
tiny-dictator/
├── project.godot
├── docs/
│   ├── 00_PHASE_1_MASTER_PRD.md
│   ├── 01_CORE_GAMEPLAY_AND_STATE_PRD.md
│   ├── 02_UI_UX_AND_SCENE_SPEC.md
│   ├── 03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md
│   ├── 04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md
│   └── 05_QA_ACCEPTANCE_AND_DELIVERY_PLAN.md
├── scenes/
│   ├── main/
│   │   └── Main.tscn
│   ├── screens/
│   │   ├── StartScreen.tscn
│   │   ├── GameScreen.tscn
│   │   └── RunEndScreen.tscn
│   └── components/
│       ├── ResourceBar.tscn
│       ├── ResourceItem.tscn
│       ├── CountryDiorama.tscn
│       ├── DecisionCard.tscn
│       ├── ActiveLawsBar.tscn
│       ├── ResultPanel.tscn
│       └── DebugOverlay.tscn
├── scripts/
│   ├── core/
│   │   ├── GameManager.gd
│   │   ├── EventBus.gd
│   │   ├── RunState.gd
│   │   ├── DecisionEngine.gd
│   │   ├── EffectResolver.gd
│   │   ├── EndingResolver.gd
│   │   ├── ContentRepository.gd
│   │   ├── ContentValidator.gd
│   │   ├── CountryStateResolver.gd
│   │   └── SaveManager.gd
│   ├── models/
│   │   ├── DecisionResult.gd
│   │   ├── RunSummary.gd
│   │   └── CountryVisualState.gd
│   └── ui/
│       ├── Main.gd
│       ├── StartScreen.gd
│       ├── GameScreen.gd
│       ├── RunEndScreen.gd
│       ├── ResourceBar.gd
│       ├── CountryDiorama.gd
│       ├── DecisionCard.gd
│       ├── ActiveLawsBar.gd
│       ├── ResultPanel.gd
│       └── DebugOverlay.gd
├── data/
│   ├── countries/
│   ├── advisors/
│   ├── decisions/
│   ├── laws/
│   ├── endings/
│   └── visual_states/
├── assets/
│   └── placeholders/
└── tests/
    ├── test_requirements.gd
    ├── test_effects.gd
    ├── test_endings.gd
    └── test_decision_selection.gd
```

---

## 3. Autoloads

Recommended autoloads:

### EventBus

```text
Name: EventBus
Path: res://scripts/core/EventBus.gd
```

### GameManager

```text
Name: GameManager
Path: res://scripts/core/GameManager.gd
```

Optional:

### SaveManager

May be an autoload once implemented.

Avoid making every service an autoload. Core helper classes may be owned by GameManager.

---

## 4. GameManager responsibilities

`GameManager` is the high-level coordinator.

It owns:

- Current `RunState`
- ContentRepository instance
- DecisionEngine instance
- EffectResolver instance
- EndingResolver instance
- CountryStateResolver instance
- Current decision data
- Run lifecycle state

It does not own:

- UI nodes
- Button references
- Final scene presentation
- Raw JSON parsing details
- Resource rendering

### Required public methods

```gdscript
func initialize_game() -> void
func start_new_run(country_id: String = "ministan") -> void
func get_current_state() -> RunState
func get_current_decision() -> Dictionary
func choose_left() -> void
func choose_right() -> void
func resolve_choice(side: String) -> DecisionResult
func continue_after_result() -> void
func restart_run() -> void
func return_to_main_menu() -> void
func force_decision(decision_id: String) -> bool
func debug_set_resource(resource_id: String, value: int) -> void
func debug_trigger_ending(ending_id: String) -> void
```

### Internal flow

```gdscript
func start_new_run(country_id: String = "ministan") -> void:
    _run_state = RunState.new()
    _run_state.initialize_from_country(_content.get_country(country_id))
    _select_and_present_next_decision()
    EventBus.run_started.emit(_run_state)
```

---

## 5. ContentRepository responsibilities

Loads and exposes content catalogs.

### Required catalogs

- Countries by ID
- Advisors by ID
- Laws by ID
- Decisions by ID
- Endings by ID

### Required methods

```gdscript
func load_all() -> bool
func reload_all() -> bool
func get_country(id: String) -> Dictionary
func get_advisor(id: String) -> Dictionary
func get_law(id: String) -> Dictionary
func get_decision(id: String) -> Dictionary
func get_ending(id: String) -> Dictionary
func get_all_decisions_for_country(country_id: String) -> Array[Dictionary]
func has_decision(id: String) -> bool
func has_law(id: String) -> bool
func has_advisor(id: String) -> bool
func has_ending(id: String) -> bool
```

### Loading behavior

- Parse JSON using Godot JSON utilities.
- Return clear errors including file path.
- Keep last valid catalog if debug reload fails, if practical.
- Do not expose mutable internal dictionaries directly where accidental mutation is likely.

---

## 6. ContentValidator responsibilities

Validates all loaded content before play.

Methods:

```gdscript
func validate_repository(repository: ContentRepository) -> ValidationReport
func validate_decision(decision: Dictionary, repository: ContentRepository) -> Array[String]
func validate_law(law: Dictionary) -> Array[String]
func validate_advisor(advisor: Dictionary) -> Array[String]
func validate_ending(ending: Dictionary) -> Array[String]
```

ValidationReport should contain:

```gdscript
var errors: Array[String]
var warnings: Array[String]
var is_valid: bool
```

In debug builds, validation output should be printed in grouped form.

---

## 7. DecisionEngine responsibilities

Owns decision eligibility and selection.

### Constructor dependencies

- ContentRepository
- RandomNumberGenerator

### Required methods

```gdscript
func get_valid_decisions(state: RunState) -> Array[Dictionary]
func select_next_decision(state: RunState) -> Dictionary
func is_decision_valid(decision: Dictionary, state: RunState) -> bool
func evaluate_requirements(requirements: Dictionary, state: RunState) -> bool
func set_forced_decision(decision_id: String) -> void
func clear_forced_decision() -> void
```

It must not:

- Apply effects
- Increment day
- Change UI
- Trigger endings directly

---

## 8. EffectResolver responsibilities

Takes one option and mutates RunState.

Required method:

```gdscript
func apply_option(
    decision: Dictionary,
    side: String,
    state: RunState,
    repository: ContentRepository
) -> DecisionResult
```

Responsibilities:

- Resolve left/right option
- Apply immediate resource changes
- Apply laws
- Apply flags
- Apply counters
- Record forced next decision
- Record explicit ending ID
- Create normalized DecisionResult
- Append history
- Mark decision used

It must not:

- Select next decision
- Change scene
- Display UI
- Decide final ending priority

---

## 9. EndingResolver responsibilities

Required methods:

```gdscript
func resolve_ending(
    state: RunState,
    decision_result: DecisionResult,
    country_data: Dictionary,
    repository: ContentRepository
) -> Dictionary
```

Priority:

1. Explicit ending from result
2. Matching special endings sorted by priority descending
3. Resource collapse
4. Maximum day
5. No ending

It should return empty dictionary if no ending.

---

## 10. CountryStateResolver responsibilities

Produces a pure visual state model.

Input:

- RunState
- Active laws
- Flags

Output example:

```json
{
  "prosperity": "poor",
  "public_mood": "protesting",
  "stability": "tense",
  "elite_status": "watching",
  "visual_tags": [
    "pizza_stalls",
    "cats_in_square",
    "traffic_chaos"
  ],
  "summary_text": "Poor, protesting, tense, elite watching"
}
```

Recommended class:

```gdscript
class_name CountryVisualState
extends RefCounted
```

The resolver must not access UI nodes.

---

## 11. UI scripts

### GameScreen.gd

Responsibilities:

- Bind to GameManager/EventBus
- Refresh visible state
- Forward left/right clicks
- Show result
- Forward Continue
- Manage local UI visibility

Must not:

- Calculate effects
- Filter decisions
- Check ending rules
- Modify state fields directly

### DecisionCard.gd

Responsibilities:

- Display decision
- Display advisor
- Display visible effects
- Emit left/right choice signal
- Enable/disable input

### ResourceBar.gd

Responsibilities:

- Display four resource values
- Show delta feedback
- Show danger state

### CountryDiorama.gd

Responsibilities:

- Render CountryVisualState placeholders
- Show law props
- Never derive gameplay rules itself

### RunEndScreen.gd

Responsibilities:

- Display RunSummary
- Emit restart/menu actions

---

## 12. RunSummary model

Recommended:

```gdscript
class_name RunSummary
extends RefCounted

var ending_id: String
var ending_title: String
var ending_description: String
var final_day: int
var final_resources: Dictionary
var active_laws: Array[String]
var decision_history: Array[Dictionary]
var random_seed: int
var legacy_text: String
```

Generated once when run ends.

---

## 13. SaveManager

Phase 1 minimum persistence:

```json
{
  "version": 1,
  "unlocked_endings": [],
  "settings": {
    "debug_enabled": true
  },
  "last_run_summary": {}
}
```

Save location:

```text
user://save.json
```

Required methods:

```gdscript
func load_save() -> Dictionary
func save_data(data: Dictionary) -> bool
func unlock_ending(ending_id: String) -> void
func is_ending_unlocked(ending_id: String) -> bool
func reset_save() -> void
```

Run state itself does not need mid-run persistence in Phase 1.

---

## 14. Signals and event flow

Recommended signal flow:

```text
StartScreen.start_pressed
→ GameManager.start_new_run
→ EventBus.run_started
→ Main shows GameScreen
→ EventBus.decision_presented
→ GameScreen displays card

DecisionCard.choice_selected
→ GameManager.resolve_choice
→ EventBus.decision_resolved
→ GameScreen shows result

ResultPanel.continue_pressed
→ GameManager.continue_after_result
→ ending?
   yes → EventBus.run_ended → Main shows RunEndScreen
   no  → EventBus.decision_presented → GameScreen displays next card
```

Avoid circular signal ownership.

---

## 15. Scene switching approach

Recommended:

- Main scene instantiated once.
- Screen scenes are instantiated into `ScreenContainer`.
- Current screen is freed before next is added.
- GameManager remains alive through autoload.

Alternative using hidden screen nodes is acceptable, but avoid duplicated signal connections.

---

## 16. Error handling strategy

### Development build

- Detailed logs
- `push_error`
- Debug overlay
- Raw IDs visible where necessary
- Content validation blocks starting a run on fatal errors

### Safe runtime behavior

- Missing portrait → placeholder icon
- Invalid optional visual tag → ignore
- Missing result text → fallback text
- Missing forced follow-up → normal selection
- Empty decision pool → fallback or ending

Never allow a broken content item to produce a null-reference crash in UI.

---

## 17. Logging

Recommended log categories:

```text
[BOOT]
[CONTENT]
[RUN]
[DECISION]
[EFFECT]
[ENDING]
[SAVE]
[DEBUG]
```

Example:

```text
[DECISION] Day 4 selected traffic_tank_solution from 7 valid candidates.
[EFFECT] order +14, treasury -12, happiness -8.
[ENDING] No ending matched.
```

Logs should be useful but not spam every frame.

---

## 18. Testing strategy

Godot does not require a full testing framework for the first prototype, but pure logic should be testable.

Recommended options:

- Lightweight custom test runner scene
- GUT plugin only if deliberately chosen later
- Script-based assertion tests in `/tests`

Phase 1 priority tests:

- Requirements evaluator
- Resource clamping
- One-time decision filtering
- Forced follow-up
- Ending priority
- Content fallback
- Restart cleanliness

---

## 19. Git workflow

Recommended branches:

```text
main
phase-1-prototype
feature/core-run-state
feature/decision-engine
feature/main-ui
feature/endings
```

For solo development, a simpler approach is acceptable:

- Work on `phase-1-prototype`
- Commit after every stable milestone
- Tag final state

Suggested commits:

```text
feat: add run state and game manager
feat: load and validate content catalogs
feat: implement decision selection
feat: implement choice resolution
feat: add placeholder game screen
feat: add ending resolver and run summary
feat: add conditional follow-ups
feat: add debug overlay
test: complete phase 1 acceptance pass
```

---

## 20. Cursor implementation protocol

Every implementation prompt should instruct Cursor to:

1. Read the relevant PRDs.
2. Inspect existing files before editing.
3. Preserve working behavior.
4. Implement only the requested milestone.
5. Avoid adding plugins or external dependencies.
6. Use typed GDScript.
7. List changed files.
8. Explain manual Godot steps.
9. Report uncertainties.
10. Avoid pretending the project ran if it did not actually run.

Recommended prompt template:

```text
Read:
- docs/00_PHASE_1_MASTER_PRD.md
- docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md
- docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md

Implement Milestone X only.

Before changing files:
- inspect the current project structure
- identify existing systems that should be reused
- do not rewrite unrelated working code

Requirements:
[insert milestone requirements]

After implementation:
- list all changed files
- explain any manual Godot editor steps
- identify tests I should run
- mention any assumptions
```

---

## 21. Milestone implementation sequence

### Milestone 1 — Boot and screen flow

Deliver:

- Main.tscn
- StartScreen.tscn
- GameScreen placeholder
- RunEndScreen placeholder
- Basic screen switching

Acceptance:

- App launches
- Start button opens Game Screen
- Debug action can open Run End Screen
- Return/restart navigation works

### Milestone 2 — RunState and GameManager

Deliver:

- RunState
- GameManager
- Default initialization
- Day and resource exposure
- Restart

Acceptance:

- New run always starts clean
- State is not stored in UI
- Debug printing works

### Milestone 3 — Content loading and validation

Deliver:

- ContentRepository
- ContentValidator
- Country/advisor/law/ending/decision files

Acceptance:

- Catalog counts print
- Invalid IDs are reported
- Start is blocked on fatal validation errors in debug

### Milestone 4 — Decision Engine

Deliver:

- Requirement evaluation
- Weighted selection
- One-time filtering
- Forced next decision
- Fallback

Acceptance:

- Conditional cards appear only when valid
- Same seed can reproduce selection sequence under same choices

### Milestone 5 — Effect resolution

Deliver:

- Resource effects
- Laws
- Flags
- Counters
- History
- DecisionResult

Acceptance:

- Actual deltas are correct
- No duplicates
- UI receives normalized result

### Milestone 6 — Main gameplay UI

Deliver:

- Resource bar
- Country placeholder
- Decision card
- Choice buttons
- Result panel
- Active laws

Acceptance:

- Full choose/result/continue loop works

### Milestone 7 — Endings

Deliver:

- EndingResolver
- Four resource endings
- One special ending
- Max-day ending
- RunSummary
- Run End Screen

Acceptance:

- Each ending can be forced and displayed
- Restart works

### Milestone 8 — Country visual state

Deliver:

- CountryStateResolver
- Placeholder state mapping
- Law visual props

Acceptance:

- Resource thresholds visibly change country state
- Laws add props

### Milestone 9 — Debug tools

Deliver:

- Debug overlay
- Force decision
- Set resource
- Trigger ending
- Reload content
- Print state

Acceptance:

- All major paths can be tested quickly

### Milestone 10 — Save and final QA

Deliver:

- SaveManager
- Unlocked endings
- Last summary
- Regression fixes

Acceptance:

- Unlock survives restart
- All QA checklist items pass

---

## 22. Performance requirements

Phase 1 targets are modest:

- No per-frame JSON parsing
- Content loaded once at boot or explicit reload
- No expensive recursion
- No large textures
- No active physics simulation
- No continuously spawning nodes
- No repeated signal connection leaks
- Stable at 60 FPS on development Mac

Mobile optimization is not the main objective yet, but architecture should not create obvious problems.

---

## 23. Security and privacy

Phase 1 is offline and stores no personal data.

No:

- Network calls
- User identifiers
- Analytics events
- Authentication
- External APIs

---

## 24. Technical definition of done

- Project opens without parse errors.
- All autoloads resolve.
- No missing required scene paths.
- Content validation passes.
- Core loop functions.
- Restart does not leak state.
- UI does not own gameplay state.
- New decision can be added via JSON only.
- Debug overlay can reproduce major states.
- Save file is versioned if persistence is implemented.
- Code is commented where behavior is non-obvious.
- All acceptance tests in QA PRD pass.
