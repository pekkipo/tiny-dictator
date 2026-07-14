extends SceneTree

## Milestone 2 assertion tests for GameManager run lifecycle.
## Run: godot --headless --path . -s tests/test_game_manager.gd

var _failures: int = 0
var _run_started_count: int = 0
var _run_reset_count: int = 0


func _initialize() -> void:
	# Autoloads are available; defer so they finish _ready first.
	await process_frame

	var event_bus: Node = root.get_node("EventBus")
	var game_manager: Node = root.get_node("GameManager")
	event_bus.run_started.connect(func(_state: RunState) -> void: _run_started_count += 1)
	event_bus.run_reset.connect(func() -> void: _run_reset_count += 1)
	var presented_count: Array[int] = [0]
	event_bus.decision_presented.connect(func(_decision: Dictionary) -> void: presented_count[0] += 1)

	# Start a run, dirty the state, then restart and verify cleanliness.
	game_manager.start_new_run()
	var state: RunState = game_manager.get_current_state()
	_check(_run_started_count == 1, "run_started emitted")
	_check(state.run_phase == RunState.RunPhase.AWAITING_DECISION, "phase AWAITING_DECISION after start")
	_check(state.day == 1, "day 1 after start")
	_check(presented_count[0] == 1, "decision_presented emitted on start")
	_check(not game_manager.get_current_decision().is_empty(), "a decision is selected at run start")
	_check(state.current_decision_id == str(game_manager.get_current_decision().get("id", "")), "current_decision_id matches selected decision")
	_check(game_manager.force_decision("free_pizza_friday"), "force_decision accepts known id")
	_check(not game_manager.force_decision("nonexistent"), "force_decision rejects unknown id")

	state.change_resource("treasury", -30)
	state.add_law("window_tax")
	state.add_flag("cheese_shortage")
	state.day = 9
	var dirty_seed: int = state.random_seed

	game_manager.restart_run()
	var fresh: RunState = game_manager.get_current_state()
	_check(_run_started_count == 2, "run_started emitted on restart")
	_check(fresh != state, "restart creates a new RunState instance")
	_check(fresh.day == 1, "restart resets day")
	_check(fresh.treasury == 55, "restart resets resources")
	_check(fresh.active_laws.is_empty(), "restart clears laws")
	_check(fresh.flags.is_empty(), "restart clears flags")
	_check(fresh.random_seed != 0, "restart generates a seed")
	if fresh.random_seed == dirty_seed:
		print("[TEST] Note: identical consecutive seeds (possible but unlikely).")

	game_manager.return_to_main_menu()
	_check(_run_reset_count == 1, "run_reset emitted on main menu")
	_check(game_manager.get_current_state().run_phase == RunState.RunPhase.NOT_STARTED, "phase NOT_STARTED after menu")

	# --- Milestone 5: full choose/result/continue loop ---
	var resolved_count: Array[int] = [0]
	event_bus.decision_resolved.connect(func(_result: DecisionResult) -> void: resolved_count[0] += 1)

	game_manager.start_new_run()
	state = game_manager.get_current_state()
	var first_decision_id: String = state.current_decision_id

	var result: DecisionResult = game_manager.resolve_choice("left")
	_check(result != null, "resolve_choice returns a result")
	_check(resolved_count[0] == 1, "decision_resolved emitted")
	_check(state.run_phase == RunState.RunPhase.SHOWING_RESULT, "phase SHOWING_RESULT after choice")
	_check(state.decision_history.size() == 1, "history has one entry")
	_check(game_manager.get_last_result() == result, "last result stored")

	# TC-002: double resolution rejected.
	var second: DecisionResult = game_manager.resolve_choice("left")
	_check(second == null, "second resolve rejected")
	_check(state.decision_history.size() == 1, "history still has one entry after double click")
	_check(state.day == 1, "day unchanged before continue")

	game_manager.continue_after_result()
	_check(state.day == 2, "day incremented after continue")
	_check(state.run_phase == RunState.RunPhase.AWAITING_DECISION, "phase AWAITING_DECISION after continue")
	_check(not game_manager.get_current_decision().is_empty(), "next decision presented")
	_check(state.current_decision_id != first_decision_id, "next decision differs from resolved one")

	# Forced follow-up through the full loop: traffic lights right forces tanks.
	game_manager.start_new_run()
	state = game_manager.get_current_state()
	game_manager.force_decision("switch_off_traffic_lights")
	game_manager.continue_after_result()  # no-op: wrong phase
	game_manager.resolve_choice("left")
	game_manager.continue_after_result()
	_check(state.current_decision_id == "switch_off_traffic_lights", "forced decision presented next")
	game_manager.resolve_choice("right")
	game_manager.continue_after_result()
	_check(state.current_decision_id == "traffic_tank_solution", "forced follow-up chain works end to end")

	# --- Milestone 7: endings and restart flow ---
	var run_ended_count: Array[int] = [0]
	var ended_payload: Array = [null]
	event_bus.run_ended.connect(func(summary: RunSummary) -> void:
		run_ended_count[0] += 1
		ended_payload[0] = summary)

	# Fatal decision: collapse happiness, then continue ends the run.
	game_manager.start_new_run()
	state = game_manager.get_current_state()
	game_manager.resolve_choice("left")
	game_manager.debug_set_resource("happiness", 0)
	var day_before: int = state.day
	game_manager.continue_after_result()
	_check(run_ended_count[0] == 1, "run_ended emitted on collapse")
	_check(state.run_phase == RunState.RunPhase.ENDED, "phase ENDED after collapse")
	_check(state.day == day_before, "day does not increment on a fatal decision")
	var summary: RunSummary = game_manager.get_last_summary()
	_check(summary != null and summary.ending_id == "revolution", "summary carries revolution ending")
	_check(summary == ended_payload[0], "run_ended payload matches get_last_summary")
	_check(summary.final_day == day_before, "summary final_day matches run day")
	_check(summary.decision_history.size() == 1, "summary records decision history")
	_check(not summary.legacy_text.is_empty(), "summary has legacy text")

	# Input after the run ended is rejected.
	_check(game_manager.resolve_choice("left") == null, "no choices accepted after run ended")
	game_manager.continue_after_result()
	_check(state.run_phase == RunState.RunPhase.ENDED, "continue after ending is a no-op")

	# Debug ending trigger ends the run immediately.
	game_manager.start_new_run()
	game_manager.debug_trigger_ending("cat_republic")
	_check(run_ended_count[0] == 2, "debug_trigger_ending ends the run")
	_check(game_manager.get_last_summary().ending_id == "cat_republic", "debug ending recorded in summary")

	# TC-019 regression: an exhausted pool must not loop the fallback card
	# forever; after the fallback limit the content_exhausted ending fires.
	game_manager.start_new_run()
	state = game_manager.get_current_state()
	for decision in game_manager.get_content().get_all_decisions_for_country(state.country_id):
		state.mark_decision_used(str(decision.get("id", "")))
	var fallback_days: int = 0
	for i in range(10):
		if state.run_phase != RunState.RunPhase.AWAITING_DECISION:
			break
		if state.current_decision_id == "generic_minister_disagreement":
			fallback_days += 1
		# Keep resources healthy so only exhaustion can end the run.
		for resource_id in RunState.RESOURCE_IDS:
			game_manager.debug_set_resource(resource_id, 55)
		game_manager.resolve_choice("left")
		game_manager.continue_after_result()
	_check(state.run_phase == RunState.RunPhase.ENDED, "exhausted content ends the run instead of looping")
	_check(game_manager.get_last_summary().ending_id == "content_exhausted", "content_exhausted ending triggered, got '%s'" % game_manager.get_last_summary().ending_id)
	_check(fallback_days <= 2, "fallback card shown at most twice, got %d" % fallback_days)

	# TC-020: ten consecutive restarts stay clean.
	var restarts_clean: bool = true
	for i in range(10):
		game_manager.restart_run()
		var restarted: RunState = game_manager.get_current_state()
		if restarted.day != 1 or not restarted.decision_history.is_empty() \
				or not restarted.active_laws.is_empty() or not restarted.flags.is_empty() \
				or restarted.run_phase != RunState.RunPhase.AWAITING_DECISION:
			restarts_clean = false
	_check(restarts_clean, "ten consecutive restarts produce clean runs")

	if _failures == 0:
		print("[TEST] All GameManager tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)
