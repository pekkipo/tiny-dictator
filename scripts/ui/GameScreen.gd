extends Control

## Main gameplay screen controller. Displays state and forwards player
## actions to GameManager; owns no gameplay logic (PRD 04 §11).


func _ready() -> void:
	%DecisionCard.choice_selected.connect(_on_choice_selected)
	%ResultPanel.continue_pressed.connect(_on_continue_pressed)
	%DebugRunEndButton.pressed.connect(_on_debug_run_end_pressed)
	%DebugStartButton.pressed.connect(_on_debug_start_pressed)
	EventBus.decision_presented.connect(_on_decision_presented)
	EventBus.decision_resolved.connect(_on_decision_resolved)
	EventBus.country_visual_state_changed.connect(_on_visual_state_changed)
	_refresh_all()


func _refresh_all() -> void:
	var state: RunState = GameManager.get_current_state()
	var content: ContentRepository = GameManager.get_content()
	var country: Dictionary = content.get_country(state.country_id)

	%CountryLabel.text = str(country.get("display_name", state.country_id)).to_upper()
	%DayLabel.text = "DAY %d" % state.day
	%ResourceBar.update_resources(state.get_resources())
	%CountryDiorama.update_visual_state(GameManager.get_country_visual_state(), content.get_visual_map())
	%ActiveLawsBar.update_laws(state.active_laws, content)
	%ResultPanel.visible = false

	var decision: Dictionary = GameManager.get_current_decision()
	if decision.is_empty():
		%DecisionCard.visible = false
		return
	%DecisionCard.visible = true
	var advisor: Dictionary = content.get_advisor(str(decision.get("advisor_id", "")))
	%DecisionCard.show_decision(decision, advisor)
	%DecisionCard.set_input_enabled(state.run_phase == RunState.RunPhase.AWAITING_DECISION)


func _on_choice_selected(side: String) -> void:
	GameManager.resolve_choice(side)


func _on_decision_presented(_decision: Dictionary) -> void:
	_refresh_all()


func _on_decision_resolved(result: DecisionResult) -> void:
	%DecisionCard.set_input_enabled(false)
	var state: RunState = GameManager.get_current_state()
	var content: ContentRepository = GameManager.get_content()
	%ResourceBar.update_resources(state.get_resources())
	%ResourceBar.show_deltas(result.resource_changes)
	%ActiveLawsBar.update_laws(state.active_laws, content)
	%ResultPanel.show_result(result, content)
	%ResultPanel.visible = true


func _on_visual_state_changed(visual: CountryVisualState) -> void:
	%CountryDiorama.update_visual_state(visual, GameManager.get_content().get_visual_map())


func _on_continue_pressed() -> void:
	GameManager.continue_after_result()


## Temporary shortcut until the M9 debug overlay; ends the run for real.
func _on_debug_run_end_pressed() -> void:
	GameManager.debug_trigger_ending("revolution")


func _on_debug_start_pressed() -> void:
	GameManager.return_to_main_menu()
