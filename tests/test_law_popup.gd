extends SceneTree

## Tests for the law detail feature: LawImpactResolver facts, the popup,
## and the tappable laws bar.
## Run: godot --headless --path . -s tests/test_law_popup.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_enactment_record()
	_test_influence_facts()
	_test_unknown_law_safety()
	await _test_popup_rendering()
	await _test_laws_bar_interaction()

	if _failures == 0:
		print("[TEST] All law popup tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _state_with_pizza_history() -> RunState:
	var state := RunState.new()
	state.add_law("free_pizza_friday")
	state.add_history_entry({
		"day": 2,
		"decision_id": "free_pizza_friday",
		"choice_label": "Approve free pizza",
		"resource_before": {"treasury": 55, "happiness": 55, "order": 55, "elite_loyalty": 55},
		"resource_after": {"treasury": 45, "happiness": 69, "order": 55, "elite_loyalty": 53},
		"added_laws": ["free_pizza_friday"],
		"added_flags": ["pizza_policy_active"],
	})
	return state


func _test_enactment_record() -> void:
	var info: Dictionary = LawImpactResolver.describe("free_pizza_friday", _state_with_pizza_history(), _repo)
	_check(info["enacted_day"] == 2, "enactment day found in history")
	_check(info["enacted_choice"] == "Approve free pizza", "enacting choice recorded")
	_check(int(info["enactment_changes"].get("treasury", 0)) == -10, "enactment treasury delta derived")
	_check(int(info["enactment_changes"].get("happiness", 0)) == 14, "enactment happiness delta derived")
	_check(not info["enactment_changes"].has("order"), "unchanged resources omitted")

	# Law present without matching history (e.g. debug-added).
	var bare := RunState.new()
	bare.add_law("window_tax")
	info = LawImpactResolver.describe("window_tax", bare, _repo)
	_check(info["enacted_day"] == 0, "no history -> enactment unknown")


func _test_influence_facts() -> void:
	var state := RunState.new()

	# cat_voting_rights gates the cat_republic ending and shows cats in town.
	var info: Dictionary = LawImpactResolver.describe("cat_voting_rights", state, _repo)
	_check(info["ending_related"], "cat law is ending-related")
	_check("🐱" in info["visual_props"], "cat law has a visual prop")
	_check(not info["repealable"], "cat law has no repeal option in content")

	# free_pizza_friday can be repealed by the cheese_shortage follow-up.
	info = LawImpactResolver.describe("free_pizza_friday", state, _repo)
	_check(info["repealable"], "pizza law is repealable")
	_check(not info["ending_related"], "pizza law is not ending-related")

	# mandatory_smiling can be repealed by fake_smile_industry.
	info = LawImpactResolver.describe("mandatory_smiling", state, _repo)
	_check(info["repealable"], "smiling law is repealable")


func _test_unknown_law_safety() -> void:
	var info: Dictionary = LawImpactResolver.describe("nonexistent_law", RunState.new(), _repo)
	_check(info["law"].is_empty(), "unknown law returns empty data without crashing")
	_check(info["visual_props"].is_empty(), "unknown law has no props")


func _test_popup_rendering() -> void:
	await process_frame
	var popup: Control = (load("res://scenes/components/LawDetailPopup.tscn") as PackedScene).instantiate()
	root.add_child(popup)
	await process_frame
	_check(not popup.visible, "popup hidden by default")

	popup.show_law("free_pizza_friday", _state_with_pizza_history(), _repo)
	_check(popup.visible, "popup visible after show_law")
	_check(popup.get_node("%LawNameLabel").text == "Free Pizza Friday", "law name displayed")
	_check("free pizza" in popup.get_node("%LawDescriptionLabel").text.to_lower(), "description displayed")
	_check("day 2" in popup.get_node("%EnactedLabel").text, "enactment day displayed")
	_check("💰 -10" in popup.get_node("%EnactedLabel").text, "enactment deltas displayed")
	var influence: String = popup.get_node("%InfluenceLabel").text
	_check("repealed" in influence, "repeal hint displayed")
	_check("🍕" in influence, "visual prop hint displayed")

	# Ending hint for the cat law; unknown enactment shows the mystery line.
	var bare := RunState.new()
	bare.add_law("cat_voting_rights")
	popup.show_law("cat_voting_rights", bare, _repo)
	_check("reign ends" in popup.get_node("%InfluenceLabel").text, "ending rumor displayed for cat law")
	_check("mysterious" in popup.get_node("%EnactedLabel").text, "unknown enactment handled")

	popup.get_node("%CloseButton").pressed.emit()
	_check(not popup.visible, "close button hides popup")

	popup.queue_free()
	await process_frame


func _test_laws_bar_interaction() -> void:
	var bar: PanelContainer = (load("res://scenes/components/ActiveLawsBar.tscn") as PackedScene).instantiate()
	root.add_child(bar)
	await process_frame

	var all_laws: Array[String] = []
	for law in _repo.get_raw_laws():
		all_laws.append(str(law.get("id", "")))
	_check(all_laws.size() == 6, "content ships six laws")

	bar.update_laws(all_laws, _repo)
	await process_frame
	var flow: HFlowContainer = bar.get_node("%LawsFlow")
	var chips: Array[Button] = []
	for child in flow.get_children():
		if child is Button and not child.is_queued_for_deletion():
			chips.append(child)
	_check(chips.size() == 6, "5 law chips + overflow toggle rendered, got %d" % chips.size())
	_check(chips[5].text == "+1 more", "overflow toggle labelled")

	# Expanding shows all six laws plus a collapse toggle.
	chips[5].pressed.emit()
	await process_frame
	chips.clear()
	for child in flow.get_children():
		if child is Button and not child.is_queued_for_deletion():
			chips.append(child)
	_check(chips.size() == 7, "expanded bar shows all laws, got %d" % chips.size())
	_check(chips[6].text == "show less", "collapse toggle labelled")

	# Tapping a law chip emits the selection signal.
	var selected: Array[String] = []
	bar.law_selected.connect(func(law_id: String) -> void: selected.append(law_id))
	chips[0].pressed.emit()
	_check(selected.size() == 1 and selected[0] == "free_pizza_friday", "law chip emits law_selected")

	bar.queue_free()
	await process_frame
