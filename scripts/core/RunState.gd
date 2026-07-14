class_name RunState
extends RefCounted

## Mutable state for a single run. Owns no UI and no content catalogs.
## Spec: docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md §2-§4.

enum RunPhase {
	NOT_STARTED,
	INITIALIZING,
	AWAITING_DECISION,
	RESOLVING_DECISION,
	SHOWING_RESULT,
	CHECKING_ENDING,
	ENDED,
}

const RESOURCE_IDS: Array[String] = ["treasury", "happiness", "order", "elite_loyalty"]
const RESOURCE_MIN: int = 0
const RESOURCE_MAX: int = 100
const DEFAULT_RESOURCE_VALUE: int = 55
const DEFAULT_COUNTRY_ID: String = "ministan"

var country_id: String = DEFAULT_COUNTRY_ID
var day: int = 1

var treasury: int = DEFAULT_RESOURCE_VALUE
var happiness: int = DEFAULT_RESOURCE_VALUE
var order: int = DEFAULT_RESOURCE_VALUE
var elite_loyalty: int = DEFAULT_RESOURCE_VALUE

var active_laws: Array[String] = []
var flags: Array[String] = []
var counters: Dictionary = {}
var used_decision_ids: Array[String] = []
var decision_history: Array[Dictionary] = []

var current_decision_id: String = ""
var current_stage_id: String = ""
var run_phase: RunPhase = RunPhase.NOT_STARTED
var random_seed: int = 0


func reset() -> void:
	country_id = DEFAULT_COUNTRY_ID
	day = 1
	treasury = DEFAULT_RESOURCE_VALUE
	happiness = DEFAULT_RESOURCE_VALUE
	order = DEFAULT_RESOURCE_VALUE
	elite_loyalty = DEFAULT_RESOURCE_VALUE
	active_laws.clear()
	flags.clear()
	counters.clear()
	used_decision_ids.clear()
	decision_history.clear()
	current_decision_id = ""
	current_stage_id = ""
	run_phase = RunPhase.NOT_STARTED
	random_seed = 0


func get_resource(resource_id: String) -> int:
	match resource_id:
		"treasury":
			return treasury
		"happiness":
			return happiness
		"order":
			return order
		"elite_loyalty":
			return elite_loyalty
		_:
			push_error("RunState: unknown resource id '%s'" % resource_id)
			return 0


func set_resource(resource_id: String, value: int) -> void:
	var clamped: int = clampi(value, RESOURCE_MIN, RESOURCE_MAX)
	match resource_id:
		"treasury":
			treasury = clamped
		"happiness":
			happiness = clamped
		"order":
			order = clamped
		"elite_loyalty":
			elite_loyalty = clamped
		_:
			push_error("RunState: unknown resource id '%s'" % resource_id)


## Applies a delta with clamping and returns the ACTUAL applied change,
## e.g. 95 + 10 -> 100, returns +5. Used for truthful feedback text.
func change_resource(resource_id: String, delta: int) -> int:
	if resource_id not in RESOURCE_IDS:
		push_error("RunState: unknown resource id '%s'" % resource_id)
		return 0
	var before: int = get_resource(resource_id)
	set_resource(resource_id, before + delta)
	return get_resource(resource_id) - before


func get_resources() -> Dictionary:
	return {
		"treasury": treasury,
		"happiness": happiness,
		"order": order,
		"elite_loyalty": elite_loyalty,
	}


func has_law(law_id: String) -> bool:
	return law_id in active_laws


func add_law(law_id: String) -> bool:
	if has_law(law_id):
		return false
	active_laws.append(law_id)
	return true


func remove_law(law_id: String) -> bool:
	if not has_law(law_id):
		return false
	active_laws.erase(law_id)
	return true


func has_flag(flag_id: String) -> bool:
	return flag_id in flags


func add_flag(flag_id: String) -> bool:
	if has_flag(flag_id):
		return false
	flags.append(flag_id)
	return true


func remove_flag(flag_id: String) -> bool:
	if not has_flag(flag_id):
		return false
	flags.erase(flag_id)
	return true


func get_counter(counter_id: String) -> int:
	return int(counters.get(counter_id, 0))


func change_counter(counter_id: String, delta: int) -> int:
	var new_value: int = get_counter(counter_id) + delta
	counters[counter_id] = new_value
	return new_value


func mark_decision_used(decision_id: String) -> void:
	if decision_id not in used_decision_ids:
		used_decision_ids.append(decision_id)


func add_history_entry(entry: Dictionary) -> void:
	decision_history.append(entry)


func to_dictionary() -> Dictionary:
	return {
		"country_id": country_id,
		"day": day,
		"resources": get_resources(),
		"active_laws": active_laws.duplicate(),
		"flags": flags.duplicate(),
		"counters": counters.duplicate(true),
		"used_decision_ids": used_decision_ids.duplicate(),
		"decision_history": decision_history.duplicate(true),
		"current_decision_id": current_decision_id,
		"current_stage_id": current_stage_id,
		"run_phase": RunPhase.keys()[run_phase],
		"random_seed": random_seed,
	}


func from_dictionary(data: Dictionary) -> void:
	reset()
	country_id = str(data.get("country_id", DEFAULT_COUNTRY_ID))
	day = int(data.get("day", 1))
	var resources: Dictionary = data.get("resources", {})
	for resource_id in RESOURCE_IDS:
		set_resource(resource_id, int(resources.get(resource_id, DEFAULT_RESOURCE_VALUE)))
	for law_id in data.get("active_laws", []):
		active_laws.append(str(law_id))
	for flag_id in data.get("flags", []):
		flags.append(str(flag_id))
	counters = data.get("counters", {}).duplicate(true)
	for decision_id in data.get("used_decision_ids", []):
		used_decision_ids.append(str(decision_id))
	for entry in data.get("decision_history", []):
		if entry is Dictionary:
			decision_history.append(entry)
	current_decision_id = str(data.get("current_decision_id", ""))
	current_stage_id = str(data.get("current_stage_id", ""))
	var phase_name: String = str(data.get("run_phase", "NOT_STARTED"))
	var phase_index: int = RunPhase.keys().find(phase_name)
	run_phase = phase_index as RunPhase if phase_index >= 0 else RunPhase.NOT_STARTED
	random_seed = int(data.get("random_seed", 0))
