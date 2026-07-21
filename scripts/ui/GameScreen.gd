extends Control

## Main gameplay screen controller. Displays state and forwards player
## actions to GameManager; owns no gameplay logic (PRD 04 §11).

var _hint_controller: OnboardingHintController = OnboardingHintController.new()


func _ready() -> void:
	%DecisionCard.choice_selected.connect(_on_choice_selected)
	%ResultPanel.continue_pressed.connect(_on_continue_pressed)
	%ActiveLawsBar.law_selected.connect(_on_law_selected)
	EventBus.decision_presented.connect(_on_decision_presented)
	EventBus.decision_resolved.connect(_on_decision_resolved)
	EventBus.country_visual_state_changed.connect(_on_visual_state_changed)
	# Keeps the top bar and laws honest when the debug overlay edits state.
	EventBus.resources_changed.connect(_on_resources_changed)
	EventBus.law_added.connect(_on_laws_changed)
	EventBus.law_removed.connect(_on_laws_changed)
	EventBus.run_started.connect(_on_run_started)
	EventBus.run_reset.connect(_on_run_reset)
	_setup_alpha_report()
	_refresh_all()


func _setup_alpha_report() -> void:
	if not has_node("%ReportIssueButton"):
		return
	var alpha_on: bool = ClosedAlphaConfig.is_enabled()
	%ReportIssueButton.visible = alpha_on
	if alpha_on:
		%ReportIssueButton.pressed.connect(func() -> void: EventBus.alpha_report_issue_requested.emit())


func _on_run_started(_state: RunState) -> void:
	_hint_controller.reset()
	_clear_hint()


func _on_run_reset() -> void:
	_hint_controller.reset()
	_clear_hint()


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
	_show_hint_if_needed(_hint_controller.consume_hint_for_decision(decision, state, content))


func _show_hint_if_needed(hint_data: Dictionary) -> void:
	if hint_data.is_empty():
		_clear_hint()
		return
	var concept_id: String = str(hint_data.get("concept_id", ""))
	if not concept_id.is_empty():
		GameManager.mark_onboarding_concept(concept_id)
	if has_node("%OnboardingHintLabel"):
		%OnboardingHintLabel.text = str(hint_data.get("text", ""))
		%OnboardingHintLabel.visible = true


func _clear_hint() -> void:
	if has_node("%OnboardingHintLabel"):
		%OnboardingHintLabel.text = ""
		%OnboardingHintLabel.visible = false


func _on_choice_selected(option_id: String) -> void:
	GameManager.resolve_choice(option_id)


func _on_decision_presented(_decision: Dictionary) -> void:
	_refresh_all()


func _on_decision_resolved(result: DecisionResult) -> void:
	%DecisionCard.set_input_enabled(false)
	var state: RunState = GameManager.get_current_state()
	var content: ContentRepository = GameManager.get_content()
	var resolved_decision: Dictionary = content.get_decision(result.decision_id)
	%ResourceBar.update_resources(state.get_resources())
	%ResourceBar.show_deltas(result.resource_changes)
	%ActiveLawsBar.update_laws(state.active_laws, content)
	%ResultPanel.show_result(result, content)
	%ResultPanel.visible = true
	_show_hint_if_needed(_hint_controller.consume_hint_for_decision(
		resolved_decision, state, content, result,
	))


func _on_visual_state_changed(visual: CountryVisualState) -> void:
	%CountryDiorama.update_visual_state(visual, GameManager.get_content().get_visual_map())


func _on_resources_changed(changes: Dictionary) -> void:
	%ResourceBar.update_resources(changes)


func _on_laws_changed(_law_id: String) -> void:
	%ActiveLawsBar.update_laws(GameManager.get_current_state().active_laws, GameManager.get_content())


func _on_law_selected(law_id: String) -> void:
	%LawDetailPopup.show_law(law_id, GameManager.get_current_state(), GameManager.get_content())


func _on_continue_pressed() -> void:
	GameManager.continue_after_result()
