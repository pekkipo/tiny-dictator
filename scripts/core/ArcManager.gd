class_name ArcManager
extends RefCounted

## Owns arc lifecycle and branch state. Does not mutate resources, display UI,
## or write save files directly. Spec: docs/06_PHASE_2A §8, §28.2.

const VALID_STATUSES: Array[String] = [
	"not_started", "active", "paused", "completed", "failed", "abandoned",
]

const VALID_ACTIONS: Array[String] = [
	"start", "advance", "branch", "pause", "complete", "fail", "abandon",
]

var _repository: ContentRepository


func _init(repository: ContentRepository) -> void:
	_repository = repository


func start_arc(state: RunState, arc_id: String, branch_id: String = "") -> bool:
	if not can_start_arc(arc_id, state):
		return false
	var runtime := _make_runtime(arc_id, state.day)
	runtime["status"] = "active"
	runtime["current_step"] = 1
	if not branch_id.is_empty():
		runtime["branch_id"] = branch_id
	state.active_arcs[arc_id] = runtime
	_emit_arc_started(arc_id, runtime)
	print("[ARC] Started '%s' branch=%s day=%d" % [arc_id, branch_id, state.day])
	return true


func advance_arc(state: RunState, arc_id: String, decision_id: String, branch_id: String = "") -> bool:
	var runtime: Dictionary = state.get_arc_runtime(arc_id)
	if runtime.is_empty():
		push_warning("[ARC] Cannot advance unknown arc '%s'." % arc_id)
		return false
	var status: String = str(runtime.get("status", ""))
	if status != "active" and status != "paused":
		push_warning("[ARC] Cannot advance arc '%s' with status '%s'." % [arc_id, status])
		return false
	if status == "paused":
		runtime["status"] = "active"
	runtime["current_step"] = int(runtime.get("current_step", 1)) + 1
	runtime["last_advanced_day"] = state.day
	if not decision_id.is_empty():
		var history: Array = runtime.get("history", [])
		if decision_id not in history:
			history.append(decision_id)
		runtime["history"] = history
	if not branch_id.is_empty():
		runtime["branch_id"] = branch_id
	state.active_arcs[arc_id] = runtime
	_emit_arc_advanced(arc_id, runtime)
	print("[ARC] Advanced '%s' to step %d decision=%s branch=%s" % [
		arc_id, runtime["current_step"], decision_id, runtime.get("branch_id", ""),
	])
	return true


func select_branch(state: RunState, arc_id: String, branch_id: String) -> bool:
	var runtime: Dictionary = state.get_arc_runtime(arc_id)
	if runtime.is_empty():
		push_warning("[ARC] Cannot select branch for unknown arc '%s'." % arc_id)
		return false
	if str(runtime.get("status", "")) not in ["active", "paused"]:
		return false
	if not _is_valid_branch(arc_id, branch_id):
		push_warning("[ARC] Invalid branch '%s' for arc '%s'." % [branch_id, arc_id])
		return false
	runtime["branch_id"] = branch_id
	state.active_arcs[arc_id] = runtime
	print("[ARC] Branch '%s' selected for arc '%s'." % [branch_id, arc_id])
	return true


func pause_arc(state: RunState, arc_id: String) -> bool:
	var runtime: Dictionary = state.get_arc_runtime(arc_id)
	if runtime.is_empty() or str(runtime.get("status", "")) != "active":
		return false
	runtime["status"] = "paused"
	state.active_arcs[arc_id] = runtime
	_emit_arc_paused(arc_id, runtime)
	print("[ARC] Paused '%s'." % arc_id)
	return true


func complete_arc(state: RunState, arc_id: String, resolution_id: String = "") -> bool:
	return _finish_arc(state, arc_id, "completed", resolution_id)


func fail_arc(state: RunState, arc_id: String, reason: String = "") -> bool:
	return _finish_arc(state, arc_id, "failed", reason)


func abandon_arc(state: RunState, arc_id: String, reason: String = "") -> bool:
	return _finish_arc(state, arc_id, "abandoned", reason)


func get_active_arcs(state: RunState) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for arc_id in state.active_arcs:
		var runtime: Dictionary = state.get_arc_runtime(str(arc_id))
		var status: String = str(runtime.get("status", ""))
		if status == "active" or status == "paused":
			result.append(runtime.duplicate(true))
	return result


func can_start_arc(arc_id: String, state: RunState) -> bool:
	var arc: Dictionary = _repository.get_arc(arc_id)
	if arc.is_empty():
		return false
	if state.is_arc_completed(arc_id) or state.is_arc_failed(arc_id):
		return false
	if state.is_arc_active(arc_id):
		return false
	if not _stage_allows_start(arc, state):
		return false
	if _exclusive_conflict(arc, state):
		return false
	return true


func apply_action(
	state: RunState,
	arc_id: String,
	action: String,
	decision_id: String = "",
	branch_id: String = "",
	reason: String = "",
) -> bool:
	match action:
		"start":
			return start_arc(state, arc_id, branch_id)
		"advance":
			return advance_arc(state, arc_id, decision_id, branch_id)
		"branch":
			return select_branch(state, arc_id, branch_id)
		"pause":
			return pause_arc(state, arc_id)
		"complete":
			return complete_arc(state, arc_id, decision_id)
		"fail":
			return fail_arc(state, arc_id, reason)
		"abandon":
			return abandon_arc(state, arc_id, reason)
		_:
			push_warning("[ARC] Unknown action '%s' for arc '%s'." % [action, arc_id])
			return false


func _finish_arc(state: RunState, arc_id: String, terminal_status: String, detail: String = "") -> bool:
	var runtime: Dictionary = state.get_arc_runtime(arc_id)
	if runtime.is_empty() and not (state.is_arc_active(arc_id)):
		# Allow completing/failing from catalog-only context during debug.
		if runtime.is_empty():
			runtime = _make_runtime(arc_id, state.day)
	if runtime.is_empty() and terminal_status != "completed":
		# fail/abandon without active arc: still record terminal state.
		if not state.is_arc_completed(arc_id) and not state.is_arc_failed(arc_id):
			state.failed_arc_ids.append(arc_id)
			_emit_arc_failed(arc_id, {"arc_id": arc_id, "status": terminal_status})
			print("[ARC] %s '%s' without active runtime." % [terminal_status, arc_id])
			return true
		return false
	if runtime.is_empty():
		return false

	runtime["status"] = terminal_status
	runtime["completed_day"] = state.day
	if not detail.is_empty() and terminal_status in ["completed", "failed", "abandoned"]:
		var history: Array = runtime.get("history", [])
		if detail not in history:
			history.append(detail)
		runtime["history"] = history

	state.active_arcs.erase(arc_id)
	if terminal_status == "completed":
		if arc_id not in state.completed_arc_ids:
			state.completed_arc_ids.append(arc_id)
		_emit_arc_completed(arc_id, runtime)
	elif terminal_status in ["failed", "abandoned"]:
		if arc_id not in state.failed_arc_ids:
			state.failed_arc_ids.append(arc_id)
		_emit_arc_failed(arc_id, runtime)
	print("[ARC] %s '%s' detail=%s day=%d" % [terminal_status, arc_id, detail, state.day])
	return true


func _make_runtime(arc_id: String, day: int) -> Dictionary:
	return {
		"arc_id": arc_id,
		"status": "not_started",
		"current_step": 0,
		"branch_id": "",
		"started_day": day,
		"last_advanced_day": day,
		"completed_day": null,
		"history": [],
	}


func _stage_allows_start(arc: Dictionary, state: RunState) -> bool:
	if state.current_stage_id.is_empty():
		return true
	var min_stage: String = str(arc.get("minimum_start_stage", ""))
	var max_stage: String = str(arc.get("maximum_start_stage", ""))
	if min_stage.is_empty() and max_stage.is_empty():
		return true
	var country: Dictionary = _repository.get_country(state.country_id)
	var run_stages: Variant = country.get("run_stages", [])
	if not (run_stages is Array):
		return true
	var stage_order: Array[String] = []
	for stage in run_stages:
		if stage is Dictionary:
			stage_order.append(str(stage.get("id", "")))
	var current_index: int = stage_order.find(state.current_stage_id)
	if current_index < 0:
		return true
	if not min_stage.is_empty():
		var min_index: int = stage_order.find(min_stage)
		if min_index >= 0 and current_index < min_index:
			return false
	if not max_stage.is_empty():
		var max_index: int = stage_order.find(max_stage)
		if max_index >= 0 and current_index > max_index:
			return false
	return true


func _exclusive_conflict(arc: Dictionary, state: RunState) -> bool:
	var groups: Array = arc.get("exclusive_groups", [])
	if groups.is_empty():
		return false
	for other_id in state.active_arcs:
		if str(other_id) == str(arc.get("id", "")):
			continue
		var other_runtime: Dictionary = state.get_arc_runtime(str(other_id))
		if str(other_runtime.get("status", "")) not in ["active", "paused"]:
			continue
		var other_arc: Dictionary = _repository.get_arc(str(other_id))
		for group in groups:
			if str(group) in other_arc.get("exclusive_groups", []):
				return true
	return false


func _is_valid_branch(arc_id: String, branch_id: String) -> bool:
	if branch_id.is_empty():
		return false
	var arc: Dictionary = _repository.get_arc(arc_id)
	var branch_ids: Array = arc.get("branch_ids", [])
	if branch_ids.is_empty():
		return true
	return branch_id in branch_ids


func _emit_arc_started(arc_id: String, runtime: Dictionary) -> void:
	_emit_signal("arc_started", arc_id, runtime)


func _emit_arc_advanced(arc_id: String, runtime: Dictionary) -> void:
	_emit_signal("arc_advanced", arc_id, runtime)


func _emit_arc_completed(arc_id: String, runtime: Dictionary) -> void:
	_emit_signal("arc_completed", arc_id, runtime)


func _emit_arc_failed(arc_id: String, runtime: Dictionary) -> void:
	_emit_signal("arc_failed", arc_id, runtime)


func _emit_arc_paused(arc_id: String, runtime: Dictionary) -> void:
	_emit_signal("arc_paused", arc_id, runtime)


func _emit_signal(signal_name: String, arc_id: String, runtime: Dictionary) -> void:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	var event_bus: Node = tree.root.get_node_or_null("EventBus")
	if event_bus and event_bus.has_signal(signal_name):
		event_bus.emit_signal(signal_name, arc_id, runtime)
