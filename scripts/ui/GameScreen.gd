extends Control

## Temporary playable placeholder. The real component-based gameplay UI
## (ResourceBar, DecisionCard, ResultPanel, ActiveLawsBar) lands in Milestone 6.

signal debug_run_end_pressed

const RESOURCE_ICONS: Dictionary = {
	"treasury": "💰",
	"happiness": "🙂",
	"order": "🛡",
	"elite_loyalty": "👑",
}


func _ready() -> void:
	%DebugRunEndButton.pressed.connect(_on_debug_run_end_pressed)
	%DebugStartButton.pressed.connect(_on_debug_start_pressed)
	%LeftChoiceButton.pressed.connect(GameManager.choose_left)
	%RightChoiceButton.pressed.connect(GameManager.choose_right)
	%ContinueButton.pressed.connect(GameManager.continue_after_result)
	EventBus.decision_presented.connect(_on_decision_presented)
	EventBus.decision_resolved.connect(_on_decision_resolved)
	_refresh_from_state()


func _refresh_from_state() -> void:
	var state: RunState = GameManager.get_current_state()
	%DayLabel.text = "DAY %d  |  %s" % [state.day, state.country_id.to_upper()]
	%ResourcesLabel.text = "💰 %d   🙂 %d   🛡 %d   👑 %d" % [
		state.treasury, state.happiness, state.order, state.elite_loyalty,
	]
	%ResultLabel.visible = false
	%ContinueButton.visible = false

	var decision: Dictionary = GameManager.get_current_decision()
	if decision.is_empty():
		%PlaceholderLabel.text = "No decision available."
		%LeftChoiceButton.visible = false
		%RightChoiceButton.visible = false
		return

	var advisor: Dictionary = GameManager.get_content().get_advisor(str(decision.get("advisor_id", "")))
	%PlaceholderLabel.text = "%s %s (%s):\n\n%s" % [
		str(advisor.get("placeholder_icon", "")),
		str(advisor.get("display_name", "?")),
		str(advisor.get("role", "")),
		str(decision.get("proposal", "")),
	]
	_setup_choice_button(%LeftChoiceButton, decision.get("left", {}))
	_setup_choice_button(%RightChoiceButton, decision.get("right", {}))


func _setup_choice_button(button: Button, option: Dictionary) -> void:
	button.visible = true
	button.disabled = false
	button.text = "%s\n%s" % [str(option.get("label", "?")), _visible_effects_text(option)]


## Shows configured effects; respects the visible_effects filter (PRD 02 §11).
func _visible_effects_text(option: Dictionary) -> String:
	var effects: Dictionary = option.get("effects", {})
	var visible: Array = option.get("visible_effects", effects.keys())
	var parts: PackedStringArray = []
	for resource_id in RunState.RESOURCE_IDS:
		if resource_id in visible and effects.has(resource_id) and int(effects[resource_id]) != 0:
			parts.append("%s %+d" % [RESOURCE_ICONS[resource_id], int(effects[resource_id])])
	return " ".join(parts)


func _on_decision_presented(_decision: Dictionary) -> void:
	_refresh_from_state()


func _on_decision_resolved(result: DecisionResult) -> void:
	%LeftChoiceButton.disabled = true
	%RightChoiceButton.disabled = true

	var state: RunState = GameManager.get_current_state()
	%ResourcesLabel.text = "💰 %d   🙂 %d   🛡 %d   👑 %d" % [
		state.treasury, state.happiness, state.order, state.elite_loyalty,
	]

	var lines: PackedStringArray = [result.result_text, ""]
	for resource_id in RunState.RESOURCE_IDS:
		if result.resource_changes.has(resource_id) and int(result.resource_changes[resource_id]) != 0:
			lines.append("%s %+d" % [RESOURCE_ICONS[resource_id], int(result.resource_changes[resource_id])])
	for law_id in result.added_laws:
		var law: Dictionary = GameManager.get_content().get_law(law_id)
		lines.append("New law: %s %s" % [str(law.get("placeholder_icon", "")), str(law.get("display_name", law_id))])
	for law_id in result.removed_laws:
		var law: Dictionary = GameManager.get_content().get_law(law_id)
		lines.append("Repealed: %s" % str(law.get("display_name", law_id)))
	%ResultLabel.text = "\n".join(lines)
	%ResultLabel.visible = true
	%ContinueButton.visible = true


func _on_debug_run_end_pressed() -> void:
	debug_run_end_pressed.emit()


func _on_debug_start_pressed() -> void:
	GameManager.return_to_main_menu()
