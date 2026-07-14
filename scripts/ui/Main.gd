extends Control

enum Screen { START, GAME, RUN_END }

const SCREEN_SCENES: Dictionary = {
	Screen.START: preload("res://scenes/screens/StartScreen.tscn"),
	Screen.GAME: preload("res://scenes/screens/GameScreen.tscn"),
	Screen.RUN_END: preload("res://scenes/screens/RunEndScreen.tscn"),
}

@onready var _screen_container: Control = %ScreenContainer

var _current_screen: Control = null


func _ready() -> void:
	print("[BOOT] Main scene ready.")
	show_screen(Screen.START)


func show_screen(screen: Screen) -> void:
	if _current_screen != null:
		_current_screen.queue_free()
		_current_screen = null

	var packed_scene: PackedScene = SCREEN_SCENES[screen]
	_current_screen = packed_scene.instantiate() as Control
	_screen_container.add_child(_current_screen)
	_connect_screen_signals(_current_screen)
	print("[BOOT] Showing screen: %s" % Screen.keys()[screen])


func _connect_screen_signals(screen: Control) -> void:
	if screen.has_signal("start_pressed"):
		if not screen.start_pressed.is_connected(_on_start_pressed):
			screen.start_pressed.connect(_on_start_pressed)
	if screen.has_signal("debug_run_end_pressed"):
		if not screen.debug_run_end_pressed.is_connected(_on_debug_run_end_pressed):
			screen.debug_run_end_pressed.connect(_on_debug_run_end_pressed)
	if screen.has_signal("main_menu_pressed"):
		if not screen.main_menu_pressed.is_connected(_on_main_menu_pressed):
			screen.main_menu_pressed.connect(_on_main_menu_pressed)
	if screen.has_signal("restart_pressed"):
		if not screen.restart_pressed.is_connected(_on_restart_pressed):
			screen.restart_pressed.connect(_on_restart_pressed)


func _on_start_pressed() -> void:
	show_screen(Screen.GAME)


func _on_debug_run_end_pressed() -> void:
	show_screen(Screen.RUN_END)


func _on_main_menu_pressed() -> void:
	show_screen(Screen.START)


func _on_restart_pressed() -> void:
	show_screen(Screen.GAME)
