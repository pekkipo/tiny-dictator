extends SceneTree

## Milestone 2A-7 tests: meta progression, Medals, Ending Archive, palace upgrades.
## Run: godot --headless --path . -s tests/test_meta_progression.gd

const SAVE_PATH: String = "user://save.json"

var _failures: int = 0
var _repo: ContentRepository
var _meta: Node
var _save: Node


func _initialize() -> void:
	await process_frame
	_meta = root.get_node("MetaProgressionManager")
	_save = root.get_node("SaveManager")
	_repo = ContentRepository.new()
	_repo.load_all()

	var game_manager: Node = root.get_node("GameManager")
	_save.reset_save()

	_test_new_ending_unlock()
	_test_repeat_ending()
	_test_medal_calculation()
	_test_arc_bonuses()
	_test_purchase_upgrade()
	_test_insufficient_medals()
	_test_duplicate_purchase()
	_test_persistence()
	_test_v1_migration()
	_test_corrupt_save()
	_test_restart_preserves_meta(game_manager)
	_test_reset_meta()
	_test_gameplay_systems_intact()

	_save.reset_save()

	if _failures == 0:
		print("[TEST] All meta progression tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _fresh_state(day: int = 9) -> RunState:
	var state := RunState.new()
	state.country_id = "ministan"
	state.day = day
	state.run_phase = RunState.RunPhase.ENDED
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	return state


func _make_summary(ending_id: String, final_day: int) -> RunSummary:
	var summary := RunSummary.new()
	summary.ending_id = ending_id
	summary.final_day = final_day
	summary.final_resources = {"treasury": 40, "happiness": 40, "order": 40, "elite_loyalty": 40}
	return summary


func _test_new_ending_unlock() -> void:
	_meta.reset_meta_progression()
	var state := _fresh_state(9)
	var summary := _make_summary("chaos_country", 9)
	var rewards: Dictionary = _meta.process_run_end(summary, state, _repo)

	_check(rewards.get("total", 0) == 8, "new ending total medals = 3 base + 5 new")
	_check(summary.is_new_ending, "summary marks new ending")
	var record: Dictionary = _meta.get_ending_record("chaos_country")
	_check(record.get("times_reached", 0) == 1, "new ending times_reached = 1")
	_check(int(record.get("best_day", 0)) == 9, "new ending best_day set")
	_check(_meta.get_medals() == 8, "medals credited")


func _test_repeat_ending() -> void:
	_meta.reset_meta_progression()
	var state := _fresh_state(12)
	_meta.process_run_end(_make_summary("chaos_country", 6), state, _repo)
	state.day = 12
	var summary := _make_summary("chaos_country", 12)
	var rewards: Dictionary = _meta.process_run_end(summary, state, _repo)

	_check(not summary.is_new_ending, "repeat ending is not new")
	_check(int(rewards.get("breakdown", {}).get("new_ending", -1)) == 0, "no new ending bonus on repeat")
	var record: Dictionary = _meta.get_ending_record("chaos_country")
	_check(int(record.get("times_reached", 0)) == 2, "repeat ending increments times_reached")
	_check(int(record.get("best_day", 0)) == 12, "best_day updated to longest run")


func _test_medal_calculation() -> void:
	_meta.reset_meta_progression()
	var state := _fresh_state(10)
	var rewards: Dictionary = _meta.calculate_run_rewards(state, _repo, "revolution", true)
	_check(int(rewards.get("total", 0)) == 8, "day 10: floor(10/3)=3 base + 5 new = 8")
	_check(int(rewards.get("breakdown", {}).get("base", 0)) == 3, "base medals from days")


func _test_arc_bonuses() -> void:
	_meta.reset_meta_progression()
	var state := _fresh_state(6)
	state.completed_arc_ids = ["cat_politics", "robot_government"]
	var rewards: Dictionary = _meta.calculate_run_rewards(state, _repo, "revolution", false)
	_check(int(rewards.get("breakdown", {}).get("major_arcs", 0)) == 3, "major arc bonus")
	_check(int(rewards.get("breakdown", {}).get("minor_arcs", 0)) == 1, "minor arc bonus")
	_check(int(rewards.get("total", 0)) == 6, "arc bonuses included in total")


func _test_purchase_upgrade() -> void:
	_meta.reset_meta_progression()
	_meta.add_medals(10)
	_check(_meta.purchase_upgrade("gold_desk", _repo), "gold desk purchase succeeds")
	_check(_meta.is_upgrade_purchased("gold_desk"), "gold desk marked purchased")
	_check(_meta.get_medals() == 5, "medals deducted after purchase")


func _test_insufficient_medals() -> void:
	_meta.reset_meta_progression()
	_check(not _meta.purchase_upgrade("gold_desk", _repo), "cannot purchase without medals")
	_check(_meta.get_medals() == 0, "medals unchanged after failed purchase")


func _test_duplicate_purchase() -> void:
	_meta.reset_meta_progression()
	_meta.add_medals(20)
	_check(_meta.purchase_upgrade("gold_desk", _repo), "first purchase ok")
	_check(not _meta.purchase_upgrade("gold_desk", _repo), "duplicate purchase blocked")
	_check(_meta.get_medals() == 15, "medals not deducted on duplicate")


func _test_persistence() -> void:
	_meta.reset_meta_progression()
	_meta.add_medals(12)
	_meta.record_ending_reached("revolution", 4)
	_meta.purchase_upgrade("gold_desk", _repo)

	var fresh_save: Node = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	var reloaded: Dictionary = fresh_save.load_save()
	_check(int(reloaded.get("medals", 0)) == 7, "medals persist across reload")
	_check(reloaded.get("ending_records", {}).has("revolution"), "ending record persists")
	_check(reloaded.get("palace_upgrades", {}).has("gold_desk"), "palace upgrade persists")
	fresh_save.free()


func _test_v1_migration() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({
		"version": 1,
		"unlocked_endings": ["revolution", "chaos_country"],
		"settings": {"debug_enabled": false},
		"last_run_summary": {"ending_id": "revolution"},
	}))
	file.close()

	var fresh_save: Node = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	var reloaded: Dictionary = fresh_save.load_save()
	_check(int(reloaded.get("version", 0)) == 2, "v1 migrates to v2")
	_check(reloaded.get("ending_records", {}).has("revolution"), "v1 ending migrated to records")
	_check(reloaded.get("ending_records", {}).has("chaos_country"), "v1 second ending migrated")
	_check(bool(reloaded.get("settings", {}).get("debug_enabled", true)) == false, "v1 settings preserved")
	_check(str(reloaded.get("last_run_summary", {}).get("ending_id", "")) == "revolution", "v1 last summary preserved")
	fresh_save.free()


func _test_corrupt_save() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string("{ broken json")
	file.close()

	var fresh_save: Node = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	var reloaded: Dictionary = fresh_save.load_save()
	_check(int(reloaded.get("version", 0)) == 2, "corrupt save falls back to v2")
	_check(reloaded.get("ending_records", {}).is_empty(), "corrupt save clears ending records")
	fresh_save.free()


func _test_restart_preserves_meta(game_manager: Node) -> void:
	_meta.reset_meta_progression()
	game_manager.start_new_run()
	game_manager.debug_trigger_ending("bankrupt_leader")
	var medals_after_run: int = _meta.get_medals()
	game_manager.restart_run()
	var state: RunState = game_manager.get_current_state()
	_check(state.day == 1, "restart resets run day")
	_check(_meta.get_medals() == medals_after_run, "restart preserves medals")
	_check("bankrupt_leader" in _meta.get_unlocked_ending_ids(), "restart preserves ending unlock")


func _test_reset_meta() -> void:
	_meta.reset_meta_progression()
	_meta.add_medals(20)
	_meta.record_ending_reached("revolution", 5)
	_meta.add_medals(5)
	_meta.purchase_upgrade("gold_desk", _repo)
	var settings_before: Dictionary = _save.get_data().get("settings", {})

	_meta.reset_meta_progression()
	_check(_meta.get_medals() == 0, "reset meta clears medals")
	_check(_meta.get_all_ending_records().is_empty(), "reset meta clears ending records")
	_check(not _meta.is_upgrade_purchased("gold_desk"), "reset meta clears upgrades")
	_check(_save.get_data().get("settings", {}) == settings_before, "reset meta keeps settings")


func _test_gameplay_systems_intact() -> void:
	var state := _fresh_state(5)
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	state.active_arcs["cat_politics"] = {
		"arc_id": "cat_politics", "status": "active", "current_step": 2, "branch_id": "support_cats",
	}
	state.active_crisis = {"crisis_id": "national_power_outage", "status": "active", "started_day": 5}
	state.narrative_event_queue.append({
		"event_id": "evt_test",
		"status": "pending",
		"decision_id": "free_pizza_hangover",
		"earliest_day": 6,
		"latest_day": 10,
		"priority": 50,
	})
	state.advisor_affinity["comrade_whiskers"] = 2
	state.ruler_traits["cat_friendly"] = 3

	var restored := RunState.new()
	restored.from_dictionary(state.to_dictionary())
	_check(restored.is_arc_active("cat_politics"), "arc survives serialization after meta work")
	_check(str(restored.active_crisis.get("crisis_id", "")) == "national_power_outage", "crisis survives")
	_check(restored.narrative_event_queue.size() == 1, "queue survives")
	_check(restored.get_advisor_affinity("comrade_whiskers") == 2, "affinity survives")
	_check(restored.get_ruler_trait("cat_friendly") == 3, "traits survive")
