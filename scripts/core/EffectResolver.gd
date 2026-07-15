class_name EffectResolver
extends RefCounted

## Applies one selected option to RunState and produces a normalized
## DecisionResult. Never selects decisions, changes scenes, or checks endings.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §8,
## sequence: docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md §5.
## Since schema v2 (PRD 2A §12) choices resolve by option id; the legacy
## ids "left"/"right" keep working through DecisionSchema aliases.

const FALLBACK_RESULT_TEXT: String = "The country reacts to your decision."


func apply_option(
	decision: Dictionary,
	option_id: String,
	state: RunState,
	repository: ContentRepository,
	arc_manager: ArcManager = null,
) -> DecisionResult:
	var result := DecisionResult.new()
	result.decision_id = str(decision.get("id", ""))

	var option: Dictionary = DecisionSchema.get_option(decision, option_id)
	if option.is_empty():
		push_error("[EFFECT] Decision '%s' has no option '%s'." % [result.decision_id, option_id])
		result.result_text = FALLBACK_RESULT_TEXT
		return result
	result.selected_option_id = str(option.get("id", option_id))
	result.selected_side = result.selected_option_id
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
		push_warning("[EFFECT] Decision '%s' option '%s' has no result_text; using fallback." % [result.decision_id, result.selected_option_id])
		result.result_text = FALLBACK_RESULT_TEXT

	if arc_manager != null:
		_apply_narrative_arc_effects(decision, result.decision_id, state, arc_manager, result)
		_apply_option_arc_actions(option, result.decision_id, state, arc_manager, result)

	state.add_history_entry({
		"day": state.day,
		"decision_id": result.decision_id,
		"advisor_id": str(decision.get("advisor_id", "")),
		"selected_option_id": result.selected_option_id,
		"selected_side": result.selected_option_id,
		"choice_label": result.choice_label,
		"resource_before": resources_before,
		"resource_after": state.get_resources(),
		"added_laws": result.added_laws.duplicate(),
		"added_flags": result.added_flags.duplicate(),
	})
	state.mark_decision_used(result.decision_id)

	print("[EFFECT] %s/%s: %s%s" % [
		result.decision_id, result.selected_option_id,
		_format_changes(result.resource_changes),
		"" if result.added_laws.is_empty() else " | new laws: %s" % ", ".join(result.added_laws),
	])
	return result


func _apply_narrative_arc_effects(
	decision: Dictionary,
	decision_id: String,
	state: RunState,
	arc_manager: ArcManager,
	result: DecisionResult,
) -> void:
	var narrative: Variant = decision.get("narrative", {})
	if not (narrative is Dictionary) or narrative.is_empty():
		return
	var arc_id: String = str(narrative.get("arc_id", ""))
	if arc_id.is_empty():
		return

	if bool(narrative.get("starts_arc", false)):
		var branch_id: String = str(narrative.get("branch_id", ""))
		if arc_manager.apply_action(state, arc_id, "start", decision_id, branch_id):
			result.arc_changes.append({"arc_id": arc_id, "action": "start", "branch_id": branch_id})

	if bool(narrative.get("advances_arc", false)):
		var branch_id: String = str(narrative.get("branch_id", ""))
		if arc_manager.apply_action(state, arc_id, "advance", decision_id, branch_id):
			result.arc_changes.append({"arc_id": arc_id, "action": "advance", "branch_id": branch_id})

	if bool(narrative.get("resolves_arc", false)):
		if arc_manager.apply_action(state, arc_id, "complete", decision_id):
			result.arc_changes.append({"arc_id": arc_id, "action": "complete"})


func _apply_option_arc_actions(
	option: Dictionary,
	decision_id: String,
	state: RunState,
	arc_manager: ArcManager,
	result: DecisionResult,
) -> void:
	for action_data in option.get("arc_actions", []):
		if not (action_data is Dictionary):
			continue
		var arc_id: String = str(action_data.get("arc_id", ""))
		var action: String = str(action_data.get("action", ""))
		var branch_id: String = str(action_data.get("branch_id", ""))
		var reason: String = str(action_data.get("reason", ""))
		if arc_id.is_empty() or action.is_empty():
			continue
		if arc_manager.apply_action(state, arc_id, action, decision_id, branch_id, reason):
			result.arc_changes.append({
				"arc_id": arc_id,
				"action": action,
				"branch_id": branch_id,
				"reason": reason,
			})


func _format_changes(changes: Dictionary) -> String:
	var parts: PackedStringArray = []
	for resource_id in changes:
		parts.append("%s %+d" % [resource_id, changes[resource_id]])
	return "no resource changes" if parts.is_empty() else ", ".join(parts)
