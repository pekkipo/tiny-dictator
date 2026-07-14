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

	# Start a run, dirty the state, then restart and verify cleanliness.
	game_manager.start_new_run()
	var state: RunState = game_manager.get_current_state()
	_check(_run_started_count == 1, "run_started emitted")
	_check(state.run_phase == RunState.RunPhase.AWAITING_DECISION, "phase AWAITING_DECISION after start")
	_check(state.day == 1, "day 1 after start")

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

	if _failures == 0:
		print("[TEST] All GameManager tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)
