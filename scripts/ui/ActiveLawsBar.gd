extends PanelContainer

## Shows persistent laws as tappable chips; overflow collapses to "+N more"
## which expands in place (PRD 02 §13). Tapping a law asks the screen to
## open its detail view.

signal law_selected(law_id: String)

const MAX_VISIBLE_LAWS: int = 5
const EMPTY_TEXT: String = "No laws yet. The country is briefly normal."

var _expanded: bool = false
var _law_ids: Array[String] = []
var _content: ContentRepository = null


func update_laws(law_ids: Array[String], content: ContentRepository) -> void:
	_law_ids = law_ids.duplicate()
	_content = content
	if _law_ids.size() <= MAX_VISIBLE_LAWS:
		_expanded = false
	_rebuild()


func _rebuild() -> void:
	var flow: HFlowContainer = %LawsFlow
	for child in flow.get_children():
		child.queue_free()

	if _law_ids.is_empty():
		flow.add_child(_make_label_chip(EMPTY_TEXT))
		return

	var visible_count: int = _law_ids.size() if _expanded else mini(_law_ids.size(), MAX_VISIBLE_LAWS)
	for i in range(visible_count):
		flow.add_child(_make_law_chip(_law_ids[i]))

	if _law_ids.size() > MAX_VISIBLE_LAWS:
		var toggle := Button.new()
		toggle.text = "show less" if _expanded else "+%d more" % (_law_ids.size() - MAX_VISIBLE_LAWS)
		toggle.flat = true
		toggle.add_theme_font_size_override("font_size", 22)
		toggle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.72))
		toggle.pressed.connect(func() -> void:
			_expanded = not _expanded
			_rebuild())
		flow.add_child(toggle)


func _make_law_chip(law_id: String) -> Button:
	var law: Dictionary = _content.get_law(law_id)
	var chip := Button.new()
	chip.text = "%s %s" % [
		str(law.get("placeholder_icon", "📜")),
		str(law.get("short_name", law.get("display_name", law_id))),
	]
	chip.flat = true
	chip.add_theme_font_size_override("font_size", 22)
	chip.tooltip_text = "Tap for details"
	chip.pressed.connect(func() -> void: law_selected.emit(law_id))
	return chip


func _make_label_chip(text: String) -> Label:
	var chip := Label.new()
	chip.text = text
	chip.add_theme_font_size_override("font_size", 22)
	chip.add_theme_color_override("font_color", Color(0.7, 0.7, 0.72))
	return chip
