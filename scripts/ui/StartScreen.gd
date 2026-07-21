extends Control

@onready var _start_button: Button = %StartButton
@onready var _meta_button: Button = %MetaButton
@onready var _meta_summary_label: Label = %MetaSummaryLabel

var _version_press_ms: int = 0


func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	_meta_button.pressed.connect(_on_meta_button_pressed)
	EventBus.meta_progression_updated.connect(_refresh_meta_summary)
	if not GameManager.is_content_valid():
		_start_button.disabled = true
		_meta_button.disabled = true
		_start_button.text = "CONTENT ERRORS — SEE LOG"
	_refresh_meta_summary()
	_setup_alpha_chrome()


func _setup_alpha_chrome() -> void:
	if not ClosedAlphaConfig.is_enabled():
		%VersionLabel.text = "Prototype %s" % str(ProjectSettings.get_setting("application/config/version", "v0.1"))
		%ReportIssueButton.visible = false
		%AlphaSettingsButton.visible = false
		return
	%VersionLabel.text = ClosedAlphaConfig.get_version_label()
	%ReportIssueButton.visible = true
	%AlphaSettingsButton.visible = true
	%ReportIssueButton.pressed.connect(func() -> void: EventBus.alpha_report_issue_requested.emit())
	%AlphaSettingsButton.pressed.connect(func() -> void: EventBus.alpha_settings_requested.emit())
	%VersionLabel.gui_input.connect(_on_version_gui_input)


func _on_version_gui_input(event: InputEvent) -> void:
	## Long-press version label unlocks hidden debug for designated testers.
	if not ClosedAlphaConfig.is_enabled():
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_version_press_ms = Time.get_ticks_msec()
		else:
			if _version_press_ms > 0 and Time.get_ticks_msec() - _version_press_ms >= 2000:
				SaveManager.set_debug_enabled(true)
				%VersionLabel.text = "%s · debug unlocked" % ClosedAlphaConfig.get_version_label()
			_version_press_ms = 0


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
