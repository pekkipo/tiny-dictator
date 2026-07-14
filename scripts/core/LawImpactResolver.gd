class_name LawImpactResolver
extends RefCounted

## Derives everything worth showing about an active law: when and how it was
## enacted (from run history) and its potential long-term influence (from
## content). Pure logic — facts only, no UI and no presentation text.


static func describe(law_id: String, state: RunState, repository: ContentRepository) -> Dictionary:
	var law: Dictionary = repository.get_law(law_id)
	var info: Dictionary = {
		"law": law,
		"enacted_day": 0,          # 0 = not found in history (e.g. debug-added)
		"enacted_choice": "",
		"enactment_changes": {},   # actual resource deltas of the enacting choice
		"unlocks_decisions": 0,    # future decisions requiring this law
		"blocks_decisions": 0,     # decisions this law prevents
		"repealable": false,       # some option can remove this law
		"ending_related": false,   # some ending's conditions require this law
		"visual_props": [],        # emoji props shown in the diorama
	}

	for entry in state.decision_history:
		if law_id in entry.get("added_laws", []):
			info["enacted_day"] = int(entry.get("day", 0))
			info["enacted_choice"] = str(entry.get("choice_label", ""))
			var before: Dictionary = entry.get("resource_before", {})
			var after: Dictionary = entry.get("resource_after", {})
			for resource_id in RunState.RESOURCE_IDS:
				var delta: int = int(after.get(resource_id, 0)) - int(before.get(resource_id, 0))
				if delta != 0:
					info["enactment_changes"][resource_id] = delta
			break

	for decision in repository.get_all_decisions_for_country(state.country_id):
		var requirements: Dictionary = decision.get("requirements", {})
		if law_id in requirements.get("all_laws", []) or law_id in requirements.get("any_laws", []):
			info["unlocks_decisions"] += 1
		if law_id in requirements.get("blocked_laws", []):
			info["blocks_decisions"] += 1
		for option in DecisionSchema.get_options(decision):
			if option is Dictionary and law_id in option.get("remove_laws", []):
				info["repealable"] = true

	for ending in repository.get_raw_endings():
		var conditions: Dictionary = ending.get("conditions", {})
		if law_id in conditions.get("all_laws", []) or law_id in conditions.get("any_laws", []):
			info["ending_related"] = true
			break

	var visual_map: Dictionary = repository.get_visual_map()
	for tag in law.get("visual_tags", []):
		if visual_map.has(str(tag)):
			info["visual_props"].append(str(visual_map[str(tag)]))

	return info
