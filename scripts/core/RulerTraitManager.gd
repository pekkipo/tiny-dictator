class_name RulerTraitManager
extends RefCounted

## Owns hidden playstyle counters and final ruler identity. Spec: docs/06_PHASE_2A §17, §28.6.

const VALID_TRAIT_IDS: Array[String] = [
	"authoritarian",
	"populist",
	"capitalist",
	"chaotic",
	"scientific",
	"propagandist",
	"bureaucratic",
	"cat_friendly",
]

const FALLBACK_IDENTITY_ID: String = "the_accidental_ruler"


func initialize_for_run(state: RunState) -> void:
	state.ruler_traits.clear()
	for trait_id in VALID_TRAIT_IDS:
		state.ruler_traits[trait_id] = 0


func ensure_loaded_traits(state: RunState) -> void:
	for trait_id in VALID_TRAIT_IDS:
		if not state.ruler_traits.has(trait_id):
			state.ruler_traits[trait_id] = 0


func apply_option_traits(option: Dictionary, state: RunState, result: DecisionResult) -> void:
	var trait_changes: Variant = option.get("trait_changes", {})
	if not (trait_changes is Dictionary) or trait_changes.is_empty():
		return
	for trait_id in trait_changes:
		var applied: int = state.change_ruler_trait(str(trait_id), int(trait_changes[trait_id]))
		result.ruler_trait_changes[str(trait_id)] = applied


func get_dominant_trait(state: RunState) -> String:
	var best_id: String = ""
	var best_value: int = 0
	for trait_id in VALID_TRAIT_IDS:
		var value: int = state.get_ruler_trait(trait_id)
		if value > best_value:
			best_value = value
			best_id = trait_id
	return best_id


func resolve_identity(state: RunState, repository: ContentRepository) -> Dictionary:
	var identities: Array[Dictionary] = repository.get_raw_ruler_identities()
	identities.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("priority", 0)) > int(b.get("priority", 0))
	)
	for identity in identities:
		if _matches_identity(state, identity):
			return {
				"id": str(identity.get("id", FALLBACK_IDENTITY_ID)),
				"display_name": str(identity.get("display_name", "The Accidental Ruler")),
			}
	return {
		"id": FALLBACK_IDENTITY_ID,
		"display_name": "The Accidental Ruler",
	}


func _matches_identity(state: RunState, identity: Dictionary) -> bool:
	var conditions: Variant = identity.get("conditions", {})
	if not (conditions is Dictionary):
		return false
	if conditions.is_empty():
		return true

	var minimum_traits: Dictionary = conditions.get("minimum_traits", {})
	for trait_id in minimum_traits:
		if state.get_ruler_trait(str(trait_id)) < int(minimum_traits[trait_id]):
			return false

	var maximum_traits: Dictionary = conditions.get("maximum_traits", {})
	for trait_id in maximum_traits:
		if state.get_ruler_trait(str(trait_id)) > int(maximum_traits[trait_id]):
			return false

	if conditions.has("minimum_total_traits"):
		var total: int = 0
		for trait_id in VALID_TRAIT_IDS:
			total += state.get_ruler_trait(trait_id)
		if total < int(conditions["minimum_total_traits"]):
			return false

	var dominant: String = str(conditions.get("dominant_trait", ""))
	if not dominant.is_empty():
		var dominant_value: int = state.get_ruler_trait(dominant)
		if dominant_value < 1:
			return false
		for trait_id in VALID_TRAIT_IDS:
			if trait_id == dominant:
				continue
			if state.get_ruler_trait(trait_id) > dominant_value:
				return false

	return true


static func format_traits_dict(state: RunState) -> String:
	var parts: PackedStringArray = []
	for trait_id in VALID_TRAIT_IDS:
		var value: int = state.get_ruler_trait(trait_id)
		if value != 0:
			parts.append("%s=%d" % [trait_id, value])
	return ", ".join(parts) if not parts.is_empty() else "(all zero)"
