extends Node

## High-level run lifecycle coordinator (autoload).
## Owns the full core loop: run lifecycle, decision selection, choice
## resolution, ending checks, and run summaries.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §4.

const CONTENT_EXHAUSTED_ENDING_ID: String = "content_exhausted"

var _run_state: RunState = RunState.new()
var _content: ContentRepository = ContentRepository.new()
var _validator: ContentValidator = ContentValidator.new()
var _content_valid: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _decision_engine: DecisionEngine = null
var _content_director: ContentDirector = null
var _arc_manager: ArcManager = null
var _crisis_manager: CrisisManager = null
var _advisor_manager: AdvisorRelationshipManager = null
var _trait_manager: RulerTraitManager = null
var _narrative_event_queue: NarrativeEventQueue = null
var _effect_resolver: EffectResolver = EffectResolver.new()
var _ending_resolver: EndingResolver = EndingResolver.new()
var _country_state_resolver: CountryStateResolver = CountryStateResolver.new()
var _current_decision: Dictionary = {}
var _last_result: DecisionResult = null
var _last_summary: RunSummary = null

## When non-zero, the next run uses this seed instead of a random one (M9 debug).
var _debug_fixed_seed: int = 0


func _ready() -> void:
	initialize_game()


func initialize_game() -> void:
	_load_and_validate_content()
	print("[BOOT] GameManager initialized. Content valid: %s" % _content_valid)


## Debug reload for the M9 overlay; safe to call any time outside a run.
func reload_content() -> bool:
	_load_and_validate_content()
	return _content_valid


func is_content_valid() -> bool:
	return _content_valid


func get_content() -> ContentRepository:
	return _content


func start_new_run(country_id: String = "ministan") -> void:
	if not _content_valid:
		push_error("[RUN] Cannot start run: content validation failed. See [CONTENT] errors above.")
		return
	var country: Dictionary = _content.get_country(country_id)
	if country.is_empty():
		push_error("[RUN] Cannot start run: unknown country '%s'" % country_id)
		return

	_run_state = RunState.new()
	_run_state.run_phase = RunState.RunPhase.INITIALIZING
	_run_state.country_id = country_id
	_run_state.random_seed = _debug_fixed_seed if _debug_fixed_seed != 0 else randi()
	var starting_resources: Dictionary = country.get("starting_resources", {})
	for resource_id in RunState.RESOURCE_IDS:
		_run_state.set_resource(resource_id, int(starting_resources.get(resource_id, RunState.DEFAULT_RESOURCE_VALUE)))

	_rng.seed = _run_state.random_seed
	_decision_engine = DecisionEngine.new(_content, _rng)
	_content_director = ContentDirector.new(_content)
	_arc_manager = ArcManager.new(_content)
	_crisis_manager = CrisisManager.new(_content)
	_advisor_manager = AdvisorRelationshipManager.new()
	_trait_manager = RulerTraitManager.new()
	_narrative_event_queue = NarrativeEventQueue.new(_content)
	_narrative_event_queue.set_decision_engine(_decision_engine)
	_narrative_event_queue.set_rng(_rng)
	_decision_engine.set_arc_manager(_arc_manager)
	_decision_engine.set_crisis_manager(_crisis_manager)
	_advisor_manager.initialize_for_run(_run_state, _content)
	_trait_manager.initialize_for_run(_run_state)
	_last_result = null

	print("[RUN] New run started: country=%s day=%d seed=%d" % [
		_run_state.country_id, _run_state.day, _run_state.random_seed,
	])
	_content_director.update_stage(_run_state)
	_select_next_decision()
	_run_state.run_phase = RunState.RunPhase.AWAITING_DECISION
	EventBus.run_started.emit(_run_state)
	EventBus.country_visual_state_changed.emit(get_country_visual_state())
	if not _current_decision.is_empty():
		EventBus.decision_presented.emit(_current_decision)


func restart_run() -> void:
	start_new_run(_run_state.country_id)


func return_to_main_menu() -> void:
	_run_state.run_phase = RunState.RunPhase.NOT_STARTED
	EventBus.run_reset.emit()


func get_current_state() -> RunState:
	return _run_state


func get_current_decision() -> Dictionary:
	return _current_decision


func get_last_result() -> DecisionResult:
	return _last_result


## Legacy Phase 1 wrappers; on schema-v2 cards "left"/"right" alias the
## first/second option (DecisionSchema.LEGACY_ALIASES).
func choose_left() -> void:
	resolve_choice("left")


func choose_right() -> void:
	resolve_choice("right")


## Resolves the current decision by option id (schema v2). Returns null when
## the choice cannot be resolved (wrong phase = double click protection,
## TC-002).
func resolve_choice(option_id: String) -> DecisionResult:
	if _run_state.run_phase != RunState.RunPhase.AWAITING_DECISION:
		return null
	if _current_decision.is_empty():
		return null

	_run_state.run_phase = RunState.RunPhase.RESOLVING_DECISION
	var result := _effect_resolver.apply_option(
		_current_decision, option_id, _run_state, _content,
		_arc_manager, _crisis_manager, _advisor_manager, _trait_manager,
	)
	_last_result = result

	if not result.forced_next_decision_id.is_empty():
		_decision_engine.set_forced_decision(result.forced_next_decision_id)

	for queued_data in result.queued_follow_ups:
		if _narrative_event_queue != null:
			_narrative_event_queue.add_event(queued_data, _run_state)

	EventBus.resources_changed.emit(_run_state.get_resources())
	for law_id in result.added_laws:
		EventBus.law_added.emit(law_id)
	for law_id in result.removed_laws:
		EventBus.law_removed.emit(law_id)
	for flag_id in result.added_flags:
		EventBus.flag_added.emit(flag_id)
	EventBus.country_visual_state_changed.emit(get_country_visual_state())

	_run_state.run_phase = RunState.RunPhase.SHOWING_RESULT
	EventBus.decision_resolved.emit(result)
	return result


func continue_after_result() -> void:
	if _run_state.run_phase != RunState.RunPhase.SHOWING_RESULT:
		return
	_run_state.run_phase = RunState.RunPhase.CHECKING_ENDING

	var country: Dictionary = _content.get_country(_run_state.country_id)
	var ending := _ending_resolver.resolve_ending(_run_state, _last_result, country, _content)
	if not ending.is_empty():
		_end_run(ending)
		return
	print("[ENDING] No ending matched.")

	# Day increments only when the run continues (PRD 01 §12).
	_run_state.day += 1
	if _narrative_event_queue != null:
		_narrative_event_queue.update_for_day(_run_state.day, _run_state)
	if _content_director != null:
		_content_director.update_stage(_run_state)
	if _crisis_manager != null and _crisis_manager.update_for_day(_run_state.day, _run_state):
		_apply_crisis_timeout()
		ending = _ending_resolver.resolve_ending(_run_state, _last_result, country, _content)
		if not ending.is_empty():
			_end_run(ending)
			return
	_select_next_decision()
	if _current_decision.is_empty():
		# Engine already tried the fallback decision; the country is out of content.
		var exhausted: Dictionary = _content.get_ending(CONTENT_EXHAUSTED_ENDING_ID)
		if exhausted.is_empty():
			push_error("[ENDING] Content exhausted and no '%s' ending exists." % CONTENT_EXHAUSTED_ENDING_ID)
			return
		_end_run(exhausted)
		return
	_run_state.run_phase = RunState.RunPhase.AWAITING_DECISION
	EventBus.decision_presented.emit(_current_decision)


func get_last_summary() -> RunSummary:
	return _last_summary


func get_country_visual_state() -> CountryVisualState:
	return _country_state_resolver.resolve(_run_state, _content)


## Debug helper (used by the M9 overlay and debug buttons).
func debug_trigger_ending(ending_id: String) -> void:
	var ending: Dictionary = _content.get_ending(ending_id)
	if ending.is_empty():
		push_error("[DEBUG] Unknown ending '%s'." % ending_id)
		return
	_end_run(ending)


func _end_run(ending: Dictionary) -> void:
	_run_state.run_phase = RunState.RunPhase.ENDED
	_last_summary = _build_run_summary(ending)
	print("[ENDING] Run ended on day %d: %s" % [_run_state.day, _last_summary.ending_id])
	SaveManager.unlock_ending(_last_summary.ending_id)
	SaveManager.set_last_run_summary({
		"ending_id": _last_summary.ending_id,
		"final_day": _last_summary.final_day,
		"final_resources": _last_summary.final_resources,
		"laws_count": _last_summary.active_laws.size(),
		"random_seed": _last_summary.random_seed,
	})
	EventBus.ending_triggered.emit(ending)
	EventBus.run_ended.emit(_last_summary)


func _build_run_summary(ending: Dictionary) -> RunSummary:
	var summary := RunSummary.new()
	summary.ending_id = str(ending.get("id", ""))
	summary.ending_title = str(ending.get("title", "The End"))
	summary.ending_description = str(ending.get("description", ""))
	summary.final_day = _run_state.day
	summary.final_resources = _run_state.get_resources()
	summary.active_laws = _run_state.active_laws.duplicate()
	summary.decision_history = _run_state.decision_history.duplicate(true)
	summary.random_seed = _run_state.random_seed
	var identity: Dictionary = _trait_manager.resolve_identity(_run_state, _content)
	summary.ruler_identity_id = str(identity.get("id", ""))
	summary.ruler_identity_title = str(identity.get("display_name", ""))
	summary.legacy_text = "Ruled for %d day%s. Made %d decision%s. Enacted %d law%s. History remembers you as %s." % [
		summary.final_day, "" if summary.final_day == 1 else "s",
		summary.decision_history.size(), "" if summary.decision_history.size() == 1 else "s",
		summary.active_laws.size(), "" if summary.active_laws.size() == 1 else "s",
		summary.ruler_identity_title,
	]
	return summary


## Debug helper (used by the M9 overlay): queue a specific decision next.
func force_decision(decision_id: String) -> bool:
	if _decision_engine == null or not _content.has_decision(decision_id):
		return false
	_decision_engine.set_forced_decision(decision_id)
	return true


func get_current_stage_id() -> String:
	if _run_state == null:
		return ""
	return _run_state.current_stage_id


func debug_get_last_content_request() -> Dictionary:
	if _content_director == null:
		return {}
	var last_request: ContentRequest = _content_director.get_last_request()
	if last_request == null:
		return {}
	return last_request.to_dictionary()


func _select_next_decision() -> void:
	if _decision_engine == null:
		push_warning("[DECISION] No decision engine available.")
		_current_decision = {}
		_run_state.current_decision_id = ""
		return
	var request: ContentRequest = null
	if _content_director != null:
		request = _content_director.build_request(
			_run_state, _decision_engine, _narrative_event_queue, _crisis_manager,
		)
	_current_decision = _decision_engine.select_next_decision(_run_state, request)
	if _current_decision.is_empty():
		# Content exhaustion triggers an ending in Milestone 7.
		push_warning("[DECISION] No valid decision available.")
		_run_state.current_decision_id = ""
		return
	_run_state.current_decision_id = str(_current_decision["id"])
	if request != null and not request.queued_event_id.is_empty() and _narrative_event_queue != null:
		_narrative_event_queue.consume_event(
			request.queued_event_id, _run_state, _run_state.current_decision_id,
		)
	var pool_size: int = _decision_engine.get_valid_decisions(_run_state).size()
	print("[DECISION] Day %d selected '%s' (%d valid candidates)" % [
		_run_state.day, _run_state.current_decision_id, pool_size,
	])


func debug_set_resource(resource_id: String, value: int) -> void:
	_run_state.set_resource(resource_id, value)
	EventBus.resources_changed.emit(_run_state.get_resources())
	EventBus.country_visual_state_changed.emit(get_country_visual_state())


func debug_add_law(law_id: String) -> bool:
	if not _content.has_law(law_id):
		push_error("[DEBUG] Unknown law '%s'." % law_id)
		return false
	if not _run_state.add_law(law_id):
		return false
	EventBus.law_added.emit(law_id)
	EventBus.country_visual_state_changed.emit(get_country_visual_state())
	return true


func debug_add_flag(flag_id: String) -> bool:
	if flag_id.is_empty() or not _run_state.add_flag(flag_id):
		return false
	EventBus.flag_added.emit(flag_id)
	return true


## Skips the current decision and moves to the next day.
func debug_advance_day() -> bool:
	if _run_state.run_phase != RunState.RunPhase.AWAITING_DECISION:
		return false
	_run_state.day += 1
	if _narrative_event_queue != null:
		_narrative_event_queue.update_for_day(_run_state.day, _run_state)
	if _content_director != null:
		_content_director.update_stage(_run_state)
	if _content_director != null:
		_content_director.update_stage(_run_state)
	if _crisis_manager != null and _crisis_manager.update_for_day(_run_state.day, _run_state):
		_apply_crisis_timeout()
		var country: Dictionary = _content.get_country(_run_state.country_id)
		var timeout_ending := _ending_resolver.resolve_ending(_run_state, _last_result, country, _content)
		if not timeout_ending.is_empty():
			_end_run(timeout_ending)
			return true
	_select_next_decision()
	if _current_decision.is_empty():
		push_warning("[DEBUG] No decision available after advancing to day %d." % _run_state.day)
		return true
	EventBus.decision_presented.emit(_current_decision)
	return true


func debug_force_crisis(crisis_id: String) -> bool:
	if _crisis_manager == null:
		return false
	if not _crisis_manager.force_start_crisis(crisis_id, _run_state):
		return false
	var crisis: Dictionary = _content.get_crisis(crisis_id)
	var entry_id: String = str(crisis.get("entry_decision_id", ""))
	if entry_id.is_empty():
		return false
	if not force_decision(entry_id):
		return false
	if _run_state.run_phase == RunState.RunPhase.AWAITING_DECISION:
		_select_next_decision()
		if not _current_decision.is_empty():
			EventBus.decision_presented.emit(_current_decision)
	return true


func debug_advance_crisis_duration(days: int = 1) -> bool:
	if _crisis_manager == null or not _crisis_manager.has_active_crisis(_run_state):
		return false
	var runtime: Dictionary = _run_state.active_crisis.duplicate(true)
	runtime["started_day"] = int(runtime.get("started_day", _run_state.day)) - maxi(1, days)
	_run_state.active_crisis = runtime
	return true


func debug_resolve_crisis(crisis_id: String, resolution_id: String = "debug") -> bool:
	if _crisis_manager == null:
		return false
	return _crisis_manager.resolve_crisis(crisis_id, resolution_id, _run_state)


func debug_fail_crisis(crisis_id: String, reason: String = "debug") -> bool:
	if _crisis_manager == null:
		return false
	return _crisis_manager.fail_crisis(crisis_id, _run_state, reason)


func debug_get_crisis_state() -> Dictionary:
	if _run_state == null:
		return {}
	return _run_state.active_crisis.duplicate(true)


func get_crisis_days_remaining() -> int:
	if _crisis_manager == null:
		return 0
	return _crisis_manager.get_days_remaining(_run_state)


func _apply_crisis_timeout() -> void:
	var timeout: Dictionary = _crisis_manager.get_timeout_result(_run_state)
	var effects: Dictionary = timeout.get("effects", {})
	for resource_id in effects:
		_run_state.change_resource(str(resource_id), int(effects[resource_id]))
	if _last_result == null:
		_last_result = DecisionResult.new()
	var ending_id: String = str(timeout.get("trigger_ending_id", ""))
	if not ending_id.is_empty():
		_last_result.triggered_ending_id = ending_id
	EventBus.resources_changed.emit(_run_state.get_resources())


## 0 disables the fixed seed. Applies from the next run start.
func debug_set_fixed_seed(new_seed: int) -> void:
	_debug_fixed_seed = new_seed
	print("[DEBUG] Fixed seed %s." % ("cleared" if new_seed == 0 else "set to %d" % new_seed))


func debug_print_state() -> void:
	print("[DEBUG] RunState: %s" % JSON.stringify(_run_state.to_dictionary(), "  "))


func debug_start_arc(arc_id: String, branch_id: String = "") -> bool:
	if _arc_manager == null:
		return false
	return _arc_manager.start_arc(_run_state, arc_id, branch_id)


func debug_advance_arc(arc_id: String, decision_id: String = "") -> bool:
	if _arc_manager == null:
		return false
	return _arc_manager.advance_arc(_run_state, arc_id, decision_id)


func debug_select_branch(arc_id: String, branch_id: String) -> bool:
	if _arc_manager == null:
		return false
	return _arc_manager.select_branch(_run_state, arc_id, branch_id)


func debug_complete_arc(arc_id: String, resolution_id: String = "") -> bool:
	if _arc_manager == null:
		return false
	return _arc_manager.complete_arc(_run_state, arc_id, resolution_id)


func debug_fail_arc(arc_id: String) -> bool:
	if _arc_manager == null:
		return false
	return _arc_manager.fail_arc(_run_state, arc_id)


func debug_get_arc_state() -> Dictionary:
	if _run_state == null:
		return {}
	return {
		"active_arcs": _run_state.active_arcs.duplicate(true),
		"completed_arc_ids": _run_state.completed_arc_ids.duplicate(),
		"failed_arc_ids": _run_state.failed_arc_ids.duplicate(),
	}


func debug_get_queue_state() -> Array[Dictionary]:
	if _run_state == null:
		return []
	return _run_state.narrative_event_queue.duplicate(true)


func debug_add_queued_event(
	decision_id: String,
	min_delay: int = 1,
	max_delay: int = 3,
	priority: int = 50,
	required_flags: Array = [],
) -> String:
	if _narrative_event_queue == null or decision_id.is_empty():
		return ""
	if not _content.has_decision(decision_id):
		push_error("[DEBUG] Unknown decision '%s' for queue." % decision_id)
		return ""
	return _narrative_event_queue.add_event({
		"source_decision_id": "debug",
		"source_option_id": "debug",
		"follow_up": {
			"type": "soft",
			"decision_id": decision_id,
			"minimum_delay_days": min_delay,
			"maximum_delay_days": max_delay,
			"priority": priority,
			"required_flags": required_flags,
		},
	}, _run_state)


func debug_cancel_queued_event(event_id: String) -> bool:
	if _narrative_event_queue == null or event_id.is_empty():
		return false
	return _narrative_event_queue.cancel_event(event_id, _run_state)


func debug_consume_queued_event(event_id: String) -> bool:
	if _narrative_event_queue == null or event_id.is_empty():
		return false
	return _narrative_event_queue.consume_event(event_id, _run_state)


func debug_force_queued_event(event_id: String) -> bool:
	if _narrative_event_queue == null or event_id.is_empty():
		return false
	for event in _run_state.narrative_event_queue:
		if str(event.get("event_id", "")) != event_id:
			continue
		var status: String = str(event.get("status", ""))
		if status not in [NarrativeEventQueue.STATUS_PENDING, NarrativeEventQueue.STATUS_ELIGIBLE]:
			return false
		var target_id: String = _narrative_event_queue.resolve_target_decision(event, _run_state)
		if target_id.is_empty():
			return false
		_decision_engine.set_forced_decision(target_id)
		return true
	return false


func debug_get_advisor_affinity() -> Dictionary:
	if _run_state == null:
		return {}
	return _run_state.advisor_affinity.duplicate(true)


func debug_get_ruler_traits() -> Dictionary:
	if _run_state == null:
		return {}
	return _run_state.ruler_traits.duplicate(true)


func debug_set_advisor_affinity(advisor_id: String, value: int) -> bool:
	if _run_state == null or not _content.has_advisor(advisor_id):
		return false
	_run_state.advisor_affinity[advisor_id] = clampi(
		value, AdvisorRelationshipManager.AFFINITY_MIN, AdvisorRelationshipManager.AFFINITY_MAX,
	)
	return true


func debug_change_trait(trait_id: String, delta: int) -> bool:
	if _run_state == null or trait_id not in RulerTraitManager.VALID_TRAIT_IDS:
		return false
	_run_state.change_ruler_trait(trait_id, delta)
	return true


func _load_and_validate_content() -> void:
	_content.load_all()
	var report := _validator.validate_repository(_content)
	report.print_summary()
	_content_valid = report.is_valid
