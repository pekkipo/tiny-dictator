# Tiny Dictator — Phase 1 Implementation Roadmap

**Purpose:** Single source of truth for implementation order, per-milestone scope, acceptance, and current status.
**Rule:** Implement exactly one milestone per Cursor task. Commit after each milestone passes its acceptance checks.

---

## Status overview

| # | Milestone | Status | Commit |
|---|-----------|--------|--------|
| 1 | Boot and basic screen navigation | ✅ Done (needs manual click-through + commit) | — |
| 2 | RunState and GameManager | ⬜ Not started | — |
| 3 | Content loading and validation | ⬜ Not started | — |
| 4 | Decision Engine | ⬜ Not started | — |
| 5 | Choice and effect resolution | ⬜ Not started | — |
| 6 | Main gameplay UI | ⬜ Not started | — |
| 7 | Endings and restart flow | ⬜ Not started | — |
| 8 | Placeholder country reactions | ⬜ Not started | — |
| 9 | Debug tools | ⬜ Not started | — |
| 10 | Save system and QA | ⬜ Not started | — |

Update this table (status + commit hash) after every milestone.

---

## Document map

Read per milestone — never all at once:

| Milestone | Required docs |
|-----------|---------------|
| 1 | 00, 02, 04 |
| 2 | 00, 01, 04 |
| 3 | 00, 03, 04 |
| 4 | 01, 03, 04 |
| 5 | 01, 03, 04 |
| 6 | 01, 02, 04 |
| 7 | 01, 02, 03 |
| 8 | 02, 04 |
| 9 | 02, 04, 05 |
| 10 | 04, 05 |

`GAME_DESIGN.md`, `TECHNICAL_DESIGN.md`, and `CONTENT_GUIDE.md` are **legacy pre-PRD notes**. Where they conflict with the numbered PRDs, the numbered PRDs win. Do not use them as implementation specs.

---

## Milestone 1 — Boot and basic screen navigation ✅

**Objective:** Project opens, portrait layout works, screens switch.

**Delivered:**
- `scenes/main/Main.tscn` + `scripts/ui/Main.gd` — instantiates one screen at a time into `ScreenContainer`, frees the previous one
- `scenes/screens/StartScreen.tscn` + `scripts/ui/StartScreen.gd`
- `scenes/screens/GameScreen.tscn` + `scripts/ui/GameScreen.gd` (placeholder)
- `scenes/screens/RunEndScreen.tscn` + `scripts/ui/RunEndScreen.gd` (placeholder)
- `scripts/core/GameManager.gd` reduced to a stub (full version in Milestone 2)
- Temporary debug buttons: Start→RunEnd, Game→RunEnd, Game→Start, RunEnd→Game/Start

**Acceptance (from PRD 04 §21):**
- [x] App launches without errors (validated headless, Godot 4.7)
- [ ] Start button opens Game Screen — verify manually in editor
- [ ] Debug button opens Run End Screen — verify manually in editor
- [ ] Return/restart navigation works — verify manually in editor
- [ ] Committed to git

**Remaining before sign-off:** one manual click-through in the editor, then commit (suggested message: `feat: milestone 1 boot and screen navigation`).

---

## Milestone 2 — RunState and GameManager

**Objective:** Clean run lifecycle state, owned outside UI.

**Deliverables:**
- Rewrite `scripts/core/RunState.gd` to PRD 01 §4: four typed resource fields (`treasury`, `happiness`, `order`, `elite_loyalty`), `active_laws`, `flags` (Array[String], not Dictionary), `counters`, `used_decision_ids`, `decision_history`, `current_decision_id`, `run_phase`, `random_seed`; full method set including `change_resource()` returning the actual applied delta after 0–100 clamping; `to_dictionary()`/`from_dictionary()`
- `RunPhase` enum per PRD 01 §2
- Rewrite `scripts/core/GameManager.gd` (autoload) with lifecycle methods from PRD 04 §4: `start_new_run()`, `restart_run()`, `return_to_main_menu()`, `get_current_state()`; decision/content methods stay stubbed
- Update `scripts/core/EventBus.gd` signals to PRD 01 §21 (`run_started`, `run_ended`, `run_reset`, etc.)
- Wire Main/StartScreen navigation through GameManager instead of direct signals where appropriate

**Legacy cleanup in this milestone:**
- Delete or rewrite `scripts/core/ResourceManager.gd` (old `approval`/`money` model; clamping moves into RunState per PRD 01)
- Delete `scripts/models/*` old data classes if they conflict (`DecisionData`, `AdvisorData`, `LawData`, `EndingData` — PRDs use Dictionaries + `DecisionResult`/`RunSummary`/`CountryVisualState` models)

**Acceptance:** new run always starts clean; state never stored in UI nodes; resources clamp 0–100 with correct applied delta (TC-003/TC-004 logic); debug print of state works.

---

## Milestone 3 — Content loading and validation

**Objective:** All content loads from JSON with strict validation.

**Deliverables:**
- `scripts/core/ContentRepository.gd` per PRD 04 §5 (catalogs: countries, advisors, laws, decisions, endings; multi-file decision loading)
- `scripts/core/ContentValidator.gd` per PRD 04 §6 + PRD 03 §18 (unique IDs, referenced IDs exist, required fields, day ranges, weights)
- Data files matching PRD 03 schemas:
  - `data/countries/ministan.json`
  - `data/advisors/advisors.json` (general_boom, minister_penny, luna_news, auntie_olga)
  - `data/laws/laws.json` (6 laws per PRD 03 §20)
  - `data/endings/endings.json` (7 endings per PRD 03 §20)
  - `data/decisions/ministan_core.json` + `ministan_followups.json`

**Legacy cleanup in this milestone:**
- Replace `data/decisions/ministan_decisions.json` (wrong schema: `money`/`approval`/`corruption`, 3 choices) with PRD-schema files
- Delete `data/scenarios/scenarios.json` (countries file replaces it)
- Rewrite old `data/advisors/advisors.json`, `data/laws/laws.json`, `data/endings/endings.json` to PRD 03 schemas

**Acceptance:** catalog counts print at boot (`[CONTENT]` log); duplicate/missing IDs produce clear errors naming file and ID; fatal validation blocks starting a run in debug.

---

## Milestone 4 — Decision Engine

**Objective:** Valid decision selection, data-driven.

**Deliverables:**
- Rewrite `scripts/core/DecisionEngine.gd` per PRD 04 §7 + PRD 03 §11–14: full requirements evaluator (`all/any/blocked` flags and laws, min/max resources, counters, day range, used/not-used decisions), one-time filtering, weighted random selection (default weight 10), forced follow-up (`set_forced_decision`), fallback decision, seeded RNG

**Acceptance:** conditional cards appear only when requirements pass (TC-007/TC-008); one-time cards never repeat (TC-009); same seed + same choices reproduces the sequence (TC-014); empty pool logs the reason and falls back safely.

---

## Milestone 5 — Choice and effect resolution

**Objective:** Choosing an option mutates state correctly and produces a normalized result.

**Deliverables:**
- `scripts/core/EffectResolver.gd` per PRD 04 §8: applies effects/laws/flags/counters, records forced follow-up and explicit ending, appends history, marks decisions used
- `scripts/models/DecisionResult.gd` per PRD 01 §6
- GameManager flow: `choose_left()`/`choose_right()`/`resolve_choice()`/`continue_after_result()`, run phase transitions per PRD 01 §5

**Acceptance:** actual deltas correct after clamping; no duplicate laws (TC-005/TC-006); double-click cannot resolve twice (TC-002); history matches choices; UI receives only the normalized `DecisionResult`.

---

## Milestone 6 — Main gameplay UI

**Objective:** Full choose → result → continue loop on screen.

**Deliverables (per PRD 02 §7–13):**
- Components under `scenes/components/`: `ResourceBar`, `ResourceItem`, `DecisionCard`, `ResultPanel`, `ActiveLawsBar`, `AdvisorHeader`
- Rebuild `scenes/screens/GameScreen.tscn`: TopBar (country, day, resources), diorama placeholder area, decision card, result panel (hidden until choice), laws bar
- Delta feedback (`+8`/`-10`) on changed resources; danger coloring with numbers always visible
- Mandatory explicit Continue button after each result

**Legacy cleanup in this milestone:** delete `scenes/game/*` (old GameScreen, ResourceBar, DecisionCard, etc.), `scenes/screens/CollectionScreen.tscn`, `PalaceScreen.tscn`, and their orphaned UI scripts — superseded by the new components.

**Acceptance:** full loop works for many consecutive days; buttons disabled during resolution; 220-char proposals wrap without clipping (UI-001); laws bar updates immediately.

---

## Milestone 7 — Endings and restart flow

**Objective:** Runs end correctly and restart is clean.

**Deliverables:**
- `scripts/core/EndingResolver.gd` per PRD 04 §9, priority: explicit → special (priority desc) → resource collapse (elite_coup > revolution > chaos_country > bankrupt_leader) → max day → none
- `scripts/models/RunSummary.gd` per PRD 04 §12
- Rebuild `scenes/screens/RunEndScreen.tscn` with real data: newspaper masthead, ending title/description, final day, four final resources, laws count, RULE AGAIN + MAIN MENU

**Acceptance:** each of the 7 endings can trigger and display; day does not increment on a fatal decision; restart resets everything (TC-020); ten consecutive restarts leak nothing.

---

## Milestone 8 — Placeholder country reactions

**Objective:** Visible country state changes.

**Deliverables:**
- `scripts/core/CountryStateResolver.gd` + `scripts/models/CountryVisualState.gd` per PRD 04 §10 (prosperity/mood/stability/elite states + visual tags)
- `scenes/components/CountryDiorama.tscn` per PRD 02 §9: emoji/color placeholders, mood overlay, state description label
- `data/visual_states/country_visual_map.json` — law → prop mapping (🍕 😁 🐱 🪖 🪟)

**Acceptance:** resource thresholds visibly change the country; enacting a law adds its prop; resolver never touches UI nodes.

---

## Milestone 9 — Debug tools

**Objective:** Every major state reachable in seconds.

**Deliverables (per PRD 02 §15 + PRD 05 §7):**
- `scenes/components/DebugOverlay.tscn` on a CanvasLayer in Main, toggled with F1/backtick
- Controls: view phase/seed/decision ID/flags/laws/counters; set resources; force decision by ID; add law/flag; trigger ending; restart; print state JSON; fixed seed; reload content

**Acceptance:** hidden overlay intercepts no input; every ending can be forced; invalid debug IDs log a message instead of crashing.

---

## Milestone 10 — Save system and QA

**Objective:** Persistence plus full acceptance pass.

**Deliverables:**
- `scripts/core/SaveManager.gd` per PRD 04 §13: versioned `user://save.json`, unlocked endings, corrupt-file recovery
- Run the full PRD 05 checklist: smoke tests, TC-001…TC-020, UI-001…UI-008, CV-001…CV-010, SAVE-001…SAVE-004
- Five recorded internal playthroughs (PRD 05 §8)
- `README.md` + `KNOWN_ISSUES.md` per PRD 05 §14
- Tag/commit `phase-1-prototype`

**Acceptance:** PRD 05 §15 final sign-off checklist fully checked.

---

## Content workstream (parallel to Milestones 4–10)

Content can be authored in JSON independently once Milestone 3 lands the schemas. Targets from PRD 00 §7 and PRD 03 §19–20:

- 24 standard decisions + 6 conditional follow-ups (stretch: 40 total)
- Four chains: Traffic savings, Free pizza, Mandatory smiling, Cat politics
- 6 laws, 8 flags, 7 endings, 1 fallback decision
- Authoring rules: PRD 03 §21 (character limits, one advisor voice, no real-world politics)

---

## Working agreement

1. One milestone per Cursor task; prompt template in PRD 04 §20.
2. Read only the docs mapped to the milestone.
3. Inspect existing files before editing; preserve working behavior.
4. Typed GDScript, Godot 4, no plugins or external dependencies.
5. After each milestone: list changed files, run headless boot validation, do a manual smoke test, commit, update the status table above.
6. Never claim something runs without actually validating it.
