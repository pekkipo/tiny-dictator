extends PanelContainer

## Shows persistent laws as chips; overflow collapses to "+N more" (PRD 02 §13).

const MAX_VISIBLE_LAWS: int = 5
const EMPTY_TEXT: String = "No laws yet. The country is briefly normal."


func update_laws(law_ids: Array[String], content: ContentRepository) -> void:
	var flow: HFlowContainer = %LawsFlow
	for child in flow.get_children():
		child.queue_free()

	if law_ids.is_empty():
		flow.add_child(_make_chip(EMPTY_TEXT, true))
		return

	for i in range(mini(law_ids.size(), MAX_VISIBLE_LAWS)):
		var law: Dictionary = content.get_law(law_ids[i])
		var text := "%s %s" % [
			str(law.get("placeholder_icon", "📜")),
			str(law.get("short_name", law.get("display_name", law_ids[i]))),
		]
		flow.add_child(_make_chip(text, false))

	if law_ids.size() > MAX_VISIBLE_LAWS:
		flow.add_child(_make_chip("+%d more" % (law_ids.size() - MAX_VISIBLE_LAWS), true))


func _make_chip(text: String, muted: bool) -> Label:
	var chip := Label.new()
	chip.text = text
	chip.add_theme_font_size_override("font_size", 22)
	if muted:
		chip.add_theme_color_override("font_color", Color(0.7, 0.7, 0.72))
	return chip
