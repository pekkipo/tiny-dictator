extends Control

## Developer-only overlay (PRD 02 §15, PRD 05 §7). Toggled with F1 or backtick.
## Every action goes through normal GameManager APIs; owns no gameplay logic.


func _ready() -> void:
	visible = false

	%CloseButton.pressed.connect(toggle_visibility)
	%SetResourceButton.pressed.connect(_on_set_resource_pressed)
	%ForceDecisionButton.pressed.connect(_on_force_decision_pressed)
	%AddLawButton.pressed.connect(_on_add_law_pressed)
	%AddFlagButton.pressed.connect(_on_add_flag_pressed)
	%TriggerEndingButton.pressed.connect(_on_trigger_ending_pressed)
	%SetSeedButton.pressed.connect(_on_set_seed_pressed)
	%AdvanceDayButton.pressed.connect(_on_advance_day_pressed)
	%RestartButton.pressed.connect(_on_restart_pressed)
	%PrintStateButton.pressed.connect(_on_print_state_pressed)
	%ReloadContentButton.pressed.connect(_on_reload_content_pressed)
	%ResetSaveButton.pressed.connect(_on_reset_save_pressed)

	for resource_id in RunState.RESOURCE_IDS:
		%ResourceOption.add_item(resource_id)
	_populate_ending_options()

	EventBus.decision_presented.connect(func(_decision: Dictionary) -> void: _refresh())
	EventBus.decision_resolved.connect(func(_result: DecisionResult) -> void: _refresh())
	EventBus.resources_changed.connect(func(_changes: Dictionary) -> void: _refresh())
	EventBus.run_started.connect(func(_state: RunState) -> void: _refresh())
	EventBus.run_ended.connect(func(_summary: RunSummary) -> void: _refresh())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo \
			and (event.keycode == KEY_F1 or event.keycode == KEY_QUOTELEFT):
		toggle_visibility()
		get_viewport().set_input_as_handled()


func toggle_visibility() -> void:
	visible = not visible
	if visible:
		_populate_ending_options()
		_show_feedback("", true)
		_refresh()


func _refresh() -> void:
	if not visible:
		return
	var state: RunState = GameManager.get_current_state()
	var lines: PackedStringArray = [
		"phase: %s   day: %d   seed: %d" % [
			RunState.RunPhase.keys()[state.run_phase], state.day, state.random_seed,
		],
		"decision: %s" % (state.current_decision_id if not state.current_decision_id.is_empty() else "(none)"),
		"resources: 💰 %d  🙂 %d  🛡 %d  👑 %d" % [state.treasury, state.happiness, state.order, state.elite_loyalty],
		"laws: %s" % (", ".join(state.active_laws) if not state.active_laws.is_empty() else "(none)"),
		"flags: %s" % (", ".join(state.flags) if not state.flags.is_empty() else "(none)"),
		"counters: %s" % (JSON.stringify(state.counters) if not state.counters.is_empty() else "(none)"),
	]
	%StateLabel.text = "\n".join(lines)


func _populate_ending_options() -> void:
	%EndingOption.clear()
	for ending in GameManager.get_content().get_raw_endings():
		%EndingOption.add_item(str(ending.get("id", "")))


func _show_feedback(message: String, ok: bool) -> void:
	%FeedbackLabel.text = message
	%FeedbackLabel.add_theme_color_override(
		"font_color", Color(0.6, 0.9, 0.6) if ok else Color(0.95, 0.5, 0.4))
	_refresh()


func _on_set_resource_pressed() -> void:
	var resource_id: String = %ResourceOption.get_item_text(%ResourceOption.selected)
	var value: int = int(%ResourceValueSpin.value)
	GameManager.debug_set_resource(resource_id, value)
	_show_feedback("Set %s to %d." % [resource_id, value], true)


func _on_force_decision_pressed() -> void:
	var decision_id: String = %ForceDecisionEdit.text.strip_edges()
	if GameManager.force_decision(decision_id):
		_show_feedback("Forced '%s' as the next decision." % decision_id, true)
	else:
		_show_feedback("Unknown decision '%s'." % decision_id, false)


func _on_add_law_pressed() -> void:
	var law_id: String = %AddLawEdit.text.strip_edges()
	if GameManager.debug_add_law(law_id):
		_show_feedback("Law '%s' added." % law_id, true)
	else:
		_show_feedback("Cannot add law '%s' (unknown or already active)." % law_id, false)


func _on_add_flag_pressed() -> void:
	var flag_id: String = %AddFlagEdit.text.strip_edges()
	if GameManager.debug_add_flag(flag_id):
		_show_feedback("Flag '%s' added." % flag_id, true)
	else:
		_show_feedback("Cannot add flag '%s' (empty or already set)." % flag_id, false)


func _on_trigger_ending_pressed() -> void:
	if %EndingOption.selected < 0:
		return
	var ending_id: String = %EndingOption.get_item_text(%EndingOption.selected)
	GameManager.debug_trigger_ending(ending_id)
	_show_feedback("Triggered ending '%s'." % ending_id, true)


func _on_set_seed_pressed() -> void:
	var text: String = %SeedEdit.text.strip_edges()
	if not text.is_empty() and not text.is_valid_int():
		_show_feedback("Seed must be an integer (0 clears).", false)
		return
	var new_seed: int = int(text) if not text.is_empty() else 0
	GameManager.debug_set_fixed_seed(new_seed)
	_show_feedback("Fixed seed cleared." if new_seed == 0 else "Next run uses seed %d." % new_seed, true)


func _on_advance_day_pressed() -> void:
	if GameManager.debug_advance_day():
		_show_feedback("Advanced to day %d." % GameManager.get_current_state().day, true)
	else:
		_show_feedback("Cannot advance day now (no run awaiting a decision).", false)


func _on_restart_pressed() -> void:
	GameManager.restart_run()
	_show_feedback("Run restarted.", true)


func _on_print_state_pressed() -> void:
	GameManager.debug_print_state()
	_show_feedback("State JSON printed to console.", true)


func _on_reload_content_pressed() -> void:
	var ok: bool = GameManager.reload_content()
	_populate_ending_options()
	_show_feedback("Content reloaded. Valid: %s." % ok, ok)


func _on_reset_save_pressed() -> void:
	SaveManager.reset_save()
	_show_feedback("Save reset: unlocked endings cleared.", true)
