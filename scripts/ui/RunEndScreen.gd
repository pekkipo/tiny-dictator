extends Control


func _ready() -> void:
	%RestartButton.pressed.connect(_on_restart_pressed)
	%MainMenuButton.pressed.connect(_on_main_menu_pressed)


func _on_restart_pressed() -> void:
	GameManager.restart_run()


func _on_main_menu_pressed() -> void:
	GameManager.return_to_main_menu()
