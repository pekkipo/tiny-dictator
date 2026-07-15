class_name DecisionResult
extends RefCounted

## Normalized outcome of resolving one decision option. The UI reads this
## instead of interpreting raw option data.
## Spec: docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md §6.

var decision_id: String = ""

## Canonical since schema v2: the id of the resolved option.
var selected_option_id: String = ""

## Legacy alias kept for Phase 1 readers; mirrors selected_option_id.
var selected_side: String = ""

var choice_label: String = ""

## Actual applied deltas after clamping, keyed by resource id.
var resource_changes: Dictionary = {}

var added_laws: Array[String] = []
var removed_laws: Array[String] = []
var added_flags: Array[String] = []
var removed_flags: Array[String] = []
var counter_changes: Dictionary = {}

var result_text: String = ""
var forced_next_decision_id: String = ""
var triggered_ending_id: String = ""
var arc_changes: Array[Dictionary] = []
var queued_follow_ups: Array[Dictionary] = []
