class_name AdvisorRelationshipManager
extends RefCounted

## Owns hidden advisor affinity (-5 to +5). Spec: docs/06_PHASE_2A §16, §28.5.

const AFFINITY_MIN: int = -5
const AFFINITY_MAX: int = 5
const DEFAULT_AFFINITY: int = 0


func initialize_for_run(state: RunState, repository: ContentRepository) -> void:
	state.advisor_affinity.clear()
	for advisor in repository.get_raw_advisors():
		var advisor_id: String = str(advisor.get("id", ""))
		if advisor_id.is_empty():
			continue
		state.advisor_affinity[advisor_id] = DEFAULT_AFFINITY


func ensure_loaded_advisors(state: RunState, repository: ContentRepository) -> void:
	for advisor in repository.get_raw_advisors():
		var advisor_id: String = str(advisor.get("id", ""))
		if advisor_id.is_empty():
			continue
		if not state.advisor_affinity.has(advisor_id):
			state.advisor_affinity[advisor_id] = DEFAULT_AFFINITY


func apply_option_affinity(
	option: Dictionary,
	state: RunState,
	repository: ContentRepository,
	result: DecisionResult,
) -> void:
	var affinity_changes: Variant = option.get("advisor_affinity", {})
	if not (affinity_changes is Dictionary) or affinity_changes.is_empty():
		return
	for advisor_id in affinity_changes:
		var applied: int = state.change_advisor_affinity(str(advisor_id), int(affinity_changes[advisor_id]))
		result.advisor_affinity_changes[str(advisor_id)] = applied
	result.advisor_feedback = build_feedback_lines(result.advisor_affinity_changes, repository)


func build_feedback_lines(changes: Dictionary, repository: ContentRepository) -> Array[String]:
	var lines: Array[String] = []
	for advisor_id in changes:
		var delta: int = int(changes[advisor_id])
		if delta == 0:
			continue
		var advisor: Dictionary = repository.get_advisor(str(advisor_id))
		var name: String = str(advisor.get("display_name", advisor_id))
		if delta >= 2:
			lines.append("%s strongly approves." % name)
		elif delta == 1:
			lines.append("%s approves." % name)
		elif delta == -1:
			lines.append("%s looks disappointed." % name)
		else:
			lines.append("%s will remember this." % name)
	return lines


static func format_affinity_dict(state: RunState, repository: ContentRepository) -> String:
	var parts: PackedStringArray = []
	for advisor in repository.get_raw_advisors():
		var advisor_id: String = str(advisor.get("id", ""))
		if advisor_id.is_empty():
			continue
		parts.append("%s=%d" % [advisor_id, state.get_advisor_affinity(advisor_id)])
	return ", ".join(parts)
