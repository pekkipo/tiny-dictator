extends SceneTree

## Milestone 2A-5 tests: CrisisManager and integration.
## Run: godot --headless --path . -s tests/test_crisis_manager.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	await process_frame
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_start_valid_crisis()
	_test_prevent_second_crisis()
	_test_mandatory_crisis_priority()
	_test_three_option_resolution()
	_test_timeout_failure()
	_test_palace_ending()
	_test_restart_cleanup()
	_test_old_save_compatibility()
	_test_arc_and_queue_intact()

	if _failures == 0:
		print("[TEST] All CrisisManager tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _fresh_state(day: int = 10) -> RunState:
	var state := RunState.new()
	state.country_id = "ministan"
	state.day = day
	state.current_stage_id = "escalation"
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	return state


func _make_rng(seed_value: int = 4242) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	return rng


func _make_engine(rng: RandomNumberGenerator) -> DecisionEngine:
	var engine := DecisionEngine.new(_repo, rng)
	engine.set_arc_manager(ArcManager.new(_repo))
	engine.set_crisis_manager(CrisisManager.new(_repo))
	return engine


func _make_crisis_manager() -> CrisisManager:
	return CrisisManager.new(_repo)


func _make_director() -> ContentDirector:
	return ContentDirector.new(_repo)


func _make_queue(engine: DecisionEngine, rng: RandomNumberGenerator) -> NarrativeEventQueue:
	var queue := NarrativeEventQueue.new(_repo)
	queue.set_decision_engine(engine)
	queue.set_rng(rng)
	return queue


func _test_start_valid_crisis() -> void:
	var state := _fresh_state(10)
	var crisis := _make_crisis_manager()
	_check(crisis.can_start_crisis("national_power_outage", state), "can start valid crisis")
	_check(crisis.force_start_crisis("national_power_outage", state), "force start succeeds")
	_check(crisis.has_active_crisis(state), "crisis is active")
	_check(str(state.active_crisis.get("status", "")) == "active", "status active")
	_check(crisis.get_mandatory_decision_id(state) == "national_power_outage", "mandatory entry decision")


func _test_prevent_second_crisis() -> void:
	var state := _fresh_state(10)
	var crisis := _make_crisis_manager()
	_check(crisis.force_start_crisis("national_power_outage", state), "first crisis starts")
	_check(not crisis.force_start_crisis("national_power_outage", state), "second crisis blocked")
	_check(not crisis.can_start_crisis("national_power_outage", state), "can_start false while active")


func _test_mandatory_crisis_priority() -> void:
	var state := _fresh_state(10)
	state.set_resource("treasury", 10)
	var rng := _make_rng()
	var engine := _make_engine(rng)
	var director := _make_director()
	var queue := _make_queue(engine, rng)
	var crisis := _make_crisis_manager()
	crisis.force_start_crisis("national_power_outage", state)

	var request: ContentRequest = director.build_request(state, engine, queue, crisis)
	_check(request.request_type == "mandatory_crisis", "director requests mandatory_crisis, got %s" % request.request_type)
	_check(request.crisis_decision_id == "national_power_outage", "crisis decision id set")

	var unrelated_count: int = 0
	for decision in engine.get_valid_decisions(state):
		if str(decision.get("id", "")) != "national_power_outage":
			unrelated_count += 1
	for _i in 200:
		var pick: Dictionary = engine.select_next_decision(state, request)
		_check(str(pick.get("id", "")) == "national_power_outage", "mandatory crisis always picks crisis card")
	_check(unrelated_count > 0, "unrelated cards exist in pool but are bypassed")


func _test_three_option_resolution() -> void:
	var state := _fresh_state(10)
	var crisis := _make_crisis_manager()
	var resolver := EffectResolver.new()
	crisis.force_start_crisis("national_power_outage", state)
	var decision: Dictionary = _repo.get_decision("national_power_outage")
	_check(DecisionSchema.get_options(decision).size() == 3, "crisis has 3 options")

	var hospital_result: DecisionResult = resolver.apply_option(
		decision, "hospital", state, _repo, null, crisis,
	)
	_check(hospital_result.selected_option_id == "hospital", "hospital option resolves")
	_check(int(hospital_result.resource_changes.get("happiness", 0)) == 8, "hospital happiness effect")
	_check(str(state.active_crisis.get("status", "")) == "resolved", "hospital resolves crisis")

	state = _fresh_state(10)
	crisis = _make_crisis_manager()
	crisis.force_start_crisis("national_power_outage", state)
	var tv_result: DecisionResult = resolver.apply_option(
		decision, "television", state, _repo, null, crisis,
	)
	_check(state.has_flag("propaganda_powered_during_blackout"), "television adds flag")
	_check(state.has_law("emergency_broadcast_priority"), "television adds law")
	_check(str(state.active_crisis.get("status", "")) == "resolved", "television resolves crisis")
	_check(tv_result.triggered_ending_id.is_empty(), "television does not trigger ending")


func _test_timeout_failure() -> void:
	var state := _fresh_state(10)
	var crisis := _make_crisis_manager()
	crisis.force_start_crisis("national_power_outage", state)
	_check(not crisis.update_for_day(12, state), "day 12 not timed out")
	_check(crisis.update_for_day(13, state), "day 13 triggers timeout")
	_check(str(state.active_crisis.get("status", "")) == "failed", "timeout marks failed")
	_check(str(state.active_crisis.get("failed_reason", "")) == "timeout", "timeout reason recorded")
	var timeout: Dictionary = crisis.get_timeout_result(state)
	_check(not str(timeout.get("trigger_ending_id", "")).is_empty(), "timeout has ending")


func _test_palace_ending() -> void:
	var state := _fresh_state(10)
	var crisis := _make_crisis_manager()
	crisis.force_start_crisis("national_power_outage", state)
	var decision: Dictionary = _repo.get_decision("national_power_outage")
	var resolver := EffectResolver.new()
	var result: DecisionResult = resolver.apply_option(
		decision, "palace", state, _repo, null, crisis,
	)
	_check(result.triggered_ending_id == "nation_in_darkness", "palace triggers ending")
	_check(str(state.active_crisis.get("status", "")) == "failed", "palace fails crisis")


func _test_restart_cleanup() -> void:
	var game_manager: Node = root.get_node("GameManager")
	game_manager.start_new_run()
	game_manager.debug_force_crisis("national_power_outage")
	_check(game_manager.debug_get_crisis_state().has("crisis_id"), "crisis active before restart")
	game_manager.restart_run()
	var state: RunState = game_manager.get_current_state()
	_check(state.active_crisis.is_empty(), "restart clears active crisis")
	_check(state.narrative_event_queue.is_empty(), "restart clears queue")


func _test_old_save_compatibility() -> void:
	var state := RunState.new()
	state.from_dictionary({"day": 5, "resources": state.get_resources()})
	_check(state.active_crisis.is_empty(), "legacy save without active_crisis loads empty")


func _test_arc_and_queue_intact() -> void:
	var state := _fresh_state(10)
	var rng := _make_rng()
	var engine := _make_engine(rng)
	var queue := _make_queue(engine, rng)
	var arcs := ArcManager.new(_repo)
	var crisis := _make_crisis_manager()

	_check(arcs.start_arc(state, "cat_politics", "support_cats"), "arc still starts during crisis work")
	crisis.force_start_crisis("national_power_outage", state)
	_check(state.is_arc_active("cat_politics"), "arc remains active when crisis forced")

	var event_id: String = queue.add_event({
		"source_decision_id": "test",
		"source_option_id": "approve",
		"follow_up": {
			"type": "soft",
			"decision_id": "cheese_shortage",
			"minimum_delay_days": 1,
			"maximum_delay_days": 2,
			"priority": 70,
		},
	}, state)
	_check(not event_id.is_empty(), "queue still accepts events during crisis")
	queue.update_for_day(state.day + 2, state)
	var due: Array[Dictionary] = queue.get_due_events(state)
	_check(not due.is_empty(), "queued event still becomes due")
