extends Control

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var continue_button: Button = %ContinueButton

func _ready() -> void:
	EventBus.run_ended.connect(_on_run_ended)
	continue_button.pressed.connect(_on_continue_pressed)

func _on_run_ended(ending_id: String) -> void:
	title_label.text = ending_id.replace("_", " ").capitalize()
	description_label.text = "Your reign has ended."

func _on_continue_pressed() -> void:
	GameManager.go_to_start()
