extends SceneTree

## Milestone 2A-2 tests: run stages, ContentDirector, ContentRequest bias.
## Run: godot --headless --path . -s tests/test_content_director.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	await process_frame
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_stage_boundaries()
	_test_update_stage_emits_on_change()
	_test_recovery_request()
	_test_recovery_bias()
	_test_forced_follow_up_wins()
	_test_endgame_exclusions()
	_test_excluded_tag_safeguard()
	_test_onboarding_request()
	_test_legacy_compatibility()
	await _test_restart_and_persistence()

	if _failures == 0:
		print("[TEST] All ContentDirector tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _make_director():
	return load("res://scripts/core/ContentDirector.gd").new(_repo)


func _make_engine(seed_value: int = 4242) -> DecisionEngine:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	return DecisionEngine.new(_repo, rng)


func _fresh_state(day: int = 1) -> RunState:
	var state := RunState.new()
	state.country_id = "ministan"
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	state.day = day
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	return state


func _valid_ids(engine: DecisionEngine, state: RunState) -> Array[String]:
	var ids: Array[String] = []
	for decision in engine.get_valid_decisions(state):
		ids.append(str(decision["id"]))
	return ids


func _test_stage_boundaries() -> void:
	var director = _make_director()
	var cases: Array = [
		[1, "establishment"],
		[7, "establishment"],
		[8, "escalation"],
		[16, "escalation"],
		[17, "instability"],
		[27, "instability"],
		[28, "endgame"],
		[40, "endgame"],
		[45, "endgame"],
	]
	for entry in cases:
		var state := _fresh_state(int(entry[0]))
		_check(
			director.resolve_stage_id(state) == str(entry[1]),
			"day %d -> %s" % [entry[0], entry[1]],
		)


func _test_update_stage_emits_on_change() -> void:
	var director = _make_director()
	var state := _fresh_state(1)
	var emissions: Array[int] = [0]
	var last_stage: Array[String] = [""]
	var event_bus: Node = root.get_node("EventBus")
	event_bus.stage_changed.connect(func(stage_id: String) -> void:
		emissions[0] += 1
		last_stage[0] = stage_id
	)

	director.update_stage(state)
	_check(state.current_stage_id == "establishment", "update_stage sets establishment on day 1")
	_check(emissions[0] == 1, "stage_changed emitted on first update")
	_check(last_stage[0] == "establishment", "stage_changed carries establishment")

	director.update_stage(state)
	_check(emissions[0] == 1, "stage_changed not emitted when stage unchanged")

	state.day = 8
	director.update_stage(state)
	_check(state.current_stage_id == "escalation", "update_stage advances to escalation on day 8")
	_check(emissions[0] == 2, "stage_changed emitted on stage change")


func _test_recovery_request() -> void:
	var director = _make_director()
	var engine := _make_engine()
	var state := _fresh_state()
	state.current_stage_id = "establishment"
	state.set_resource("treasury", 20)

	var request = director.build_request(state, engine)
	_check(request.request_type == "recovery", "treasury 20 -> recovery request")
	_check(request.preferred_card_types == ["recovery"], "recovery prefers recovery card type")
	_check("treasury" in request.reason, "recovery reason mentions treasury")

	state.set_resource("treasury", 21)
	request = director.build_request(state, engine)
	_check(request.request_type != "recovery", "treasury 21 -> not recovery")


func _test_recovery_bias() -> void:
	var director = _make_director()
	var low_state := _fresh_state()
	low_state.current_stage_id = "establishment"
	low_state.set_resource("treasury", 20)

	var normal_state := _fresh_state()
	normal_state.current_stage_id = "establishment"

	var low_hits: int = 0
	var normal_hits: int = 0
	const TRIALS: int = 200

	for i in range(TRIALS):
		var low_engine := _make_engine(9000 + i)
		var low_request = director.build_request(low_state, low_engine)
		var low_pick: Dictionary = low_engine.select_next_decision(low_state, low_request)
		if str(low_pick.get("id", "")) == "recovery_international_bank":
			low_hits += 1

		var normal_engine := _make_engine(9000 + i)
		var normal_request = director.build_request(normal_state, normal_engine)
		var normal_pick: Dictionary = normal_engine.select_next_decision(normal_state, normal_request)
		if str(normal_pick.get("id", "")) == "recovery_international_bank":
			normal_hits += 1

	_check(low_hits > 20, "recovery card picked often with low treasury, got %d/%d" % [low_hits, TRIALS])
	_check(normal_hits == 0, "recovery card not in healthy-treasury pool, got %d hits" % normal_hits)
	_check(low_hits > normal_hits * 5, "recovery bias: low=%d normal=%d" % [low_hits, normal_hits])


func _test_forced_follow_up_wins() -> void:
	var director = _make_director()
	var engine := _make_engine()
	var state := _fresh_state()
	state.current_stage_id = "establishment"
	state.set_resource("treasury", 10)

	engine.set_forced_decision("free_pizza_friday")
	var request = director.build_request(state, engine)
	_check(request.request_type == "forced_follow_up", "low treasury still reports forced_follow_up")

	var picked: Dictionary = engine.select_next_decision(state, request)
	_check(str(picked.get("id", "")) == "free_pizza_friday", "forced card wins over recovery bias")


func _test_endgame_exclusions() -> void:
	var director = _make_director()
	var engine := _make_engine()
	var state := _fresh_state(30)
	director.update_stage(state)
	_check(state.current_stage_id == "endgame", "day 30 resolves to endgame")

	var ids := _valid_ids(engine, state)
	_check("long_setup_grand_canal" not in ids, "long_setup card excluded in endgame")
	_check("escalation_only_rival_parade" not in ids, "escalation-only card excluded in endgame")
	_check("endgame_legacy_statue" in ids, "resolution card valid in endgame")

	var request = director.build_request(state, engine)
	_check(request.request_type == "endgame_resolution", "day 30 -> endgame_resolution request")
	_check(request.excluded_tags == ["long_setup"], "endgame request excludes long_setup tag")


func _test_excluded_tag_safeguard() -> void:
	var engine := _make_engine()
	var state := _fresh_state()
	state.current_stage_id = "establishment"

	for decision in _repo.get_all_decisions_for_country("ministan"):
		var id: String = str(decision.get("id", ""))
		if id != "window_tax_proposal":
			state.mark_decision_used(id)

	var sole: Dictionary = _repo.get_decision("window_tax_proposal")
	var tags: Array = sole.get("tags", [])
	_check(not tags.is_empty(), "sole candidate has tags for safeguard test")

	var request = load("res://scripts/models/ContentRequest.gd").new()
	request.excluded_tags.append(str(tags[0]))
	var picked: Dictionary = engine.select_next_decision(state, request)
	_check(not picked.is_empty(), "excluded-tag safeguard still returns a card when pool has candidates")


func _test_onboarding_request() -> void:
	var director = _make_director()
	var engine := _make_engine()
	var state := _fresh_state()
	state.current_stage_id = "establishment"

	var request = director.build_request(state, engine)
	_check(request.request_type == "onboarding", "fresh run prefers onboarding")
	_check("onboarding" in request.required_tags, "onboarding request requires onboarding tag")

	var onboarding_hits: int = 0
	const TRIALS: int = 100
	for i in range(TRIALS):
		var trial_state := _fresh_state()
		trial_state.current_stage_id = "establishment"
		var trial_engine := _make_engine(5000 + i)
		var trial_request = director.build_request(trial_state, trial_engine)
		var pick: Dictionary = trial_engine.select_next_decision(trial_state, trial_request)
		var tags: Array = pick.get("tags", [])
		if "onboarding" in tags:
			onboarding_hits += 1
	_check(onboarding_hits > 40, "onboarding cards dominate early pool, got %d/%d" % [onboarding_hits, TRIALS])


func _test_legacy_compatibility() -> void:
	var engine := _make_engine()
	var legacy: Dictionary = _repo.get_decision("window_tax_proposal")
	_check(not legacy.get("options", []).is_empty(), "window_tax has normalized options")

	for stage_id in ["establishment"]:
		var state := _fresh_state()
		state.current_stage_id = stage_id
		_check(engine.is_decision_valid(legacy, state), "window_tax valid in stage %s" % stage_id)

	for stage_id in ["escalation", "instability", "endgame"]:
		var state := _fresh_state()
		state.current_stage_id = stage_id
		state.day = 30 if stage_id == "endgame" else 10
		_check(not engine.is_decision_valid(legacy, state), "window_tax excluded in stage %s" % stage_id)

	var state := _fresh_state()
	var picked: Dictionary = engine.select_next_decision(state)
	_check(not picked.is_empty(), "select_next_decision(state) one-arg call still works")


func _test_restart_and_persistence() -> void:
	var game_manager: Node = root.get_node("GameManager")

	game_manager.debug_set_fixed_seed(424242)
	game_manager.start_new_run()
	var state: RunState = game_manager.get_current_state()
	_check(game_manager.get_current_stage_id() == "establishment", "new run starts in establishment")

	# Advance calendar without resolving arc force_next chains that can end the run early.
	for i in range(9):
		game_manager.debug_advance_day()
	_check(state.day == 10, "advanced to day 10 through normal flow")
	_check(game_manager.get_current_stage_id() == "escalation", "stage advances with day")

	game_manager.restart_run()
	var restarted: RunState = game_manager.get_current_state()
	_check(restarted.day == 1, "restart resets day to 1")
	_check(game_manager.get_current_stage_id() == "establishment", "restart resets stage to establishment")

	state.current_stage_id = "endgame"
	var saved: Dictionary = state.to_dictionary()
	var loaded := RunState.new()
	loaded.from_dictionary(saved)
	_check(loaded.current_stage_id == "endgame", "to_dictionary/from_dictionary preserves current_stage_id")

	var defaulted := RunState.new()
	defaulted.from_dictionary({})
	_check(defaulted.current_stage_id == "", "from_dictionary({}) defaults current_stage_id to empty")
