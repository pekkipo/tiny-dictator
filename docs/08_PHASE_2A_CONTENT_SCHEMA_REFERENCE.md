# Tiny Dictator — Phase 2A Content Schema Reference

**Purpose:** Practical authoring reference for Phase 2B content production.  
**Design rationale:** See [06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md](06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md).  
**Status:** Frozen at Phase 2A completion (save schema v2, decision schema v2).

---

## Quick validation commands

```bash
GODOT="/Applications/Godot.app/Contents/MacOS/Godot"

# Boot + content validation
$GODOT --headless --path . -s tests/test_content_validation.gd

# Full Phase 2A acceptance matrix
$GODOT --headless --path . -s tests/run_phase_2a_qa.gd

# 1,000-run simulation report (seed 20260715)
$GODOT --headless --path . -s tests/run_2a9_sim_report.gd

# Static narrative diagnostics (in-editor: F1 → Run Static Diagnostics)
$GODOT --headless --path . -s tests/test_diagnostics_simulation.gd

# Content manifest build + validation (Milestone 2B-0)
$GODOT --headless --path . -s tests/run_content_manifest.gd

# Regenerate manifest JSON and audit markdown
$GODOT --headless --path . -s tests/run_content_manifest.gd -- --export-audit

# Manifest assertion tests
$GODOT --headless --path . -s tests/test_content_manifest.gd
```

Exports land in `user://diagnostics/` as JSON and text.

---

## 1. Decision schema v2 (final)

### Legacy compatibility

Phase 1 cards with `"left"` / `"right"` still load. `DecisionSchema.normalize()` converts them to:

```json
"options": [
  { "id": "left", "label": "...", "effects": {}, "result_text": "..." },
  { "id": "right", "label": "...", "effects": {}, "result_text": "..." }
]
```

New content should set `"schema_version": 2` and author `"options"` directly.

### Required fields

| Field | Type | Notes |
|-------|------|-------|
| `id` | string | Unique across all decision files for the country |
| `country_id` | string | e.g. `"ministan"` |
| `advisor_id` | string | Must exist in `data/advisors/` |
| `proposal` | string | Card body text |
| `options` | array | 2–3 entries, unique `id` per card |
| `options[].label` | string | Button text |
| `options[].result_text` | string | Result panel text |

### Common optional fields

| Field | Default | Notes |
|-------|---------|-------|
| `schema_version` | 1 (legacy) | Use `2` for new content |
| `card_type` | `"normal"` | See card types below |
| `one_time` | `true` | `false` = repeatable filler |
| `base_weight` | 10 | Selection weight (v2); legacy uses `weight` |
| `minimum_day` / `maximum_day` | 1 / 9999 | Day window |
| `fallback` | false | Only one per country; excluded from normal pool |
| `queue_only` | false | Selected only via forced/queued/crisis paths |
| `debug_only` | false | Excluded from normal play |
| `tags` | [] | Used by ContentDirector filtering |
| `visual_tags` | [] | Country diorama hints |
| `requirements` | {} | Eligibility gates (flags, laws, arcs, affinity, resources) |
| `pacing` | {} | `allowed_stages`, `cooldown_group`, `cooldown_days` |
| `narrative` | {} | Arc/crisis linkage (see below) |

### Card types

| `card_type` | Use |
|-------------|-----|
| `normal` | Standard two-option card |
| `crisis` | Urgent event; 2–3 options; crisis banner in UI |
| `advisor` | Relationship-focused |
| `consequence` | Delayed follow-up from narrative queue |
| `resolution` | Arc or crisis resolution |
| `recovery` | Resource rescue; biased when resource is low |
| `ending_setup` | Moves toward special ending without revealing it |

### Option fields

Each option in `options[]` may include:

```json
{
  "id": "approve",
  "label": "Approve",
  "effects": { "treasury": -5, "happiness": 3 },
  "visible_effects": { "treasury": -5 },
  "add_laws": ["law_id"],
  "remove_laws": [],
  "add_flags": ["flag_id"],
  "remove_flags": [],
  "counter_changes": { "counter_id": 1 },
  "advisor_affinity": { "general_boom": -2 },
  "trait_changes": { "authoritarian": 1 },
  "arc_actions": [{ "arc_id": "cat_politics", "action": "advance", "branch_id": "support_cats" }],
  "follow_up": { "type": "soft", "decision_id": "cheese_shortage", "minimum_delay_days": 2, "maximum_delay_days": 5, "priority": 70 },
  "force_next_decision": "hard_follow_up_id",
  "trigger_ending": "ending_id",
  "result_text": "What happened."
}
```

`arc_actions` actions: `start`, `advance`, `branch`, `pause`, `complete`, `fail`.

`follow_up` types: `hard`, `soft`, `pool` (see §4).

### Requirements block

```json
"requirements": {
  "all_flags": [],
  "any_flags": [],
  "blocked_flags": [],
  "all_laws": [],
  "any_laws": [],
  "blocked_laws": [],
  "minimum_resources": { "treasury": 40 },
  "maximum_resources": { "order": 35 },
  "minimum_counters": {},
  "maximum_counters": {},
  "minimum_day": 3,
  "maximum_day": 20,
  "used_decisions": [],
  "not_used_decisions": [],
  "active_arcs": ["cat_politics"],
  "blocked_arcs": [],
  "completed_arcs": [],
  "arc_branches": { "cat_politics": "support_cats" },
  "advisor_affinity": { "general_boom": 2 },
  "minimum_traits": {},
  "maximum_traits": {}
}
```

### Narrative block (on decisions)

```json
"narrative": {
  "arc_id": "cat_politics",
  "crisis_id": "national_power_outage",
  "beat_type": "setup",
  "step": 1,
  "branch_id": null,
  "starts_arc": true,
  "starts_crisis": true,
  "advances_arc": false,
  "resolves_arc": false,
  "importance": "major"
}
```

- `step` > 1 requires matching `current_step` on the active arc.
- `branch_id` on the decision must match runtime branch when set.
- `resolves_arc: true` requires the arc to be active.

### Minimal v2 example

```json
{
  "id": "example_decision",
  "schema_version": 2,
  "country_id": "ministan",
  "card_type": "normal",
  "advisor_id": "minister_penny",
  "proposal": "Short absurd proposal.",
  "one_time": true,
  "base_weight": 10,
  "options": [
    { "id": "no", "label": "Reject", "effects": { "happiness": 2 }, "result_text": "Rejected." },
    { "id": "yes", "label": "Approve", "effects": { "treasury": -3 }, "result_text": "Approved." }
  ],
  "tags": ["economy"]
}
```

---

## 2. Arc schema

**File:** `data/arcs/ministan_arcs.json` (or country-specific arc file referenced by `ContentRepository`).

```json
{
  "id": "cat_politics",
  "display_name": "The Cat Political Movement",
  "country_id": "ministan",
  "arc_type": "national",
  "importance": "major",
  "priority": 60,
  "minimum_start_stage": "establishment",
  "maximum_start_stage": "escalation",
  "maximum_concurrent_runs": 1,
  "exclusive_groups": ["government_replacement_arc"],
  "entry_decision_ids": ["cat_voting_rights"],
  "resolution_decision_ids": ["cat_republic_declared", "cat_party_banned", "cats_return_to_boxes"],
  "branch_ids": ["support_cats", "oppose_cats", "negotiate_cats"],
  "tags": ["cats", "politics"]
}
```

| Field | Notes |
|-------|-------|
| `arc_type` | `"national"` or `"advisor"` |
| `importance` | `"major"` or `"minor"` — affects medal bonuses |
| `exclusive_groups` | Arcs in the same group cannot run simultaneously |
| `entry_decision_ids` | Decisions with `starts_arc: true` |
| `resolution_decision_ids` | Resolution cards that complete the arc |
| `branch_ids` | Valid branch names for `arc_actions` / requirements |

### Runtime arc state (in RunState, not authored)

```json
{
  "arc_id": "cat_politics",
  "status": "active",
  "current_step": 2,
  "branch_id": "support_cats",
  "started_day": 5
}
```

Statuses: `active`, `paused`, `completed`, `failed`.

---

## 3. Crisis schema

**Definitions:** `data/crises/ministan_crises.json`  
**Crisis cards:** `data/decisions/ministan_crises.json` (decisions with `card_type: "crisis"`).

### Crisis definition

```json
{
  "id": "national_power_outage",
  "display_name": "National Power Outage",
  "country_id": "ministan",
  "severity": 2,
  "maximum_duration_days": 3,
  "resolution_required": true,
  "priority": 90,
  "start_requirements": {
    "minimum_day": 8,
    "allowed_stages": ["escalation", "instability"]
  },
  "entry_decision_id": "national_power_outage",
  "resolution_decision_id": "national_power_outage_resolution",
  "resolution_paths": [
    { "resolution_id": "hospital_restore", "option_id": "hospital_restore" },
    { "resolution_id": "science_generator", "option_id": "science_generator" }
  ],
  "failure_paths": [
    {
      "failure_id": "palace_blackout",
      "option_id": "palace_blackout",
      "trigger_ending_id": "nation_in_darkness"
    }
  ],
  "timeout": {
    "trigger_ending_id": "nation_in_darkness",
    "effects": { "happiness": -8, "order": -6 }
  },
  "tags": ["infrastructure", "crisis"]
}
```

| Field | Notes |
|---|---|
| `entry_decision_id` | Mandatory first crisis card (`starts_crisis: true`) |
| `resolution_decision_id` | Optional. When set, crisis is two-decision: resolve/fail options live on this card; `resolution_paths` / `failure_paths` `option_id`s must match it |
| One-decision crises | Omit `resolution_decision_id`; paths refer to entry options |

### Rules

- Only **one** major crisis active at a time.
- Crisis cards may have **2 or 3** options.
- While a mandatory crisis is unresolved, unrelated setup cards are suppressed.
- After the entry card is used, `CrisisManager.get_mandatory_decision_id` returns `resolution_decision_id` until that card is used or the crisis ends.
- Crisis runtime state lives in `RunState.active_crisis`.

---

## 4. Narrative event queue schema

Queued at runtime when a choice includes `follow_up` or `force_next_decision`.

### Queue entry

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
  "required_flags": [],
  "blocked_flags": ["pizza_program_cancelled"],
  "status": "pending"
}
```

Statuses: `pending`, `eligible`, `consumed`, `cancelled`, `expired`.

### Follow-up authoring

**Hard** (immediate; also sets forced decision):

```json
"force_next_decision": "traffic_tank_solution"
```

**Soft:**

```json
"follow_up": {
  "type": "soft",
  "decision_id": "cheese_shortage",
  "minimum_delay_days": 2,
  "maximum_delay_days": 5,
  "priority": 70,
  "blocked_flags": ["pizza_program_cancelled"]
}
```

**Pool** — define pool in `data/follow_up_pools/follow_up_pools.json`:

```json
{
  "id": "free_pizza_consequences",
  "decision_ids": ["cheese_shortage", "pizza_union_strike", "pineapple_referendum"]
}
```

```json
"follow_up": {
  "type": "pool",
  "pool_id": "free_pizza_consequences",
  "minimum_delay_days": 2,
  "maximum_delay_days": 6,
  "priority": 60
}
```

Priority rises as `latest_day` approaches. Overdue mandatory events win selection.

---

## 5. Advisor affinity and ruler traits

### Advisor definitions

**File:** `data/advisors/advisors.json`

```json
{
  "id": "general_boom",
  "display_name": "General Boom",
  "title": "Minister of Loud Solutions",
  "emoji": "💥",
  "tags": ["military", "order"]
}
```

### Affinity (hidden, -5 to +5)

Changed per option via `"advisor_affinity": { "general_boom": -2 }`.  
Gated in `requirements.advisor_affinity`:

```json
"requirements": {
  "advisor_affinity": { "general_boom": 2 }
}
```

Main game UI does **not** show numeric affinity. Debug overlay shows exact values.

### Ruler traits (hidden integer counters)

Changed per option via `"trait_changes": { "authoritarian": 2 }`.

Tracked traits (Ministan): `authoritarian`, `populist`, `capitalist`, `chaotic`, `scientific`, `propagandist`, `bureaucratic`, `cat_friendly`.

**Identity resolution:** `data/ruler_identities/ruler_identities.json` maps trait thresholds to run-end labels (e.g. `the_smiling_tyrant`).

---

## 6. Meta-progression and save schema v2

**File:** `user://save.json`  
**Version:** `2` (`SaveManager.SAVE_VERSION`)

```json
{
  "version": 2,
  "medals": 0,
  "total_runs_completed": 0,
  "unlocked_country_ids": ["ministan"],
  "ending_records": {
    "revolution": {
      "ending_id": "revolution",
      "unlocked": true,
      "first_unlocked_at": 1700000000,
      "times_reached": 1,
      "best_day": 12
    }
  },
  "palace_upgrades": {
    "gold_desk": { "purchased": true, "purchased_at": 1700000000 }
  },
  "settings": { "debug_enabled": true },
  "last_run_summary": {}
}
```

### Migration

- **v1 → v2:** `unlocked_endings[]` becomes `ending_records{}`. Settings and `last_run_summary` preserved.
- **Corrupt / missing version:** Safe reset to v2 defaults.
- **Mid-run state is never saved.** Only meta progression persists.

### Medals (prototype formula)

```
base = floor(days_survived / 3)
new ending = +5
major arc completed = +3
minor arc completed = +1
```

### Palace upgrades

**File:** `data/meta/palace_upgrades.json`

```json
{
  "id": "gold_desk",
  "display_name": "Gold Desk",
  "description": "A desk so shiny it counts as foreign policy.",
  "cost": 5,
  "emoji": "🪑"
}
```

---

## 7. How to add content (data only)

No GDScript changes required for normal additions. Reload content via debug overlay or restart Godot.

### Add a decision

1. Open or create a file listed in `data/countries/ministan.json` → `decision_files`.
2. Add a unique `id` entry with `schema_version: 2` and `options` array.
3. Set `advisor_id` to an existing advisor.
4. Run `tests/test_content_validation.gd`.

### Add a narrative arc

1. Add arc definition to `data/arcs/ministan_arcs.json`.
2. Author entry card (`starts_arc: true`), branch steps, and resolution cards (`resolves_arc: true`).
3. Wire `arc_actions` on options to `start` / `advance` / `branch` / `complete` / `fail`.
4. Use `requirements.active_arcs` and `requirements.arc_branches` on follow-up cards.
5. Run static diagnostics; confirm no `arcs_no_reachable_resolution` errors.

### Add a crisis

1. Add crisis definition to `data/crises/ministan_crises.json`.
2. Add crisis decision card to a decision file (`card_type: "crisis"`, `narrative.starts_crisis: true`).
3. Define `resolution_paths` and optional `failure_paths` / `timeout`.
4. Force-test via debug overlay → Force Crisis.

### Add an advisor

1. Add entry to `data/advisors/advisors.json` with unique `id`, `display_name`, `emoji`.
2. Reference `advisor_id` in decisions. Placeholder emoji is sufficient for Phase 2B.

### Add a law

1. Add entry to `data/laws/laws.json` with unique `id`, `display_name`, `description`, `emoji`.
2. Reference via `add_laws` on options or `requirements.all_laws`.
3. Optional: add visual mapping in `data/visual_states/country_visual_map.json`.

### Add an ending

1. Add entry to `data/endings/endings.json` with `id`, `title`, `description`, `newspaper_headline`, `priority`.
2. Define `conditions` (resources, flags, laws, completed_arcs, traits, etc.).
3. Trigger via option `trigger_ending` or crisis `failure_paths` / `timeout`.
4. Confirm reachability in simulation report.

---

## 8. Country configuration

**File:** `data/countries/ministan.json`

Key fields for pacing:

```json
{
  "max_day": 40,
  "run_stages": [
    { "id": "establishment", "minimum_day": 1,  "maximum_day": 7 },
    { "id": "escalation",    "minimum_day": 8,  "maximum_day": 16 },
    { "id": "instability",   "minimum_day": 17, "maximum_day": 27 },
    { "id": "endgame",       "minimum_day": 28, "maximum_day": 40 }
  ],
  "fallback_decision_id": "generic_minister_disagreement",
  "fallback_decision_limit": 2,
  "survival_ending_id": "survived_the_prototype",
  "decision_files": [ "res://data/decisions/..." ]
}
```

---

## 9. Debug overlay forcing guide

Press **F1** or **`** in the editor.

| Action | Use |
|--------|-----|
| Force Decision | Jump to any decision by ID |
| Start / Advance / Complete / Fail Arc | Walk arc branches |
| Force Crisis | Trigger crisis entry card |
| Add / Cancel / Force Queue Event | Test delayed consequences |
| Set resource | Trigger recovery-card bias |
| Trigger Ending | Verify ending presentation |
| Sim 100 / Sim 1000 | Headless balance batch |
| Run Static Diagnostics | Unreachable cards, cycles, validator |
| Reload Content | Hot-reload JSON without restart |
| Reset Save | Clear meta progression |

Simulations and diagnostics **never write** to the real player save.

---

## 10. Static diagnostics findings

`ContentDiagnostics` reports (severity order):

| Finding | Severity | Meaning |
|---------|----------|---------|
| `validator_errors` | error | Blocking — fix before ship |
| `forced_follow_up_cycles` | error | Infinite forced loop |
| `validator_warnings` | warning | Review |
| `unreachable_decisions` | warning | No optimistic path from day-1 entries (arc-gated cards often appear here; expected) |
| `arcs_no_reachable_resolution` | error | Arc cannot complete |
| `endings_impossible` | warning | Conditions contradict day-1 state (resource-collapse endings) |
| `dominant_choice_options` | info | One option always better on paper |
| `excessive_advisor_concentration` | info | Advisor over-represented |

---

## 11. Content manifest (Phase 2B-0)

Development-only inventory at `data/content_manifest.json`. **Not loaded at game boot.**

Tracks every decision and catalog item with:

- `primary_content_class` (onboarding, standalone, short_chain, major_arc, crisis, recovery, endgame)
- Review gates: schema, graph, manual test, voice, balance
- `status` (only `approved` counts toward the 330-decision strong-launch target)
- Computed `quota_report` and `distribution_report`

Human-readable audit: [docs/content/PHASE_2A_CONTENT_AUDIT.md](content/PHASE_2A_CONTENT_AUDIT.md)

Rebuild after content changes:

```bash
godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit
```

---

## 12. Architecture freeze statement

Phase 2A is frozen at:

- **Save schema v2**
- **Decision schema v2** (legacy v1 normalized at load)
- **No further core-engine schema changes expected** before Phase 2B

Phase 2B work should be **JSON authoring, writing, balance, and playtesting** — not new managers or UI systems.
