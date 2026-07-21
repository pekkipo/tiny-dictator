extends CanvasLayer

## Closed-alpha settings: export, reset anonymous ID, unlock hidden debug.

signal closed
signal feedback_requested
signal report_issue_requested


func _ready() -> void:
	layer = 110
	visible = false
	%CloseButton.pressed.connect(hide_panel)
	%ExportButton.pressed.connect(_on_export_pressed)
	%OpenExportsButton.pressed.connect(_on_open_exports_pressed)
	%ResetIdButton.pressed.connect(_on_reset_id_pressed)
	%FeedbackButton.pressed.connect(func() -> void: feedback_requested.emit())
	%ReportIssueButton.pressed.connect(func() -> void: report_issue_requested.emit())
	%UnlockDebugButton.pressed.connect(_on_unlock_debug_pressed)


func open_panel() -> void:
	if not ClosedAlphaConfig.is_enabled():
		return
	_refresh()
	visible = true


func hide_panel() -> void:
	visible = false
	closed.emit()


func _refresh() -> void:
	%VersionLabel.text = ClosedAlphaConfig.get_version_label()
	%TesterIdLabel.text = "Anonymous ID: %s" % ClosedAlphaLogger.get_anonymous_tester_id()
	%PrivacyLabel.text = "No account. No email. No personal data. Local export only."
	%DebugStatusLabel.text = "Hidden debug unlocked: %s" % str(SaveManager.is_debug_enabled())
	%StatusLabel.text = ""


func _on_export_pressed() -> void:
	var result: Dictionary = ClosedAlphaExporter.export_package(ClosedAlphaLogger)
	%StatusLabel.text = "Exported: %s (%d runs, %d feedback)" % [
		str(result.get("package_name", "")),
		int(result.get("run_count", 0)),
		int(result.get("feedback_count", 0)),
	]


func _on_open_exports_pressed() -> void:
	var path: String = ClosedAlphaExporter.get_exports_dir_absolute()
	OS.shell_open(path)
	%StatusLabel.text = "Opened exports folder."


func _on_reset_id_pressed() -> void:
	var new_id: String = ClosedAlphaLogger.reset_anonymous_id()
	%TesterIdLabel.text = "Anonymous ID: %s" % new_id
	%StatusLabel.text = "Anonymous ID reset."


func _on_unlock_debug_pressed() -> void:
	SaveManager.set_debug_enabled(true)
	%DebugStatusLabel.text = "Hidden debug unlocked: true"
	%StatusLabel.text = "Debug menu unlocked (F1 / `). For designated testers only."
