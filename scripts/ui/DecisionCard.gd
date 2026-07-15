extends PanelContainer

## Presents the current advisor, proposal, and the decision's options
## (PRD 02 §10-§11, PRD 2A §12-§13). Renders two options side by side and
## three options stacked vertically for portrait mode. Emits the picked
## option id; never resolves anything itself.

signal choice_selected(option_id: String)

const RESOURCE_ICONS: Dictionary = {
	"treasury": "💰",
	"happiness": "🙂",
	"order": "🛡",
	"elite_loyalty": "👑",
}

## Placeholder banners per card type (PRD 2A §13). "normal" shows no banner.
## Later milestones add real behavior; this is presentation only.
const CARD_TYPE_BANNERS: Dictionary = {
	"crisis": "🔥 CRISIS",
	"advisor": "🤝 ADVISOR MATTER",
	"consequence": "↩ CONSEQUENCE",
	"resolution": "🏁 RESOLUTION",
	"recovery": "🚑 RECOVERY",
	"ending_setup": "🔮 SOMETHING STIRS",
}

const TWO_OPTION_BUTTON_HEIGHT: int = 110
const THREE_OPTION_BUTTON_HEIGHT: int = 84

var _option_buttons: Array[Button] = []


func show_decision(decision: Dictionary, advisor: Dictionary) -> void:
	%AdvisorPortraitLabel.text = str(advisor.get("placeholder_icon", "👤"))
	%AdvisorNameLabel.text = str(advisor.get("display_name", "Unknown Advisor"))
	%AdvisorRoleLabel.text = str(advisor.get("role", ""))
	%ProposalLabel.text = str(decision.get("proposal", ""))

	var card_type: String = str(decision.get("card_type", DecisionSchema.DEFAULT_CARD_TYPE))
	var banner_text: String = str(CARD_TYPE_BANNERS.get(card_type, ""))
	if card_type == "crisis":
		var days_left: int = GameManager.get_crisis_days_remaining()
		var crisis_state: Dictionary = GameManager.debug_get_crisis_state()
		var severity: int = int(crisis_state.get("severity", 0))
		if severity > 0 or days_left > 0:
			banner_text = "🔥 CRISIS — SEV %d — %dd left" % [severity if severity > 0 else 1, days_left]
		modulate = Color(1.0, 0.94, 0.88)
	else:
		modulate = Color.WHITE
	%CardTypeLabel.text = banner_text
	%CardTypeLabel.visible = CARD_TYPE_BANNERS.has(card_type) or card_type == "crisis"

	_rebuild_options(DecisionSchema.get_options(decision))
	set_input_enabled(true)


func set_input_enabled(enabled: bool) -> void:
	for button in _option_buttons:
		button.disabled = not enabled


## Exposed for tests and debug tools.
func get_option_buttons() -> Array[Button]:
	return _option_buttons.duplicate()


func _rebuild_options(options: Array) -> void:
	var container: BoxContainer = %OptionsContainer
	for child in container.get_children():
		child.queue_free()
	_option_buttons.clear()

	# Two options sit side by side (classic left/right); three stack
	# vertically so labels stay readable in portrait (PRD 2A milestone 1).
	container.vertical = options.size() >= 3
	var button_height: int = THREE_OPTION_BUTTON_HEIGHT if container.vertical else TWO_OPTION_BUTTON_HEIGHT

	for option in options:
		if not (option is Dictionary):
			continue
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, button_height)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.add_theme_font_size_override("font_size", 24)
		var label: String = str(option.get("label", "?"))
		var effects_text := _visible_effects_text(option)
		button.text = label if effects_text.is_empty() else "%s\n%s" % [label, effects_text]
		var option_id: String = str(option.get("id", ""))
		button.pressed.connect(func() -> void: choice_selected.emit(option_id))
		container.add_child(button)
		_option_buttons.append(button)


## Effects are shown exactly as configured unless filtered by visible_effects
## (PRD 02 §11). Hidden effects surface later in the result panel.
func _visible_effects_text(option: Dictionary) -> String:
	var effects: Dictionary = option.get("effects", {})
	var visible: Array = option.get("visible_effects", effects.keys())
	var parts: PackedStringArray = []
	for resource_id in RESOURCE_ICONS:
		if resource_id in visible and effects.has(resource_id) and int(effects[resource_id]) != 0:
			parts.append("%s %+d" % [RESOURCE_ICONS[resource_id], int(effects[resource_id])])
	return "  ".join(parts)
