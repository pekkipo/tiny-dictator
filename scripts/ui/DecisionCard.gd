extends Control

signal choice_selected(decision_id: String, choice_id: String)

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var choices_container: VBoxContainer = %ChoicesContainer

var _decision_id: String = ""

func show_decision(decision: DecisionData) -> void:
	_decision_id = decision.id
	title_label.text = decision.title
	description_label.text = decision.description
	_clear_choices()
	for choice in decision.choices:
		_add_choice_button(choice)

func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()

func _add_choice_button(choice: Dictionary) -> void:
	var button := Button.new()
	button.text = choice.get("label", "Choose")
	button.pressed.connect(_on_choice_pressed.bind(choice.get("id", "")))
	choices_container.add_child(button)

func _on_choice_pressed(choice_id: String) -> void:
	choice_selected.emit(_decision_id, choice_id)
