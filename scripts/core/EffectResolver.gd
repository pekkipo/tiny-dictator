class_name EffectResolver
extends RefCounted

## Applies one selected option to RunState and produces a normalized
## DecisionResult. Never selects decisions, changes scenes, or checks endings.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §8,
## sequence: docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md §5.

const FALLBACK_RESULT_TEXT: String = "The country reacts to your decision."


func apply_option(decision: Dictionary, side: String, state: RunState, repository: ContentRepository) -> DecisionResult:
	var result := DecisionResult.new()
	result.decision_id = str(decision.get("id", ""))
	result.selected_side = side

	var option: Variant = decision.get(side)
	if not (option is Dictionary):
		push_error("[EFFECT] Decision '%s' has no '%s' option." % [result.decision_id, side])
		result.result_text = FALLBACK_RESULT_TEXT
		return result
	result.choice_label = str(option.get("label", ""))

	var resources_before: Dictionary = state.get_resources()

	var effects: Dictionary = option.get("effects", {})
	for resource_id in effects:
		var applied: int = state.change_resource(str(resource_id), int(effects[resource_id]))
		result.resource_changes[str(resource_id)] = applied

	for law_id in option.get("add_laws", []):
		if not repository.has_law(str(law_id)):
			push_error("[EFFECT] Decision '%s' adds unknown law '%s'." % [result.decision_id, law_id])
			continue
		if state.add_law(str(law_id)):
			result.added_laws.append(str(law_id))

	for law_id in option.get("remove_laws", []):
		if state.remove_law(str(law_id)):
			result.removed_laws.append(str(law_id))

	for flag_id in option.get("add_flags", []):
		if state.add_flag(str(flag_id)):
			result.added_flags.append(str(flag_id))

	for flag_id in option.get("remove_flags", []):
		if state.remove_flag(str(flag_id)):
			result.removed_flags.append(str(flag_id))

	var counter_changes: Dictionary = option.get("counter_changes", {})
	for counter_id in counter_changes:
		var delta: int = int(counter_changes[counter_id])
		state.change_counter(str(counter_id), delta)
		result.counter_changes[str(counter_id)] = delta

	result.forced_next_decision_id = str(option.get("force_next_decision", ""))
	result.triggered_ending_id = str(option.get("trigger_ending", ""))
	result.result_text = str(option.get("result_text", ""))
	if result.result_text.is_empty():
		push_warning("[EFFECT] Decision '%s' option '%s' has no result_text; using fallback." % [result.decision_id, side])
		result.result_text = FALLBACK_RESULT_TEXT

	state.add_history_entry({
		"day": state.day,
		"decision_id": result.decision_id,
		"advisor_id": str(decision.get("advisor_id", "")),
		"selected_side": side,
		"choice_label": result.choice_label,
		"resource_before": resources_before,
		"resource_after": state.get_resources(),
		"added_laws": result.added_laws.duplicate(),
		"added_flags": result.added_flags.duplicate(),
	})
	state.mark_decision_used(result.decision_id)

	print("[EFFECT] %s/%s: %s%s" % [
		result.decision_id, side,
		_format_changes(result.resource_changes),
		"" if result.added_laws.is_empty() else " | new laws: %s" % ", ".join(result.added_laws),
	])
	return result


func _format_changes(changes: Dictionary) -> String:
	var parts: PackedStringArray = []
	for resource_id in changes:
		parts.append("%s %+d" % [resource_id, changes[resource_id]])
	return "no resource changes" if parts.is_empty() else ", ".join(parts)
