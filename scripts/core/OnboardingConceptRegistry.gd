class_name OnboardingConceptRegistry
extends RefCounted

## Loads onboarding concept catalog and hint copy for first-run teaching.

const CONCEPTS_PATH: String = "res://data/onboarding/ministan_onboarding_concepts.json"

var _concept_ids: Array[String] = []
var _decisions_by_concept: Dictionary = {}
var _ui_hints: Dictionary = {}


func load_from_disk() -> bool:
	_concept_ids.clear()
	_decisions_by_concept.clear()
	_ui_hints.clear()

	if not FileAccess.file_exists(CONCEPTS_PATH):
		push_warning("[ONBOARDING] Missing concept catalog at %s" % CONCEPTS_PATH)
		return false

	var file := FileAccess.open(CONCEPTS_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		push_warning("[ONBOARDING] Concept catalog must be a JSON object.")
		return false

	var data: Dictionary = parsed
	for concept_id in data.get("concept_ids", []):
		var id: String = str(concept_id)
		if not id.is_empty():
			_concept_ids.append(id)

	var by_concept: Variant = data.get("decisions_by_concept", {})
	if by_concept is Dictionary:
		_decisions_by_concept = by_concept.duplicate(true)

	var hints: Variant = data.get("ui_hints", {})
	if hints is Dictionary:
		_ui_hints = hints.duplicate(true)

	return true


func get_all_concept_ids() -> Array[String]:
	return _concept_ids.duplicate()


func get_decision_ids_for_concept(concept_id: String) -> Array[String]:
	var ids: Array[String] = []
	for entry in _decisions_by_concept.get(concept_id, []):
		var id: String = str(entry)
		if not id.is_empty():
			ids.append(id)
	return ids


func get_hint_text(concept_id: String) -> String:
	return str(_ui_hints.get(concept_id, ""))


func get_concepts_for_decision(decision_id: String) -> Array[String]:
	var matched: Array[String] = []
	for concept_id in _concept_ids:
		for mapped_id in get_decision_ids_for_concept(concept_id):
			if mapped_id == decision_id:
				matched.append(concept_id)
				break
	return matched


func get_missing_concepts(introduced: Array[String]) -> Array[String]:
	var missing: Array[String] = []
	for concept_id in _concept_ids:
		if concept_id not in introduced:
			missing.append(concept_id)
	return missing
