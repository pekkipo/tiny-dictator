extends SceneTree

## Milestone 5 assertion tests for EffectResolver.
## Run: godot --headless --path . -s tests/test_effect_resolver.gd

var _failures: int = 0
var _repo: ContentRepository
var _resolver: EffectResolver


func _initialize() -> void:
	_repo = ContentRepository.new()
	_repo.load_all()
	_resolver = EffectResolver.new()

	_test_pizza_right_option()
	_test_clamping_deltas()
	_test_duplicate_law_protection()
	_test_forced_followup_recorded()
	_test_trigger_ending_recorded()
	_test_missing_result_text_fallback()
	_test_law_removal()
	_test_history_and_used()

	if _failures == 0:
		print("[TEST] All EffectResolver tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _fresh_state() -> RunState:
	var state := RunState.new()
	state.run_phase = RunState.RunPhase.RESOLVING_DECISION
	return state


func _test_pizza_right_option() -> void:
	var state := _fresh_state()
	var decision: Dictionary = _repo.get_decision("free_pizza_friday")
	var result := _resolver.apply_option(decision, "right", state, _repo)

	_check(result.decision_id == "free_pizza_friday", "result carries decision id")
	# This card is schema v2 now: the legacy "right" alias resolves the second
	# option, and the result carries the option's real id.
	_check(result.selected_option_id == "approve", "result carries resolved option id")
	_check(result.selected_side == "approve", "selected_side mirrors option id")
	_check(result.choice_label == "Give them pizza", "result carries label")
	_check(int(result.resource_changes.get("treasury", 0)) == -10, "treasury -10 applied")
	_check(int(result.resource_changes.get("happiness", 0)) == 14, "happiness +14 applied")
	_check(state.treasury == 45 and state.happiness == 69, "state resources updated")
	_check(result.added_laws.size() == 1 and result.added_laws[0] == "free_pizza_friday", "law recorded in result")
	_check(state.has_law("free_pizza_friday"), "law active in state")
	_check(state.has_flag("pizza_policy_active"), "flag set in state")
	_check(state.get_counter("pizza_choices") == 1, "counter incremented")
	_check(not result.result_text.is_empty(), "result text present")


func _test_clamping_deltas() -> void:
	# TC-004 logic: happiness 5 with -12 effect applies only -5.
	var state := _fresh_state()
	state.set_resource("happiness", 5)
	var decision := {
		"id": "synthetic_clamp",
		"advisor_id": "auntie_olga",
		"proposal": "Test",
		"left": {
			"label": "Test",
			"effects": {"happiness": -12},
			"result_text": "Testing clamped deltas here.",
		},
	}
	var result := _resolver.apply_option(decision, "left", state, _repo)
	_check(state.happiness == 0, "happiness clamped to 0")
	_check(int(result.resource_changes.get("happiness", 0)) == -5, "actual delta -5 recorded, got %d" % int(result.resource_changes.get("happiness", 99)))


func _test_duplicate_law_protection() -> void:
	# TC-005/TC-006: adding an active law does not duplicate it.
	var state := _fresh_state()
	state.add_law("window_tax")
	var decision := {
		"id": "synthetic_law",
		"advisor_id": "minister_penny",
		"proposal": "Test",
		"right": {
			"label": "Test",
			"add_laws": ["window_tax"],
			"result_text": "Testing duplicate law protection.",
		},
	}
	var result := _resolver.apply_option(decision, "right", state, _repo)
	_check(result.added_laws.is_empty(), "duplicate law not reported as added")
	_check(state.active_laws.count("window_tax") == 1, "law appears exactly once")


func _test_forced_followup_recorded() -> void:
	var state := _fresh_state()
	var decision: Dictionary = _repo.get_decision("switch_off_traffic_lights")
	var result := _resolver.apply_option(decision, "right", state, _repo)
	_check(result.forced_next_decision_id == "traffic_tank_solution", "forced follow-up recorded")
	_check(state.has_flag("traffic_lights_off"), "setup flag applied")


func _test_trigger_ending_recorded() -> void:
	var state := _fresh_state()
	var decision := {
		"id": "synthetic_ending",
		"advisor_id": "general_boom",
		"proposal": "Test",
		"left": {
			"label": "Test",
			"trigger_ending": "revolution",
			"result_text": "Testing explicit ending trigger.",
		},
	}
	var result := _resolver.apply_option(decision, "left", state, _repo)
	_check(result.triggered_ending_id == "revolution", "explicit ending recorded")


func _test_missing_result_text_fallback() -> void:
	var state := _fresh_state()
	var decision := {
		"id": "synthetic_no_text",
		"advisor_id": "luna_news",
		"proposal": "Test",
		"left": {
			"label": "Test",
			"effects": {"order": 1},
		},
	}
	var result := _resolver.apply_option(decision, "left", state, _repo)
	_check(result.result_text == EffectResolver.FALLBACK_RESULT_TEXT, "fallback result text used")


func _test_law_removal() -> void:
	var state := _fresh_state()
	state.add_law("free_pizza_friday")
	state.add_flag("pizza_policy_active")
	var decision: Dictionary = _repo.get_decision("cheese_shortage")
	var result := _resolver.apply_option(decision, "right", state, _repo)
	_check(result.removed_laws.size() == 1 and result.removed_laws[0] == "free_pizza_friday", "removed law recorded")
	_check(not state.has_law("free_pizza_friday"), "law removed from state")
	_check(not state.has_flag("pizza_policy_active"), "flag removed from state")


func _test_history_and_used() -> void:
	var state := _fresh_state()
	state.day = 3
	var decision: Dictionary = _repo.get_decision("military_parade")
	_resolver.apply_option(decision, "right", state, _repo)

	_check(state.decision_history.size() == 1, "one history entry")
	var entry: Dictionary = state.decision_history[0]
	_check(int(entry.get("day", 0)) == 3, "history records day")
	_check(str(entry.get("decision_id", "")) == "military_parade", "history records decision")
	_check(str(entry.get("advisor_id", "")) == "general_boom", "history records advisor")
	_check(int(entry.get("resource_before", {}).get("treasury", 0)) == 55, "history records before")
	_check(int(entry.get("resource_after", {}).get("treasury", 0)) == 47, "history records after")
	_check("military_parade" in state.used_decision_ids, "decision marked used")

	# Resolving again (engine would not allow it, but resolver is defensive-free):
	# the double-resolution guard lives in GameManager phases, tested separately.
