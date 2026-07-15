extends SceneTree

## Milestone 4 assertion tests for DecisionEngine.
## Run: godot --headless --path . -s tests/test_decision_engine.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_day_one_pool()
	_test_flag_requirement()
	_test_blocked_flag()
	_test_one_time_filtering()
	_test_requirements_evaluator()
	_test_seed_reproducibility()
	_test_forced_decision()
	_test_invalid_forced_decision()
	_test_fallback()
	_test_repetition_avoidance()

	if _failures == 0:
		print("[TEST] All DecisionEngine tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _make_engine(seed_value: int = 42) -> DecisionEngine:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	return DecisionEngine.new(_repo, rng)


func _fresh_state() -> RunState:
	var state := RunState.new()
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	return state


func _valid_ids(engine: DecisionEngine, state: RunState) -> Array[String]:
	var ids: Array[String] = []
	for decision in engine.get_valid_decisions(state):
		ids.append(str(decision["id"]))
	return ids


func _test_day_one_pool() -> void:
	# Day 1, no flags: all 9 non-fallback core decisions valid, no follow-ups.
	var ids := _valid_ids(_make_engine(), _fresh_state())
	_check(ids.size() == 12, "day 1 pool has 12 decisions, got %d" % ids.size())
	_check("generic_minister_disagreement" not in ids, "fallback excluded from normal pool")
	_check("traffic_tank_solution" not in ids, "follow-up hidden without flag")
	_check("cheese_shortage" not in ids, "pizza follow-up hidden without flag")
	_check("switch_off_traffic_lights" in ids, "core decision present")


func _test_flag_requirement() -> void:
	# Phase 2A: traffic follow-ups require an active arc and branch, not only flags.
	var state_tank := _fresh_state()
	state_tank.add_flag("traffic_lights_off")
	state_tank.day = 3
	state_tank.current_stage_id = "establishment"
	state_tank.active_arcs["traffic_military"] = {
		"arc_id": "traffic_military",
		"status": "active",
		"current_step": 1,
		"branch_id": "tank_response",
	}
	var ids_tank := _valid_ids(_make_engine(), state_tank)
	_check("traffic_tank_solution" in ids_tank, "tank follow-up eligible with arc branch")

	var state_complaint := _fresh_state()
	state_complaint.add_flag("traffic_lights_off")
	state_complaint.day = 3
	state_complaint.current_stage_id = "establishment"
	state_complaint.active_arcs["traffic_military"] = {
		"arc_id": "traffic_military",
		"status": "active",
		"current_step": 1,
		"branch_id": "restore_lights",
	}
	var ids_complaint := _valid_ids(_make_engine(), state_complaint)
	_check("traffic_complaint" in ids_complaint, "complaint follow-up eligible with restore branch")


func _test_blocked_flag() -> void:
	# TC-008: blocked flag removes eligibility (with active traffic arc).
	var state := _fresh_state()
	state.add_flag("traffic_lights_off")
	state.add_flag("military_controls_traffic")
	state.day = 3
	state.current_stage_id = "establishment"
	state.active_arcs["traffic_military"] = {
		"arc_id": "traffic_military",
		"status": "active",
		"current_step": 1,
		"branch_id": "tank_response",
	}
	var ids := _valid_ids(_make_engine(), state)
	_check("traffic_tank_solution" not in ids, "tank follow-up blocked by flag")
	state.active_arcs["traffic_military"]["branch_id"] = "restore_lights"
	var ids_restore := _valid_ids(_make_engine(), state)
	_check("traffic_complaint" not in ids_restore, "complaint blocked by flag")


func _test_one_time_filtering() -> void:
	# TC-009: used one-time decision never reappears.
	var state := _fresh_state()
	state.mark_decision_used("switch_off_traffic_lights")
	var ids := _valid_ids(_make_engine(), state)
	_check("switch_off_traffic_lights" not in ids, "used one-time decision excluded")
	_check(ids.size() == 11, "pool shrinks to 11, got %d" % ids.size())


func _test_requirements_evaluator() -> void:
	var engine := _make_engine()
	var state := _fresh_state()

	_check(engine.evaluate_requirements({}, state), "empty requirements pass")
	_check(engine.evaluate_requirements({"minimum_resources": {"treasury": 55}}, state), "minimum_resources at threshold passes")
	_check(not engine.evaluate_requirements({"minimum_resources": {"treasury": 56}}, state), "minimum_resources above value fails")
	_check(engine.evaluate_requirements({"maximum_resources": {"order": 55}}, state), "maximum_resources at threshold passes")
	_check(not engine.evaluate_requirements({"maximum_resources": {"order": 54}}, state), "maximum_resources below value fails")

	state.add_law("window_tax")
	_check(engine.evaluate_requirements({"all_laws": ["window_tax"]}, state), "all_laws passes")
	_check(engine.evaluate_requirements({"any_laws": ["window_tax", "no_weekends"]}, state), "any_laws passes")
	_check(not engine.evaluate_requirements({"blocked_laws": ["window_tax"]}, state), "blocked_laws fails")

	state.change_counter("pizza_choices", 2)
	_check(engine.evaluate_requirements({"minimum_counters": {"pizza_choices": 2}}, state), "minimum_counters passes")
	_check(not engine.evaluate_requirements({"minimum_counters": {"pizza_choices": 3}}, state), "minimum_counters fails")
	_check(not engine.evaluate_requirements({"maximum_counters": {"pizza_choices": 1}}, state), "maximum_counters fails")

	state.mark_decision_used("free_pizza_friday")
	_check(engine.evaluate_requirements({"used_decisions": ["free_pizza_friday"]}, state), "used_decisions passes")
	_check(not engine.evaluate_requirements({"used_decisions": ["military_parade"]}, state), "used_decisions fails when not used")
	_check(not engine.evaluate_requirements({"not_used_decisions": ["free_pizza_friday"]}, state), "not_used_decisions fails when used")

	state.day = 5
	_check(engine.evaluate_requirements({"minimum_day": 5, "maximum_day": 10}, state), "day range passes")
	_check(not engine.evaluate_requirements({"minimum_day": 6}, state), "minimum_day fails")


func _test_seed_reproducibility() -> void:
	# TC-014: same seed produces the same selection sequence.
	var sequence_a: Array[String] = _selection_sequence(1337)
	var sequence_b: Array[String] = _selection_sequence(1337)
	var sequence_c: Array[String] = _selection_sequence(9999)
	_check(sequence_a == sequence_b, "same seed reproduces sequence")
	if sequence_a == sequence_c:
		print("[TEST] Note: different seeds produced identical sequence (possible but unlikely).")


func _selection_sequence(seed_value: int) -> Array[String]:
	var engine := _make_engine(seed_value)
	var state := _fresh_state()
	var picks: Array[String] = []
	for i in range(6):
		var decision := engine.select_next_decision(state)
		if decision.is_empty():
			break
		var id: String = str(decision["id"])
		picks.append(id)
		state.mark_decision_used(id)
		state.current_decision_id = id
	return picks


func _test_forced_decision() -> void:
	# TC-011: forced follow-up bypasses weighting.
	var engine := _make_engine()
	engine.set_forced_decision("free_pizza_friday")
	var decision := engine.select_next_decision(_fresh_state())
	_check(str(decision.get("id", "")) == "free_pizza_friday", "forced decision selected")
	# Forced decision is consumed; next selection is normal.
	var next := engine.select_next_decision(_fresh_state())
	_check(not next.is_empty(), "selection continues after forced decision")


func _test_invalid_forced_decision() -> void:
	# TC-012: invalid forced decision falls back to normal selection.
	var engine := _make_engine()
	engine.set_forced_decision("traffic_tank_solution")
	var decision := engine.select_next_decision(_fresh_state())
	_check(not decision.is_empty(), "selection still returns a decision")
	_check(str(decision.get("id", "")) != "traffic_tank_solution", "invalid forced decision not selected")


func _test_fallback() -> void:
	# TC-019: exhausted pool uses the country fallback decision.
	# Phase 2A repeatable fillers keep the pool non-empty on day 1; use end-of-run day instead.
	var engine := _make_engine()
	var state := _fresh_state()
	state.day = 41
	state.current_stage_id = "endgame"
	for decision in _repo.get_all_decisions_for_country("ministan"):
		var id: String = str(decision.get("id", ""))
		if bool(decision.get("fallback", false)):
			continue
		if bool(decision.get("one_time", true)):
			state.mark_decision_used(id)
	_check(engine.get_valid_decisions(state).is_empty(), "pool empty after all one-time cards used past max day")
	var selected := engine.select_next_decision(state)
	_check(str(selected.get("id", "")) == "generic_minister_disagreement", "fallback selected on empty pool")
	# Fallback is reusable within its limit: with one resolved use it repeats.
	state.current_decision_id = "generic_minister_disagreement"
	state.add_history_entry({"day": 15, "decision_id": "generic_minister_disagreement"})
	var again := engine.select_next_decision(state)
	_check(str(again.get("id", "")) == "generic_minister_disagreement", "fallback can repeat within its limit")
	# After the per-run limit (2 for ministan) the pool is truly exhausted,
	# so the content_exhausted ending can fire instead of looping forever.
	state.add_history_entry({"day": 16, "decision_id": "generic_minister_disagreement"})
	var exhausted := engine.select_next_decision(state)
	_check(exhausted.is_empty(), "fallback stops after its limit, got '%s'" % exhausted.get("id", ""))


func _test_repetition_avoidance() -> void:
	# With alternatives available, the current decision is not repeated.
	var engine := _make_engine()
	var state := _fresh_state()
	state.current_decision_id = "military_parade"
	var pool := engine.get_valid_decisions(state)
	_check(pool.size() > 1, "multiple candidates available for repetition test")
	var selected := engine.select_next_decision(state)
	_check(str(selected.get("id", "")) != "military_parade",
		"repetition avoidance violated: picked %s" % selected.get("id", ""))
