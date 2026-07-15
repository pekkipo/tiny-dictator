class_name ContentRepository
extends RefCounted

## Loads and exposes content catalogs from /data JSON files.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §5,
## schemas: docs/03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md.

const COUNTRIES_DIR: String = "res://data/countries"
const ARCS_DIR: String = "res://data/arcs"
const CRISES_DIR: String = "res://data/crises"
const ADVISORS_PATH: String = "res://data/advisors/advisors.json"
const LAWS_PATH: String = "res://data/laws/laws.json"
const ENDINGS_PATH: String = "res://data/endings/endings.json"
const VISUAL_MAP_PATH: String = "res://data/visual_states/country_visual_map.json"
const FOLLOW_UP_POOLS_PATH: String = "res://data/follow_up_pools/follow_up_pools.json"
const RULER_IDENTITIES_PATH: String = "res://data/ruler_identities/ruler_identities.json"
const META_REWARDS_PATH: String = "res://data/meta/meta_rewards.json"
const PALACE_UPGRADES_PATH: String = "res://data/meta/palace_upgrades.json"
const ONBOARDING_CONCEPTS_PATH: String = "res://data/onboarding/ministan_onboarding_concepts.json"

var _countries: Dictionary = {}
var _advisors: Dictionary = {}
var _laws: Dictionary = {}
var _decisions: Dictionary = {}
var _endings: Dictionary = {}
var _arcs: Dictionary = {}
var _crises: Dictionary = {}
var _follow_up_pools: Dictionary = {}
var _ruler_identities: Dictionary = {}
var _meta_rewards: Dictionary = {}
var _palace_upgrades: Dictionary = {}
var _onboarding_registry: RefCounted = null

## Visual tag -> placeholder prop (emoji), consumed by CountryDiorama.
var _visual_map: Dictionary = {}

## Decision IDs per country, in file order.
var _country_decision_ids: Dictionary = {}

## Raw entry arrays (including duplicates) kept for validation.
var _raw_advisors: Array[Dictionary] = []
var _raw_laws: Array[Dictionary] = []
var _raw_decisions: Array[Dictionary] = []
var _raw_endings: Array[Dictionary] = []
var _raw_arcs: Array[Dictionary] = []
var _raw_crises: Array[Dictionary] = []
var _raw_countries: Array[Dictionary] = []
var _raw_follow_up_pools: Array[Dictionary] = []
var _raw_ruler_identities: Array[Dictionary] = []
var _raw_palace_upgrades: Array[Dictionary] = []

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
	_load_arcs()
	_load_crises()
	_load_follow_up_pools()

	_raw_ruler_identities = _load_entry_array(RULER_IDENTITIES_PATH)
	_index_catalog(_raw_ruler_identities, _ruler_identities, "ruler identity", RULER_IDENTITIES_PATH)

	_load_meta_rewards()
	_load_palace_upgrades()
	_onboarding_registry = load("res://scripts/core/OnboardingConceptRegistry.gd").new()
	_onboarding_registry.load_from_disk()

	var parsed_map: Variant = _parse_json_file(VISUAL_MAP_PATH)
	if parsed_map is Dictionary:
		_visual_map = parsed_map
	elif parsed_map != null:
		_load_errors.append("Expected a JSON object at root of %s" % VISUAL_MAP_PATH)

	var summary := "[CONTENT] Loaded: %d countries, %d advisors, %d laws, %d decisions, %d endings, %d arcs, %d crises, %d follow-up pools, %d ruler identities, %d palace upgrades" % [
		_countries.size(), _advisors.size(), _laws.size(), _decisions.size(), _endings.size(), _arcs.size(),
		_crises.size(), _follow_up_pools.size(), _ruler_identities.size(), _palace_upgrades.size(),
	]
	print(summary)
	for error in _load_errors:
		push_error("[CONTENT] %s" % error)
	return _load_errors.is_empty()


func reload_all() -> bool:
	return load_all()


## Loads an isolated test bundle for diagnostics/simulation unit tests.
static func load_test_bundle(path: String) -> ContentRepository:
	var repo := ContentRepository.new()
	var parsed: Variant = repo._parse_json_file(path)
	if not (parsed is Dictionary):
		push_error("[CONTENT] Test bundle '%s' must be a JSON object." % path)
		return repo
	var bundle: Dictionary = parsed
	repo._clear()

	for advisor in bundle.get("advisors", []):
		if advisor is Dictionary:
			repo._raw_advisors.append(advisor)
			var advisor_id: String = str(advisor.get("id", ""))
			if not advisor_id.is_empty():
				repo._advisors[advisor_id] = advisor

	for law in bundle.get("laws", []):
		if law is Dictionary:
			repo._raw_laws.append(law)
			var law_id: String = str(law.get("id", ""))
			if not law_id.is_empty():
				repo._laws[law_id] = law

	for ending in bundle.get("endings", []):
		if ending is Dictionary:
			repo._raw_endings.append(ending)
			var ending_id: String = str(ending.get("id", ""))
			if not ending_id.is_empty():
				repo._endings[ending_id] = ending

	for arc in bundle.get("arcs", []):
		if arc is Dictionary:
			repo._raw_arcs.append(arc)
			var arc_id: String = str(arc.get("id", ""))
			if not arc_id.is_empty():
				repo._arcs[arc_id] = arc

	for crisis in bundle.get("crises", []):
		if crisis is Dictionary:
			repo._raw_crises.append(crisis)
			var crisis_id: String = str(crisis.get("id", ""))
			if not crisis_id.is_empty():
				repo._crises[crisis_id] = crisis

	for pool in bundle.get("follow_up_pools", []):
		if pool is Dictionary:
			repo._raw_follow_up_pools.append(pool)
			var pool_id: String = str(pool.get("id", ""))
			if not pool_id.is_empty():
				repo._follow_up_pools[pool_id] = pool

	for country in bundle.get("countries", []):
		if country is Dictionary:
			repo._raw_countries.append(country)
			var country_id: String = str(country.get("id", ""))
			if country_id.is_empty():
				continue
			repo._countries[country_id] = country
			var decision_ids: Array[String] = []
			for decision in bundle.get("decisions", []):
				if not (decision is Dictionary):
					continue
				if str(decision.get("country_id", country_id)) != country_id:
					continue
				var decision_id: String = str(decision.get("id", ""))
				if decision_id.is_empty():
					continue
				if not repo._decisions.has(decision_id):
					repo._raw_decisions.append(decision)
					repo._decisions[decision_id] = DecisionSchema.normalize(decision.duplicate(true))
				decision_ids.append(decision_id)
			repo._country_decision_ids[country_id] = decision_ids

	if repo._meta_rewards.is_empty():
		repo._meta_rewards = {"days_survived_divisor": 3, "new_ending_bonus": 5}

	return repo


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


func get_arc(id: String) -> Dictionary:
	return _arcs.get(id, {})


func get_arcs_for_country(country_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for arc in _raw_arcs:
		if str(arc.get("country_id", "")) == country_id:
			result.append(arc)
	return result


func has_arc(id: String) -> bool:
	return _arcs.has(id)


func get_crisis(id: String) -> Dictionary:
	return _crises.get(id, {})


func get_crises_for_country(country_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for crisis in _raw_crises:
		if str(crisis.get("country_id", "")) == country_id:
			result.append(crisis)
	return result


func has_crisis(id: String) -> bool:
	return _crises.has(id)


func get_raw_crises() -> Array[Dictionary]:
	return _raw_crises


func get_follow_up_pool(id: String) -> Dictionary:
	return _follow_up_pools.get(id, {})


func has_follow_up_pool(id: String) -> bool:
	return _follow_up_pools.has(id)


func get_raw_follow_up_pools() -> Array[Dictionary]:
	return _raw_follow_up_pools


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


func get_raw_arcs() -> Array[Dictionary]:
	return _raw_arcs


func get_ruler_identity(id: String) -> Dictionary:
	return _ruler_identities.get(id, {})


func has_ruler_identity(id: String) -> bool:
	return _ruler_identities.has(id)


func get_raw_ruler_identities() -> Array[Dictionary]:
	return _raw_ruler_identities


func get_meta_rewards() -> Dictionary:
	return _meta_rewards.duplicate(true)


func get_palace_upgrade(id: String) -> Dictionary:
	return _palace_upgrades.get(id, {})


func has_palace_upgrade(id: String) -> bool:
	return _palace_upgrades.has(id)


func get_raw_palace_upgrades() -> Array[Dictionary]:
	return _raw_palace_upgrades


func get_onboarding_registry() -> RefCounted:
	return _onboarding_registry


func _load_meta_rewards() -> void:
	var parsed: Variant = _parse_json_file(META_REWARDS_PATH)
	if parsed is Dictionary:
		_meta_rewards = parsed
	elif parsed != null:
		_load_errors.append("Expected a JSON object at root of %s" % META_REWARDS_PATH)


func _load_palace_upgrades() -> void:
	var entries := _load_entry_array(PALACE_UPGRADES_PATH)
	for upgrade in entries:
		_raw_palace_upgrades.append(upgrade)
		var upgrade_id: String = str(upgrade.get("id", ""))
		if upgrade_id.is_empty():
			_load_errors.append("Palace upgrade missing 'id' in %s" % PALACE_UPGRADES_PATH)
			continue
		if _palace_upgrades.has(upgrade_id):
			_load_errors.append("Duplicate palace upgrade id '%s' in %s" % [upgrade_id, PALACE_UPGRADES_PATH])
			continue
		_palace_upgrades[upgrade_id] = upgrade


func _clear() -> void:
	_countries.clear()
	_advisors.clear()
	_laws.clear()
	_decisions.clear()
	_endings.clear()
	_arcs.clear()
	_crises.clear()
	_follow_up_pools.clear()
	_ruler_identities.clear()
	_meta_rewards.clear()
	_palace_upgrades.clear()
	_visual_map.clear()
	_country_decision_ids.clear()
	_raw_advisors = []
	_raw_laws = []
	_raw_decisions = []
	_raw_endings = []
	_raw_arcs = []
	_raw_crises = []
	_raw_countries = []
	_raw_follow_up_pools = []
	_raw_ruler_identities = []
	_raw_palace_upgrades = []
	_load_errors = []
	_onboarding_registry = null


func _load_follow_up_pools() -> void:
	var entries := _load_entry_array(FOLLOW_UP_POOLS_PATH)
	for pool in entries:
		_raw_follow_up_pools.append(pool)
		var pool_id: String = str(pool.get("id", ""))
		if pool_id.is_empty():
			_load_errors.append("Follow-up pool missing 'id' in %s" % FOLLOW_UP_POOLS_PATH)
			continue
		if _follow_up_pools.has(pool_id):
			_load_errors.append("Duplicate follow-up pool id '%s' in %s" % [pool_id, FOLLOW_UP_POOLS_PATH])
			continue
		_follow_up_pools[pool_id] = pool


func _load_arcs() -> void:
	var dir := DirAccess.open(ARCS_DIR)
	if dir == null:
		_load_errors.append("Cannot open arcs directory: %s" % ARCS_DIR)
		return
	var file_names := dir.get_files()
	file_names.sort()
	for file_name in file_names:
		if not file_name.ends_with(".json"):
			continue
		var path := "%s/%s" % [ARCS_DIR, file_name]
		var entries := _load_entry_array(path)
		for arc in entries:
			_raw_arcs.append(arc)
			var arc_id: String = str(arc.get("id", ""))
			if arc_id.is_empty():
				_load_errors.append("Arc missing 'id' in %s" % path)
				continue
			if _arcs.has(arc_id):
				_load_errors.append("Duplicate arc id '%s' in %s" % [arc_id, path])
				continue
			_arcs[arc_id] = arc


func _load_crises() -> void:
	var dir := DirAccess.open(CRISES_DIR)
	if dir == null:
		_load_errors.append("Cannot open crises directory: %s" % CRISES_DIR)
		return
	var file_names := dir.get_files()
	file_names.sort()
	for file_name in file_names:
		if not file_name.ends_with(".json"):
			continue
		var path := "%s/%s" % [CRISES_DIR, file_name]
		var entries := _load_entry_array(path)
		for crisis in entries:
			_raw_crises.append(crisis)
			var crisis_id: String = str(crisis.get("id", ""))
			if crisis_id.is_empty():
				_load_errors.append("Crisis missing 'id' in %s" % path)
				continue
			if _crises.has(crisis_id):
				_load_errors.append("Duplicate crisis id '%s' in %s" % [crisis_id, path])
				continue
			_crises[crisis_id] = crisis


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
			# Normalize once at load: legacy left/right become an "options"
			# array; schema_version and card_type get defaults (PRD 2A §12).
			_decisions[decision_id] = DecisionSchema.normalize(decision)
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
