# Tiny Dictator — Phase 1 Implementation Roadmap

**Purpose:** Single source of truth for implementation order, per-milestone scope, acceptance, and current status.
**Rule:** Implement exactly one milestone per Cursor task. Commit after each milestone passes its acceptance checks.

---

## Status overview

| # | Milestone | Status | Commit |
|---|-----------|--------|--------|
| 1 | Boot and basic screen navigation | ✅ Done | `454e614` |
| 2 | RunState and GameManager | ✅ Done | `1a057f0` |
| 3 | Content loading and validation | ✅ Done | `d1df89e` |
| 4 | Decision Engine | ✅ Done | `32d1b18` |
| 5 | Choice and effect resolution | ✅ Done | `97568b2` |
| 6 | Main gameplay UI | ✅ Done | `8772603` |
| 7 | Endings and restart flow | ✅ Done | `7fa3d03` |
| 8 | Placeholder country reactions | ✅ Done | `d986086` |
| 9 | Debug tools | ✅ Done | pending commit |
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

Files in `docs/legacy/` (`GAME_DESIGN.md`, `TECHNICAL_DESIGN.md`, `CONTENT_GUIDE.md`) are **legacy pre-PRD notes**. Where they conflict with the numbered PRDs, the numbered PRDs win. Do not use them as implementation specs.

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
- [x] Start button opens Game Screen
- [x] Debug button opens Run End Screen
- [x] Return/restart navigation works
- [x] Committed to git (`454e614`)

---

## Milestone 2 — RunState and GameManager ✅

**Objective:** Clean run lifecycle state, owned outside UI.

**Delivered:**
- `scripts/core/RunState.gd` rewritten to PRD 01 §4: four typed resources, `RunPhase` enum, laws/flags/counters/used-decisions/history, `change_resource()` returning actual applied delta after 0–100 clamping, `to_dictionary()`/`from_dictionary()`
- `scripts/core/GameManager.gd` rewritten (autoload): `start_new_run()`, `restart_run()`, `return_to_main_menu()`, `get_current_state()`, `debug_set_resource()`, `debug_print_state()`; content/decision methods stubbed until M3/M4
- `scripts/core/EventBus.gd` rewritten to PRD 01 §21 signal set
- Navigation per PRD 04 §14: StartScreen → `GameManager.start_new_run()` → `run_started` → Main shows Game Screen; RunEnd buttons call `restart_run()`/`return_to_main_menu()`; debug run-end buttons remain Main-local until M7
- GameScreen placeholder now displays real day/resources from RunState
- Tests: `tests/test_run_state.gd`, `tests/test_game_manager.gd` (headless assertion scripts)

**Legacy cleanup done (expanded beyond original plan to keep the project parse-error-free):**
- Deleted `ResourceManager.gd`, `DecisionEngine.gd` (rewritten fresh in M4), `SaveManager.gd` (rewritten fresh in M10), all `scripts/models/*`
- Deleted old UI scripts (`DecisionCard`, `ResourceBar`, `ActiveLawsBar`, `CountryDiorama`) and `scenes/game/*`, `CollectionScreen.tscn`, `PalaceScreen.tscn` — they depended on the old data model and would no longer compile (M6 cleanup pulled forward)

**Acceptance (verified):**
- [x] New run always starts clean; restart creates a fresh RunState instance (tested)
- [x] State not stored in UI nodes
- [x] Clamping returns actual applied delta — TC-003/TC-004 logic (tested)
- [x] Debug state printing works
- [x] Headless boot passes with no errors

---

## Milestone 3 — Content loading and validation ✅

**Objective:** All content loads from JSON with strict validation.

**Delivered:**
- `scripts/core/ContentRepository.gd` per PRD 04 §5: catalogs for countries (directory scan), advisors, laws, decisions (multi-file per country), endings; duplicate-ID detection at load; clear errors naming file path and ID
- `scripts/core/ContentValidator.gd` per PRD 04 §6 + PRD 03 §18: required fields, referenced IDs exist (advisors, laws, endings, forced decisions), resource IDs, weights, day ranges, requirement/condition operator keys; character-limit checks are warnings (PRD 03 §21); `ValidationReport` with errors/warnings/is_valid
- Data files (PRD 03 schemas): `data/countries/ministan.json`, `advisors.json` (4), `laws.json` (6), `endings.json` (7), `ministan_core.json` (10 decisions incl. fallback) + `ministan_followups.json` (6 follow-ups). All four chains (traffic, pizza, smiling, cats) have their setup + follow-ups; cat_republic special ending is fully wired via law + flag + counter
- GameManager: loads and validates content at boot, prints `[CONTENT]` summary, refuses `start_new_run()` on validation failure, applies country starting resources; `reload_content()` ready for the M9 debug overlay
- StartScreen: Start button disabled with "CONTENT ERRORS — SEE LOG" when validation fails
- Tests: `tests/test_content_validation.gd` (repository counts, shipped content zero errors/warnings, validator catches 7 classes of broken content)

**Legacy cleanup done:** deleted `data/scenarios/scenarios.json` and old-schema `ministan_decisions.json`; rewrote advisors/laws/endings JSON to PRD schemas.

**Acceptance (verified):**
- [x] Catalog counts print at boot: `1 countries, 4 advisors, 6 laws, 16 decisions, 7 endings`
- [x] Duplicate/missing IDs produce errors naming file and ID (tested)
- [x] Fatal validation blocks starting a run and disables the Start button
- [x] Headless boot passes with 0 errors, 0 warnings

**Content note:** 16 decisions shipped (10 core + 6 follow-ups). Expanding to the 24+6 PRD target is the parallel content workstream — pure JSON authoring, no code changes.

---

## Milestone 4 — Decision Engine ✅

**Objective:** Valid decision selection, data-driven.

**Delivered:**
- `scripts/core/DecisionEngine.gd` (new, per PRD 04 §7 + PRD 03 §11–14): full requirements evaluator (`all/any/blocked` flags and laws, min/max resources, counters, day range, used/not-used decisions), one-time filtering, `debug_only` exclusion, weighted random selection (default weight 10), forced follow-up (consumed once, invalid IDs fall back to normal selection), country fallback decision on empty pool, immediate-repetition avoidance, seeded RNG injected by GameManager
- GameManager: creates a seeded engine per run, selects and presents the first decision at run start (`decision_presented` after `run_started`), exposes `get_current_decision()` and `force_decision()` for the debug overlay
- GameScreen placeholder now shows the selected advisor and proposal (read-only until M6)
- Tests: `tests/test_decision_engine.gd` (10 test groups: pool contents, flag gating TC-007/008, one-time TC-009, full evaluator matrix, seed reproducibility TC-014, forced TC-011/012, fallback TC-019, repetition avoidance)

**Acceptance (verified):**
- [x] Conditional cards appear only when requirements pass (tested)
- [x] One-time cards never repeat (tested)
- [x] Same seed reproduces the selection sequence (tested)
- [x] Empty pool logs the reason and uses the fallback decision (tested)
- [x] All four suites pass headless; boot clean

---

## Milestone 5 — Choice and effect resolution ✅

**Objective:** Choosing an option mutates state correctly and produces a normalized result.

**Delivered:**
- `scripts/models/DecisionResult.gd` per PRD 01 §6 (plus `forced_next_decision_id` per PRD 04 §8)
- `scripts/core/EffectResolver.gd` per PRD 04 §8: applies effects (recording actual clamped deltas), laws (dedup-safe), flags, counters; records forced follow-up and explicit ending; appends history entry (PRD 01 §11); marks decision used; fallback result text; `[EFFECT]` logging
- GameManager: `choose_left()`/`choose_right()`/`resolve_choice()`/`continue_after_result()` with full phase transitions (AWAITING → RESOLVING → SHOWING_RESULT → CHECKING_ENDING → next day); phase guards give double-click protection; forced follow-ups queued into the engine; state-change signals emitted from the resolved result; endings still stubbed (M7)
- GameScreen: temporary playable loop — two choice buttons with visible-effects summaries (respecting `visible_effects` filter), result text with actual deltas and law announcements, explicit Continue button. Replaced by real components in M6.
- Tests: `tests/test_effect_resolver.gd` (8 groups) + full-loop and forced-chain integration tests in `test_game_manager.gd`

**Acceptance (verified):**
- [x] Actual deltas correct after clamping (tested)
- [x] No duplicate laws — TC-005/TC-006 (tested)
- [x] Double-click cannot resolve twice — TC-002 (tested)
- [x] History matches actual choices with before/after snapshots (tested)
- [x] UI receives only the normalized DecisionResult
- [x] Forced chain works end to end: traffic lights → tanks (tested)
- [x] All five suites pass headless; boot clean

---

## Milestone 6 — Main gameplay UI ✅

**Objective:** Full choose → result → continue loop on screen.

**Delivered (per PRD 02 §7–13):**
- Components under `scenes/components/` with scripts in `scripts/ui/`: `ResourceItem` (icon + value + delta, danger coloring with number always visible), `ResourceBar` (four items, `update_resources`/`show_deltas`), `DecisionCard` (advisor row with emoji portrait, wrapping proposal, two choice buttons with visible-effects summaries, `choice_selected` signal), `ResultPanel` (result text, actual delta summary, law announcements, Continue button), `ActiveLawsBar` (chips, max 5 + "+N more", empty-state text). Advisor header is part of DecisionCard per PRD 02 §10.
- `GameScreen.tscn` rebuilt to the spec layout: TopBar (country name, day, resource bar), country diorama placeholder area (real diorama in M8), decision card, hidden-until-choice result panel, laws bar, debug row
- Delta feedback shows actual applied (clamped) changes; danger states colored at ≤30, collapsed at 0
- Explicit Continue button after every result (mandatory per PRD 02 §12)
- Tests: `tests/test_game_screen.gd` drives the real screen headless through 12 in-game days including double-tap protection

**Acceptance (verified):**
- [x] Full loop stable through many consecutive days (12 days automated)
- [x] Buttons disabled during resolution; double tap does not re-resolve
- [x] Proposals wrap without clipping (autowrap on all text)
- [x] Laws bar updates immediately after law changes
- [x] All six suites pass headless; boot clean

---

## Milestone 7 — Endings and restart flow ✅

**Objective:** Runs end correctly and restart is clean.

**Delivered:**
- `scripts/core/RequirementsEvaluator.gd` — shared static condition matcher; `DecisionEngine.evaluate_requirements()` now delegates to it, and `EndingResolver` uses it for ending conditions (same operator set, PRD 03 §11 / PRD 01 §14)
- `scripts/core/EndingResolver.gd` per PRD 04 §9. Priority: explicit `trigger_ending` → condition-based endings by data priority (special 100 outranks collapses 50–53; simultaneous collapses resolve by priority, TC-017) → country `max_day` survival ending → none
- `scripts/models/RunSummary.gd` per PRD 04 §12, built once by GameManager at run end (incl. generated legacy text)
- GameManager: real ending check in `continue_after_result()` (day increments only when the run continues); content-exhaustion ending when the engine returns no decision even after fallback; `_end_run()` emits `ending_triggered` + `run_ended(summary)`; `get_last_summary()`; `debug_trigger_ending(id)` for M9
- `scenes/screens/RunEndScreen.tscn` rebuilt as the newspaper: light paper panel on dark background, masthead + "Day N of the Glorious Reign", ending title/icon/description, final resources, laws count, legacy text, RULE AGAIN + MAIN MENU. Script reads only the RunSummary (placeholder shown if opened without one)
- Main switches to Run End on `run_ended`; GameScreen debug button now triggers a real ending (`revolution`) through the full flow
- EventBus payloads typed: `decision_resolved(DecisionResult)`, `run_ended(RunSummary)`
- Tests: `tests/test_ending_resolver.gd` (7 groups: all four collapses, collapse priority TC-017, explicit TC-015, unknown explicit id, special-beats-collapse TC-016, max-day TC-018), M7 section in `test_game_manager.gd` (fatal decision ends run with frozen day, post-ending input rejected, debug trigger, ten clean restarts TC-020), `tests/test_run_end_screen.gd` (newspaper populated, restart + main menu buttons)

**Acceptance (verified):**
- [x] Endings trigger and display (collapses, special, survival, explicit, exhausted all covered by tests; any ending forceable via `debug_trigger_ending`)
- [x] Day does not increment on a fatal decision (tested)
- [x] Restart resets everything — TC-020 (tested)
- [x] Ten consecutive restarts leak nothing (tested)
- [x] All eight suites pass headless; boot clean

---

## Milestone 8 — Placeholder country reactions ✅

**Objective:** Visible country state changes.

**Delivered:**
- `scripts/models/CountryVisualState.gd` per PRD 04 §10: prosperity / public_mood / stability / elite_status + visual_tags + summary_text
- `scripts/core/CountryStateResolver.gd` — pure logic, never touches UI. Tier thresholds match the resource danger coloring (>60 healthy, 31–60 middling, ≤30 bad): treasury → prosperous/normal/poor, happiness → celebrating/calm/protesting, order → stable/tense/chaotic, elite_loyalty → supportive/watching/coup_risk. Visual tags collected (deduped) from active laws' `visual_tags`
- `data/visual_states/country_visual_map.json` — visual tag → emoji prop (🍕 😁 🪟 🐱 🪖 🥱); loaded by ContentRepository (`get_visual_map()`); validator warns when a law tag has no mapping
- `scenes/components/CountryDiorama.tscn` + `scripts/ui/CountryDiorama.gd` per PRD 02 §9: sky color by mood, ground color by prosperity, palace row by elite status (👑/👀/🗡️), houses by prosperity (🏘️/🏚️), citizens by mood (🎉/🙂/🪧), stability tint overlay, law props layer, "Country state: …" summary label. Unknown tags ignored safely (PRD 04 §16)
- GameManager: owns `CountryStateResolver`, exposes `get_country_visual_state()`, emits `country_visual_state_changed` on run start, after each resolved choice, and on `debug_set_resource`
- GameScreen: diorama instance replaces the M6 placeholder; updates on refresh and on the visual-state signal
- Tests: `tests/test_country_state.gd` — resolver tier boundaries (61/60/31/30), law tags incl. unknown-law safety, visual map completeness for shipped laws, diorama rendering (bad state props/colors, recovery clears props)

**Acceptance (verified):**
- [x] Resource thresholds visibly change the country (tested at exact boundaries)
- [x] Enacting a law adds its prop; removing laws clears props (tested)
- [x] Resolver never touches UI nodes (pure RefCounted, repository + state in, model out)
- [x] All nine suites pass headless; boot clean, 0 validation warnings

---

## Milestone 9 — Debug tools ✅

**Objective:** Every major state reachable in seconds.

**Delivered (per PRD 02 §15 + PRD 05 §7):**
- `scenes/components/DebugOverlay.tscn` + `scripts/ui/DebugOverlay.gd` on a `DebugLayer` CanvasLayer (layer 100) in Main; toggled with F1 or backtick; hidden by default and invisible controls intercept no input
- State readout (refreshed live via EventBus): phase, day, seed, current decision ID, resources, laws, flags, counters
- Controls, all through normal GameManager APIs: set any resource (dropdown + spinbox), force decision by ID, add law by ID, add flag by ID, trigger any ending (dropdown built from content), advance day, restart run, print state JSON, set fixed seed, reload content. Feedback label reports success/failure — invalid IDs message instead of crashing
- New GameManager debug APIs: `debug_add_law()`, `debug_add_flag()`, `debug_advance_day()` (skips current decision, presents the next), `debug_set_fixed_seed()` (0 clears; applies from next run start)
- GameScreen now listens to `resources_changed` / `law_added` / `law_removed`, so debug edits update the resource bar, laws bar, and diorama immediately (QA §7)
- Legacy cleanup: temporary M1 debug buttons removed from StartScreen and GameScreen (the overlay supersedes them); Main's debug-signal plumbing deleted
- Tests: `tests/test_debug_overlay.gd` — hidden by default, F1/backtick key toggling via real input events, every overlay control exercised through button presses, invalid law/decision IDs produce messages not crashes, fixed seed reproduces the same first decision across restarts, trigger-ending ends the run for real

**Acceptance (verified):**
- [x] Hidden overlay intercepts no input (hidden by default; toggle via unhandled key input)
- [x] Every ending can be forced (dropdown lists all endings from content; tested end-to-end with cat_republic)
- [x] Invalid debug IDs log a message instead of crashing (tested)
- [x] Resource/law edits immediately update UI (signal wiring tested via GameManager APIs)
- [x] All ten suites pass headless; boot clean

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
