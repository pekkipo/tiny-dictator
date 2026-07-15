extends Node

## Persistence autoload (PRD 04 §13). Phase 2A stores meta-progression in a
## versioned user://save.json with safe migration from Phase 1 saves.

const SAVE_PATH: String = "user://save.json"
const SAVE_VERSION: int = 2
const LEGACY_SAVE_VERSION: int = 1

var _data: Dictionary = {}
var _persistence_enabled: bool = true


func _ready() -> void:
	_data = load_save()
	print("[SAVE] Loaded save v%d: %d ending(s), %d medal(s)." % [
		get_save_version(), get_unlocked_endings().size(), get_medals(),
	])


## Reads the save file from disk, migrating or falling back when needed.
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
	var version: int = int(parsed.get("version", 0))
	var migrated: bool = false

	if version == LEGACY_SAVE_VERSION:
		parsed = _migrate_v1_to_v2(parsed)
		migrated = true
	elif version == SAVE_VERSION:
		parsed = _sanitize_and_backfill(parsed)
	elif version <= 0:
		push_warning("[SAVE] Missing save version; resetting to defaults.")
		_data = _default_data()
		_persist()
		return _data
	else:
		push_warning("[SAVE] Unknown save version %d; attempting sanitize." % version)
		parsed = _sanitize_and_backfill(parsed)
		parsed["version"] = SAVE_VERSION
		migrated = true

	_sync_unlocked_endings_array(parsed)
	_data = parsed
	if migrated:
		_persist()
	return _data


func get_data() -> Dictionary:
	return _data.duplicate(true)


func create_snapshot() -> Dictionary:
	return _data.duplicate(true)


func restore_snapshot(snapshot: Dictionary) -> void:
	_data = snapshot.duplicate(true)
	_sync_unlocked_endings_array(_data)
	if _persistence_enabled:
		_persist()


func set_persistence_enabled(enabled: bool) -> void:
	_persistence_enabled = enabled


func is_persistence_enabled() -> bool:
	return _persistence_enabled


func save_data(data: Dictionary) -> bool:
	_data = data.duplicate(true)
	_sync_unlocked_endings_array(_data)
	return _persist()


func get_save_version() -> int:
	return int(_data.get("version", 0))


func get_medals() -> int:
	return int(_data.get("medals", 0))


func set_medals(value: int) -> void:
	_data["medals"] = maxi(0, value)
	_persist()


func get_total_runs_completed() -> int:
	return int(_data.get("total_runs_completed", 0))


func set_total_runs_completed(value: int) -> void:
	_data["total_runs_completed"] = maxi(0, value)
	_persist()


func get_ending_records() -> Dictionary:
	var records: Variant = _data.get("ending_records", {})
	return records if records is Dictionary else {}


func set_ending_records(records: Dictionary) -> void:
	_data["ending_records"] = records.duplicate(true)
	_sync_unlocked_endings_array(_data)
	_persist()


func get_palace_upgrades() -> Dictionary:
	var upgrades: Variant = _data.get("palace_upgrades", {})
	return upgrades if upgrades is Dictionary else {}


func set_palace_upgrades(upgrades: Dictionary) -> void:
	_data["palace_upgrades"] = upgrades.duplicate(true)
	_persist()


func get_unlocked_country_ids() -> Array:
	var countries: Variant = _data.get("unlocked_country_ids", [])
	if countries is Array:
		return countries.duplicate()
	return ["ministan"]


func set_unlocked_country_ids(country_ids: Array) -> void:
	_data["unlocked_country_ids"] = country_ids.duplicate()
	_persist()


func unlock_ending(ending_id: String) -> void:
	if ending_id.is_empty():
		return
	var records: Dictionary = get_ending_records()
	if records.has(ending_id):
		return
	var now: int = int(Time.get_unix_time_from_system())
	records[ending_id] = {
		"ending_id": ending_id,
		"unlocked": true,
		"first_unlocked_at": now,
		"times_reached": 1,
		"best_day": 0,
	}
	set_ending_records(records)
	print("[SAVE] Ending unlocked: %s" % ending_id)


func is_ending_unlocked(ending_id: String) -> bool:
	return ending_id in get_unlocked_endings()


func get_unlocked_endings() -> Array:
	return _data.get("unlocked_endings", []).duplicate()


func set_last_run_summary(summary: Dictionary) -> void:
	_data["last_run_summary"] = summary.duplicate(true)
	_persist()


func get_last_run_summary() -> Dictionary:
	return _data.get("last_run_summary", {})


func reset_meta_progression() -> void:
	var settings: Dictionary = _data.get("settings", {"debug_enabled": true})
	_data = _default_data()
	_data["settings"] = settings.duplicate(true)
	_persist()
	print("[SAVE] Meta progression reset.")


func get_introduced_onboarding_concepts() -> Array[String]:
	var concepts: Array[String] = []
	for concept_id in _data.get("introduced_onboarding_concepts", []):
		var id: String = str(concept_id)
		if not id.is_empty():
			concepts.append(id)
	return concepts


func merge_introduced_onboarding_concepts(new_concepts: Array) -> void:
	if new_concepts.is_empty():
		return
	var merged: Array[String] = get_introduced_onboarding_concepts()
	for concept_id in new_concepts:
		var id: String = str(concept_id)
		if id.is_empty() or id in merged:
			continue
		merged.append(id)
	merged.sort()
	_data["introduced_onboarding_concepts"] = merged
	_persist()


func reset_save() -> void:
	_data = _default_data()
	_persist()
	print("[SAVE] Save reset to defaults.")


func _default_data() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"medals": 0,
		"total_runs_completed": 0,
		"unlocked_country_ids": ["ministan"],
		"ending_records": {},
		"palace_upgrades": {},
		"unlocked_endings": [],
		"settings": {
			"debug_enabled": true,
		},
		"last_run_summary": {},
		"introduced_onboarding_concepts": [],
	}


func _migrate_v1_to_v2(parsed: Dictionary) -> Dictionary:
	var migrated := _default_data()
	var settings: Variant = parsed.get("settings", {})
	if settings is Dictionary:
		migrated["settings"] = settings.duplicate(true)
	var last_summary: Variant = parsed.get("last_run_summary", {})
	if last_summary is Dictionary:
		migrated["last_run_summary"] = last_summary.duplicate(true)

	var now: int = int(Time.get_unix_time_from_system())
	var records: Dictionary = {}
	for ending_id in parsed.get("unlocked_endings", []):
		var id: String = str(ending_id)
		if id.is_empty() or records.has(id):
			continue
		records[id] = {
			"ending_id": id,
			"unlocked": true,
			"first_unlocked_at": now,
			"times_reached": 1,
			"best_day": 0,
		}
	migrated["ending_records"] = records
	migrated["version"] = SAVE_VERSION
	print("[SAVE] Migrated save v1 -> v2 (%d ending record(s))." % records.size())
	return migrated


func _sanitize_and_backfill(parsed: Dictionary) -> Dictionary:
	var defaults := _default_data()
	var sanitized: Dictionary = parsed.duplicate(true)
	sanitized["version"] = SAVE_VERSION

	if not sanitized.get("settings", {}) is Dictionary:
		sanitized["settings"] = defaults["settings"].duplicate(true)
	if not sanitized.get("last_run_summary", {}) is Dictionary:
		sanitized["last_run_summary"] = {}

	sanitized["medals"] = maxi(0, int(parsed.get("medals", defaults["medals"])))
	sanitized["total_runs_completed"] = maxi(0, int(parsed.get("total_runs_completed", 0)))

	var countries: Variant = parsed.get("unlocked_country_ids", defaults["unlocked_country_ids"])
	if countries is Array and not countries.is_empty():
		sanitized["unlocked_country_ids"] = countries.duplicate()
	else:
		sanitized["unlocked_country_ids"] = defaults["unlocked_country_ids"].duplicate()

	sanitized["ending_records"] = _sanitize_ending_records(parsed.get("ending_records", {}))
	sanitized["palace_upgrades"] = _sanitize_palace_upgrades(parsed.get("palace_upgrades", {}))

	var saved_concepts: Variant = parsed.get("introduced_onboarding_concepts", [])
	if saved_concepts is Array:
		var concepts: Array[String] = []
		for concept_id in saved_concepts:
			var id: String = str(concept_id)
			if not id.is_empty() and id not in concepts:
				concepts.append(id)
		concepts.sort()
		sanitized["introduced_onboarding_concepts"] = concepts
	else:
		sanitized["introduced_onboarding_concepts"] = []

	for key in defaults:
		if not sanitized.has(key):
			sanitized[key] = defaults[key]
	return sanitized


func _sanitize_ending_records(raw: Variant) -> Dictionary:
	if not raw is Dictionary:
		return {}
	var records: Dictionary = {}
	for ending_id in raw:
		var entry: Variant = raw[ending_id]
		if not entry is Dictionary:
			continue
		var id: String = str(entry.get("ending_id", ending_id))
		if id.is_empty():
			continue
		records[id] = {
			"ending_id": id,
			"unlocked": bool(entry.get("unlocked", true)),
			"first_unlocked_at": int(entry.get("first_unlocked_at", 0)),
			"times_reached": maxi(1, int(entry.get("times_reached", 1))),
			"best_day": maxi(0, int(entry.get("best_day", 0))),
		}
	return records


func _sanitize_palace_upgrades(raw: Variant) -> Dictionary:
	if not raw is Dictionary:
		return {}
	var upgrades: Dictionary = {}
	for upgrade_id in raw:
		var entry: Variant = raw[upgrade_id]
		if not entry is Dictionary:
			continue
		var id: String = str(upgrade_id)
		if id.is_empty():
			continue
		upgrades[id] = {
			"purchased": bool(entry.get("purchased", false)),
			"purchased_at": int(entry.get("purchased_at", 0)),
		}
	return upgrades


func _sync_unlocked_endings_array(data: Dictionary) -> void:
	var records: Dictionary = data.get("ending_records", {})
	if not records is Dictionary:
		data["unlocked_endings"] = []
		return
	var ids: Array[String] = []
	for ending_id in records:
		var record: Dictionary = records[ending_id]
		if bool(record.get("unlocked", false)):
			ids.append(str(ending_id))
	ids.sort()
	data["unlocked_endings"] = ids


func _persist() -> bool:
	if not _persistence_enabled:
		return true
	_sync_unlocked_endings_array(_data)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[SAVE] Cannot write %s (error %d)." % [SAVE_PATH, FileAccess.get_open_error()])
		return false
	file.store_string(JSON.stringify(_data, "  "))
	file.close()
	return true
