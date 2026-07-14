extends Node

## Persistence autoload (PRD 04 §13). Phase 1 stores unlocked endings,
## settings, and the last run summary in a versioned user://save.json.
## Corrupt or mismatched files reset to a safe default (SAVE-002/003).

const SAVE_PATH: String = "user://save.json"
const SAVE_VERSION: int = 1

var _data: Dictionary = {}


func _ready() -> void:
	_data = load_save()
	print("[SAVE] Loaded save v%d: %d ending(s) unlocked." % [
		int(_data.get("version", 0)), get_unlocked_endings().size(),
	])


## Reads the save file from disk, falling back to defaults when the file is
## missing, unreadable, malformed, or from a different version.
func load_save() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		_data = _default_data()
		_persist()
		return _data

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("[SAVE] Cannot open %s; using defaults." % SAVE_PATH)
		_data = _default_data()
		return _data
	var text := file.get_as_text()
	file.close()

	var json := JSON.new()
	if json.parse(text) != OK or not (json.data is Dictionary):
		push_warning("[SAVE] Corrupt save file; resetting to defaults.")
		_data = _default_data()
		_persist()
		return _data

	var parsed: Dictionary = json.data
	if int(parsed.get("version", 0)) != SAVE_VERSION:
		push_warning("[SAVE] Save version %s != %d; resetting to defaults." % [
			str(parsed.get("version", "?")), SAVE_VERSION,
		])
		_data = _default_data()
		_persist()
		return _data

	# Backfill any keys missing from older-but-same-version files.
	var defaults := _default_data()
	for key in defaults:
		if not parsed.has(key):
			parsed[key] = defaults[key]
	_data = parsed
	return _data


func save_data(data: Dictionary) -> bool:
	_data = data
	return _persist()


func unlock_ending(ending_id: String) -> void:
	if ending_id.is_empty() or is_ending_unlocked(ending_id):
		return
	_data["unlocked_endings"].append(ending_id)
	_persist()
	print("[SAVE] Ending unlocked: %s" % ending_id)


func is_ending_unlocked(ending_id: String) -> bool:
	return ending_id in _data.get("unlocked_endings", [])


func get_unlocked_endings() -> Array:
	return _data.get("unlocked_endings", []).duplicate()


func set_last_run_summary(summary: Dictionary) -> void:
	_data["last_run_summary"] = summary
	_persist()


func get_last_run_summary() -> Dictionary:
	return _data.get("last_run_summary", {})


func reset_save() -> void:
	_data = _default_data()
	_persist()
	print("[SAVE] Save reset to defaults.")


func _default_data() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"unlocked_endings": [],
		"settings": {
			"debug_enabled": true,
		},
		"last_run_summary": {},
	}


func _persist() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[SAVE] Cannot write %s (error %d)." % [SAVE_PATH, FileAccess.get_open_error()])
		return false
	file.store_string(JSON.stringify(_data, "  "))
	file.close()
	return true
