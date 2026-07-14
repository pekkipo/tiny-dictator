extends SceneTree

## Milestone 6 smoke test: drives the real GameScreen through a full
## choose/result/continue loop headless.
## Run: godot --headless --path . -s tests/test_game_screen.gd

var _failures: int = 0


func _initialize() -> void:
	await process_frame

	var game_manager: Node = root.get_node("GameManager")
	game_manager.start_new_run()

	var screen: Control = (load("res://scenes/screens/GameScreen.tscn") as PackedScene).instantiate()
	root.add_child(screen)
	await process_frame

	var day_label: Label = screen.get_node("%DayLabel")
	var decision_card: PanelContainer = screen.get_node("%DecisionCard")
	var result_panel: PanelContainer = screen.get_node("%ResultPanel")
	var proposal_label: Label = decision_card.get_node("%ProposalLabel")

	# Option buttons are rebuilt for every decision since schema v2.
	var buttons: Array[Button] = decision_card.get_option_buttons()

	_check(day_label.text == "DAY 1", "day label shows DAY 1, got '%s'" % day_label.text)
	_check(decision_card.visible, "decision card visible")
	_check(not proposal_label.text.is_empty(), "proposal populated")
	_check(buttons.size() >= 2, "at least two option buttons rendered")
	_check(not buttons[0].disabled, "choices enabled before pick")
	_check(not result_panel.visible, "result panel hidden before pick")

	# Simulate tapping the first choice button.
	buttons[0].pressed.emit()
	await process_frame

	_check(buttons[0].disabled, "choices disabled after pick")
	_check(result_panel.visible, "result panel visible after pick")
	var result_text: Label = result_panel.get_node("%ResultTextLabel")
	_check(not result_text.text.is_empty(), "result text populated")

	# Tapping again must not double-resolve (TC-002 at the UI level).
	var history_size: int = game_manager.get_current_state().decision_history.size()
	buttons[0].pressed.emit()
	await process_frame
	_check(game_manager.get_current_state().decision_history.size() == history_size, "double tap does not re-resolve")

	# Continue to the next day.
	var continue_button: Button = result_panel.get_node("%ContinueButton")
	continue_button.pressed.emit()
	await process_frame

	buttons = decision_card.get_option_buttons()
	_check(day_label.text == "DAY 2", "day label shows DAY 2 after continue, got '%s'" % day_label.text)
	_check(not result_panel.visible, "result panel hidden on next card")
	_check(buttons.size() >= 2 and not buttons[0].disabled, "choices enabled on next card")

	# Play several more days to shake out loop issues. Resources are topped
	# up each day so no collapse ending cuts the loop short (endings have
	# their own tests in test_ending_resolver.gd / test_run_end_screen.gd).
	# Left-only choices never set flags, so the pool can legitimately run dry
	# near day 12 once the fallback card hits its per-run cap; ending the run
	# with content_exhausted is a valid outcome, looping the fallback is not.
	for i in range(10):
		if game_manager.get_current_state().run_phase == RunState.RunPhase.ENDED:
			break
		for resource_id in RunState.RESOURCE_IDS:
			game_manager.debug_set_resource(resource_id, 55)
		buttons = decision_card.get_option_buttons()
		if buttons.is_empty():
			break
		buttons[0].pressed.emit()
		await process_frame
		continue_button.pressed.emit()
		await process_frame
	var reached_day_12: bool = day_label.text == "DAY 12"
	var exhausted_cleanly: bool = game_manager.get_current_state().run_phase == RunState.RunPhase.ENDED \
		and game_manager.get_last_summary().ending_id == "content_exhausted"
	_check(reached_day_12 or exhausted_cleanly,
		"loop reaches day 12 or ends via content_exhausted, got '%s'" % day_label.text)

	if _failures == 0:
		print("[TEST] All GameScreen smoke tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)
