extends SceneTree

## Milestone 2 assertion tests for RunState.
## Run: godot --headless --path . -s tests/test_run_state.gd

var _failures: int = 0


func _initialize() -> void:
	_test_defaults()
	_test_clamp_upper()
	_test_clamp_lower()
	_test_unknown_resource()
	_test_law_dedup()
	_test_flag_dedup()
	_test_counters()
	_test_reset_cleanliness()
	_test_serialization_round_trip()
	_test_queue_serialization()

	if _failures == 0:
		print("[TEST] All RunState tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_defaults() -> void:
	var state := RunState.new()
	_check(state.day == 1, "default day is 1")
	_check(state.country_id == "ministan", "default country is ministan")
	for resource_id in RunState.RESOURCE_IDS:
		_check(state.get_resource(resource_id) == 55, "default %s is 55" % resource_id)
	_check(state.run_phase == RunState.RunPhase.NOT_STARTED, "default phase NOT_STARTED")


func _test_clamp_upper() -> void:
	# TC-003: 95 + 10 clamps to 100, actual delta +5.
	var state := RunState.new()
	state.set_resource("treasury", 95)
	var applied: int = state.change_resource("treasury", 10)
	_check(state.treasury == 100, "treasury clamped to 100")
	_check(applied == 5, "applied delta is +5, got %d" % applied)


func _test_clamp_lower() -> void:
	# TC-004: 5 - 10 clamps to 0, actual delta -5.
	var state := RunState.new()
	state.set_resource("happiness", 5)
	var applied: int = state.change_resource("happiness", -10)
	_check(state.happiness == 0, "happiness clamped to 0")
	_check(applied == -5, "applied delta is -5, got %d" % applied)


func _test_unknown_resource() -> void:
	var state := RunState.new()
	var applied: int = state.change_resource("corruption", 10)
	_check(applied == 0, "unknown resource applies nothing")


func _test_law_dedup() -> void:
	var state := RunState.new()
	_check(state.add_law("free_pizza_friday"), "first add_law returns true")
	_check(not state.add_law("free_pizza_friday"), "duplicate add_law returns false")
	_check(state.active_laws.size() == 1, "law appears once")
	_check(state.remove_law("free_pizza_friday"), "remove_law returns true")
	_check(not state.remove_law("free_pizza_friday"), "removing inactive law returns false")


func _test_flag_dedup() -> void:
	var state := RunState.new()
	_check(state.add_flag("traffic_lights_off"), "first add_flag returns true")
	_check(not state.add_flag("traffic_lights_off"), "duplicate add_flag returns false")
	_check(state.has_flag("traffic_lights_off"), "has_flag true after add")
	_check(state.remove_flag("traffic_lights_off"), "remove_flag returns true")
	_check(not state.has_flag("traffic_lights_off"), "has_flag false after remove")


func _test_counters() -> void:
	var state := RunState.new()
	_check(state.get_counter("pizza_choices") == 0, "counter defaults to 0")
	_check(state.change_counter("pizza_choices", 2) == 2, "counter increments to 2")
	_check(state.change_counter("pizza_choices", -1) == 1, "counter decrements to 1")


func _test_reset_cleanliness() -> void:
	var state := RunState.new()
	state.day = 12
	state.set_resource("order", 3)
	state.add_law("mandatory_smiling")
	state.add_flag("cats_enfranchised")
	state.change_counter("cat_favor_choices", 3)
	state.active_arcs["cat_politics"] = {
		"arc_id": "cat_politics",
		"status": "active",
		"current_step": 2,
		"branch_id": "support_cats",
		"started_day": 3,
		"last_advanced_day": 3,
		"completed_day": null,
		"history": ["cat_voting_rights"],
	}
	state.completed_arc_ids.append("robot_government")
	state.failed_arc_ids.append("old_arc")
	state.mark_decision_used("budget_crisis")
	state.add_history_entry({"day": 12})
	state.current_decision_id = "budget_crisis"
	state.run_phase = RunState.RunPhase.ENDED
	state.reset()
	_check(state.day == 1, "reset day")
	_check(state.order == 55, "reset resources")
	_check(state.active_laws.is_empty(), "reset laws")
	_check(state.flags.is_empty(), "reset flags")
	_check(state.counters.is_empty(), "reset counters")
	_check(state.used_decision_ids.is_empty(), "reset used decisions")
	_check(state.decision_history.is_empty(), "reset history")
	_check(state.current_decision_id == "", "reset current decision")
	_check(state.active_arcs.is_empty(), "reset active arcs")
	_check(state.completed_arc_ids.is_empty(), "reset completed arcs")
	_check(state.failed_arc_ids.is_empty(), "reset failed arcs")
	_check(state.narrative_event_queue.is_empty(), "reset narrative event queue")
	_check(state.run_phase == RunState.RunPhase.NOT_STARTED, "reset phase")


func _test_serialization_round_trip() -> void:
	var state := RunState.new()
	state.day = 7
	state.set_resource("treasury", 30)
	state.add_law("window_tax")
	state.add_flag("cheese_shortage")
	state.change_counter("public_scandals", 2)
	state.mark_decision_used("free_pizza_friday")
	state.current_stage_id = "escalation"
	state.active_arcs["cat_politics"] = {
		"arc_id": "cat_politics", "status": "active", "current_step": 1, "branch_id": "support_cats",
	}
	state.completed_arc_ids.append("robot_government")
	state.failed_arc_ids.append("old_arc")
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	state.random_seed = 12345

	var restored := RunState.new()
	restored.from_dictionary(state.to_dictionary())
	_check(restored.day == 7, "round-trip day")
	_check(restored.treasury == 30, "round-trip treasury")
	_check(restored.has_law("window_tax"), "round-trip law")
	_check(restored.has_flag("cheese_shortage"), "round-trip flag")
	_check(restored.get_counter("public_scandals") == 2, "round-trip counter")
	_check(restored.used_decision_ids.size() == 1 and restored.used_decision_ids[0] == "free_pizza_friday", "round-trip used decisions")
	_check(restored.run_phase == RunState.RunPhase.AWAITING_DECISION, "round-trip phase")
	_check(restored.random_seed == 12345, "round-trip seed")
	_check(restored.current_stage_id == "escalation", "round-trip stage")
	_check(restored.is_arc_active("cat_politics"), "round-trip active arc")
	_check(restored.get_arc_branch("cat_politics") == "support_cats", "round-trip arc branch")
	_check(restored.is_arc_completed("robot_government"), "round-trip completed arc")
	_check(restored.is_arc_failed("old_arc"), "round-trip failed arc")

	var legacy := RunState.new()
	legacy.from_dictionary({"day": 2, "resources": restored.get_resources()})
	_check(legacy.active_arcs.is_empty(), "legacy save without arc fields")
	_check(legacy.narrative_event_queue.is_empty(), "legacy save without queue field")


func _test_queue_serialization() -> void:
	var state := RunState.new()
	state.narrative_event_queue.append({
		"event_id": "evt_0001",
		"source_decision_id": "free_pizza_friday",
		"event_type": "soft_follow_up",
		"decision_id": "cheese_shortage",
		"earliest_day": 5,
		"latest_day": 8,
		"priority": 70,
		"status": "pending",
		"mandatory": false,
	})
	var restored := RunState.new()
	restored.from_dictionary(state.to_dictionary())
	_check(restored.narrative_event_queue.size() == 1, "queue round-trip size")
	_check(restored.narrative_event_queue[0]["event_id"] == "evt_0001", "queue round-trip event_id")
	_check(restored.narrative_event_queue[0]["decision_id"] == "cheese_shortage", "queue round-trip decision_id")
