class_name ContentDirector
extends RefCounted

## Produces ContentRequest hints for DecisionEngine. Mutates only run stage id on RunState.

const RECOVERY_THRESHOLD := 20

var _repository: ContentRepository
var _last_request: ContentRequest = null


func _init(repository: ContentRepository) -> void:
	_repository = repository


func resolve_stage_id(state: RunState) -> String:
	var country: Dictionary = _repository.get_country(state.country_id)
	var run_stages: Variant = country.get("run_stages", [])
	if not (run_stages is Array) or run_stages.is_empty():
		return ""

	var last_stage_id: String = ""
	for stage in run_stages:
		if not (stage is Dictionary):
			continue
		var stage_id: String = str(stage.get("id", ""))
		if stage_id.is_empty():
			continue
		last_stage_id = stage_id
		var minimum_day: int = int(stage.get("minimum_day", 0))
		var maximum_day: int = int(stage.get("maximum_day", 0))
		if state.day >= minimum_day and state.day <= maximum_day:
			return stage_id

	return last_stage_id


func update_stage(state: RunState) -> void:
	var stage_id: String = resolve_stage_id(state)
	if stage_id == state.current_stage_id:
		return
	state.current_stage_id = stage_id
	_emit_stage_changed(stage_id)


func _emit_stage_changed(stage_id: String) -> void:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	var event_bus: Node = tree.root.get_node_or_null("EventBus")
	if event_bus:
		event_bus.stage_changed.emit(stage_id)


func build_request(
	state: RunState,
	decision_engine: DecisionEngine,
	queue: NarrativeEventQueue = null,
) -> ContentRequest:
	var request := ContentRequest.new()

	if decision_engine.has_forced_decision():
		request.request_type = "forced_follow_up"
		request.reason = "forced decision '%s'" % decision_engine.get_forced_decision_id()
	elif queue != null:
		var due_events: Array[Dictionary] = queue.get_due_events(state)
		if not due_events.is_empty():
			var top_event: Dictionary = due_events[0]
			var target_id: String = queue.resolve_target_decision(top_event, state)
			if not target_id.is_empty():
				var is_mandatory: bool = bool(top_event.get("mandatory", false))
				request.request_type = "mandatory_queued_event" if is_mandatory else "queued_event"
				request.queued_decision_id = target_id
				request.queued_event_id = str(top_event.get("event_id", ""))
				request.mandatory = is_mandatory
				request.priority = queue.get_effective_priority(top_event, state.day)
				request.reason = "queued %s -> '%s' (priority %d)" % [
					top_event.get("event_type", ""), target_id, request.priority,
				]
			else:
				push_warning("[DIRECTOR] Due queue event '%s' has no valid target." % top_event.get("event_id", ""))

	if request.request_type == "standalone":
		if _should_advance_arc(state):
			var arc_request: Dictionary = _pick_arc_request(state)
			request.request_type = "advance_arc"
			request.arc_id = str(arc_request.get("arc_id", ""))
			request.required_tags = arc_request.get("tags", [])
			request.priority = int(arc_request.get("priority", 0))
			request.reason = "active arc '%s' step %d" % [
				request.arc_id, int(arc_request.get("current_step", 0)),
			]
		elif _needs_recovery(state):
			var lowest: Dictionary = _lowest_resource_at_or_below_threshold(state)
			request.request_type = "recovery"
			request.preferred_card_types = ["recovery"]
			request.reason = "%s at %d" % [str(lowest["id"]), int(lowest["value"])]
		elif state.current_stage_id == "endgame":
			request.request_type = "endgame_resolution"
			request.preferred_card_types = ["resolution", "ending_setup"]
			request.excluded_tags = ["long_setup"]

	if state.current_stage_id == "endgame":
		request.excluded_tags = ["long_setup"]

	_last_request = request
	return request


func get_last_request() -> ContentRequest:
	return _last_request


func _needs_recovery(state: RunState) -> bool:
	for resource_id in RunState.RESOURCE_IDS:
		if state.get_resource(resource_id) <= RECOVERY_THRESHOLD:
			return true
	return false


func _lowest_resource_at_or_below_threshold(state: RunState) -> Dictionary:
	var lowest_id: String = ""
	var lowest_value: int = RECOVERY_THRESHOLD + 1
	for resource_id in RunState.RESOURCE_IDS:
		var value: int = state.get_resource(resource_id)
		if value <= RECOVERY_THRESHOLD and value < lowest_value:
			lowest_value = value
			lowest_id = resource_id
	return {"id": lowest_id, "value": lowest_value}


func _should_advance_arc(state: RunState) -> bool:
	for arc_id in state.active_arcs:
		var runtime: Dictionary = state.get_arc_runtime(str(arc_id))
		if str(runtime.get("status", "")) == "active":
			return true
	return false


func _pick_arc_request(state: RunState) -> Dictionary:
	var best: Dictionary = {}
	var best_priority: int = -1
	for arc_id in state.active_arcs:
		var runtime: Dictionary = state.get_arc_runtime(str(arc_id))
		if str(runtime.get("status", "")) != "active":
			continue
		var arc: Dictionary = _repository.get_arc(str(arc_id))
		var priority: int = int(arc.get("priority", 0))
		if priority > best_priority:
			best_priority = priority
			best = {
				"arc_id": str(arc_id),
				"current_step": int(runtime.get("current_step", 0)),
				"priority": priority,
				"tags": arc.get("tags", []),
			}
	return best
