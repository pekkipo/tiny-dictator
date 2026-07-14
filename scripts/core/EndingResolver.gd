class_name EndingResolver
extends RefCounted

## Determines whether the run ends after a resolved decision.
## Returns the matching ending dictionary, or {} when the run continues.
## Priority per PRD 01 §13: explicit > condition-based by priority
## (special endings outrank resource collapses via data priorities) > max day.


func resolve_ending(state: RunState, decision_result: DecisionResult, country_data: Dictionary, repository: ContentRepository) -> Dictionary:
	# 1. Explicit ending triggered by the selected option.
	if decision_result != null and not decision_result.triggered_ending_id.is_empty():
		var explicit: Dictionary = repository.get_ending(decision_result.triggered_ending_id)
		if explicit.is_empty():
			push_error("[ENDING] Option triggered unknown ending '%s'." % decision_result.triggered_ending_id)
		else:
			return explicit

	# 2./3. Condition-based endings (special + resource collapse), highest priority wins.
	# Multiple simultaneous collapses resolve by data priority (TC-017).
	var best: Dictionary = {}
	var best_priority: int = -1
	for ending in repository.get_raw_endings():
		var type: String = str(ending.get("type", ""))
		if type != "special" and type != "resource_failure":
			continue
		var conditions: Dictionary = ending.get("conditions", {})
		if conditions.is_empty():
			continue
		if not RequirementsEvaluator.matches(conditions, state):
			continue
		var priority: int = int(ending.get("priority", 0))
		if priority > best_priority:
			best = ending
			best_priority = priority
	if not best.is_empty():
		return best

	# 4. Configurable maximum day (survival ending).
	var max_day: int = int(country_data.get("max_day", 0))
	if max_day > 0 and state.day >= max_day:
		var survival: Dictionary = repository.get_ending(str(country_data.get("survival_ending_id", "")))
		if not survival.is_empty():
			return survival
		push_warning("[ENDING] Max day reached but survival ending is missing.")

	return {}
