class_name RequirementsEvaluator
extends RefCounted

## Shared condition matcher used by DecisionEngine (decision requirements)
## and EndingResolver (ending conditions). Operators per PRD 03 §11 / PRD 01 §14.


static func matches(requirements: Dictionary, state: RunState) -> bool:
	for flag_id in requirements.get("all_flags", []):
		if not state.has_flag(str(flag_id)):
			return false

	var any_flags: Array = requirements.get("any_flags", [])
	if not any_flags.is_empty() and not any_flags.any(func(flag_id: Variant) -> bool: return state.has_flag(str(flag_id))):
		return false

	for flag_id in requirements.get("blocked_flags", []):
		if state.has_flag(str(flag_id)):
			return false

	for law_id in requirements.get("all_laws", []):
		if not state.has_law(str(law_id)):
			return false

	var any_laws: Array = requirements.get("any_laws", [])
	if not any_laws.is_empty() and not any_laws.any(func(law_id: Variant) -> bool: return state.has_law(str(law_id))):
		return false

	for law_id in requirements.get("blocked_laws", []):
		if state.has_law(str(law_id)):
			return false

	var minimum_resources: Dictionary = requirements.get("minimum_resources", {})
	for resource_id in minimum_resources:
		if state.get_resource(str(resource_id)) < int(minimum_resources[resource_id]):
			return false

	var maximum_resources: Dictionary = requirements.get("maximum_resources", {})
	for resource_id in maximum_resources:
		if state.get_resource(str(resource_id)) > int(maximum_resources[resource_id]):
			return false

	var minimum_counters: Dictionary = requirements.get("minimum_counters", {})
	for counter_id in minimum_counters:
		if state.get_counter(str(counter_id)) < int(minimum_counters[counter_id]):
			return false

	var maximum_counters: Dictionary = requirements.get("maximum_counters", {})
	for counter_id in maximum_counters:
		if state.get_counter(str(counter_id)) > int(maximum_counters[counter_id]):
			return false

	if requirements.has("minimum_day") and state.day < int(requirements["minimum_day"]):
		return false
	if requirements.has("maximum_day") and state.day > int(requirements["maximum_day"]):
		return false

	for decision_id in requirements.get("used_decisions", []):
		if str(decision_id) not in state.used_decision_ids:
			return false

	for decision_id in requirements.get("not_used_decisions", []):
		if str(decision_id) in state.used_decision_ids:
			return false

	for arc_id in requirements.get("active_arcs", []):
		if not state.is_arc_active(str(arc_id)):
			return false

	for arc_id in requirements.get("blocked_arcs", []):
		var blocked_id := str(arc_id)
		if state.is_arc_active(blocked_id) or state.is_arc_completed(blocked_id):
			return false

	for arc_id in requirements.get("completed_arcs", []):
		if not state.is_arc_completed(str(arc_id)):
			return false

	for arc_id in requirements.get("failed_arcs", []):
		if not state.is_arc_failed(str(arc_id)):
			return false

	var arc_branches: Variant = requirements.get("arc_branches", {})
	if arc_branches is Dictionary:
		for arc_id in arc_branches:
			if not state.is_arc_active(str(arc_id)):
				return false
			if state.get_arc_branch(str(arc_id)) != str(arc_branches[arc_id]):
				return false

	if requirements.has("active_crisis"):
		var required_id: String = str(requirements["active_crisis"])
		if str(state.active_crisis.get("status", "")) != "active":
			return false
		if str(state.active_crisis.get("crisis_id", "")) != required_id:
			return false

	if requirements.has("blocked_crisis"):
		var blocked_id: String = str(requirements["blocked_crisis"])
		if str(state.active_crisis.get("status", "")) == "active":
			if str(state.active_crisis.get("crisis_id", "")) == blocked_id:
				return false

	if bool(requirements.get("completed_crisis", false)):
		if state.active_crisis.is_empty():
			return false
		if str(state.active_crisis.get("status", "")) != "resolved":
			return false

	if requirements.has("failed_crisis"):
		var failed_id: String = str(requirements["failed_crisis"])
		if state.active_crisis.is_empty():
			return false
		if str(state.active_crisis.get("crisis_id", "")) != failed_id:
			return false
		if str(state.active_crisis.get("status", "")) != "failed":
			return false

	var minimum_advisor_affinity: Dictionary = requirements.get("minimum_advisor_affinity", {})
	for advisor_id in minimum_advisor_affinity:
		if state.get_advisor_affinity(str(advisor_id)) < int(minimum_advisor_affinity[advisor_id]):
			return false

	var maximum_advisor_affinity: Dictionary = requirements.get("maximum_advisor_affinity", {})
	for advisor_id in maximum_advisor_affinity:
		if state.get_advisor_affinity(str(advisor_id)) > int(maximum_advisor_affinity[advisor_id]):
			return false

	return true
