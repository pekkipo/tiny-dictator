class_name ContentValidator
extends RefCounted

## Validates loaded content before play.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §6,
## checks: docs/03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md §18, §21.

class ValidationReport:
	var errors: Array[String] = []
	var warnings: Array[String] = []

	var is_valid: bool:
		get:
			return errors.is_empty()

	func print_summary() -> void:
		print("[CONTENT] Validation complete: %d error(s), %d warning(s)" % [errors.size(), warnings.size()])
		for error in errors:
			push_error("[CONTENT] ERROR: %s" % error)
		for warning in warnings:
			push_warning("[CONTENT] WARNING: %s" % warning)


const KNOWN_REQUIREMENT_KEYS: Array[String] = [
	"all_flags", "any_flags", "blocked_flags",
	"all_laws", "any_laws", "blocked_laws",
	"minimum_resources", "maximum_resources",
	"minimum_counters", "maximum_counters",
	"minimum_day", "maximum_day",
	"used_decisions", "not_used_decisions",
	"active_arcs", "blocked_arcs", "completed_arcs", "failed_arcs", "arc_branches",
	"active_crisis", "blocked_crisis", "completed_crisis", "failed_crisis",
	"minimum_advisor_affinity", "maximum_advisor_affinity",
	"minimum_traits", "maximum_traits",
]

const KNOWN_ENDING_CONDITION_KEYS: Array[String] = [
	"all_flags", "any_flags", "blocked_flags",
	"all_laws", "any_laws",
	"minimum_resources", "maximum_resources",
	"minimum_counters", "maximum_counters",
	"minimum_day", "maximum_day",
]

const KNOWN_PACING_KEYS: Array[String] = [
	"allowed_stages",
]

const PROPOSAL_MAX_LENGTH: int = 220
const CHOICE_LABEL_MAX_LENGTH: int = 32
const RESULT_TEXT_MAX_LENGTH: int = 180
const VALID_ARC_ACTIONS: Array[String] = [
	"start", "advance", "branch", "pause", "complete", "fail", "abandon",
]
const VALID_ARC_IMPORTANCE: Array[String] = ["major", "minor"]
const VALID_CRISIS_ACTIONS: Array[String] = ["start", "resolve", "fail"]
const KNOWN_META_REQUIREMENT_KEYS: Array[String] = [
	"minimum_endings_unlocked",
	"minimum_medals",
	"required_ending_ids",
	"minimum_total_runs",
]


func validate_repository(repository: ContentRepository) -> ValidationReport:
	var report := ValidationReport.new()

	for error in repository.get_load_errors():
		report.errors.append(error)

	for advisor in repository.get_raw_advisors():
		for error in validate_advisor(advisor):
			report.errors.append(error)

	for law in repository.get_raw_laws():
		for error in validate_law(law):
			report.errors.append(error)

	for ending in repository.get_raw_endings():
		for error in validate_ending(ending):
			report.errors.append(error)

	for country in repository.get_raw_countries():
		for error in _validate_country(country, repository):
			report.errors.append(error)
		for warning in _country_warnings(country):
			report.warnings.append(warning)

	for decision in repository.get_raw_decisions():
		for error in validate_decision(decision, repository):
			report.errors.append(error)
		for warning in _decision_warnings(decision, repository):
			report.warnings.append(warning)

	for arc in repository.get_raw_arcs():
		for error in validate_arc(arc, repository):
			report.errors.append(error)

	for crisis in repository.get_raw_crises():
		for error in validate_crisis(crisis, repository):
			report.errors.append(error)

	for pool in repository.get_raw_follow_up_pools():
		for error in validate_follow_up_pool(pool, repository):
			report.errors.append(error)

	for identity in repository.get_raw_ruler_identities():
		for error in validate_ruler_identity(identity):
			report.errors.append(error)

	for error in validate_meta_rewards(repository.get_meta_rewards()):
		report.errors.append(error)

	for upgrade in repository.get_raw_palace_upgrades():
		for error in validate_palace_upgrade(upgrade, repository):
			report.errors.append(error)

	# Unmapped visual tags render nothing in the diorama; warn, don't fail.
	var visual_map: Dictionary = repository.get_visual_map()
	for law in repository.get_raw_laws():
		for tag in law.get("visual_tags", []):
			if not visual_map.has(str(tag)):
				report.warnings.append("Law '%s' visual tag '%s' has no entry in country_visual_map.json" % [
					str(law.get("id", "")), str(tag),
				])

	return report


func validate_ruler_identity(identity: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(identity.get("id", ""))
	if id.is_empty():
		errors.append("Ruler identity missing 'id'")
		return errors
	if str(identity.get("display_name", "")).is_empty():
		errors.append("Ruler identity '%s' missing 'display_name'" % id)

	var conditions: Variant = identity.get("conditions", {})
	if not (conditions is Dictionary):
		errors.append("Ruler identity '%s' conditions must be an object" % id)
		return errors

	for key in ["minimum_traits", "maximum_traits"]:
		var traits: Variant = conditions.get(key, {})
		if traits is Dictionary:
			for trait_id in traits:
				if str(trait_id) not in RulerTraitManager.VALID_TRAIT_IDS:
					errors.append("Ruler identity '%s' %s references unknown trait '%s'" % [id, key, trait_id])

	var dominant: String = str(conditions.get("dominant_trait", ""))
	if not dominant.is_empty() and dominant not in RulerTraitManager.VALID_TRAIT_IDS:
		errors.append("Ruler identity '%s' dominant_trait '%s' is invalid" % [id, dominant])

	return errors


func validate_advisor(advisor: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(advisor.get("id", ""))
	if id.is_empty():
		errors.append("Advisor missing 'id'")
		return errors
	if str(advisor.get("display_name", "")).is_empty():
		errors.append("Advisor '%s' missing 'display_name'" % id)
	if str(advisor.get("role", "")).is_empty():
		errors.append("Advisor '%s' missing 'role'" % id)
	return errors


func validate_law(law: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(law.get("id", ""))
	if id.is_empty():
		errors.append("Law missing 'id'")
		return errors
	if str(law.get("display_name", "")).is_empty():
		errors.append("Law '%s' missing 'display_name'" % id)
	return errors


func validate_ending(ending: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(ending.get("id", ""))
	if id.is_empty():
		errors.append("Ending missing 'id'")
		return errors
	if str(ending.get("type", "")).is_empty():
		errors.append("Ending '%s' missing 'type'" % id)
	if not (ending.get("priority") is float or ending.get("priority") is int):
		errors.append("Ending '%s' has non-numeric 'priority'" % id)
	if str(ending.get("title", "")).is_empty():
		errors.append("Ending '%s' missing 'title'" % id)
	if str(ending.get("description", "")).is_empty():
		errors.append("Ending '%s' missing 'description'" % id)
	var conditions: Variant = ending.get("conditions", {})
	if conditions is Dictionary:
		for key in conditions:
			if str(key) not in KNOWN_ENDING_CONDITION_KEYS:
				errors.append("Ending '%s' has unknown condition '%s'" % [id, key])
	else:
		errors.append("Ending '%s' has non-object 'conditions'" % id)
	return errors


func validate_decision(decision: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(decision.get("id", ""))
	if id.is_empty():
		errors.append("Decision missing 'id'")
		return errors

	var advisor_id: String = str(decision.get("advisor_id", ""))
	if advisor_id.is_empty():
		errors.append("Decision '%s' missing 'advisor_id'" % id)
	elif not repository.has_advisor(advisor_id):
		errors.append("Decision '%s' references unknown advisor '%s'" % [id, advisor_id])

	if str(decision.get("proposal", "")).is_empty():
		errors.append("Decision '%s' missing 'proposal'" % id)

	# Schema v2 (PRD 2A §12): normalize first so all checks below run against
	# the options model, covering authored "options" and legacy left/right,
	# and so v2 "base_weight" is mapped onto "weight".
	DecisionSchema.normalize(decision)

	var weight: Variant = decision.get("weight", 10)
	if not (weight is float or weight is int) or int(weight) <= 0:
		errors.append("Decision '%s' has invalid 'weight' (must be positive integer)" % id)

	var minimum_day: int = int(decision.get("minimum_day", 1))
	var maximum_day: int = int(decision.get("maximum_day", 9999))
	if minimum_day > maximum_day:
		errors.append("Decision '%s' has minimum_day > maximum_day" % id)

	var schema_version: int = int(decision.get("schema_version", DecisionSchema.LEGACY_VERSION))
	if schema_version < DecisionSchema.LEGACY_VERSION or schema_version > DecisionSchema.CURRENT_VERSION:
		errors.append("Decision '%s' has unsupported schema_version %d" % [id, schema_version])

	var card_type: String = str(decision.get("card_type", DecisionSchema.DEFAULT_CARD_TYPE))
	if card_type not in DecisionSchema.CARD_TYPES:
		errors.append("Decision '%s' has unknown card_type '%s'" % [id, card_type])

	var options: Array = decision.get("options", [])
	if options.size() < DecisionSchema.MIN_OPTIONS:
		errors.append("Decision '%s' has %d option(s); minimum is %d" % [id, options.size(), DecisionSchema.MIN_OPTIONS])
	if options.size() > DecisionSchema.MAX_OPTIONS:
		errors.append("Decision '%s' has %d options; maximum is %d" % [id, options.size(), DecisionSchema.MAX_OPTIONS])
	var seen_option_ids: Dictionary = {}
	for option in options:
		if not (option is Dictionary):
			errors.append("Decision '%s' has a non-object option" % id)
			continue
		var option_id: String = str(option.get("id", ""))
		if option_id.is_empty():
			errors.append("Decision '%s' has an option without 'id'" % id)
		elif seen_option_ids.has(option_id):
			errors.append("Decision '%s' has duplicate option id '%s'" % [id, option_id])
		seen_option_ids[option_id] = true
		errors.append_array(_validate_option(id, option_id, option, repository))

	var requirements: Variant = decision.get("requirements", {})
	if requirements is Dictionary:
		errors.append_array(_validate_requirements(id, requirements, repository))
	else:
		errors.append("Decision '%s' has non-object 'requirements'" % id)

	if decision.has("pacing"):
		var pacing: Variant = decision.get("pacing")
		if not (pacing is Dictionary):
			errors.append("Decision '%s' has non-object 'pacing'" % id)
		elif pacing.has("allowed_stages"):
			var allowed_stages: Variant = pacing.get("allowed_stages")
			if not (allowed_stages is Array):
				errors.append("Decision '%s' pacing.allowed_stages must be an array" % id)
			else:
				for stage_ref in allowed_stages:
					if not (stage_ref is String):
						errors.append("Decision '%s' pacing.allowed_stages must contain only strings" % id)
						break

	errors.append_array(_validate_decision_narrative(id, decision, repository))
	errors.append_array(_validate_decision_narrative_crisis(id, decision, repository))

	return errors


func validate_arc(arc: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(arc.get("id", ""))
	if id.is_empty():
		errors.append("Arc missing 'id'")
		return errors

	var country_id: String = str(arc.get("country_id", ""))
	if country_id.is_empty():
		errors.append("Arc '%s' missing 'country_id'" % id)
	elif not repository.has_country(country_id):
		errors.append("Arc '%s' references unknown country '%s'" % [id, country_id])

	for entry_id in arc.get("entry_decision_ids", []):
		var decision_id := str(entry_id)
		if not repository.has_decision(decision_id):
			errors.append("Arc '%s' entry decision '%s' not found" % [id, decision_id])

	for resolution_id in arc.get("resolution_decision_ids", []):
		var decision_id := str(resolution_id)
		if not repository.has_decision(decision_id):
			errors.append("Arc '%s' resolution decision '%s' not found" % [id, decision_id])

	for group in arc.get("exclusive_groups", []):
		if str(group).is_empty():
			errors.append("Arc '%s' has empty exclusive_groups entry" % id)

	var branch_ids: Array = arc.get("branch_ids", [])
	for branch_id in branch_ids:
		if str(branch_id).is_empty():
			errors.append("Arc '%s' has empty branch_ids entry" % id)

	if country_id and repository.has_country(country_id):
		var country: Dictionary = repository.get_country(country_id)
		var stage_ids: Array[String] = []
		for stage in country.get("run_stages", []):
			if stage is Dictionary:
				stage_ids.append(str(stage.get("id", "")))
		for stage_key in ["minimum_start_stage", "maximum_start_stage"]:
			var stage_id: String = str(arc.get(stage_key, ""))
			if not stage_id.is_empty() and stage_id not in stage_ids:
				errors.append("Arc '%s' %s '%s' not in country run_stages" % [id, stage_key, stage_id])

	var importance: String = str(arc.get("importance", "major"))
	if importance not in VALID_ARC_IMPORTANCE:
		errors.append("Arc '%s' importance '%s' must be major or minor" % [id, importance])

	return errors


func validate_meta_rewards(config: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if config.is_empty():
		errors.append("Meta rewards config is missing or empty")
		return errors
	for key in ["days_survived_divisor", "new_ending_bonus", "completed_major_arc_bonus", "completed_minor_arc_bonus"]:
		if not config.has(key):
			errors.append("Meta rewards missing '%s'" % key)
		elif int(config.get(key, -1)) < 0:
			errors.append("Meta rewards '%s' must be non-negative" % key)
	if int(config.get("days_survived_divisor", 1)) < 1:
		errors.append("Meta rewards days_survived_divisor must be at least 1")
	return errors


func validate_palace_upgrade(upgrade: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(upgrade.get("id", ""))
	if id.is_empty():
		errors.append("Palace upgrade missing 'id'")
		return errors
	if str(upgrade.get("display_name", "")).is_empty():
		errors.append("Palace upgrade '%s' missing 'display_name'" % id)
	if int(upgrade.get("medal_cost", -1)) < 0:
		errors.append("Palace upgrade '%s' medal_cost must be non-negative" % id)

	var requirements: Variant = upgrade.get("requirements", {})
	if not requirements is Dictionary:
		errors.append("Palace upgrade '%s' requirements must be an object" % id)
		return errors
	for key in requirements:
		if str(key) not in KNOWN_META_REQUIREMENT_KEYS:
			errors.append("Palace upgrade '%s' has unknown requirement key '%s'" % [id, key])
	var required_endings: Variant = requirements.get("required_ending_ids", [])
	if required_endings is Array:
		for ending_id in required_endings:
			if not repository.has_ending(str(ending_id)):
				errors.append("Palace upgrade '%s' requires unknown ending '%s'" % [id, ending_id])
	return errors


func validate_crisis(crisis: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(crisis.get("id", ""))
	if id.is_empty():
		errors.append("Crisis missing 'id'")
		return errors

	var country_id: String = str(crisis.get("country_id", ""))
	if country_id.is_empty():
		errors.append("Crisis '%s' missing 'country_id'" % id)
	elif not repository.has_country(country_id):
		errors.append("Crisis '%s' references unknown country '%s'" % [id, country_id])

	var severity: int = int(crisis.get("severity", 0))
	if severity < 1 or severity > 3:
		errors.append("Crisis '%s' severity must be 1-3" % id)

	var max_days: int = int(crisis.get("maximum_duration_days", 0))
	if max_days < 1:
		errors.append("Crisis '%s' maximum_duration_days must be >= 1" % id)

	var entry_id: String = str(crisis.get("entry_decision_id", ""))
	if entry_id.is_empty():
		errors.append("Crisis '%s' missing 'entry_decision_id'" % id)
	elif not repository.has_decision(entry_id):
		errors.append("Crisis '%s' entry decision '%s' not found" % [id, entry_id])
	else:
		var entry: Dictionary = repository.get_decision(entry_id)
		if str(entry.get("card_type", "")) != "crisis":
			errors.append("Crisis '%s' entry decision '%s' must have card_type 'crisis'" % [id, entry_id])

	var resolution_decision_id: String = str(crisis.get("resolution_decision_id", ""))
	var path_decision_id: String = entry_id
	if not resolution_decision_id.is_empty():
		if not repository.has_decision(resolution_decision_id):
			errors.append("Crisis '%s' resolution decision '%s' not found" % [id, resolution_decision_id])
		else:
			var resolution_decision: Dictionary = repository.get_decision(resolution_decision_id)
			if str(resolution_decision.get("card_type", "")) != "crisis":
				errors.append("Crisis '%s' resolution decision '%s' must have card_type 'crisis'" % [
					id, resolution_decision_id,
				])
			path_decision_id = resolution_decision_id

	var path_options: Dictionary = _option_ids_for_decision(path_decision_id, repository)
	for path in crisis.get("resolution_paths", []):
		if not (path is Dictionary):
			continue
		var resolution_id: String = str(path.get("resolution_id", ""))
		var option_id: String = str(path.get("option_id", ""))
		if resolution_id.is_empty():
			errors.append("Crisis '%s' resolution_path missing 'resolution_id'" % id)
		if option_id.is_empty():
			errors.append("Crisis '%s' resolution_path missing 'option_id'" % id)
		elif not path_options.has(option_id):
			errors.append("Crisis '%s' resolution_path option '%s' not on %s decision" % [
				id, option_id, "resolution" if not resolution_decision_id.is_empty() else "entry",
			])

	for path in crisis.get("failure_paths", []):
		if not (path is Dictionary):
			continue
		var option_id: String = str(path.get("option_id", ""))
		if option_id.is_empty():
			errors.append("Crisis '%s' failure_path missing 'option_id'" % id)
		elif not path_options.has(option_id):
			errors.append("Crisis '%s' failure_path option '%s' not on %s decision" % [
				id, option_id, "resolution" if not resolution_decision_id.is_empty() else "entry",
			])
		var ending_id: String = str(path.get("trigger_ending_id", ""))
		if not ending_id.is_empty() and not repository.has_ending(ending_id):
			errors.append("Crisis '%s' failure_path references unknown ending '%s'" % [id, ending_id])

	var timeout: Variant = crisis.get("timeout", {})
	if timeout is Dictionary and not timeout.is_empty():
		var timeout_ending: String = str(timeout.get("trigger_ending_id", ""))
		if not timeout_ending.is_empty() and not repository.has_ending(timeout_ending):
			errors.append("Crisis '%s' timeout references unknown ending '%s'" % [id, timeout_ending])
		var effects: Variant = timeout.get("effects", {})
		if effects is Dictionary:
			for resource_id in effects:
				if str(resource_id) not in RunState.RESOURCE_IDS:
					errors.append("Crisis '%s' timeout has unknown resource '%s'" % [id, resource_id])

	if country_id and repository.has_country(country_id):
		var country: Dictionary = repository.get_country(country_id)
		var stage_ids: Array[String] = []
		for stage in country.get("run_stages", []):
			if stage is Dictionary:
				stage_ids.append(str(stage.get("id", "")))
		var start_req: Variant = crisis.get("start_requirements", {})
		if start_req is Dictionary:
			for stage_ref in start_req.get("allowed_stages", []):
				if str(stage_ref) not in stage_ids:
					errors.append("Crisis '%s' start_requirements allowed_stages '%s' not in country run_stages" % [
						id, str(stage_ref),
					])

	return errors


func _option_ids_for_decision(decision_id: String, repository: ContentRepository) -> Dictionary:
	var result: Dictionary = {}
	if decision_id.is_empty():
		return result
	var decision: Dictionary = repository.get_decision(decision_id)
	for option in DecisionSchema.get_options(decision):
		if option is Dictionary:
			var option_id: String = str(option.get("id", ""))
			if not option_id.is_empty():
				result[option_id] = true
	return result


func _validate_decision_narrative_crisis(decision_id: String, decision: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var narrative: Variant = decision.get("narrative", {})
	if not (narrative is Dictionary) or narrative.is_empty():
		return errors
	var crisis_id: String = str(narrative.get("crisis_id", ""))
	if crisis_id.is_empty():
		return errors
	if not repository.has_crisis(crisis_id):
		errors.append("Decision '%s' references unknown crisis '%s'" % [decision_id, crisis_id])
		return errors
	if bool(narrative.get("starts_crisis", false)):
		var crisis: Dictionary = repository.get_crisis(crisis_id)
		if str(crisis.get("entry_decision_id", "")) != decision_id:
			errors.append("Decision '%s' starts crisis '%s' but is not listed as entry_decision_id" % [
				decision_id, crisis_id,
			])
	return errors


func validate_follow_up_pool(pool: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(pool.get("id", ""))
	if id.is_empty():
		errors.append("Follow-up pool missing 'id'")
		return errors

	var decision_ids: Variant = pool.get("decision_ids", [])
	if not (decision_ids is Array) or decision_ids.is_empty():
		errors.append("Follow-up pool '%s' missing non-empty 'decision_ids'" % id)
		return errors

	for decision_id in decision_ids:
		if not repository.has_decision(str(decision_id)):
			errors.append("Follow-up pool '%s' references unknown decision '%s'" % [id, decision_id])

	return errors


func _validate_decision_narrative(decision_id: String, decision: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var narrative: Variant = decision.get("narrative", {})
	if not (narrative is Dictionary) or narrative.is_empty():
		return errors

	var crisis_id: String = str(narrative.get("crisis_id", ""))
	var arc_id: String = str(narrative.get("arc_id", ""))
	if not crisis_id.is_empty() and arc_id.is_empty():
		return errors

	if arc_id.is_empty():
		errors.append("Decision '%s' narrative missing 'arc_id'" % decision_id)
		return errors
	if not repository.has_arc(arc_id):
		errors.append("Decision '%s' references unknown arc '%s'" % [decision_id, arc_id])
		return errors

	var arc: Dictionary = repository.get_arc(arc_id)
	var branch_id: String = str(narrative.get("branch_id", ""))
	if narrative.get("branch_id") != null and not branch_id.is_empty() and branch_id != "<null>":
		var branch_ids: Array = arc.get("branch_ids", [])
		if not branch_ids.is_empty() and branch_id not in branch_ids:
			errors.append("Decision '%s' narrative branch_id '%s' invalid for arc '%s'" % [
				decision_id, branch_id, arc_id,
			])

	if bool(narrative.get("starts_arc", false)):
		var entry_ids: Array = arc.get("entry_decision_ids", [])
		if decision_id not in entry_ids:
			errors.append("Decision '%s' starts arc '%s' but is not listed in entry_decision_ids" % [
				decision_id, arc_id,
			])

	if bool(narrative.get("resolves_arc", false)):
		var resolution_ids: Array = arc.get("resolution_decision_ids", [])
		if decision_id not in resolution_ids:
			errors.append("Decision '%s' resolves arc '%s' but is not listed in resolution_decision_ids" % [
				decision_id, arc_id,
			])

	return errors


func _validate_option(decision_id: String, option_id: String, option: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var where := "Decision '%s' option '%s'" % [decision_id, option_id]

	if str(option.get("label", "")).is_empty():
		errors.append("%s missing 'label'" % where)
	if str(option.get("result_text", "")).is_empty():
		errors.append("%s missing 'result_text'" % where)

	var effects: Variant = option.get("effects", {})
	if effects is Dictionary:
		for resource_id in effects:
			if str(resource_id) not in RunState.RESOURCE_IDS:
				errors.append("%s has unknown resource '%s' in effects" % [where, resource_id])
	else:
		errors.append("%s has non-object 'effects'" % where)

	for key in ["add_laws", "remove_laws"]:
		for law_id in option.get(key, []):
			if not repository.has_law(str(law_id)):
				errors.append("%s references unknown law '%s' in %s" % [where, law_id, key])

	var forced: String = str(option.get("force_next_decision", ""))
	if not forced.is_empty() and not repository.has_decision(forced):
		errors.append("%s forces unknown decision '%s'" % [where, forced])

	var follow_up: Variant = option.get("follow_up", {})
	if follow_up is Dictionary and not follow_up.is_empty():
		errors.append_array(_validate_follow_up(decision_id, option_id, follow_up, repository, not forced.is_empty()))

	var trigger_ending: String = str(option.get("trigger_ending", ""))
	if not trigger_ending.is_empty() and not repository.has_ending(trigger_ending):
		errors.append("%s triggers unknown ending '%s'" % [where, trigger_ending])

	for resource_id in option.get("visible_effects", []):
		if str(resource_id) not in RunState.RESOURCE_IDS:
			errors.append("%s has unknown resource '%s' in visible_effects" % [where, resource_id])

	for action_data in option.get("arc_actions", []):
		if not (action_data is Dictionary):
			errors.append("%s has non-object arc_action" % where)
			continue
		var arc_id: String = str(action_data.get("arc_id", ""))
		var action: String = str(action_data.get("action", ""))
		if arc_id.is_empty():
			errors.append("%s arc_action missing 'arc_id'" % where)
		elif not repository.has_arc(arc_id):
			errors.append("%s arc_action references unknown arc '%s'" % [where, arc_id])
		if action.is_empty():
			errors.append("%s arc_action missing 'action'" % where)
		elif action not in VALID_ARC_ACTIONS:
			errors.append("%s arc_action has invalid action '%s'" % [where, action])
		var branch_id: String = str(action_data.get("branch_id", ""))
		if action in ["branch", "advance"] and not branch_id.is_empty():
			var arc: Dictionary = repository.get_arc(arc_id)
			var branch_ids: Array = arc.get("branch_ids", [])
			if not branch_ids.is_empty() and branch_id not in branch_ids:
				errors.append("%s arc_action branch_id '%s' invalid for arc '%s'" % [where, branch_id, arc_id])

	for action_data in option.get("crisis_actions", []):
		if not (action_data is Dictionary):
			errors.append("%s has non-object crisis_action" % where)
			continue
		var crisis_id: String = str(action_data.get("crisis_id", ""))
		var action: String = str(action_data.get("action", ""))
		if crisis_id.is_empty():
			errors.append("%s crisis_action missing 'crisis_id'" % where)
		elif not repository.has_crisis(crisis_id):
			errors.append("%s crisis_action references unknown crisis '%s'" % [where, crisis_id])
		if action.is_empty():
			errors.append("%s crisis_action missing 'action'" % where)
		elif action not in VALID_CRISIS_ACTIONS:
			errors.append("%s crisis_action has invalid action '%s'" % [where, action])
		if action == "resolve" and str(action_data.get("resolution_id", "")).is_empty():
			errors.append("%s crisis_action resolve missing 'resolution_id'" % where)

	var affinity_changes: Variant = option.get("advisor_affinity", {})
	if affinity_changes is Dictionary:
		for advisor_id in affinity_changes:
			if not repository.has_advisor(str(advisor_id)):
				errors.append("%s advisor_affinity references unknown advisor '%s'" % [where, advisor_id])
			var delta: int = int(affinity_changes[advisor_id])
			if delta < AdvisorRelationshipManager.AFFINITY_MIN or delta > AdvisorRelationshipManager.AFFINITY_MAX:
				errors.append("%s advisor_affinity delta %d for '%s' out of range %d to %d" % [
					where, delta, advisor_id,
					AdvisorRelationshipManager.AFFINITY_MIN, AdvisorRelationshipManager.AFFINITY_MAX,
				])
	elif option.has("advisor_affinity"):
		errors.append("%s has non-object 'advisor_affinity'" % where)

	var trait_changes: Variant = option.get("trait_changes", {})
	if trait_changes is Dictionary:
		for trait_id in trait_changes:
			if str(trait_id) not in RulerTraitManager.VALID_TRAIT_IDS:
				errors.append("%s trait_changes references unknown trait '%s'" % [where, trait_id])
	elif option.has("trait_changes"):
		errors.append("%s has non-object 'trait_changes'" % where)

	return errors


func _validate_follow_up(
	decision_id: String,
	option_id: String,
	follow_up: Dictionary,
	repository: ContentRepository,
	has_forced: bool,
) -> Array[String]:
	var errors: Array[String] = []
	var where := "Decision '%s' option '%s' follow_up" % [decision_id, option_id]

	if has_forced:
		errors.append("%s cannot coexist with force_next_decision on the same option" % where)

	var follow_type: String = str(follow_up.get("type", ""))
	if follow_type not in ["hard", "soft", "pool"]:
		errors.append("%s has invalid type '%s' (expected hard, soft, or pool)" % [where, follow_type])
		return errors

	if follow_type in ["hard", "soft"]:
		var target_id: String = str(follow_up.get("decision_id", ""))
		if target_id.is_empty():
			errors.append("%s type '%s' requires 'decision_id'" % [where, follow_type])
		elif not repository.has_decision(target_id):
			errors.append("%s references unknown decision '%s'" % [where, target_id])

	if follow_type == "pool":
		var pool_id: String = str(follow_up.get("pool_id", ""))
		if pool_id.is_empty():
			errors.append("%s type 'pool' requires 'pool_id'" % where)
		elif not repository.has_follow_up_pool(pool_id):
			errors.append("%s references unknown pool '%s'" % [where, pool_id])

	if follow_type in ["soft", "pool"]:
		var min_delay: int = int(follow_up.get("minimum_delay_days", -1))
		var max_delay: int = int(follow_up.get("maximum_delay_days", -1))
		if min_delay < 0:
			errors.append("%s missing or invalid minimum_delay_days" % where)
		if max_delay < min_delay:
			errors.append("%s maximum_delay_days must be >= minimum_delay_days" % where)

		var priority: int = int(follow_up.get("priority", 50))
		if priority < 0 or priority > 100:
			errors.append("%s priority %d out of range 0-100" % [where, priority])

	return errors


func _validate_requirements(decision_id: String, requirements: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	for key in requirements:
		if str(key) not in KNOWN_REQUIREMENT_KEYS:
			errors.append("Decision '%s' has unknown requirement '%s'" % [decision_id, key])
	for key in ["all_laws", "any_laws", "blocked_laws"]:
		for law_id in requirements.get(key, []):
			if not repository.has_law(str(law_id)):
				errors.append("Decision '%s' requirement %s references unknown law '%s'" % [decision_id, key, law_id])
	for key in ["minimum_resources", "maximum_resources"]:
		var thresholds: Variant = requirements.get(key, {})
		if thresholds is Dictionary:
			for resource_id in thresholds:
				if str(resource_id) not in RunState.RESOURCE_IDS:
					errors.append("Decision '%s' requirement %s has unknown resource '%s'" % [decision_id, key, resource_id])
	for key in ["active_arcs", "blocked_arcs", "completed_arcs", "failed_arcs"]:
		for arc_id in requirements.get(key, []):
			if not repository.has_arc(str(arc_id)):
				errors.append("Decision '%s' requirement %s references unknown arc '%s'" % [decision_id, key, arc_id])
	var arc_branches: Variant = requirements.get("arc_branches", {})
	if arc_branches is Dictionary:
		for arc_id in arc_branches:
			if not repository.has_arc(str(arc_id)):
				errors.append("Decision '%s' arc_branches references unknown arc '%s'" % [decision_id, arc_id])
			var branch_id: String = str(arc_branches[arc_id])
			var arc: Dictionary = repository.get_arc(str(arc_id))
			var branch_ids: Array = arc.get("branch_ids", [])
			if not branch_ids.is_empty() and branch_id not in branch_ids:
				errors.append("Decision '%s' arc_branches '%s' has invalid branch '%s'" % [
					decision_id, arc_id, branch_id,
				])
	for key in ["minimum_advisor_affinity", "maximum_advisor_affinity"]:
		var thresholds: Variant = requirements.get(key, {})
		if thresholds is Dictionary:
			for advisor_id in thresholds:
				if not repository.has_advisor(str(advisor_id)):
					errors.append("Decision '%s' requirement %s references unknown advisor '%s'" % [
						decision_id, key, advisor_id,
					])
				var threshold: int = int(thresholds[advisor_id])
				if threshold < AdvisorRelationshipManager.AFFINITY_MIN \
						or threshold > AdvisorRelationshipManager.AFFINITY_MAX:
					errors.append("Decision '%s' requirement %s threshold %d for '%s' out of range %d to %d" % [
						decision_id, key, threshold, advisor_id,
						AdvisorRelationshipManager.AFFINITY_MIN, AdvisorRelationshipManager.AFFINITY_MAX,
					])
	for key in ["minimum_traits", "maximum_traits"]:
		var traits: Variant = requirements.get(key, {})
		if traits is Dictionary:
			for trait_id in traits:
				if str(trait_id) not in RulerTraitManager.VALID_TRAIT_IDS:
					errors.append("Decision '%s' requirement %s references unknown trait '%s'" % [
						decision_id, key, trait_id,
					])
	return errors


func _validate_country(country: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var id: String = str(country.get("id", ""))
	if id.is_empty():
		errors.append("Country missing 'id'")
		return errors
	if str(country.get("display_name", "")).is_empty():
		errors.append("Country '%s' missing 'display_name'" % id)
	if not (country.get("starting_resources") is Dictionary):
		errors.append("Country '%s' missing 'starting_resources'" % id)
	else:
		for resource_id in RunState.RESOURCE_IDS:
			if not country["starting_resources"].has(resource_id):
				errors.append("Country '%s' starting_resources missing '%s'" % [id, resource_id])
	if int(country.get("max_day", 0)) <= 0:
		errors.append("Country '%s' missing positive 'max_day'" % id)
	if country.get("decision_files", []).is_empty():
		errors.append("Country '%s' has no 'decision_files'" % id)

	var fallback_id: String = str(country.get("fallback_decision_id", ""))
	if not fallback_id.is_empty() and not repository.has_decision(fallback_id):
		errors.append("Country '%s' fallback decision '%s' not found" % [id, fallback_id])

	var survival_id: String = str(country.get("survival_ending_id", ""))
	if not survival_id.is_empty() and not repository.has_ending(survival_id):
		errors.append("Country '%s' survival ending '%s' not found" % [id, survival_id])

	if country.has("run_stages"):
		var run_stages: Variant = country.get("run_stages")
		if not (run_stages is Array):
			errors.append("Country '%s' run_stages must be an array" % id)
		else:
			errors.append_array(_validate_run_stages(id, run_stages))

	return errors


func _validate_run_stages(country_id: String, run_stages: Array) -> Array[String]:
	var errors: Array[String] = []
	var seen_ids: Dictionary = {}
	var previous_max_day: int = 0

	for index in run_stages.size():
		var stage: Variant = run_stages[index]
		var where := "Country '%s' run_stages[%d]" % [country_id, index]
		if not (stage is Dictionary):
			errors.append("%s must be an object" % where)
			continue

		var stage_id: String = str(stage.get("id", ""))
		if stage_id.is_empty():
			errors.append("%s missing non-empty string 'id'" % where)
		elif seen_ids.has(stage_id):
			errors.append("Country '%s' run_stages has duplicate stage id '%s'" % [country_id, stage_id])
		else:
			seen_ids[stage_id] = true

		var minimum_day: Variant = stage.get("minimum_day")
		var maximum_day: Variant = stage.get("maximum_day")
		var minimum_valid := _is_integer_value(minimum_day)
		var maximum_valid := _is_integer_value(maximum_day)
		if not minimum_valid:
			errors.append("%s 'minimum_day' must be an integer" % where)
		if not maximum_valid:
			errors.append("%s 'maximum_day' must be an integer" % where)

		if minimum_valid and maximum_valid:
			var min_day: int = int(minimum_day)
			var max_day: int = int(maximum_day)
			if min_day > max_day:
				errors.append("%s has minimum_day (%d) > maximum_day (%d)" % [where, min_day, max_day])
			if index == 0:
				if min_day != 1:
					errors.append("Country '%s' first run stage must start at day 1 (got %d)" % [country_id, min_day])
			elif previous_max_day > 0 and min_day != previous_max_day + 1:
				errors.append(
					"Country '%s' run stage '%s' minimum_day (%d) must be %d (previous maximum_day + 1)" % [
						country_id, stage_id, min_day, previous_max_day + 1,
					]
				)
			previous_max_day = max_day

	return errors


func _country_warnings(country: Dictionary) -> Array[String]:
	var warnings: Array[String] = []
	var id: String = str(country.get("id", ""))
	if id.is_empty() or not country.has("run_stages"):
		return warnings

	var run_stages: Variant = country.get("run_stages")
	if not (run_stages is Array) or run_stages.is_empty():
		return warnings

	var last_stage: Variant = run_stages[run_stages.size() - 1]
	if not (last_stage is Dictionary):
		return warnings

	var last_max_day: int = int(last_stage.get("maximum_day", 0))
	var max_day: int = int(country.get("max_day", 0))
	if last_max_day != max_day:
		warnings.append(
			"Country '%s' last run stage maximum_day (%d) does not match max_day (%d)" % [
				id, last_max_day, max_day,
			]
		)
	return warnings


func _collect_run_stage_ids(repository: ContentRepository) -> Dictionary:
	var stage_ids: Dictionary = {}
	for country in repository.get_raw_countries():
		var run_stages: Variant = country.get("run_stages", [])
		if not (run_stages is Array):
			continue
		for stage in run_stages:
			if stage is Dictionary:
				var stage_id: String = str(stage.get("id", ""))
				if not stage_id.is_empty():
					stage_ids[stage_id] = true
	return stage_ids


func _is_integer_value(value: Variant) -> bool:
	if value is int:
		return true
	if value is float:
		return is_finite(value) and value == int(value)
	return false


## Length checks are warnings, not failures (PRD 03 §21).
func _decision_warnings(decision: Dictionary, repository: ContentRepository) -> Array[String]:
	var warnings: Array[String] = []
	var id: String = str(decision.get("id", ""))
	if str(decision.get("proposal", "")).length() > PROPOSAL_MAX_LENGTH:
		warnings.append("Decision '%s' proposal exceeds %d characters" % [id, PROPOSAL_MAX_LENGTH])
	for option in DecisionSchema.get_options(decision):
		if not (option is Dictionary):
			continue
		var option_id: String = str(option.get("id", "?"))
		if str(option.get("label", "")).length() > CHOICE_LABEL_MAX_LENGTH:
			warnings.append("Decision '%s' option '%s' label exceeds %d characters" % [id, option_id, CHOICE_LABEL_MAX_LENGTH])
		if str(option.get("result_text", "")).length() > RESULT_TEXT_MAX_LENGTH:
			warnings.append("Decision '%s' option '%s' result_text exceeds %d characters" % [id, option_id, RESULT_TEXT_MAX_LENGTH])

	var pacing: Variant = decision.get("pacing", {})
	if pacing is Dictionary and not pacing.is_empty():
		var known_stage_ids: Dictionary = _collect_run_stage_ids(repository)
		if pacing.has("allowed_stages") and pacing["allowed_stages"] is Array:
			for stage_ref in pacing["allowed_stages"]:
				var stage_id: String = str(stage_ref)
				if not stage_id.is_empty() and not known_stage_ids.has(stage_id):
					warnings.append("Decision '%s' pacing references unknown stage '%s'" % [id, stage_id])
		for key in pacing:
			if str(key) not in KNOWN_PACING_KEYS:
				warnings.append("Decision '%s' pacing key '%s' is not yet supported" % [id, key])

	return warnings
