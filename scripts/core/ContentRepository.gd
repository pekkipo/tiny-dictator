class_name ContentRepository
extends RefCounted

## Loads and exposes content catalogs from /data JSON files.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §5,
## schemas: docs/03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md.

const COUNTRIES_DIR: String = "res://data/countries"
const ADVISORS_PATH: String = "res://data/advisors/advisors.json"
const LAWS_PATH: String = "res://data/laws/laws.json"
const ENDINGS_PATH: String = "res://data/endings/endings.json"
const VISUAL_MAP_PATH: String = "res://data/visual_states/country_visual_map.json"

var _countries: Dictionary = {}
var _advisors: Dictionary = {}
var _laws: Dictionary = {}
var _decisions: Dictionary = {}
var _endings: Dictionary = {}

## Visual tag -> placeholder prop (emoji), consumed by CountryDiorama.
var _visual_map: Dictionary = {}

## Decision IDs per country, in file order.
var _country_decision_ids: Dictionary = {}

## Raw entry arrays (including duplicates) kept for validation.
var _raw_advisors: Array[Dictionary] = []
var _raw_laws: Array[Dictionary] = []
var _raw_decisions: Array[Dictionary] = []
var _raw_endings: Array[Dictionary] = []
var _raw_countries: Array[Dictionary] = []

var _load_errors: Array[String] = []


func load_all() -> bool:
	_clear()

	_raw_advisors = _load_entry_array(ADVISORS_PATH)
	_index_catalog(_raw_advisors, _advisors, "advisor", ADVISORS_PATH)

	_raw_laws = _load_entry_array(LAWS_PATH)
	_index_catalog(_raw_laws, _laws, "law", LAWS_PATH)

	_raw_endings = _load_entry_array(ENDINGS_PATH)
	_index_catalog(_raw_endings, _endings, "ending", ENDINGS_PATH)

	_load_countries()

	var parsed_map: Variant = _parse_json_file(VISUAL_MAP_PATH)
	if parsed_map is Dictionary:
		_visual_map = parsed_map
	elif parsed_map != null:
		_load_errors.append("Expected a JSON object at root of %s" % VISUAL_MAP_PATH)

	var summary := "[CONTENT] Loaded: %d countries, %d advisors, %d laws, %d decisions, %d endings" % [
		_countries.size(), _advisors.size(), _laws.size(), _decisions.size(), _endings.size(),
	]
	print(summary)
	for error in _load_errors:
		push_error("[CONTENT] %s" % error)
	return _load_errors.is_empty()


func reload_all() -> bool:
	return load_all()


func get_load_errors() -> Array[String]:
	return _load_errors.duplicate()


func get_country(id: String) -> Dictionary:
	return _countries.get(id, {})


func get_advisor(id: String) -> Dictionary:
	return _advisors.get(id, {})


func get_law(id: String) -> Dictionary:
	return _laws.get(id, {})


func get_decision(id: String) -> Dictionary:
	return _decisions.get(id, {})


func get_ending(id: String) -> Dictionary:
	return _endings.get(id, {})


func get_visual_map() -> Dictionary:
	return _visual_map


func get_all_decisions_for_country(country_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for decision_id in _country_decision_ids.get(country_id, []):
		result.append(_decisions[decision_id])
	return result


func has_country(id: String) -> bool:
	return _countries.has(id)


func has_decision(id: String) -> bool:
	return _decisions.has(id)


func has_law(id: String) -> bool:
	return _laws.has(id)


func has_advisor(id: String) -> bool:
	return _advisors.has(id)


func has_ending(id: String) -> bool:
	return _endings.has(id)


## Raw accessors used by ContentValidator (may contain duplicates).
func get_raw_countries() -> Array[Dictionary]:
	return _raw_countries


func get_raw_advisors() -> Array[Dictionary]:
	return _raw_advisors


func get_raw_laws() -> Array[Dictionary]:
	return _raw_laws


func get_raw_decisions() -> Array[Dictionary]:
	return _raw_decisions


func get_raw_endings() -> Array[Dictionary]:
	return _raw_endings


func _clear() -> void:
	_countries.clear()
	_advisors.clear()
	_laws.clear()
	_decisions.clear()
	_endings.clear()
	_visual_map.clear()
	_country_decision_ids.clear()
	_raw_advisors = []
	_raw_laws = []
	_raw_decisions = []
	_raw_endings = []
	_raw_countries = []
	_load_errors = []


func _load_countries() -> void:
	var dir := DirAccess.open(COUNTRIES_DIR)
	if dir == null:
		_load_errors.append("Cannot open countries directory: %s" % COUNTRIES_DIR)
		return
	var file_names := dir.get_files()
	file_names.sort()
	for file_name in file_names:
		if not file_name.ends_with(".json"):
			continue
		var path := "%s/%s" % [COUNTRIES_DIR, file_name]
		var country: Variant = _parse_json_file(path)
		if not (country is Dictionary):
			continue
		var country_id: String = str(country.get("id", ""))
		if country_id.is_empty():
			_load_errors.append("Country file missing 'id': %s" % path)
			continue
		if _countries.has(country_id):
			_load_errors.append("Duplicate country id '%s' in %s" % [country_id, path])
			continue
		_raw_countries.append(country)
		_countries[country_id] = country
		_load_decision_files(country)


func _load_decision_files(country: Dictionary) -> void:
	var country_id: String = str(country.get("id", ""))
	var decision_ids: Array[String] = []
	for decision_path in country.get("decision_files", []):
		var entries := _load_entry_array(str(decision_path))
		for decision in entries:
			_raw_decisions.append(decision)
			var decision_id: String = str(decision.get("id", ""))
			if decision_id.is_empty():
				_load_errors.append("Decision missing 'id' in %s" % decision_path)
				continue
			if _decisions.has(decision_id):
				_load_errors.append("Duplicate decision id '%s' in %s" % [decision_id, decision_path])
				continue
			_decisions[decision_id] = decision
			decision_ids.append(decision_id)
	_country_decision_ids[country_id] = decision_ids


## Loads a JSON file whose root is an array of dictionaries.
func _load_entry_array(path: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var parsed: Variant = _parse_json_file(path)
	if parsed is Array:
		for entry in parsed:
			if entry is Dictionary:
				result.append(entry)
			else:
				_load_errors.append("Non-object entry in %s" % path)
	elif parsed != null:
		_load_errors.append("Expected a JSON array at root of %s" % path)
	return result


func _parse_json_file(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		_load_errors.append("Missing content file: %s" % path)
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_load_errors.append("Cannot open content file: %s" % path)
		return null
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	var error := json.parse(text)
	if error != OK:
		_load_errors.append("JSON parse error in %s at line %d: %s" % [
			path, json.get_error_line(), json.get_error_message(),
		])
		return null
	return json.data


func _index_catalog(entries: Array[Dictionary], target: Dictionary, kind: String, path: String) -> void:
	for entry in entries:
		var id: String = str(entry.get("id", ""))
		if id.is_empty():
			_load_errors.append("%s entry missing 'id' in %s" % [kind.capitalize(), path])
			continue
		if target.has(id):
			_load_errors.append("Duplicate %s id '%s' in %s" % [kind, id, path])
			continue
		target[id] = entry
