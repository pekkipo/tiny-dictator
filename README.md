# Tiny Dictator — Phase 2A Prototype

A satirical portrait-mode strategy-comedy game. You rule the tiny fictional
country of Ministan through absurd laws, branching narrative arcs, crises, and
advisor relationships. Every choice moves four resources — Treasury 💰,
Happiness 🙂, Order 🛡, Elite Loyalty 👑 — and can enact laws with lasting,
visible consequences. Survive to day 40, complete arcs, survive crises, and
discover one of eleven endings.

**Phase 2A status:** Architecture frozen. See
[docs/PHASE_2A_COMPLETION_REPORT.md](docs/PHASE_2A_COMPLETION_REPORT.md).

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
scenes/screens/              StartScreen, GameScreen, RunEndScreen, MetaProgressScreen
scenes/components/           ResourceBar, DecisionCard, ResultPanel,
                             ActiveLawsBar, LawDetailPopup, CountryDiorama,
                             DebugOverlay
scripts/core/                GameManager, EventBus, RunState, ContentDirector,
                             ArcManager, CrisisManager, NarrativeEventQueue,
                             AdvisorRelationshipManager, RulerTraitManager,
                             MetaProgressionManager, ContentDiagnostics,
                             RunSimulator, DecisionEngine, EffectResolver, …
scripts/models/              DecisionResult, RunSummary, ContentRequest, …
scripts/ui/                  One controller per screen/component (display only)
data/                        All game content as JSON (countries, advisors,
                             decisions, arcs, crises, laws, endings, meta)
tests/                       Headless assertion test suites
docs/                        Phase 1–2A PRDs, schema reference, completion report
```

Architecture rule of thumb: UI scripts only display state and forward input to
`GameManager`; all gameplay logic lives in `scripts/core`, and all content
lives in `data/` JSON.

## Content inventory (Ministan)

| Type | Count |
|------|-------|
| Decisions | 74 |
| Arcs | 6 |
| Crises | 6 |
| Laws | 12 |
| Endings | 11 |
| Advisors | 8 |

## How to add content

See the canonical authoring reference:
[docs/08_PHASE_2A_CONTENT_SCHEMA_REFERENCE.md](docs/08_PHASE_2A_CONTENT_SCHEMA_REFERENCE.md).

Quick summary for decisions:

1. Add an entry to a file listed in `data/countries/ministan.json` → `decision_files`.
2. Use `"schema_version": 2` and an `"options"` array (2–3 options).
3. Run validation (below). No code changes needed for normal additions.

Legacy Phase 1 `left`/`right` format still works via automatic normalization.

## Debug overlay

Press **F1** or **`** (backtick) at any time:

- Live readout: phase, day, seed, stage, content request, arcs, crisis, queue
- Force decisions, arcs, crises, queued events, endings
- Set resources, laws, flags; advance day; restart run
- Sim 100 / Sim 1000 / static diagnostics export
- Reload content, reset save

## Tests

Each suite runs headless and exits non-zero on failure:

```bash
# Full Phase 2A acceptance matrix (recommended before commit)
godot --headless --path . -s tests/run_phase_2a_qa.gd

# Individual suites
godot --headless --path . -s tests/test_content_validation.gd
godot --headless --path . -s tests/test_schema_v2.gd
godot --headless --path . -s tests/test_content_director.gd
godot --headless --path . -s tests/test_arc_manager.gd
godot --headless --path . -s tests/test_narrative_event_queue.gd
godot --headless --path . -s tests/test_crisis_manager.gd
godot --headless --path . -s tests/test_advisor_ruler_identity.gd
godot --headless --path . -s tests/test_meta_progression.gd
godot --headless --path . -s tests/test_diagnostics_simulation.gd
godot --headless --path . -s tests/test_manual_path_verification.gd

# Phase 1 regression
godot --headless --path . -s tests/test_run_state.gd
godot --headless --path . -s tests/test_game_manager.gd
godot --headless --path . -s tests/test_decision_engine.gd
godot --headless --path . -s tests/test_save_manager.gd
godot --headless --path . -s tests/playthrough_sim.gd
```

1,000-run simulation report (seed `20260715`):

```bash
godot --headless --path . -s tests/run_2a9_sim_report.gd
```

If a new script class is not found after pulling changes, refresh Godot's
class cache once: `godot --headless --path . --import`.

## Save file

`user://save.json` (version **2**). Stores Medals, Ending Archive, palace
upgrades, settings, and last run summary. Corrupt or version-mismatched files
reset safely to defaults. Delete the file or use the debug overlay's RESET SAVE
to start over. Mid-run state is **not** saved.

## Current limitations

See [KNOWN_ISSUES.md](KNOWN_ISSUES.md). Phase 2A uses placeholder art, no audio,
no mobile export polish. Phase 2B focuses on content production and balance.
