class_name SaveManager
extends RefCounted

const SAVE_PATH := "user://save.json"

static func save_run(state: RunState) -> bool:
	var data := {
		"scenario_id": state.scenario_id,
		"day": state.day,
		"resources": state.resources,
		"active_laws": state.active_laws,
		"flags": state.flags,
		"seen_decisions": state.seen_decisions,
		"ending_id": state.ending_id,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	return true

static func load_run() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	return parsed if parsed is Dictionary else {}

static func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
