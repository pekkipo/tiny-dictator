extends Control

@onready var _start_button: Button = %StartButton


func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	if not GameManager.is_content_valid():
		_start_button.disabled = true
		_start_button.text = "CONTENT ERRORS — SEE LOG"


func _on_start_button_pressed() -> void:
	_start_button.disabled = true
	GameManager.start_new_run()
