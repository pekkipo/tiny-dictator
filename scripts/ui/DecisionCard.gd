extends PanelContainer

## Presents the current advisor, proposal, and two choices (PRD 02 §10-§11).
## Emits the player's pick; never resolves anything itself.

signal choice_selected(side: String)

const RESOURCE_ICONS: Dictionary = {
	"treasury": "💰",
	"happiness": "🙂",
	"order": "🛡",
	"elite_loyalty": "👑",
}


func _ready() -> void:
	%LeftChoiceButton.pressed.connect(func() -> void: choice_selected.emit("left"))
	%RightChoiceButton.pressed.connect(func() -> void: choice_selected.emit("right"))


func show_decision(decision: Dictionary, advisor: Dictionary) -> void:
	%AdvisorPortraitLabel.text = str(advisor.get("placeholder_icon", "👤"))
	%AdvisorNameLabel.text = str(advisor.get("display_name", "Unknown Advisor"))
	%AdvisorRoleLabel.text = str(advisor.get("role", ""))
	%ProposalLabel.text = str(decision.get("proposal", ""))
	_setup_button(%LeftChoiceButton, decision.get("left", {}))
	_setup_button(%RightChoiceButton, decision.get("right", {}))
	set_input_enabled(true)


func set_input_enabled(enabled: bool) -> void:
	%LeftChoiceButton.disabled = not enabled
	%RightChoiceButton.disabled = not enabled


func _setup_button(button: Button, option: Dictionary) -> void:
	var label: String = str(option.get("label", "?"))
	var effects_text := _visible_effects_text(option)
	button.text = label if effects_text.is_empty() else "%s\n%s" % [label, effects_text]


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
