extends Control

signal debug_run_end_pressed

@onready var _start_button: Button = %StartButton


func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	%DebugRunEndButton.pressed.connect(_on_debug_run_end_pressed)
	if not GameManager.is_content_valid():
		_start_button.disabled = true
		_start_button.text = "CONTENT ERRORS — SEE LOG"


func _on_start_button_pressed() -> void:
	_start_button.disabled = true
	GameManager.start_new_run()


func _on_debug_run_end_pressed() -> void:
	debug_run_end_pressed.emit()
