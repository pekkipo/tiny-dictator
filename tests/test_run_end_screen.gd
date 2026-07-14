extends SceneTree

## Milestone 7 UI smoke test for the Run End Screen newspaper.
## Run: godot --headless --path . -s tests/test_run_end_screen.gd

var _failures: int = 0


func _initialize() -> void:
	# Load after the first frame so autoloads exist when the script compiles.
	await process_frame
	var run_end_scene: PackedScene = load("res://scenes/screens/RunEndScreen.tscn")

	var game_manager: Node = root.get_node("GameManager")
	var event_bus: Node = root.get_node("EventBus")
	var run_started_count: Array[int] = [0]
	var run_reset_count: Array[int] = [0]
	event_bus.run_started.connect(func(_state: RunState) -> void: run_started_count[0] += 1)
	event_bus.run_reset.connect(func() -> void: run_reset_count[0] += 1)

	# Screen opened without any finished run shows the placeholder.
	var screen: Control = run_end_scene.instantiate()
	root.add_child(screen)
	await process_frame
	_check(screen.get_node("%EndingTitleLabel").text == "NO RUN DATA", "placeholder shown without summary")
	screen.queue_free()
	await process_frame

	# End a real run and verify the newspaper is populated.
	game_manager.start_new_run()
	game_manager.resolve_choice("left")
	game_manager.debug_set_resource("order", 0)
	game_manager.continue_after_result()
	var summary: RunSummary = game_manager.get_last_summary()
	_check(summary != null and summary.ending_id == "chaos_country", "run ended with chaos_country")

	screen = run_end_scene.instantiate()
	root.add_child(screen)
	await process_frame
	_check(screen.get_node("%MastheadLabel").text == "THE MINISTAN TIMES", "masthead from ending data")
	_check(screen.get_node("%EndingTitleLabel").text == "NATIONWIDE SHRUG", "ending title displayed uppercase")
	_check(screen.get_node("%DateLabel").text == "Day 1 of the Glorious Reign", "final day displayed")
	_check("🛡 0" in screen.get_node("%FinalStatsLabel").text, "collapsed resource shown in stats")
	_check(screen.get_node("%LawsCountLabel").text.begins_with("Active laws:"), "laws count displayed")
	_check(not screen.get_node("%LegacySummaryLabel").text.is_empty(), "legacy text displayed")

	# RULE AGAIN starts a fresh run.
	var starts_before: int = run_started_count[0]
	screen.get_node("%RestartButton").pressed.emit()
	await process_frame
	_check(run_started_count[0] == starts_before + 1, "restart button starts a new run")
	var state: RunState = game_manager.get_current_state()
	_check(state.day == 1 and state.run_phase == RunState.RunPhase.AWAITING_DECISION, "restarted run is clean")
	screen.queue_free()
	await process_frame

	# MAIN MENU resets to the start screen state.
	game_manager.debug_trigger_ending("revolution")
	screen = run_end_scene.instantiate()
	root.add_child(screen)
	await process_frame
	screen.get_node("%MainMenuButton").pressed.emit()
	await process_frame
	_check(run_reset_count[0] == 1, "main menu button emits run_reset")
	_check(game_manager.get_current_state().run_phase == RunState.RunPhase.NOT_STARTED, "phase NOT_STARTED after main menu")
	screen.queue_free()
	await process_frame

	if _failures == 0:
		print("[TEST] All RunEndScreen tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)
