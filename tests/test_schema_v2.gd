extends SceneTree

## Milestone 2A-1 tests: decision schema v2, option normalization,
## option-id resolution, 2-3 option rendering, card types, validation.
## Run: godot --headless --path . -s tests/test_schema_v2.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	await process_frame
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_legacy_normalization()
	_test_v2_normalization()
	_test_option_lookup_and_aliases()
	_test_resolution_by_option_id()
	_test_validation_rules()
	_test_game_manager_flow()
	await _test_decision_card_rendering()
	_test_restart_and_save_compatibility()

	if _failures == 0:
		print("[TEST] All schema v2 tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_legacy_normalization() -> void:
	# Legacy card loaded from disk: normalized at load, original keys kept.
	var legacy: Dictionary = _repo.get_decision("switch_off_traffic_lights")
	_check(int(legacy.get("schema_version", 0)) == 1, "legacy card reports schema_version 1")
	_check(str(legacy.get("card_type", "")) == "normal", "legacy card defaults to card_type normal")
	var options: Array = legacy.get("options", [])
	_check(options.size() == 2, "legacy card normalized to 2 options")
	_check(str(options[0].get("id", "")) == "left" and str(options[1].get("id", "")) == "right", "legacy options get ids left/right")
	_check(str(options[0].get("label", "")) == "Keep them on", "left option content preserved")
	_check(legacy.has("left") and legacy.has("right"), "legacy left/right keys preserved for compatibility")

	# Normalization is idempotent.
	var before: int = DecisionSchema.get_options(legacy).size()
	DecisionSchema.normalize(legacy)
	_check(DecisionSchema.get_options(legacy).size() == before, "normalize is idempotent")


func _test_v2_normalization() -> void:
	var v2: Dictionary = _repo.get_decision("free_pizza_friday")
	_check(int(v2.get("schema_version", 0)) == 2, "v2 card reports schema_version 2")
	_check(int(v2.get("weight", 0)) == 10, "v2 base_weight mapped onto weight for the engine")
	var options: Array = v2.get("options", [])
	_check(options.size() == 2, "v2 card keeps authored options")
	_check(str(options[0].get("id", "")) == "refuse", "authored option ids preserved")

	var crisis: Dictionary = _repo.get_decision("budget_meltdown_crisis")
	_check(str(crisis.get("card_type", "")) == "crisis", "crisis card_type loaded")
	_check(DecisionSchema.get_options(crisis).size() == 3, "crisis card has 3 options")


func _test_option_lookup_and_aliases() -> void:
	var v2: Dictionary = _repo.get_decision("free_pizza_friday")
	_check(str(DecisionSchema.get_option(v2, "approve").get("id", "")) == "approve", "lookup by authored id works")
	_check(DecisionSchema.get_option(v2, "nonexistent").is_empty(), "unknown option id returns empty")
	# Legacy aliases: "left"/"right" map to first/second option on v2 cards.
	_check(str(DecisionSchema.get_option(v2, "left").get("id", "")) == "refuse", "'left' aliases first option on v2 card")
	_check(str(DecisionSchema.get_option(v2, "right").get("id", "")) == "approve", "'right' aliases second option on v2 card")


func _test_resolution_by_option_id() -> void:
	var resolver := EffectResolver.new()

	# Legacy card resolved by side id.
	var state := RunState.new()
	var legacy: Dictionary = _repo.get_decision("window_tax_proposal")
	var result: DecisionResult = resolver.apply_option(legacy, "right", state, _repo)
	_check(result.selected_option_id == "right", "legacy resolution carries option id")
	_check(result.selected_side == "right", "legacy selected_side alias preserved")
	_check(state.has_law("window_tax"), "legacy option effects applied")

	# Three-option crisis resolved by authored option id.
	state = RunState.new()
	var crisis: Dictionary = _repo.get_decision("budget_meltdown_crisis")
	result = resolver.apply_option(crisis, "print_money", state, _repo)
	_check(result.selected_option_id == "print_money", "crisis resolution by option id")
	_check(int(result.resource_changes.get("treasury", 0)) == 15, "third option effects applied")
	_check(state.has_flag("money_printer_used"), "third option flag applied")
	_check(str(state.decision_history[0].get("selected_option_id", "")) == "print_money", "history records option id")

	# Unknown option id fails safe.
	state = RunState.new()
	result = resolver.apply_option(crisis, "bribe_aliens", state, _repo)
	_check(result.selected_option_id.is_empty(), "unknown option id resolves nothing")
	_check(result.result_text == EffectResolver.FALLBACK_RESULT_TEXT, "unknown option id uses fallback text")


func _test_validation_rules() -> void:
	var validator := ContentValidator.new()

	_check(validator.validate_decision(_v2_decision(), _repo).is_empty(), "minimal valid v2 decision passes")

	var one_option := _v2_decision()
	one_option["options"] = [one_option["options"][0]]
	_check(_has_error(validator, one_option, "minimum"), "fewer than 2 options rejected")

	var four_options := _v2_decision()
	for n in range(2):
		var extra: Dictionary = four_options["options"][0].duplicate(true)
		extra["id"] = "extra_%d" % n
		four_options["options"].append(extra)
	_check(_has_error(validator, four_options, "maximum"), "more than 3 options rejected")

	var duplicate_ids := _v2_decision()
	duplicate_ids["options"][1]["id"] = "accept"
	duplicate_ids["options"][0]["id"] = "accept"
	_check(_has_error(validator, duplicate_ids, "duplicate option id"), "duplicate option ids rejected")

	var empty_label := _v2_decision()
	empty_label["options"][0]["label"] = ""
	_check(_has_error(validator, empty_label, "label"), "empty option label rejected")

	var empty_result := _v2_decision()
	empty_result["options"][1].erase("result_text")
	_check(_has_error(validator, empty_result, "result_text"), "missing result_text rejected")

	var bad_card_type := _v2_decision()
	bad_card_type["card_type"] = "melodrama"
	_check(_has_error(validator, bad_card_type, "card_type"), "unknown card_type rejected")

	var bad_version := _v2_decision()
	bad_version["schema_version"] = 7
	_check(_has_error(validator, bad_version, "schema_version"), "unsupported schema_version rejected")

	# Shipped content (legacy + v2 mix) validates clean.
	var report := validator.validate_repository(_repo)
	_check(report.is_valid, "shipped mixed-schema content has zero errors")


func _test_game_manager_flow() -> void:
	var game_manager: Node = root.get_node("GameManager")

	# Full loop on the three-option crisis via resolve_choice(option_id).
	game_manager.start_new_run()
	var state: RunState = game_manager.get_current_state()
	state.day = 5  # crisis requires day >= 3
	game_manager.force_decision("budget_meltdown_crisis")
	game_manager.resolve_choice("left")
	game_manager.continue_after_result()
	_check(state.current_decision_id == "budget_meltdown_crisis", "forced crisis card presented")
	var result: DecisionResult = game_manager.resolve_choice("sell_furniture")
	_check(result != null and result.selected_option_id == "sell_furniture", "GameManager resolves by option id")

	# Legacy wrappers still work on v2 cards.
	game_manager.start_new_run()
	state = game_manager.get_current_state()
	game_manager.force_decision("free_pizza_friday")
	game_manager.resolve_choice("left")
	game_manager.continue_after_result()
	_check(state.current_decision_id == "free_pizza_friday", "forced v2 card presented")
	game_manager.choose_left()
	_check(game_manager.get_last_result().selected_option_id == "refuse", "choose_left resolves first option of v2 card")


func _test_decision_card_rendering() -> void:
	var card: PanelContainer = (load("res://scenes/components/DecisionCard.tscn") as PackedScene).instantiate()
	root.add_child(card)
	await process_frame

	var advisor: Dictionary = _repo.get_advisor("minister_penny")
	var container: BoxContainer = card.get_node("%OptionsContainer")
	var banner: Label = card.get_node("%CardTypeLabel")

	# Three-option crisis: vertical stack + crisis banner.
	card.show_decision(_repo.get_decision("budget_meltdown_crisis"), advisor)
	var buttons: Array[Button] = card.get_option_buttons()
	_check(buttons.size() == 3, "crisis renders 3 buttons, got %d" % buttons.size())
	_check(container.vertical, "3 options stack vertically")
	_check(banner.visible and "CRISIS" in banner.text, "crisis banner shown")

	# Legacy two-option card: horizontal row, no banner.
	card.show_decision(_repo.get_decision("switch_off_traffic_lights"), advisor)
	buttons = card.get_option_buttons()
	_check(buttons.size() == 2, "legacy card renders 2 buttons")
	_check(not container.vertical, "2 options sit side by side")
	_check(not banner.visible, "normal card shows no banner")
	_check("Keep them on" in buttons[0].text, "legacy option label rendered")

	# Button press emits the option id.
	card.show_decision(_repo.get_decision("free_pizza_friday"), advisor)
	var picked: Array[String] = []
	card.choice_selected.connect(func(option_id: String) -> void: picked.append(option_id))
	card.get_option_buttons()[1].pressed.emit()
	_check(picked.size() == 1 and picked[0] == "approve", "button press emits authored option id")

	card.queue_free()
	await process_frame


func _test_restart_and_save_compatibility() -> void:
	var game_manager: Node = root.get_node("GameManager")
	var save_manager: Node = root.get_node("SaveManager")

	# Restart after v2 resolutions stays clean (TC-020 with new schema).
	game_manager.restart_run()
	var state: RunState = game_manager.get_current_state()
	_check(state.day == 1 and state.decision_history.is_empty() and state.flags.is_empty(), "restart clean after v2 play")
	_check(state.run_phase == RunState.RunPhase.AWAITING_DECISION, "restart presents a decision")

	# Save format is untouched by schema v2: it still loads and persists.
	var endings_before: Array = save_manager.get_unlocked_endings()
	game_manager.debug_trigger_ending("revolution")
	_check(save_manager.is_ending_unlocked("revolution"), "endings still unlock through the save system")
	var reloaded: Dictionary = save_manager.load_save()
	_check(int(reloaded.get("version", 0)) == save_manager.SAVE_VERSION, "save file loads with current version")
	if "revolution" not in endings_before:
		print("[TEST] Note: revolution ending was newly unlocked by this test run.")


func _v2_decision() -> Dictionary:
	return {
		"id": "synthetic_v2",
		"schema_version": 2,
		"card_type": "normal",
		"advisor_id": "auntie_olga",
		"proposal": "A synthetic schema v2 proposal about national affairs.",
		"options": [
			{
				"id": "decline",
				"label": "Decline",
				"effects": {"happiness": -2},
				"result_text": "Nothing much happens, which is suspicious.",
			},
			{
				"id": "accept",
				"label": "Accept",
				"effects": {"treasury": -3},
				"result_text": "Something happens, which is also suspicious.",
			},
		],
	}


func _has_error(validator: ContentValidator, decision: Dictionary, needle: String) -> bool:
	for error in validator.validate_decision(decision, _repo):
		if needle in error:
			return true
	return false
