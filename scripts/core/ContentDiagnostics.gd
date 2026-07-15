class_name ContentDiagnostics
extends RefCounted

## Development-only static content graph and balance analysis.
## Spec: docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md §25–§26.

const ADVISOR_CONCENTRATION_THRESHOLD: float = 0.15
const TAG_CONCENTRATION_THRESHOLD: float = 0.20
const JOKE_TAG_PREFIX: String = "joke_"

const CATEGORIES: Array[String] = [
	"unreachable_decisions",
	"decisions_never_selected",
	"arcs_no_valid_entry",
	"arcs_no_reachable_resolution",
	"branches_no_continuation",
	"endings_impossible",
	"endings_never_reached",
	"invalid_references",
	"forced_follow_up_cycles",
	"narrative_event_cycles",
	"self_blocking_requirements",
	"content_exhaustion_risk",
	"excessive_fallback_use",
	"dominant_choice_options",
	"cards_no_meaningful_effects",
	"empty_recovery_pool",
	"empty_endgame_resolution_pool",
	"excessive_advisor_concentration",
	"excessive_tag_concentration",
	"excessive_joke_concentration",
	"validator_errors",
	"validator_warnings",
]


static func empty_report() -> Dictionary:
	var report: Dictionary = {"findings": {}, "summary": {}}
	for category in CATEGORIES:
		report["findings"][category] = []
	report["summary"]["total_findings"] = 0
	return report


func analyze(content: ContentRepository, country_id: String = "ministan") -> Dictionary:
	var report := empty_report()
	if content == null:
		return report

	var validator := ContentValidator.new()
	var validation := validator.validate_repository(content)
	for error in validation.errors:
		_add_finding(report, "validator_errors", "", "error", error, {})
	for warning in validation.warnings:
		_add_finding(report, "validator_warnings", "", "warning", warning, {})

	if not content.has_country(country_id):
		_add_finding(report, "invalid_references", country_id, "error", "Unknown country '%s'" % country_id, {})
		_finalize_summary(report)
		return report

	var decisions: Array[Dictionary] = content.get_all_decisions_for_country(country_id)
	var decision_map: Dictionary = {}
	for decision in decisions:
		decision_map[str(decision.get("id", ""))] = decision

	_analyze_unreachable(report, content, country_id, decisions, decision_map)
	_analyze_arcs(report, content, country_id, decision_map)
	_analyze_branches(report, content, country_id, decision_map)
	_analyze_endings_impossible(report, content, country_id)
	_analyze_cycles(report, content, country_id, decision_map)
	_analyze_self_blocking(report, decisions, decision_map)
	_analyze_balance(report, content, country_id, decisions)
	_analyze_concentration(report, decisions)

	_finalize_summary(report)
	return report


static func format_report_text(data: Dictionary) -> String:
	var lines: PackedStringArray = ["Static diagnostics:"]
	var findings: Dictionary = data.get("findings", {})
	for category in CATEGORIES:
		var items: Array = findings.get(category, [])
		if items.is_empty():
			continue
		lines.append("")
		lines.append("%s (%d):" % [category.replace("_", " "), items.size()])
		for item in items:
			if item is Dictionary:
				lines.append("  [%s] %s" % [item.get("severity", "info"), item.get("message", "")])
	return "\n".join(lines)


func _add_finding(
	report: Dictionary,
	category: String,
	item_id: String,
	severity: String,
	message: String,
	details: Dictionary,
) -> void:
	if not report["findings"].has(category):
		report["findings"][category] = []
	report["findings"][category].append({
		"id": item_id,
		"severity": severity,
		"message": message,
		"details": details.duplicate(true),
	})


func _finalize_summary(report: Dictionary) -> void:
	var total: int = 0
	for category in report["findings"]:
		total += report["findings"][category].size()
	report["summary"]["total_findings"] = total


func _analyze_unreachable(
	report: Dictionary,
	content: ContentRepository,
	country_id: String,
	decisions: Array[Dictionary],
	decision_map: Dictionary,
) -> void:
	var entry_ids: Array[String] = _day_one_entry_decisions(decisions)
	var reachable: Dictionary = {}
	var queue: Array[String] = entry_ids.duplicate()
	for entry_id in entry_ids:
		reachable[entry_id] = true

	while not queue.is_empty():
		var current_id: String = queue.pop_front()
		if not decision_map.has(current_id):
			continue
		for target_id in _graph_neighbors(decision_map[current_id], content, decision_map):
			if reachable.has(target_id):
				continue
			reachable[target_id] = true
			queue.append(target_id)

	for crisis in content.get_crises_for_country(country_id):
		var entry_id: String = str(crisis.get("entry_decision_id", ""))
		if not entry_id.is_empty() and not reachable.has(entry_id):
			reachable[entry_id] = true

	for decision in decisions:
		var id: String = str(decision.get("id", ""))
		if id.is_empty() or bool(decision.get("fallback", false)):
			continue
		if bool(decision.get("queue_only", false)):
			continue
		if reachable.has(id):
			continue
		_add_finding(
			report, "unreachable_decisions", id, "warning",
			"Decision '%s' has no optimistic graph path from day-1 entry cards." % id,
			{"requirements": decision.get("requirements", {})},
		)


func _day_one_entry_decisions(decisions: Array[Dictionary]) -> Array[String]:
	var entries: Array[String] = []
	for decision in decisions:
		var id: String = str(decision.get("id", ""))
		if id.is_empty():
			continue
		if bool(decision.get("fallback", false)) or bool(decision.get("queue_only", false)):
			continue
		if bool(decision.get("debug_only", false)):
			continue
		if int(decision.get("minimum_day", 1)) > 1:
			continue
		var requirements: Dictionary = decision.get("requirements", {})
		if not requirements.is_empty() and not _requirements_are_broadly_startable(requirements):
			continue
		entries.append(id)
	return entries


func _requirements_are_broadly_startable(requirements: Dictionary) -> bool:
	for key in ["all_flags", "any_flags", "all_laws", "any_laws", "used_decisions",
			"active_arcs", "completed_arcs", "failed_arcs", "arc_branches",
			"minimum_advisor_affinity", "minimum_counters"]:
		if requirements.has(key) and not requirements[key].is_empty():
			return false
	var minimum_resources: Dictionary = requirements.get("minimum_resources", {})
	for resource_id in minimum_resources:
		if int(minimum_resources[resource_id]) > RunState.DEFAULT_RESOURCE_VALUE:
			return false
	return true


func _graph_neighbors(
	decision: Dictionary,
	content: ContentRepository,
	decision_map: Dictionary,
) -> Array[String]:
	var neighbors: Array[String] = []
	for option in DecisionSchema.get_options(decision):
		if not (option is Dictionary):
			continue
		var forced_id: String = str(option.get("force_next_decision", ""))
		if not forced_id.is_empty():
			neighbors.append(forced_id)
		var follow_up: Variant = option.get("follow_up", {})
		if follow_up is Dictionary:
			var follow_type: String = str(follow_up.get("type", ""))
			if follow_type == "hard":
				var hard_id: String = str(follow_up.get("decision_id", ""))
				if not hard_id.is_empty():
					neighbors.append(hard_id)
			elif follow_type in ["soft", "pool"]:
				var soft_id: String = str(follow_up.get("decision_id", ""))
				if not soft_id.is_empty():
					neighbors.append(soft_id)
				var pool_id: String = str(follow_up.get("pool_id", ""))
				if not pool_id.is_empty() and content.has_follow_up_pool(pool_id):
					var pool: Dictionary = content.get_follow_up_pool(pool_id)
					for pool_decision_id in pool.get("decision_ids", []):
						var id: String = str(pool_decision_id)
						if not id.is_empty():
							neighbors.append(id)
	return neighbors


func _analyze_arcs(
	report: Dictionary,
	content: ContentRepository,
	country_id: String,
	decision_map: Dictionary,
) -> void:
	for arc in content.get_arcs_for_country(country_id):
		var arc_id: String = str(arc.get("id", ""))
		var entry_ids: Array = arc.get("entry_decision_ids", [])
		if entry_ids.is_empty():
			_add_finding(report, "arcs_no_valid_entry", arc_id, "error",
				"Arc '%s' has no entry_decision_ids." % arc_id, {})
			continue

		var valid_entry := false
		for entry_id in entry_ids:
			var entry: String = str(entry_id)
			if decision_map.has(entry):
				valid_entry = true
				break
		if not valid_entry:
			_add_finding(report, "arcs_no_valid_entry", arc_id, "error",
				"Arc '%s' entry decisions are missing from content." % arc_id, {"entry_decision_ids": entry_ids})

		var resolution_ids: Array = arc.get("resolution_decision_ids", [])
		if resolution_ids.is_empty():
			_add_finding(report, "arcs_no_reachable_resolution", arc_id, "error",
				"Arc '%s' has no resolution_decision_ids." % arc_id, {})
			continue

		var reachable_from_entry: Dictionary = {}
		var queue: Array[String] = []
		for entry_id in entry_ids:
			var entry: String = str(entry_id)
			if decision_map.has(entry):
				queue.append(entry)
				reachable_from_entry[entry] = true

		while not queue.is_empty():
			var current_id: String = queue.pop_front()
			if not decision_map.has(current_id):
				continue
			for target_id in _graph_neighbors(decision_map[current_id], content, decision_map):
				if reachable_from_entry.has(target_id):
					continue
				reachable_from_entry[target_id] = true
				queue.append(target_id)

		var has_resolution := false
		for resolution_id in resolution_ids:
			if reachable_from_entry.has(str(resolution_id)):
				has_resolution = true
				break
		if not has_resolution:
			_add_finding(report, "arcs_no_reachable_resolution", arc_id, "warning",
				"Arc '%s' has no graph path from entry to any resolution card." % arc_id,
				{"resolution_decision_ids": resolution_ids})


func _analyze_branches(
	report: Dictionary,
	content: ContentRepository,
	country_id: String,
	decision_map: Dictionary,
) -> void:
	for arc in content.get_arcs_for_country(country_id):
		var arc_id: String = str(arc.get("id", ""))
		for branch_id in arc.get("branch_ids", []):
			var branch: String = str(branch_id)
			var used := false
			for decision_id in decision_map:
				var decision: Dictionary = decision_map[decision_id]
				var requirements: Dictionary = decision.get("requirements", {})
				var arc_branches: Variant = requirements.get("arc_branches", {})
				if arc_branches is Dictionary and str(arc_branches.get(arc_id, "")) == branch:
					used = true
					break
				for option in DecisionSchema.get_options(decision):
					if not (option is Dictionary):
						continue
					for action in option.get("arc_actions", []):
						if action is Dictionary \
								and str(action.get("arc_id", "")) == arc_id \
								and str(action.get("branch_id", "")) == branch:
							used = true
							break
			if not used:
				_add_finding(report, "branches_no_continuation", "%s:%s" % [arc_id, branch], "warning",
					"Arc '%s' branch '%s' is never referenced by a decision or option." % [arc_id, branch], {})


func _analyze_endings_impossible(
	report: Dictionary,
	content: ContentRepository,
	country_id: String,
) -> void:
	var country: Dictionary = content.get_country(country_id)
	var starting: Dictionary = country.get("starting_resources", {})
	var start_state := RunState.new()
	start_state.country_id = country_id
	start_state.day = 1
	for resource_id in RunState.RESOURCE_IDS:
		start_state.set_resource(resource_id, int(starting.get(resource_id, RunState.DEFAULT_RESOURCE_VALUE)))

	for ending in content.get_raw_endings():
		var ending_id: String = str(ending.get("id", ""))
		var conditions: Dictionary = ending.get("conditions", {})
		if conditions.is_empty():
			continue
		if not _ending_can_ever_match(conditions, starting):
			_add_finding(report, "endings_impossible", ending_id, "warning",
				"Ending '%s' conditions contradict starting state on day 1." % ending_id,
				{"conditions": conditions})


func _ending_can_ever_match(conditions: Dictionary, starting: Dictionary) -> bool:
	var minimum_resources: Dictionary = conditions.get("minimum_resources", {})
	for resource_id in minimum_resources:
		if int(starting.get(resource_id, 0)) < int(minimum_resources[resource_id]):
			return false
	var maximum_resources: Dictionary = conditions.get("maximum_resources", {})
	for resource_id in maximum_resources:
		if int(starting.get(resource_id, 100)) > int(maximum_resources[resource_id]):
			return false
	if conditions.has("minimum_day") and int(conditions["minimum_day"]) > 1:
		pass
	return true


func _analyze_cycles(
	report: Dictionary,
	content: ContentRepository,
	country_id: String,
	decision_map: Dictionary,
) -> void:
	var forced_edges: Dictionary = {}
	var narrative_edges: Dictionary = {}
	for decision_id in decision_map:
		var decision: Dictionary = decision_map[decision_id]
		for option in DecisionSchema.get_options(decision):
			if not (option is Dictionary):
				continue
			var forced_id: String = str(option.get("force_next_decision", ""))
			if not forced_id.is_empty():
				_add_edge(forced_edges, decision_id, forced_id)
			var follow_up: Variant = option.get("follow_up", {})
			if not (follow_up is Dictionary):
				continue
			var follow_type: String = str(follow_up.get("type", ""))
			if follow_type == "hard":
				var hard_id: String = str(follow_up.get("decision_id", ""))
				if not hard_id.is_empty():
					_add_edge(forced_edges, decision_id, hard_id)
			elif follow_type in ["soft", "pool"]:
				for target_id in _graph_neighbors(decision, content, decision_map):
					_add_edge(narrative_edges, decision_id, target_id)

	for cycle in _find_cycles(forced_edges):
		_add_finding(report, "forced_follow_up_cycles", cycle[0], "error",
			"Forced follow-up cycle detected: %s" % " -> ".join(cycle), {"cycle": cycle})

	for cycle in _find_cycles(narrative_edges):
		_add_finding(report, "narrative_event_cycles", cycle[0], "warning",
			"Narrative follow-up cycle detected: %s" % " -> ".join(cycle), {"cycle": cycle})


func _add_edge(edges: Dictionary, from_id: String, to_id: String) -> void:
	if not edges.has(from_id):
		edges[from_id] = []
	if to_id not in edges[from_id]:
		edges[from_id].append(to_id)


func _find_cycles(edges: Dictionary) -> Array:
	var cycles: Array = []
	var visited: Dictionary = {}
	var stack: Dictionary = {}
	for node_id in edges:
		_dfs_cycles(node_id, edges, visited, stack, [], cycles)
	return cycles


func _dfs_cycles(
	node_id: String,
	edges: Dictionary,
	visited: Dictionary,
	stack: Dictionary,
	path: Array,
	cycles: Array,
) -> void:
	if stack.has(node_id):
		var cycle_start := path.find(node_id)
		if cycle_start >= 0:
			var cycle: Array = path.slice(cycle_start)
			cycle.append(node_id)
			cycles.append(cycle)
		return
	if visited.has(node_id):
		return
	visited[node_id] = true
	stack[node_id] = true
	path.append(node_id)
	for neighbor in edges.get(node_id, []):
		_dfs_cycles(str(neighbor), edges, visited, stack, path, cycles)
	path.pop_back()
	stack.erase(node_id)


func _analyze_self_blocking(
	report: Dictionary,
	decisions: Array[Dictionary],
	decision_map: Dictionary,
) -> void:
	for decision in decisions:
		var id: String = str(decision.get("id", ""))
		var requirements: Dictionary = decision.get("requirements", {})
		if requirements.is_empty():
			continue
		for flag_id in requirements.get("all_flags", []):
			if _only_set_by_decision(str(flag_id), id, decision_map):
				_add_finding(report, "self_blocking_requirements", id, "warning",
					"Decision '%s' requires flag '%s' that only it can set." % [id, flag_id], {})
		for law_id in requirements.get("all_laws", []):
			if _only_set_by_decision_law(str(law_id), id, decision_map):
				_add_finding(report, "self_blocking_requirements", id, "warning",
					"Decision '%s' requires law '%s' that only it can add." % [id, law_id], {})


func _only_set_by_decision(flag_id: String, decision_id: String, decision_map: Dictionary) -> bool:
	var found_elsewhere := false
	for other_id in decision_map:
		var decision: Dictionary = decision_map[other_id]
		for option in DecisionSchema.get_options(decision):
			if flag_id in option.get("add_flags", []):
				if str(other_id) != decision_id:
					return false
				found_elsewhere = true
	return found_elsewhere


func _only_set_by_decision_law(law_id: String, decision_id: String, decision_map: Dictionary) -> bool:
	var found_elsewhere := false
	for other_id in decision_map:
		var decision: Dictionary = decision_map[other_id]
		for option in DecisionSchema.get_options(decision):
			if law_id in option.get("add_laws", []):
				if str(other_id) != decision_id:
					return false
				found_elsewhere = true
	return found_elsewhere


func _analyze_balance(
	report: Dictionary,
	content: ContentRepository,
	country_id: String,
	decisions: Array[Dictionary],
) -> void:
	var recovery_count: int = 0
	var endgame_count: int = 0
	var playable_count: int = 0

	for decision in decisions:
		var id: String = str(decision.get("id", ""))
		if bool(decision.get("fallback", false)) or bool(decision.get("queue_only", false)):
			continue
		playable_count += 1
		var card_type: String = str(decision.get("card_type", "normal"))
		if card_type == "recovery":
			recovery_count += 1
		if card_type in ["resolution", "ending_setup"]:
			var pacing: Variant = decision.get("pacing", {})
			if pacing is Dictionary:
				var allowed: Array = pacing.get("allowed_stages", [])
				if allowed.is_empty() or "endgame" in allowed:
					endgame_count += 1

		for option in DecisionSchema.get_options(decision):
			if _option_has_no_meaningful_effects(option):
				_add_finding(report, "cards_no_meaningful_effects", "%s:%s" % [id, option.get("id", "")],
					"info", "Decision '%s' option '%s' has no meaningful effects." % [id, option.get("id", "")], {})

		var dominant_id: String = _find_dominant_option(decision)
		if not dominant_id.is_empty():
			_add_finding(report, "dominant_choice_options", id, "warning",
				"Decision '%s' option '%s' dominates all alternatives on visible resources." % [id, dominant_id], {})

	var country: Dictionary = content.get_country(country_id)
	var max_day: int = int(country.get("max_day", 0))
	if recovery_count == 0:
		_add_finding(report, "empty_recovery_pool", country_id, "warning",
			"No recovery cards found for country '%s'." % country_id, {})
	if endgame_count == 0:
		_add_finding(report, "empty_endgame_resolution_pool", country_id, "warning",
			"No endgame resolution cards found for country '%s'." % country_id, {})
	if playable_count > 0 and playable_count < max_day / 2:
		_add_finding(report, "content_exhaustion_risk", country_id, "warning",
			"Only %d playable cards for %d max days; content exhaustion risk is high." % [playable_count, max_day],
			{"playable_count": playable_count, "max_day": max_day})


func _option_has_no_meaningful_effects(option: Dictionary) -> bool:
	if not option.get("effects", {}).is_empty():
		return false
	if not option.get("add_laws", []).is_empty() or not option.get("remove_laws", []).is_empty():
		return false
	if not option.get("add_flags", []).is_empty() or not option.get("remove_flags", []).is_empty():
		return false
	if not option.get("counter_changes", {}).is_empty():
		return false
	if not str(option.get("force_next_decision", "")).is_empty():
		return false
	if not str(option.get("trigger_ending", "")).is_empty():
		return false
	if not option.get("follow_up", {}).is_empty():
		return false
	if not option.get("arc_actions", []).is_empty():
		return false
	if not option.get("crisis_actions", []).is_empty():
		return false
	if not option.get("advisor_affinity_changes", {}).is_empty():
		return false
	if not option.get("trait_changes", {}).is_empty():
		return false
	return true


func _find_dominant_option(decision: Dictionary) -> String:
	var options: Array = DecisionSchema.get_options(decision)
	if options.size() < 2:
		return ""
	for i in range(options.size()):
		var candidate: Dictionary = options[i]
		var candidate_id: String = str(candidate.get("id", ""))
		var candidate_effects: Dictionary = candidate.get("effects", {})
		if candidate_effects.is_empty():
			continue
		var dominates_all := true
		for j in range(options.size()):
			if i == j:
				continue
			var other: Dictionary = options[j]
			var other_effects: Dictionary = other.get("effects", {})
			for resource_id in RunState.RESOURCE_IDS:
				var candidate_value: int = int(candidate_effects.get(resource_id, 0))
				var other_value: int = int(other_effects.get(resource_id, 0))
				if candidate_value < other_value:
					dominates_all = false
					break
			if not dominates_all:
				break
			var strictly_better := false
			for resource_id in RunState.RESOURCE_IDS:
				if int(candidate_effects.get(resource_id, 0)) > int(other_effects.get(resource_id, 0)):
					strictly_better = true
					break
			if not strictly_better:
				dominates_all = false
				break
		if dominates_all:
			return candidate_id
	return ""


func _analyze_concentration(report: Dictionary, decisions: Array[Dictionary]) -> void:
	if decisions.is_empty():
		return
	var total: int = decisions.size()
	var advisor_counts: Dictionary = {}
	var tag_counts: Dictionary = {}
	var joke_counts: Dictionary = {}

	for decision in decisions:
		var advisor_id: String = str(decision.get("advisor_id", ""))
		if not advisor_id.is_empty():
			advisor_counts[advisor_id] = int(advisor_counts.get(advisor_id, 0)) + 1
		for tag in decision.get("tags", []):
			var tag_id: String = str(tag)
			tag_counts[tag_id] = int(tag_counts.get(tag_id, 0)) + 1
			if tag_id.begins_with(JOKE_TAG_PREFIX):
				joke_counts[tag_id] = int(joke_counts.get(tag_id, 0)) + 1

	for advisor_id in advisor_counts:
		var ratio: float = float(advisor_counts[advisor_id]) / float(total)
		if ratio > ADVISOR_CONCENTRATION_THRESHOLD:
			_add_finding(report, "excessive_advisor_concentration", advisor_id, "info",
				"Advisor '%s' appears on %.0f%% of cards." % [advisor_id, ratio * 100.0],
				{"count": advisor_counts[advisor_id], "ratio": ratio})

	for tag_id in tag_counts:
		var ratio: float = float(tag_counts[tag_id]) / float(total)
		if ratio > TAG_CONCENTRATION_THRESHOLD:
			_add_finding(report, "excessive_tag_concentration", tag_id, "info",
				"Tag '%s' appears on %.0f%% of cards." % [tag_id, ratio * 100.0],
				{"count": tag_counts[tag_id], "ratio": ratio})

	for joke_tag in joke_counts:
		var ratio: float = float(joke_counts[joke_tag]) / float(total)
		if ratio > TAG_CONCENTRATION_THRESHOLD:
			_add_finding(report, "excessive_joke_concentration", joke_tag, "info",
				"Joke tag '%s' appears on %.0f%% of cards." % [joke_tag, ratio * 100.0],
				{"count": joke_counts[joke_tag], "ratio": ratio})
