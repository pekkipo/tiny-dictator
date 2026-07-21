extends CanvasLayer

## Lightweight closed-alpha feedback form. Optional; never forced after a run.

signal closed
signal submitted(record: Dictionary)

var _default_type: String = "general"
var _default_decision_id: String = ""
var _default_run_id: String = ""


func _ready() -> void:
	layer = 120
	visible = false
	%CloseButton.pressed.connect(hide_panel)
	%SubmitButton.pressed.connect(_on_submit_pressed)
	%TypeOption.clear()
	for label in ["general", "bug", "confusion", "humor", "pacing", "ending", "other"]:
		%TypeOption.add_item(label)


func open_panel(feedback_type: String = "general", decision_id: String = "", run_id: String = "") -> void:
	if not ClosedAlphaConfig.is_enabled():
		return
	_default_type = feedback_type if not feedback_type.is_empty() else "general"
	_default_decision_id = decision_id
	_default_run_id = run_id
	_reset_form()
	visible = true


func hide_panel() -> void:
	visible = false
	closed.emit()


func _reset_form() -> void:
	%StatusLabel.text = ""
	%DecisionIdEdit.text = _default_decision_id
	%RunIdEdit.text = _default_run_id if not _default_run_id.is_empty() else ClosedAlphaLogger.get_last_completed_run_id()
	%CommentEdit.text = ""
	%RatingSpin.value = 3
	%ConfusingCheck.button_pressed = false
	%RepeatedCheck.button_pressed = false
	%BugCheck.button_pressed = _default_type == "bug"
	%OffensiveCheck.button_pressed = false
	%FavoriteCheck.button_pressed = false
	var type_index: int = 0
	for i in range(%TypeOption.item_count):
		if %TypeOption.get_item_text(i) == _default_type:
			type_index = i
			break
	%TypeOption.select(type_index)


func _on_submit_pressed() -> void:
	var record: Dictionary = ClosedAlphaLogger.submit_feedback({
		"feedback_type": %TypeOption.get_item_text(%TypeOption.selected),
		"related_decision_id": %DecisionIdEdit.text.strip_edges(),
		"related_run_id": %RunIdEdit.text.strip_edges(),
		"rating": int(%RatingSpin.value),
		"comment": %CommentEdit.text.strip_edges(),
		"confusing_content": %ConfusingCheck.button_pressed,
		"repeated_content": %RepeatedCheck.button_pressed,
		"technical_bug": %BugCheck.button_pressed,
		"offensive_or_inappropriate": %OffensiveCheck.button_pressed,
		"favorite_moment": %FavoriteCheck.button_pressed,
	})
	if record.is_empty():
		%StatusLabel.text = "Feedback not saved (alpha logging inactive)."
		return
	%StatusLabel.text = "Saved locally. Thank you."
	submitted.emit(record)
	await get_tree().create_timer(0.6).timeout
	hide_panel()
