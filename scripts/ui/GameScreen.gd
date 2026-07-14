extends Control

signal debug_run_end_pressed


func _ready() -> void:
	%DebugRunEndButton.pressed.connect(_on_debug_run_end_pressed)
	%DebugStartButton.pressed.connect(_on_debug_start_pressed)
	_refresh_from_state()


## Placeholder display until the real gameplay UI lands in Milestone 6.
func _refresh_from_state() -> void:
	var state: RunState = GameManager.get_current_state()
	%DayLabel.text = "DAY %d  |  %s" % [state.day, state.country_id.to_upper()]
	%ResourcesLabel.text = "💰 %d   🙂 %d   🛡 %d   👑 %d" % [
		state.treasury, state.happiness, state.order, state.elite_loyalty,
	]
	var decision: Dictionary = GameManager.get_current_decision()
	if decision.is_empty():
		%PlaceholderLabel.text = "No decision selected."
		return
	var advisor: Dictionary = GameManager.get_content().get_advisor(str(decision.get("advisor_id", "")))
	%PlaceholderLabel.text = "%s %s (%s):\n\n%s" % [
		str(advisor.get("placeholder_icon", "")),
		str(advisor.get("display_name", "?")),
		str(advisor.get("role", "")),
		str(decision.get("proposal", "")),
	]


func _on_debug_run_end_pressed() -> void:
	debug_run_end_pressed.emit()


func _on_debug_start_pressed() -> void:
	GameManager.return_to_main_menu()
