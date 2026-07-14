extends Node

## High-level run lifecycle coordinator (autoload).
## Milestone 5 scope: run lifecycle, decision selection, choice resolution.
## Endings (M7) are stubbed.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §4.

var _run_state: RunState = RunState.new()
var _content: ContentRepository = ContentRepository.new()
var _validator: ContentValidator = ContentValidator.new()
var _content_valid: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _decision_engine: DecisionEngine = null
var _effect_resolver: EffectResolver = EffectResolver.new()
var _current_decision: Dictionary = {}
var _last_result: DecisionResult = null


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
	_run_state.random_seed = randi()
	var starting_resources: Dictionary = country.get("starting_resources", {})
	for resource_id in RunState.RESOURCE_IDS:
		_run_state.set_resource(resource_id, int(starting_resources.get(resource_id, RunState.DEFAULT_RESOURCE_VALUE)))

	_rng.seed = _run_state.random_seed
	_decision_engine = DecisionEngine.new(_content, _rng)
	_last_result = null

	print("[RUN] New run started: country=%s day=%d seed=%d" % [
		_run_state.country_id, _run_state.day, _run_state.random_seed,
	])
	_select_next_decision()
	_run_state.run_phase = RunState.RunPhase.AWAITING_DECISION
	EventBus.run_started.emit(_run_state)
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


func choose_left() -> void:
	resolve_choice("left")


func choose_right() -> void:
	resolve_choice("right")


## Returns null when the choice cannot be resolved (wrong phase = double
## click protection, TC-002).
func resolve_choice(side: String) -> DecisionResult:
	if _run_state.run_phase != RunState.RunPhase.AWAITING_DECISION:
		return null
	if _current_decision.is_empty():
		return null

	_run_state.run_phase = RunState.RunPhase.RESOLVING_DECISION
	var result := _effect_resolver.apply_option(_current_decision, side, _run_state, _content)
	_last_result = result

	if not result.forced_next_decision_id.is_empty():
		_decision_engine.set_forced_decision(result.forced_next_decision_id)

	EventBus.resources_changed.emit(_run_state.get_resources())
	for law_id in result.added_laws:
		EventBus.law_added.emit(law_id)
	for law_id in result.removed_laws:
		EventBus.law_removed.emit(law_id)
	for flag_id in result.added_flags:
		EventBus.flag_added.emit(flag_id)

	_run_state.run_phase = RunState.RunPhase.SHOWING_RESULT
	EventBus.decision_resolved.emit(result)
	return result


func continue_after_result() -> void:
	if _run_state.run_phase != RunState.RunPhase.SHOWING_RESULT:
		return
	_run_state.run_phase = RunState.RunPhase.CHECKING_ENDING
	# Ending resolution arrives in Milestone 7; until then runs never end here.
	_run_state.day += 1
	_select_next_decision()
	_run_state.run_phase = RunState.RunPhase.AWAITING_DECISION
	if _current_decision.is_empty():
		push_warning("[RUN] No decision available on day %d (content exhaustion ending arrives in M7)." % _run_state.day)
		return
	EventBus.decision_presented.emit(_current_decision)


## Debug helper (used by the M9 overlay): queue a specific decision next.
func force_decision(decision_id: String) -> bool:
	if _decision_engine == null or not _content.has_decision(decision_id):
		return false
	_decision_engine.set_forced_decision(decision_id)
	return true


func _select_next_decision() -> void:
	_current_decision = _decision_engine.select_next_decision(_run_state)
	if _current_decision.is_empty():
		# Content exhaustion triggers an ending in Milestone 7.
		push_warning("[DECISION] No valid decision available.")
		_run_state.current_decision_id = ""
		return
	_run_state.current_decision_id = str(_current_decision["id"])
	var pool_size: int = _decision_engine.get_valid_decisions(_run_state).size()
	print("[DECISION] Day %d selected '%s' (%d valid candidates)" % [
		_run_state.day, _run_state.current_decision_id, pool_size,
	])


func debug_set_resource(resource_id: String, value: int) -> void:
	_run_state.set_resource(resource_id, value)
	EventBus.resources_changed.emit(_run_state.get_resources())


func debug_print_state() -> void:
	print("[DEBUG] RunState: %s" % JSON.stringify(_run_state.to_dictionary(), "  "))


func _load_and_validate_content() -> void:
	_content.load_all()
	var report := _validator.validate_repository(_content)
	report.print_summary()
	_content_valid = report.is_valid
