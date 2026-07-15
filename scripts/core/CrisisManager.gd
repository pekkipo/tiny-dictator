class_name CrisisManager
extends RefCounted

## Owns active-crisis lifecycle. Does not mutate resources, display UI,
## or write save files directly. Spec: docs/06_PHASE_2A §14, §28.4.

const VALID_STATUSES: Array[String] = ["active", "resolved", "failed"]
const VALID_ACTIONS: Array[String] = ["start", "resolve", "fail"]

var _repository: ContentRepository


func _init(repository: ContentRepository) -> void:
	_repository = repository


func can_start_crisis(crisis_id: String, state: RunState) -> bool:
	var crisis: Dictionary = _repository.get_crisis(crisis_id)
	if crisis.is_empty():
		return false
	if str(crisis.get("country_id", "")) != state.country_id:
		return false
	if has_active_crisis(state):
		return false
	if _crisis_terminal_this_run(crisis_id, state):
		return false
	return _matches_start_requirements(crisis, state)


func start_crisis(crisis_id: String, state: RunState) -> bool:
	if not can_start_crisis(crisis_id, state):
		return false
	var crisis: Dictionary = _repository.get_crisis(crisis_id)
	var runtime := {
		"crisis_id": crisis_id,
		"status": "active",
		"started_day": state.day,
		"severity": int(crisis.get("severity", 1)),
		"maximum_duration_days": int(crisis.get("maximum_duration_days", 3)),
		"resolution_required": bool(crisis.get("resolution_required", true)),
		"resolved_resolution_id": "",
		"failed_reason": "",
	}
	state.active_crisis = runtime
	_emit_crisis_started(crisis_id, runtime)
	print("[CRISIS] Started '%s' day=%d severity=%d" % [crisis_id, state.day, runtime["severity"]])
	return true


func force_start_crisis(crisis_id: String, state: RunState) -> bool:
	var crisis: Dictionary = _repository.get_crisis(crisis_id)
	if crisis.is_empty():
		return false
	if has_active_crisis(state):
		return false
	if _crisis_terminal_this_run(crisis_id, state):
		return false
	var runtime := {
		"crisis_id": crisis_id,
		"status": "active",
		"started_day": state.day,
		"severity": int(crisis.get("severity", 1)),
		"maximum_duration_days": int(crisis.get("maximum_duration_days", 3)),
		"resolution_required": bool(crisis.get("resolution_required", true)),
		"resolved_resolution_id": "",
		"failed_reason": "",
	}
	state.active_crisis = runtime
	_emit_crisis_started(crisis_id, runtime)
	print("[CRISIS] Force-started '%s' day=%d" % [crisis_id, state.day])
	return true


func resolve_crisis(crisis_id: String, resolution_id: String, state: RunState) -> bool:
	if not has_active_crisis(state):
		return false
	if str(state.active_crisis.get("crisis_id", "")) != crisis_id:
		return false
	var runtime: Dictionary = state.active_crisis.duplicate(true)
	runtime["status"] = "resolved"
	runtime["resolved_resolution_id"] = resolution_id
	state.active_crisis = runtime
	_emit_crisis_resolved(crisis_id, runtime)
	print("[CRISIS] Resolved '%s' via '%s'." % [crisis_id, resolution_id])
	return true


func fail_crisis(crisis_id: String, state: RunState, reason: String = "") -> bool:
	if not has_active_crisis(state):
		return false
	if str(state.active_crisis.get("crisis_id", "")) != crisis_id:
		return false
	var runtime: Dictionary = state.active_crisis.duplicate(true)
	runtime["status"] = "failed"
	runtime["failed_reason"] = reason
	state.active_crisis = runtime
	_emit_crisis_failed(crisis_id, runtime)
	print("[CRISIS] Failed '%s' reason=%s." % [crisis_id, reason])
	return true


func has_active_crisis(state: RunState) -> bool:
	return str(state.active_crisis.get("status", "")) == "active"


func get_active_crisis_id(state: RunState) -> String:
	if not has_active_crisis(state):
		return ""
	return str(state.active_crisis.get("crisis_id", ""))


func get_mandatory_decision_id(state: RunState) -> String:
	if not has_active_crisis(state):
		return ""
	var crisis_id: String = get_active_crisis_id(state)
	var crisis: Dictionary = _repository.get_crisis(crisis_id)
	if crisis.is_empty():
		return ""
	if not bool(state.active_crisis.get("resolution_required", true)):
		return ""
	var entry_id: String = str(crisis.get("entry_decision_id", ""))
	if entry_id.is_empty():
		return ""
	if entry_id in state.used_decision_ids:
		return ""
	return entry_id


func update_for_day(day: int, state: RunState) -> bool:
	if not has_active_crisis(state):
		return false
	var started_day: int = int(state.active_crisis.get("started_day", day))
	var max_days: int = int(state.active_crisis.get("maximum_duration_days", 3))
	if day - started_day < max_days:
		return false
	var crisis_id: String = get_active_crisis_id(state)
	fail_crisis(crisis_id, state, "timeout")
	return true


func get_timeout_result(state: RunState) -> Dictionary:
	var crisis_id: String = str(state.active_crisis.get("crisis_id", ""))
	var crisis: Dictionary = _repository.get_crisis(crisis_id)
	var timeout: Variant = crisis.get("timeout", {})
	if not (timeout is Dictionary):
		return {}
	return {
		"effects": timeout.get("effects", {}).duplicate(true),
		"trigger_ending_id": str(timeout.get("trigger_ending_id", "")),
	}


func get_failure_ending_for_option(crisis_id: String, option_id: String) -> String:
	var crisis: Dictionary = _repository.get_crisis(crisis_id)
	for path in crisis.get("failure_paths", []):
		if not (path is Dictionary):
			continue
		if str(path.get("option_id", "")) == option_id:
			return str(path.get("trigger_ending_id", ""))
	return ""


func apply_action(
	state: RunState,
	crisis_id: String,
	action: String,
	decision_id: String = "",
	resolution_id: String = "",
	reason: String = "",
) -> bool:
	if action not in VALID_ACTIONS:
		push_warning("[CRISIS] Unknown action '%s'." % action)
		return false
	match action:
		"start":
			return start_crisis(crisis_id, state)
		"resolve":
			return resolve_crisis(crisis_id, resolution_id, state)
		"fail":
			return fail_crisis(crisis_id, state, reason if not reason.is_empty() else decision_id)
	return false


func get_crisis_priority(crisis_id: String) -> int:
	var crisis: Dictionary = _repository.get_crisis(crisis_id)
	return int(crisis.get("priority", 90))


func get_days_remaining(state: RunState) -> int:
	if not has_active_crisis(state):
		return 0
	var started_day: int = int(state.active_crisis.get("started_day", state.day))
	var max_days: int = int(state.active_crisis.get("maximum_duration_days", 3))
	return maxi(0, max_days - (state.day - started_day))


func _crisis_terminal_this_run(crisis_id: String, state: RunState) -> bool:
	if state.active_crisis.is_empty():
		return false
	if str(state.active_crisis.get("crisis_id", "")) != crisis_id:
		return false
	var status: String = str(state.active_crisis.get("status", ""))
	return status == "resolved" or status == "failed"


func _matches_start_requirements(crisis: Dictionary, state: RunState) -> bool:
	var requirements: Variant = crisis.get("start_requirements", {})
	if not (requirements is Dictionary) or requirements.is_empty():
		return true
	if not RequirementsEvaluator.matches(requirements, state):
		return false
	var allowed_stages: Variant = requirements.get("allowed_stages", [])
	if allowed_stages is Array and not allowed_stages.is_empty():
		if state.current_stage_id.is_empty():
			return false
		if state.current_stage_id not in allowed_stages:
			return false
	return true


func _emit_crisis_started(crisis_id: String, runtime: Dictionary) -> void:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	var event_bus: Node = tree.root.get_node_or_null("EventBus")
	if event_bus:
		event_bus.crisis_started.emit(crisis_id, runtime)


func _emit_crisis_resolved(crisis_id: String, runtime: Dictionary) -> void:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	var event_bus: Node = tree.root.get_node_or_null("EventBus")
	if event_bus:
		event_bus.crisis_resolved.emit(crisis_id, runtime)


func _emit_crisis_failed(crisis_id: String, runtime: Dictionary) -> void:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	var event_bus: Node = tree.root.get_node_or_null("EventBus")
	if event_bus:
		event_bus.crisis_failed.emit(crisis_id, runtime)
