extends SceneTree

## Milestone 2A-3 tests: ArcManager, arc eligibility, and integration.
## Run: godot --headless --path . -s tests/test_arc_manager.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	await process_frame
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_start_arc()
	_test_prevent_duplicate_start()
	_test_branch_selection()
	_test_branch_specific_eligibility()
	_test_advance_active_arc()
	_test_complete_arc()
	_test_fail_arc()
	_test_completed_arc_cannot_restart()
	_test_exclusive_arcs()
	_test_restart_clears_arc_state()
	_test_old_save_compatibility()
	_test_forced_follow_up_still_wins()
	_test_arc_actions_via_effect_resolver()

	if _failures == 0:
		print("[TEST] All ArcManager tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _fresh_state(day: int = 4) -> RunState:
	var state := RunState.new()
	state.country_id = "ministan"
	state.day = day
	state.current_stage_id = "establishment"
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	return state


func _make_arc_manager() -> ArcManager:
	return load("res://scripts/core/ArcManager.gd").new(_repo)


func _make_engine(seed_value: int = 7777) -> DecisionEngine:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var engine := DecisionEngine.new(_repo, rng)
	engine.set_arc_manager(_make_arc_manager())
	return engine


func _test_start_arc() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	_check(arcs.start_arc(state, "cat_politics", "rights_path"), "start_arc succeeds")
	_check(state.is_arc_active("cat_politics"), "arc is active")
	_check(state.get_arc_branch("cat_politics") == "rights_path", "branch stored")
	var runtime: Dictionary = state.get_arc_runtime("cat_politics")
	_check(int(runtime.get("current_step", 0)) == 1, "starts at step 1")
	_check(int(runtime.get("started_day", 0)) == 4, "started_day recorded")


func _test_prevent_duplicate_start() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	_check(arcs.start_arc(state, "cat_politics"), "first start succeeds")
	_check(not arcs.start_arc(state, "cat_politics"), "duplicate start blocked")


func _test_branch_selection() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	arcs.start_arc(state, "cat_politics")
	_check(arcs.select_branch(state, "cat_politics", "cynical_path"), "select_branch succeeds")
	_check(state.get_arc_branch("cat_politics") == "cynical_path", "branch updated")


func _test_branch_specific_eligibility() -> void:
	var state := _fresh_state()
	var engine := _make_engine()
	var arcs := _make_arc_manager()
	engine.set_arc_manager(arcs)
	arcs.start_arc(state, "cat_politics", "rights_path")
	state.add_flag("cat_pol_live")

	var entry_card: Dictionary = _repo.get_decision("cat_faction_proposal")
	_check(not engine.is_decision_valid(entry_card, state), "entry blocked while cat_pol_live")
	_check(arcs.can_start_arc("whiskers_cat_revolution", state) == false, "whiskers blocked while cat active")


func _test_advance_active_arc() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	arcs.start_arc(state, "cat_politics")
	_check(arcs.advance_arc(state, "cat_politics", "cat_faction_proposal", "rights_path"), "advance succeeds")
	var runtime: Dictionary = state.get_arc_runtime("cat_politics")
	_check(int(runtime.get("current_step", 0)) == 2, "step incremented")
	_check("cat_faction_proposal" in runtime.get("history", []), "history records decision")


func _test_complete_arc() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	arcs.start_arc(state, "cat_politics")
	arcs.complete_arc(state, "cat_politics", "cat_politics_resolution")
	_check(state.is_arc_completed("cat_politics"), "arc completed")
	_check(not state.is_arc_active("cat_politics"), "removed from active")


func _test_fail_arc() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	arcs.start_arc(state, "cat_politics")
	arcs.fail_arc(state, "cat_politics")
	_check(state.is_arc_failed("cat_politics"), "arc failed")
	_check(not state.is_arc_active("cat_politics"), "removed from active")


func _test_completed_arc_cannot_restart() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	var engine := _make_engine()
	engine.set_arc_manager(arcs)
	arcs.start_arc(state, "cat_politics")
	arcs.complete_arc(state, "cat_politics", "cat_politics_resolution")
	_check(not arcs.can_start_arc("cat_politics", state), "cannot restart completed arc")
	var entry: Dictionary = _repo.get_decision("cat_faction_proposal")
	_check(not engine.is_decision_valid(entry, state), "entry decision invalid after completion")


func _test_exclusive_arcs() -> void:
	var state := _fresh_state()
	state.day = 10
	state.current_stage_id = "escalation"
	var arcs := _make_arc_manager()
	_check(arcs.start_arc(state, "robot_government"), "robot arc starts")
	_check(not arcs.can_start_arc("cat_politics", state), "cat arc blocked by exclusive group")
	_check(not arcs.start_arc(state, "cat_politics"), "cat arc start fails while robot active")
	_check(arcs.can_start_arc("whiskers_cat_revolution", state), "whiskers not blocked by AI group alone")
	state.reset()
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	state.country_id = "ministan"
	state.day = 4
	state.current_stage_id = "establishment"
	_check(arcs.start_arc(state, "whiskers_cat_revolution"), "whiskers starts")
	_check(not arcs.can_start_arc("cat_politics", state), "cat blocked by cat_governance_arc mutex")


func _test_restart_clears_arc_state() -> void:
	var state := _fresh_state()
	var arcs := _make_arc_manager()
	arcs.start_arc(state, "cat_politics")
	arcs.complete_arc(state, "cat_politics", "cat_politics_resolution")
	state.reset()
	_check(state.active_arcs.is_empty(), "reset clears active arcs")
	_check(state.completed_arc_ids.is_empty(), "reset clears completed arcs")
	_check(state.failed_arc_ids.is_empty(), "reset clears failed arcs")


func _test_old_save_compatibility() -> void:
	var legacy := {
		"day": 5,
		"resources": {"treasury": 40, "happiness": 50, "order": 55, "elite_loyalty": 55},
	}
	var state := RunState.new()
	state.from_dictionary(legacy)
	_check(state.active_arcs.is_empty(), "missing active_arcs defaults empty")
	_check(state.completed_arc_ids.is_empty(), "missing completed_arc_ids defaults empty")
	_check(state.failed_arc_ids.is_empty(), "missing failed_arc_ids defaults empty")


func _test_forced_follow_up_still_wins() -> void:
	var director = load("res://scripts/core/ContentDirector.gd").new(_repo)
	var engine := _make_engine()
	var state := _fresh_state()
	engine.set_forced_decision("traffic_tank_solution")
	var request = director.build_request(state, engine)
	_check(request.request_type == "forced_follow_up", "forced follow-up beats arc request")


func _test_arc_actions_via_effect_resolver() -> void:
	var state := _fresh_state()
	var resolver := EffectResolver.new()
	var arcs := _make_arc_manager()
	var decision: Dictionary = _repo.get_decision("cat_faction_proposal").duplicate(true)
	var result: DecisionResult = resolver.apply_option(decision, "open_representation", state, _repo, arcs)
	_check(state.is_arc_active("cat_politics"), "entry choice starts arc via narrative")
	_check(state.get_arc_branch("cat_politics") == "rights_path", "branch action applied")
	_check(not result.arc_changes.is_empty(), "arc changes recorded on result")
	_check(state.has_flag("cat_pol_live"), "live flag set")
	_check(not result.queued_follow_ups.is_empty() or not result.forced_next_decision_id.is_empty(),
		"follow-up queued or forced")
