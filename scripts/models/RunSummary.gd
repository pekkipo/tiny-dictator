class_name RunSummary
extends RefCounted

## Immutable snapshot generated once when a run ends; the Run End Screen
## displays this instead of reading RunState.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §12.

var ending_id: String = ""
var ending_title: String = ""
var ending_description: String = ""
var final_day: int = 1
var final_resources: Dictionary = {}
var active_laws: Array[String] = []
var decision_history: Array[Dictionary] = []
var random_seed: int = 0
var legacy_text: String = ""
