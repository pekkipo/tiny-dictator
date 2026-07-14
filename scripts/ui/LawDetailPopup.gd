extends Control

## Modal card describing one active law: what it is, how it was enacted,
## and teasing hints about its long-term influence. Facts come from
## LawImpactResolver; this script only formats and displays them.

const RESOURCE_ICONS: Dictionary = {
	"treasury": "💰",
	"happiness": "🙂",
	"order": "🛡",
	"elite_loyalty": "👑",
}


func _ready() -> void:
	visible = false
	%CloseButton.pressed.connect(hide_popup)
	%Dim.gui_input.connect(_on_dim_input)


func show_law(law_id: String, state: RunState, content: ContentRepository) -> void:
	var info: Dictionary = LawImpactResolver.describe(law_id, state, content)
	var law: Dictionary = info["law"]

	%LawIconLabel.text = str(law.get("placeholder_icon", "📜"))
	%LawNameLabel.text = str(law.get("display_name", law_id))
	%LawCategoryLabel.text = str(law.get("category", "")).replace("_", " ").to_upper()
	%LawDescriptionLabel.text = str(law.get("description", ""))

	if info["enacted_day"] > 0:
		var deltas: PackedStringArray = []
		for resource_id in RESOURCE_ICONS:
			if info["enactment_changes"].has(resource_id):
				deltas.append("%s %+d" % [RESOURCE_ICONS[resource_id], int(info["enactment_changes"][resource_id])])
		%EnactedLabel.text = "Enacted on day %d — \"%s\"%s" % [
			info["enacted_day"], info["enacted_choice"],
			"" if deltas.is_empty() else "\nImmediate impact: %s" % "  ".join(deltas),
		]
	else:
		%EnactedLabel.text = "Enacted under mysterious circumstances."

	%InfluenceLabel.text = "\n".join(_influence_lines(info))
	visible = true


func hide_popup() -> void:
	visible = false


func _influence_lines(info: Dictionary) -> PackedStringArray:
	var lines: PackedStringArray = []
	var unlocks: int = int(info["unlocks_decisions"])
	var blocks: int = int(info["blocks_decisions"])
	if unlocks > 0:
		lines.append("👀 Advisors have %s that only exist because of this law." % (
			"a plan" if unlocks == 1 else "%d plans" % unlocks))
	if blocks > 0:
		lines.append("🚫 Quietly prevents %s from ever reaching your desk." % (
			"one proposal" if blocks == 1 else "%d proposals" % blocks))
	if info["ending_related"]:
		lines.append("🔮 Rumor has it this law could decide how your reign ends.")
	if info["repealable"]:
		lines.append("📝 Could still be repealed, if circumstances demand it.")
	if not info["visual_props"].is_empty():
		lines.append("🏙️ Visible across the country: %s" % "  ".join(info["visual_props"]))
	if lines.is_empty():
		lines.append("No further consequences expected. Probably.")
	return lines


func _on_dim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		hide_popup()
