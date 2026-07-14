# Tiny Dictator — Phase 1 PRD Set

Read these files in order:

1. `00_PHASE_1_MASTER_PRD.md`
2. `01_CORE_GAMEPLAY_AND_STATE_PRD.md`
3. `02_UI_UX_AND_SCENE_SPEC.md`
4. `03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md`
5. `04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md`
6. `05_QA_ACCEPTANCE_AND_DELIVERY_PLAN.md`

## Recommended use in Cursor

Keep these documents under the project `/docs` folder.

For each implementation task, tell Cursor to read only the master PRD plus the one or two documents relevant to that milestone. Avoid asking it to implement the entire phase in a single prompt.

Example:

```text
Read:
- docs/00_PHASE_1_MASTER_PRD.md
- docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md
- docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md

Implement Milestone 2: RunState and GameManager only.

Do not implement UI, content selection, endings, saving, or debug tools yet.
Inspect the current project first and preserve existing working files.
After implementation, list changed files and explain any manual Godot steps.
```

## Recommended first milestone

Start with:

- Main scene
- Start Screen
- Placeholder Game Screen
- Placeholder Run End Screen
- Basic screen switching

Then proceed to state and gameplay systems.
