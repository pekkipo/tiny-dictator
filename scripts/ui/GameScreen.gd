extends Control

signal debug_run_end_pressed
signal main_menu_pressed


func _ready() -> void:
	%DebugRunEndButton.pressed.connect(_on_debug_run_end_pressed)
	%DebugStartButton.pressed.connect(_on_main_menu_pressed)


func _on_debug_run_end_pressed() -> void:
	debug_run_end_pressed.emit()


func _on_main_menu_pressed() -> void:
	main_menu_pressed.emit()
