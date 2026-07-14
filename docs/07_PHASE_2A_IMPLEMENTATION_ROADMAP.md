# Tiny Dictator — Phase 2A Implementation Roadmap

**Suggested repository path:** `docs/07_PHASE_2A_IMPLEMENTATION_ROADMAP.md`  
**Purpose:** Track implementation order and give Cursor one milestone at a time  
**Source of truth:** `docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md`

---

## How to use this roadmap

The Phase 2A PRD describes the complete target system.

This roadmap controls implementation order.

Do not ask Cursor to implement all milestones at once.

For every milestone:

1. Send Cursor only the prompt for the current milestone.
2. Let Cursor inspect and modify the project.
3. Run the project in Godot.
4. Test the milestone acceptance criteria.
5. Ask Cursor to fix only the discovered issues.
6. Commit the stable implementation to Git.
7. Mark the milestone complete in this file.
8. Start the next milestone in a new Cursor Agent task.

Recommended Git commit format:

```text
feat: complete phase 2a milestone 2a-1 schema v2
```

---

# Status

```text
[ ] 2A-1 Schema v2 and option normalization
[ ] 2A-2 Run stages and Content Director skeleton
[ ] 2A-3 Arc Manager
[ ] 2A-4 Narrative event queue
[ ] 2A-5 Crisis system
[ ] 2A-6 Advisors, affinity, and ruler identity
[ ] 2A-7 Meta-progression skeleton
[ ] 2A-8 Diagnostics and simulation
[ ] 2A-9 Representative content pack
[ ] 2A-10 QA and architecture freeze
```

---

# Milestone 2A-1 — Schema v2 and option normalization

## Goal

Upgrade decision content from fixed `left/right` choices to a flexible `options` array while preserving all Phase 1 content.

## Cursor must read

- `docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md`
- `docs/03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md`
- `docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md`
- `docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md`
- `docs/07_PHASE_2A_IMPLEMENTATION_ROADMAP.md`

## Deliverables

- Decision schema version support.
- Legacy decision normalization.
- Two-to-three options.
- Option-ID-based resolution.
- Card type field.
- Updated validation.
- One placeholder three-option card.
- No arcs or crisis engine yet.

## Acceptance

- Legacy cards still work.
- Schema-v2 two-option cards work.
- Schema-v2 three-option card renders and resolves.
- Restart remains clean.
- Existing saves do not break.

---

# Milestone 2A-2 — Run stages and Content Director skeleton

## Goal

Make card selection aware of the current stage and current gameplay need.

## Cursor must read

- `docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md`
- `docs/03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md`
- `docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md`
- `docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md`
- `docs/07_PHASE_2A_IMPLEMENTATION_ROADMAP.md`

## Deliverables

- Run-stage configuration.
- Stage derivation.
- `ContentDirector.gd`.
- Content request model.
- Stage-aware card selection.
- Recovery request when a resource is critically low.
- Endgame suppression of long setup cards.
- Debug display of current stage and request type.

## Acceptance

- Stage changes at configured days.
- Debug overlay shows stage.
- Low resource increases recovery-card selection.
- Endgame avoids configured long setup cards.
- Existing forced follow-ups still win over the Content Director.

---

# Milestone 2A-3 — Arc Manager

## Goal

Support multi-step, branching narrative arcs.

## Deliverables

- Arc catalog.
- Arc runtime state.
- Start, advance, branch, pause, complete, and fail actions.
- Arc requirements in decision eligibility.
- Arc actions in choice options.
- Exclusive arc groups.
- Debug arc controls.
- One complete representative Cat Politics arc.

## Acceptance

- Arc starts from an entry decision.
- Different choices select different branches.
- Branch-specific cards become eligible.
- Resolution completes the arc.
- Completed arc does not restart.
- Exclusive arcs cannot run simultaneously.

---

# Milestone 2A-4 — Narrative event queue

## Goal

Support consequences that appear later rather than immediately.

## Deliverables

- Narrative event queue in RunState.
- Hard follow-up.
- Soft follow-up.
- Pool follow-up.
- Earliest and latest day.
- Priority increase near deadline.
- Cancellation conditions.
- Queue debug view.
- Representative Free Pizza delayed consequence.

## Acceptance

- Soft consequence appears inside its configured window.
- Cancelled policy cancels its future consequence.
- Mandatory overdue event is selected.
- Queue survives normal day progression.
- Restart clears the queue.

---

# Milestone 2A-5 — Crisis system

## Goal

Add urgent, exceptional events with distinct pacing and two or three options.

## Deliverables

- Crisis definitions.
- `CrisisManager.gd`.
- One active major crisis.
- Crisis selection rules.
- Crisis resolution.
- Crisis failure.
- Distinct placeholder UI label.
- Five representative crisis definitions eventually; one is enough for initial implementation.

## Acceptance

- Crisis can be forced from debug tools.
- Three options display correctly.
- Unrelated setup cards do not interrupt a mandatory crisis.
- Crisis resolves or fails cleanly.
- Crisis may trigger an ending.

---

# Milestone 2A-6 — Advisors, affinity, and ruler identity

## Goal

Turn advisors into persistent characters and classify the player's governing style.

## Deliverables

- Eight advisor definitions.
- Hidden affinity from -5 to +5.
- Choice-driven affinity changes.
- Affinity requirements for decisions.
- Hidden ruler traits.
- Ruler identity calculation.
- Run-end identity summary.
- Debug visibility.

## Acceptance

- Choices alter advisor affinity.
- Affinity unlocks or blocks representative cards.
- Main game UI does not show exact affinity.
- Debug UI shows exact affinity.
- Run ending displays ruler identity.

---

# Milestone 2A-7 — Meta-progression skeleton

## Goal

Make progress persist across runs.

## Deliverables

- Ending Archive.
- Ending records.
- Medal calculation.
- Three placeholder palace upgrades.
- Upgrade purchasing.
- Save schema migration.
- Run reward summary.

## Acceptance

- New ending unlock persists.
- Repeated ending updates its record.
- Medals persist.
- Palace upgrade persists.
- Phase 1 save migrates without losing existing data.

---

# Milestone 2A-8 — Diagnostics and simulation

## Goal

Make large-scale content safe to author and balance.

## Deliverables

- Narrative graph diagnostics.
- Unreachable-card detection.
- Arc-without-resolution detection.
- Forced-loop detection.
- Dominant-option warnings.
- Content coverage report.
- Fast simulation for 100 or 1,000 runs.
- JSON or text report export.

## Acceptance

- Simulation runs without normal UI input.
- Known unreachable test card is detected.
- Known forced loop is detected.
- Ending distribution is reported.
- Content exhaustion count is reported.
- Same random seed can reproduce a failed simulation.

---

# Milestone 2A-9 — Representative content pack

## Goal

Prove all systems with a meaningful but not final content library.

## Target inventory

- 8 advisors.
- 40–55 decisions.
- 5 arcs.
- 5 crises.
- 12 laws.
- 11 endings.
- Recovery cards.
- Endgame resolution cards.

## Required arcs

- Cat Politics.
- Traffic and Military.
- Mandatory Happiness.
- General Boom advisor arc.
- Doctor Maybe advisor arc.

## Acceptance

- Every new Phase 2A system occurs naturally.
- At least five meaningfully different run stories are possible.
- No validation errors.
- No content exhaustion in 1,000 simulated runs.
- Special endings are reachable.

---

# Milestone 2A-10 — QA and architecture freeze

## Goal

Confirm the system is stable enough for full Phase 2B content production.

## Deliverables

- Manual path testing.
- Natural-run testing.
- Save migration testing.
- Simulation review.
- Updated schema documentation.
- Known limitations.
- Phase 2A completion checklist.
- Git tag or release branch.

## Acceptance

- New normal cards need no GDScript changes.
- New arcs need no core-engine changes.
- New crises need no UI changes.
- New advisors need only data and placeholder assets.
- Debug tools can force every path.
- No expected major schema changes remain.
- Phase 2B can focus primarily on writing, balance, and content.

---

# Generic Cursor prompt template

Use this only after replacing the bracketed sections.

```text
Read:

- docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md
- docs/07_PHASE_2A_IMPLEMENTATION_ROADMAP.md
- [relevant Phase 1 PRDs]

Implement only Milestone [NUMBER]: [NAME].

Before changing files:

1. Inspect the current implementation.
2. Confirm all earlier milestones that this work depends on.
3. Preserve existing working functionality.
4. Identify any data or save migrations required.
5. Do not implement later milestones.

Required deliverables:

[copy the deliverables from this roadmap]

Acceptance criteria:

[copy the acceptance criteria from this roadmap]

After implementation:

1. List all created and modified files.
2. Explain manual Godot steps.
3. Explain how to test every acceptance criterion.
4. Describe migrations and compatibility.
5. Report assumptions and unresolved issues.
6. Do not claim successful execution unless it was actually validated.
```

---

# Do not start the next milestone until

```text
[ ] Godot opens without new parse errors
[ ] Current milestone works manually
[ ] Earlier milestones still work
[ ] Acceptance criteria pass
[ ] Cursor fixes are complete
[ ] Git commit is created
[ ] Status checkbox is updated
```
