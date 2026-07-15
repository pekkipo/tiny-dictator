extends SceneTree

## Milestone 10 + 2A-7 tests: SaveManager persistence and migration.
## Run: godot --headless --path . -s tests/test_save_manager.gd

const SAVE_PATH: String = "user://save.json"

var _failures: int = 0
var _meta: Node


func _initialize() -> void:
	await process_frame
	var save_manager: Node = root.get_node("SaveManager")
	var game_manager: Node = root.get_node("GameManager")
	_meta = root.get_node("MetaProgressionManager")

	# Start from a known-clean save (SAVE-004).
	save_manager.reset_save()
	_check(save_manager.get_unlocked_endings().is_empty(), "reset clears unlocked endings")
	_check(int(save_manager.get_save_version()) == 2, "default save is v2")
	_check(save_manager.get_medals() == 0, "default save has zero medals")
	_check(FileAccess.file_exists(SAVE_PATH), "reset writes a default save file")

	# Unlock + dedup via meta progression.
	_meta.record_ending_reached("revolution", 3)
	_meta.record_ending_reached("revolution", 5)
	_check(save_manager.is_ending_unlocked("revolution"), "ending unlocked")
	_check(save_manager.get_unlocked_endings().size() == 1, "unlock is deduplicated in records")
	var record: Dictionary = _meta.get_ending_record("revolution")
	_check(int(record.get("times_reached", 0)) == 2, "repeat record increments times_reached")

	# SAVE-001: persistence across a fresh instance (simulated app restart).
	var fresh: Node = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	var reloaded: Dictionary = fresh.load_save()
	_check("revolution" in reloaded.get("unlocked_endings", []), "unlock survives reload from disk")
	_check(int(reloaded.get("medals", -1)) == save_manager.get_medals(), "medals survive reload")
	fresh.free()

	# SAVE-002: corrupt file resets to safe defaults.
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string("{ not valid json !!!")
	file.close()
	fresh = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	reloaded = fresh.load_save()
	_check(reloaded.get("unlocked_endings", [null]).is_empty(), "corrupt save resets to defaults")
	_check(int(reloaded.get("version", 0)) == save_manager.SAVE_VERSION, "corrupt save rewritten with current version")
	fresh.free()

	# SAVE-003: v1 save migrates without losing endings.
	file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({
		"version": 1,
		"unlocked_endings": ["cat_republic", "chaos_country"],
		"settings": {"debug_enabled": true},
		"last_run_summary": {"ending_id": "chaos_country"},
	}))
	file.close()
	fresh = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	reloaded = fresh.load_save()
	_check(int(reloaded.get("version", 0)) == 2, "v1 save migrates to v2")
	_check(reloaded.get("ending_records", {}).has("cat_republic"), "v1 first ending preserved in records")
	_check(reloaded.get("ending_records", {}).has("chaos_country"), "v1 second ending preserved in records")
	fresh.free()

	# Integration: a real ending unlocks and records meta rewards.
	save_manager.reset_save()
	game_manager.start_new_run()
	game_manager.debug_trigger_ending("chaos_country")
	_check(save_manager.is_ending_unlocked("chaos_country"), "run ending unlocks in save")
	_check(_meta.get_medals() > 0, "run ending awards medals")
	var last: Dictionary = save_manager.get_last_run_summary()
	_check(str(last.get("ending_id", "")) == "chaos_country", "last run summary recorded")
	_check(int(last.get("final_day", 0)) == 1, "last run summary day recorded")
	_check(last.has("medals_earned"), "last run summary includes medals")

	# Leave a clean default save behind.
	save_manager.reset_save()

	if _failures == 0:
		print("[TEST] All SaveManager tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)
