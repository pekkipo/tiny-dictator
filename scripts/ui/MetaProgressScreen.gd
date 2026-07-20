extends Control

## Placeholder palace and Ending Archive screen (Milestone 2A-7).

signal back_pressed


func _ready() -> void:
	%BackButton.pressed.connect(_on_back_pressed)
	EventBus.meta_progression_updated.connect(_populate)
	_populate()


func _populate() -> void:
	%MedalsLabel.text = "Medals: %d" % MetaProgressionManager.get_medals()
	%RunsLabel.text = "Runs completed: %d" % MetaProgressionManager.get_total_runs_completed()
	%SaveVersionLabel.text = "Save v%d" % MetaProgressionManager.get_save_version()

	_populate_endings()
	_populate_upgrades()


func _populate_endings() -> void:
	for child in %EndingList.get_children():
		child.queue_free()

	var content: ContentRepository = GameManager.get_content()
	var records: Dictionary = MetaProgressionManager.get_all_ending_records()
	for ending in content.get_raw_endings():
		if ending.has("collectible") and not bool(ending.get("collectible", true)):
			continue
		var ending_id: String = str(ending.get("id", ""))
		var row := _make_ending_row(ending, records.get(ending_id, {}))
		%EndingList.add_child(row)


func _make_ending_row(ending: Dictionary, record: Dictionary) -> PanelContainer:
	var panel := PanelContainer.new()
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	margin.add_child(vbox)

	var unlocked: bool = not record.is_empty() and bool(record.get("unlocked", false))
	var icon: String = str(ending.get("placeholder_icon", "📰")) if unlocked else "❓"
	var title: String = str(ending.get("title", ending.get("id", ""))) if unlocked else "???"
	var rarity: String = str(ending.get("rarity", ""))
	var desc: String = str(ending.get("description", "")) if unlocked else str(ending.get("archive_hint", "Reach this ending to unlock the archive entry."))

	var title_label := Label.new()
	if unlocked and not rarity.is_empty():
		title_label.text = "%s  %s (%s)" % [icon, title, rarity]
	else:
		title_label.text = "%s  %s" % [icon, title]
	title_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title_label)

	if unlocked:
		var subtitle: String = str(ending.get("subtitle", ""))
		if not subtitle.is_empty() and subtitle != title:
			var subtitle_label := Label.new()
			subtitle_label.text = subtitle
			subtitle_label.add_theme_font_size_override("font_size", 18)
			vbox.add_child(subtitle_label)

	var desc_label := Label.new()
	desc_label.text = desc
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(desc_label)

	if unlocked:
		var stats_label := Label.new()
		stats_label.text = "Reached %d time(s) · Best day: %d" % [
			int(record.get("times_reached", 0)),
			int(record.get("best_day", 0)),
		]
		stats_label.add_theme_font_size_override("font_size", 18)
		vbox.add_child(stats_label)

	return panel


func _populate_upgrades() -> void:
	for child in %UpgradeList.get_children():
		child.queue_free()

	var content: ContentRepository = GameManager.get_content()
	for upgrade in content.get_raw_palace_upgrades():
		var upgrade_id: String = str(upgrade.get("id", ""))
		var row := _make_upgrade_row(upgrade, upgrade_id, content)
		%UpgradeList.add_child(row)


func _make_upgrade_row(upgrade: Dictionary, upgrade_id: String, content: ContentRepository) -> PanelContainer:
	var panel := PanelContainer.new()
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	margin.add_child(hbox)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 4)
	hbox.add_child(info)

	var icon: String = str(upgrade.get("placeholder_icon", "🏛️"))
	var title_label := Label.new()
	title_label.text = "%s  %s" % [icon, str(upgrade.get("display_name", upgrade_id))]
	title_label.add_theme_font_size_override("font_size", 24)
	info.add_child(title_label)

	var desc_label := Label.new()
	desc_label.text = str(upgrade.get("description", ""))
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 20)
	info.add_child(desc_label)

	var cost: int = int(upgrade.get("medal_cost", 0))
	var requirements: Dictionary = upgrade.get("requirements", {})
	var status: String = MetaProgressionManager.get_upgrade_status(upgrade_id, content)
	var status_label := Label.new()
	match status:
		"purchased":
			status_label.text = "Purchased"
		"available":
			status_label.text = "Cost: %d Medals" % cost
		_:
			status_label.text = "Locked — %s" % MetaProgressionManager.format_requirements_hint(requirements)
	status_label.add_theme_font_size_override("font_size", 18)
	info.add_child(status_label)

	var buy_button := Button.new()
	buy_button.text = "Purchased" if status == "purchased" else "Purchase"
	buy_button.disabled = status != "available"
	buy_button.pressed.connect(_on_purchase_pressed.bind(upgrade_id))
	hbox.add_child(buy_button)

	return panel


func _on_purchase_pressed(upgrade_id: String) -> void:
	if MetaProgressionManager.purchase_upgrade(upgrade_id, GameManager.get_content()):
		_populate()


func _on_back_pressed() -> void:
	back_pressed.emit()
