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
]

const KNOWN_ENDING_CONDITION_KEYS: Array[String] = [
	"all_flags", "any_flags", "blocked_flags",
	"all_laws", "any_laws",
	"minimum_resources", "maximum_resources",
	"minimum_counters", "maximum_counters",
	"minimum_day", "maximum_day",
]

const PROPOSAL_MAX_LENGTH: int = 220
const CHOICE_LABEL_MAX_LENGTH: int = 32
const RESULT_TEXT_MAX_LENGTH: int = 180


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

	for decision in repository.get_raw_decisions():
		for error in validate_decision(decision, repository):
			report.errors.append(error)
		for warning in _decision_warnings(decision):
			report.warnings.append(warning)

	# Unmapped visual tags render nothing in the diorama; warn, don't fail.
	var visual_map: Dictionary = repository.get_visual_map()
	for law in repository.get_raw_laws():
		for tag in law.get("visual_tags", []):
			if not visual_map.has(str(tag)):
				report.warnings.append("Law '%s' visual tag '%s' has no entry in country_visual_map.json" % [
					str(law.get("id", "")), str(tag),
				])

	return report


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

	var weight: Variant = decision.get("weight", 10)
	if not (weight is float or weight is int) or int(weight) <= 0:
		errors.append("Decision '%s' has invalid 'weight' (must be positive integer)" % id)

	var minimum_day: int = int(decision.get("minimum_day", 1))
	var maximum_day: int = int(decision.get("maximum_day", 9999))
	if minimum_day > maximum_day:
		errors.append("Decision '%s' has minimum_day > maximum_day" % id)

	for side in ["left", "right"]:
		var option: Variant = decision.get(side)
		if not (option is Dictionary):
			errors.append("Decision '%s' missing '%s' option" % [id, side])
			continue
		errors.append_array(_validate_option(id, side, option, repository))

	var requirements: Variant = decision.get("requirements", {})
	if requirements is Dictionary:
		errors.append_array(_validate_requirements(id, requirements, repository))
	else:
		errors.append("Decision '%s' has non-object 'requirements'" % id)

	return errors


func _validate_option(decision_id: String, side: String, option: Dictionary, repository: ContentRepository) -> Array[String]:
	var errors: Array[String] = []
	var where := "Decision '%s' option '%s'" % [decision_id, side]

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

	var trigger_ending: String = str(option.get("trigger_ending", ""))
	if not trigger_ending.is_empty() and not repository.has_ending(trigger_ending):
		errors.append("%s triggers unknown ending '%s'" % [where, trigger_ending])

	for resource_id in option.get("visible_effects", []):
		if str(resource_id) not in RunState.RESOURCE_IDS:
			errors.append("%s has unknown resource '%s' in visible_effects" % [where, resource_id])

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

	return errors


## Length checks are warnings, not failures (PRD 03 §21).
func _decision_warnings(decision: Dictionary) -> Array[String]:
	var warnings: Array[String] = []
	var id: String = str(decision.get("id", ""))
	if str(decision.get("proposal", "")).length() > PROPOSAL_MAX_LENGTH:
		warnings.append("Decision '%s' proposal exceeds %d characters" % [id, PROPOSAL_MAX_LENGTH])
	for side in ["left", "right"]:
		var option: Variant = decision.get(side)
		if not (option is Dictionary):
			continue
		if str(option.get("label", "")).length() > CHOICE_LABEL_MAX_LENGTH:
			warnings.append("Decision '%s' %s label exceeds %d characters" % [id, side, CHOICE_LABEL_MAX_LENGTH])
		if str(option.get("result_text", "")).length() > RESULT_TEXT_MAX_LENGTH:
			warnings.append("Decision '%s' %s result_text exceeds %d characters" % [id, side, RESULT_TEXT_MAX_LENGTH])
	return warnings
