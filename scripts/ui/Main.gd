extends Control

## Owns screen switching only. Gameplay flow lives in GameManager.
## Navigation spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §14-§15.

enum Screen { START, GAME, RUN_END }

const SCREEN_SCENES: Dictionary = {
	Screen.START: preload("res://scenes/screens/StartScreen.tscn"),
	Screen.GAME: preload("res://scenes/screens/GameScreen.tscn"),
	Screen.RUN_END: preload("res://scenes/screens/RunEndScreen.tscn"),
}

@onready var _screen_container: Control = %ScreenContainer

var _current_screen: Control = null


func _ready() -> void:
	EventBus.run_started.connect(_on_run_started)
	EventBus.run_reset.connect(_on_run_reset)
	EventBus.run_ended.connect(_on_run_ended)
	print("[BOOT] Main scene ready.")
	show_screen(Screen.START)


func show_screen(screen: Screen) -> void:
	if _current_screen != null:
		_current_screen.queue_free()
		_current_screen = null

	var packed_scene: PackedScene = SCREEN_SCENES[screen]
	_current_screen = packed_scene.instantiate() as Control
	_screen_container.add_child(_current_screen)
	print("[BOOT] Showing screen: %s" % Screen.keys()[screen])


func _on_run_started(_run_state: RunState) -> void:
	show_screen(Screen.GAME)


func _on_run_reset() -> void:
	show_screen(Screen.START)


func _on_run_ended(_summary: RunSummary) -> void:
	show_screen(Screen.RUN_END)
