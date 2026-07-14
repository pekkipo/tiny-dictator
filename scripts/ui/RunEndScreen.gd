extends Control

signal restart_pressed
signal main_menu_pressed


func _ready() -> void:
	%RestartButton.pressed.connect(_on_restart_pressed)
	%MainMenuButton.pressed.connect(_on_main_menu_pressed)


func _on_restart_pressed() -> void:
	restart_pressed.emit()


func _on_main_menu_pressed() -> void:
	main_menu_pressed.emit()
