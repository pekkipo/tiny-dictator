extends SceneTree

## Milestone 10 tests: SaveManager persistence (SAVE-001..SAVE-004).
## Run: godot --headless --path . -s tests/test_save_manager.gd

const SAVE_PATH: String = "user://save.json"

var _failures: int = 0


func _initialize() -> void:
	await process_frame
	var save_manager: Node = root.get_node("SaveManager")
	var game_manager: Node = root.get_node("GameManager")

	# Start from a known-clean save (SAVE-004).
	save_manager.reset_save()
	_check(save_manager.get_unlocked_endings().is_empty(), "reset clears unlocked endings")
	_check(FileAccess.file_exists(SAVE_PATH), "reset writes a default save file")

	# Unlock + dedup.
	save_manager.unlock_ending("revolution")
	save_manager.unlock_ending("revolution")
	_check(save_manager.is_ending_unlocked("revolution"), "ending unlocked")
	_check(save_manager.get_unlocked_endings().size() == 1, "unlock is deduplicated")

	# SAVE-001: persistence across a fresh instance (simulated app restart).
	var fresh: Node = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	var reloaded: Dictionary = fresh.load_save()
	_check("revolution" in reloaded.get("unlocked_endings", []), "unlock survives reload from disk")
	fresh.free()

	# SAVE-002: corrupt file resets to safe defaults.
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string("{ not valid json !!!")
	file.close()
	fresh = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	reloaded = fresh.load_save()
	_check(reloaded.get("unlocked_endings", [null]).is_empty(), "corrupt save resets to defaults")
	_check(int(reloaded.get("version", 0)) == 1, "corrupt save rewritten with current version")
	fresh.free()

	# SAVE-003: version mismatch resets without crashing.
	file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"version": 99, "unlocked_endings": ["cat_republic"]}))
	file.close()
	fresh = (load("res://scripts/core/SaveManager.gd") as GDScript).new()
	reloaded = fresh.load_save()
	_check(reloaded.get("unlocked_endings", [null]).is_empty(), "version mismatch resets to defaults")
	fresh.free()

	# Integration: a real ending unlocks and records the last run summary.
	save_manager.reset_save()
	game_manager.start_new_run()
	game_manager.debug_trigger_ending("chaos_country")
	_check(save_manager.is_ending_unlocked("chaos_country"), "run ending unlocks in save")
	var last: Dictionary = save_manager.get_last_run_summary()
	_check(str(last.get("ending_id", "")) == "chaos_country", "last run summary recorded")
	_check(int(last.get("final_day", 0)) == 1, "last run summary day recorded")

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
