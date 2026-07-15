extends Control

@onready var _start_button: Button = %StartButton
@onready var _meta_button: Button = %MetaButton
@onready var _meta_summary_label: Label = %MetaSummaryLabel


func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	_meta_button.pressed.connect(_on_meta_button_pressed)
	EventBus.meta_progression_updated.connect(_refresh_meta_summary)
	if not GameManager.is_content_valid():
		_start_button.disabled = true
		_meta_button.disabled = true
		_start_button.text = "CONTENT ERRORS — SEE LOG"
	_refresh_meta_summary()


func _refresh_meta_summary() -> void:
	var endings_count: int = MetaProgressionManager.get_unlocked_ending_ids().size()
	var total_endings: int = GameManager.get_content().get_raw_endings().size()
	_meta_summary_label.text = "🏅 %d Medals · Endings %d / %d" % [
		MetaProgressionManager.get_medals(), endings_count, total_endings,
	]


func _on_start_button_pressed() -> void:
	_start_button.disabled = true
	GameManager.start_new_run()


func _on_meta_button_pressed() -> void:
	EventBus.meta_screen_requested.emit()
