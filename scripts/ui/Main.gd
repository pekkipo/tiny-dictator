extends Control

## Owns screen switching only. Gameplay flow lives in GameManager.
## Navigation spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §14-§15.

enum Screen { START, GAME, RUN_END, META }

const SCREEN_SCENES: Dictionary = {
	Screen.START: preload("res://scenes/screens/StartScreen.tscn"),
	Screen.GAME: preload("res://scenes/screens/GameScreen.tscn"),
	Screen.RUN_END: preload("res://scenes/screens/RunEndScreen.tscn"),
	Screen.META: preload("res://scenes/screens/MetaProgressScreen.tscn"),
}

const ALPHA_FEEDBACK_SCENE: PackedScene = preload("res://scenes/components/AlphaFeedbackPanel.tscn")
const ALPHA_SETTINGS_SCENE: PackedScene = preload("res://scenes/components/AlphaSettingsPanel.tscn")

@onready var _screen_container: Control = %ScreenContainer

var _current_screen: Control = null
var _alpha_feedback: CanvasLayer = null
var _alpha_settings: CanvasLayer = null


func _ready() -> void:
	EventBus.run_started.connect(_on_run_started)
	EventBus.run_reset.connect(_on_run_reset)
	EventBus.run_ended.connect(_on_run_ended)
	EventBus.meta_screen_requested.connect(_on_meta_screen_requested)
	EventBus.alpha_settings_requested.connect(_on_alpha_settings_requested)
	EventBus.alpha_feedback_requested.connect(_on_alpha_feedback_requested)
	EventBus.alpha_report_issue_requested.connect(_on_alpha_report_issue_requested)
	_setup_alpha_panels()
	print("[BOOT] Main scene ready.")
	show_screen(Screen.START)


func _setup_alpha_panels() -> void:
	if not ClosedAlphaConfig.is_enabled():
		return
	_alpha_feedback = ALPHA_FEEDBACK_SCENE.instantiate()
	add_child(_alpha_feedback)
	_alpha_settings = ALPHA_SETTINGS_SCENE.instantiate()
	add_child(_alpha_settings)
	_alpha_settings.feedback_requested.connect(func() -> void:
		EventBus.alpha_feedback_requested.emit("general", "", "")
	)
	_alpha_settings.report_issue_requested.connect(func() -> void:
		EventBus.alpha_report_issue_requested.emit()
	)


func show_screen(screen: Screen) -> void:
	if _current_screen != null:
		_current_screen.queue_free()
		_current_screen = null

	var packed_scene: PackedScene = SCREEN_SCENES[screen]
	_current_screen = packed_scene.instantiate() as Control
	_screen_container.add_child(_current_screen)
	if screen == Screen.META and _current_screen.has_signal("back_pressed"):
		_current_screen.back_pressed.connect(_on_meta_back_pressed)
	print("[BOOT] Showing screen: %s" % Screen.keys()[screen])


func _on_run_started(_run_state: RunState) -> void:
	show_screen(Screen.GAME)


func _on_run_reset() -> void:
	show_screen(Screen.START)


func _on_run_ended(_summary: RunSummary) -> void:
	show_screen(Screen.RUN_END)


func _on_meta_screen_requested() -> void:
	show_screen(Screen.META)


func _on_meta_back_pressed() -> void:
	show_screen(Screen.START)


func _on_alpha_settings_requested() -> void:
	if _alpha_settings != null:
		_alpha_settings.open_panel()


func _on_alpha_feedback_requested(feedback_type: String, decision_id: String, run_id: String) -> void:
	if _alpha_feedback != null:
		_alpha_feedback.open_panel(feedback_type, decision_id, run_id)


func _on_alpha_report_issue_requested() -> void:
	if _alpha_feedback != null:
		_alpha_feedback.open_panel("bug", "", ClosedAlphaLogger.get_active_run_id())
