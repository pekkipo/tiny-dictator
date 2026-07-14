# Tiny Dictator — Phase 1 Prototype

A satirical portrait-mode strategy-comedy game. You rule the tiny fictional
country of Ministan by approving or rejecting absurd proposals from four
advisors. Every choice moves four resources — Treasury 💰, Happiness 🙂,
Order 🛡, Elite Loyalty 👑 — and can enact laws with lasting, visible
consequences. Survive to day 30, or discover one of seven endings trying.

## Requirements

- **Godot 4.7** (GL Compatibility renderer, no plugins, no external dependencies)
- Target resolution: portrait 1080×1920 (responsive containers, resizable window)

## How to open and run

1. Open Godot 4.7 and import this folder (`project.godot`).
2. Press **Play** (F5). The main scene `scenes/main/Main.tscn` is preconfigured.
3. Press **START NEW RULE**.

Headless boot check from the terminal:

```bash
godot --headless --path . --quit-after 10
```

## Project structure

```text
scenes/main/Main.tscn        Screen switching + debug overlay layer
scenes/screens/              StartScreen, GameScreen, RunEndScreen
scenes/components/           ResourceBar, DecisionCard, ResultPanel,
                             ActiveLawsBar, LawDetailPopup, CountryDiorama,
                             DebugOverlay
scripts/core/                GameManager, EventBus (autoloads), RunState,
                             ContentRepository, ContentValidator, DecisionEngine,
                             DecisionSchema, EffectResolver, EndingResolver,
                             CountryStateResolver, RequirementsEvaluator,
                             LawImpactResolver, SaveManager (autoload)
scripts/models/              DecisionResult, RunSummary, CountryVisualState
scripts/ui/                  One controller per screen/component (display only)
data/                        All game content as JSON (countries, advisors,
                             decisions, laws, endings, visual states)
tests/                       Headless assertion test suites
docs/                        Phase 1 PRDs + implementation roadmap
```

Architecture rule of thumb: UI scripts only display state and forward input to
`GameManager`; all gameplay logic lives in `scripts/core`, and all content
lives in `data/` JSON.

## How to add a decision

Phase 1 legacy format (still fully supported):

1. Open `data/decisions/ministan_core.json` (or `ministan_followups.json`).
2. Add an entry with a unique `id`, an `advisor_id`, a `proposal`, and `left`/
   `right` options (each with `label`, `effects`, `result_text`; optionally
   `add_laws`, `add_flags`, `counter_changes`, `force_next_decision`,
   `trigger_ending`, `visible_effects`).
3. Optionally gate it with `requirements` and mark it `one_time`.

Schema v2 format (Phase 2A milestone 2A-1 — preferred for new content):

1. Same file, but set `"schema_version": 2` and author an `"options"` array
   (2–3 entries, each with a unique `"id"`, plus `label`, `effects`,
   `result_text`). Use `"base_weight"` instead of `"weight"`.
2. Optional `"card_type"`: `normal` (default), `crisis`, `advisor`,
   `consequence`, `resolution`, `recovery`, `ending_setup`. Non-normal types
   show a placeholder banner on the card; behavior comes in later milestones.
3. At load time `DecisionSchema.normalize()` converts legacy `left`/`right`
   into options, so the engine, resolver, and UI always read the same model.

Run the game after editing. Content is validated at boot — errors name the
file and ID, and the Start button is blocked until they are fixed. No code
changes needed for content-only additions.

## Debug overlay

Press **F1** or **`** (backtick) at any time:

- Live readout: phase, day, seed, current decision, run stage, content request, resources, laws, flags, counters
- Set any resource, force a decision by ID, add laws/flags
- Trigger any ending, advance the day, restart the run
- Fixed random seed (reproducible runs), print state JSON, reload content, reset save

## Tests

Each suite runs headless and exits non-zero on failure:

```bash
godot --headless --path . -s tests/test_run_state.gd
godot --headless --path . -s tests/test_game_manager.gd
godot --headless --path . -s tests/test_content_validation.gd
godot --headless --path . -s tests/test_decision_engine.gd
godot --headless --path . -s tests/test_effect_resolver.gd
godot --headless --path . -s tests/test_ending_resolver.gd
godot --headless --path . -s tests/test_country_state.gd
godot --headless --path . -s tests/test_game_screen.gd
godot --headless --path . -s tests/test_run_end_screen.gd
godot --headless --path . -s tests/test_debug_overlay.gd
godot --headless --path . -s tests/test_save_manager.gd
godot --headless --path . -s tests/test_law_popup.gd
godot --headless --path . -s tests/test_schema_v2.gd   # Phase 2A schema v2
godot --headless --path . -s tests/test_content_director.gd   # Phase 2A run stages + ContentDirector
godot --headless --path . -s tests/playthrough_sim.gd   # 5 automated playthroughs
```

If a new script class is not found after pulling changes, refresh Godot's
class cache once: `godot --headless --path . --import`.

## Save file

`user://save.json` (versioned). Stores unlocked endings, settings, and the
last run summary. Corrupt or version-mismatched files reset safely to
defaults. Delete the file or use the debug overlay's RESET SAVE to start over.

## Current limitations

See `KNOWN_ISSUES.md`. Phase 1 is a placeholder-art prototype: emoji visuals,
no audio, no animations, no mobile export polish, limited content volume.
