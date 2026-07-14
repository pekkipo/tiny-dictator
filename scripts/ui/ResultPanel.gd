extends PanelContainer

## Shows what a choice actually did before the run continues (PRD 02 §12).

signal continue_pressed

const RESOURCE_ICONS: Dictionary = {
	"treasury": "💰",
	"happiness": "🙂",
	"order": "🛡",
	"elite_loyalty": "👑",
}


func _ready() -> void:
	%ContinueButton.pressed.connect(func() -> void: continue_pressed.emit())


func show_result(result: DecisionResult, content: ContentRepository) -> void:
	%ResultTextLabel.text = result.result_text

	var deltas: PackedStringArray = []
	for resource_id in RESOURCE_ICONS:
		var applied: int = int(result.resource_changes.get(resource_id, 0))
		if applied != 0:
			deltas.append("%s %+d" % [RESOURCE_ICONS[resource_id], applied])
	%DeltaSummaryLabel.text = "  ".join(deltas)
	%DeltaSummaryLabel.visible = not deltas.is_empty()

	var law_lines: PackedStringArray = []
	for law_id in result.added_laws:
		var law: Dictionary = content.get_law(law_id)
		law_lines.append("New law: %s %s" % [str(law.get("placeholder_icon", "")), str(law.get("display_name", law_id))])
	for law_id in result.removed_laws:
		var law: Dictionary = content.get_law(law_id)
		law_lines.append("Repealed: %s" % str(law.get("display_name", law_id)))
	%NewLawLabel.text = "\n".join(law_lines)
	%NewLawLabel.visible = not law_lines.is_empty()
