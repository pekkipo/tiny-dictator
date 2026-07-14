extends SceneTree

## Milestone 9 tests: debug overlay + GameManager debug APIs.
## Run: godot --headless --path . -s tests/test_debug_overlay.gd

var _failures: int = 0


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")

	var overlay: Control = (load("res://scenes/components/DebugOverlay.tscn") as PackedScene).instantiate()
	root.add_child(overlay)
	await process_frame

	# Hidden by default; F1 toggles on, backtick toggles off.
	_check(not overlay.visible, "overlay hidden by default")
	root.push_input(_key_event(KEY_F1))
	await process_frame
	_check(overlay.visible, "F1 shows overlay")
	root.push_input(_key_event(KEY_QUOTELEFT))
	await process_frame
	_check(not overlay.visible, "backtick hides overlay")
	overlay.toggle_visibility()
	_check(overlay.visible, "toggle_visibility works directly")

	game_manager.start_new_run()
	var state: RunState = game_manager.get_current_state()

	# Set resource through the overlay controls; UI-facing signal path is
	# covered by GameManager.debug_set_resource emitting resources_changed.
	var option: OptionButton = overlay.get_node("%ResourceOption")
	option.select(_find_item(option, "happiness"))
	overlay.get_node("%ResourceValueSpin").value = 5
	overlay.get_node("%SetResourceButton").pressed.emit()
	_check(state.happiness == 5, "overlay sets happiness to 5")

	# Add law: valid, duplicate, unknown (message, not crash).
	overlay.get_node("%AddLawEdit").text = "window_tax"
	overlay.get_node("%AddLawButton").pressed.emit()
	_check(state.has_law("window_tax"), "overlay adds a law")
	overlay.get_node("%AddLawButton").pressed.emit()
	_check(state.active_laws.count("window_tax") == 1, "duplicate law rejected")
	overlay.get_node("%AddLawEdit").text = "not_a_law"
	overlay.get_node("%AddLawButton").pressed.emit()
	_check(not state.has_law("not_a_law"), "unknown law rejected without crash")

	# Add flag.
	overlay.get_node("%AddFlagEdit").text = "debug_flag"
	overlay.get_node("%AddFlagButton").pressed.emit()
	_check(state.has_flag("debug_flag"), "overlay adds a flag")

	# Force decision, then advance day applies it.
	overlay.get_node("%ForceDecisionEdit").text = "free_pizza_friday"
	overlay.get_node("%ForceDecisionButton").pressed.emit()
	var day_before: int = state.day
	overlay.get_node("%AdvanceDayButton").pressed.emit()
	_check(state.day == day_before + 1, "advance day increments day")
	_check(state.current_decision_id == "free_pizza_friday", "forced decision applied on advance")

	# Unknown forced decision id: feedback, no crash.
	overlay.get_node("%ForceDecisionEdit").text = "bogus_decision"
	overlay.get_node("%ForceDecisionButton").pressed.emit()
	_check("bogus_decision" in overlay.get_node("%FeedbackLabel").text, "invalid decision id reports a message")

	# Fixed seed makes restarts reproducible.
	overlay.get_node("%SeedEdit").text = "12345"
	overlay.get_node("%SetSeedButton").pressed.emit()
	overlay.get_node("%RestartButton").pressed.emit()
	state = game_manager.get_current_state()
	var first_decision: String = state.current_decision_id
	_check(state.random_seed == 12345, "fixed seed used on restart")
	overlay.get_node("%RestartButton").pressed.emit()
	state = game_manager.get_current_state()
	_check(state.random_seed == 12345 and state.current_decision_id == first_decision, "same seed reproduces first decision")
	overlay.get_node("%SeedEdit").text = "0"
	overlay.get_node("%SetSeedButton").pressed.emit()

	# Print state and reload content: no crash, content stays valid.
	overlay.get_node("%PrintStateButton").pressed.emit()
	overlay.get_node("%ReloadContentButton").pressed.emit()
	_check(game_manager.is_content_valid(), "content still valid after reload")

	# Trigger ending from the dropdown ends the run for real.
	game_manager.start_new_run()
	var ending_option: OptionButton = overlay.get_node("%EndingOption")
	ending_option.select(_find_item(ending_option, "cat_republic"))
	overlay.get_node("%TriggerEndingButton").pressed.emit()
	_check(game_manager.get_current_state().run_phase == RunState.RunPhase.ENDED, "trigger ending ends the run")
	_check(game_manager.get_last_summary().ending_id == "cat_republic", "selected ending recorded")

	overlay.queue_free()
	await process_frame

	if _failures == 0:
		print("[TEST] All DebugOverlay tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _key_event(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	return event


func _find_item(option: OptionButton, text: String) -> int:
	for i in range(option.item_count):
		if option.get_item_text(i) == text:
			return i
	return -1
