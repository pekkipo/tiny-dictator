class_name DecisionEngine
extends RefCounted

var _decisions: Array[Dictionary] = []

func load_decisions(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("DecisionEngine: failed to open %s" % path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Dictionary:
		_decisions = parsed.get("decisions", [])

func get_valid_decisions(state: RunState) -> Array[Dictionary]:
	var valid: Array[Dictionary] = []
	for decision in _decisions:
		if _is_valid(decision, state):
			valid.append(decision)
	return valid

func get_decision_by_id(decision_id: String) -> Dictionary:
	for decision in _decisions:
		if decision.get("id", "") == decision_id:
			return decision
	return {}

func _is_valid(decision: Dictionary, state: RunState) -> bool:
	var id: String = decision.get("id", "")
	if id in state.seen_decisions:
		return false
	if decision.get("scenario_id", "") != state.scenario_id:
		return false
	for flag in decision.get("requires_flags", []):
		if not state.has_flag(flag):
			return false
	for law in decision.get("requires_laws", []):
		if law not in state.active_laws:
			return false
	return true
