class_name DecisionEngine
extends RefCounted

## Owns decision eligibility and selection. Never applies effects,
## increments days, touches UI, or triggers endings.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §7,
## algorithm: docs/03_CONTENT_DATA_AND_DECISION_ENGINE_PRD.md §11-§14.

const DEFAULT_WEIGHT: int = 10
const PREFERRED_WEIGHT_MULTIPLIER: int = 4

## The fallback card is a short buffer, not infinite content: after this many
## appearances in one run the pool is treated as truly exhausted, which lets
## GameManager trigger the content_exhausted ending instead of looping the
## same card forever. Countries can override via "fallback_decision_limit".
const DEFAULT_FALLBACK_LIMIT: int = 2

var _repository: ContentRepository
var _rng: RandomNumberGenerator
var _arc_manager: ArcManager = null
var _forced_decision_id: String = ""


func _init(repository: ContentRepository, rng: RandomNumberGenerator) -> void:
	_repository = repository
	_rng = rng


func set_arc_manager(arc_manager: ArcManager) -> void:
	_arc_manager = arc_manager


func set_forced_decision(decision_id: String) -> void:
	_forced_decision_id = decision_id


func clear_forced_decision() -> void:
	_forced_decision_id = ""


func has_forced_decision() -> bool:
	return not _forced_decision_id.is_empty()


func get_forced_decision_id() -> String:
	return _forced_decision_id


## Returns {} only when no decision (including the fallback) is available.
func select_next_decision(state: RunState, request: ContentRequest = null) -> Dictionary:
	if not _forced_decision_id.is_empty():
		var forced_id := _forced_decision_id
		_forced_decision_id = ""
		var forced: Dictionary = _repository.get_decision(forced_id)
		if not forced.is_empty() and is_decision_valid(forced, state):
			print("[DECISION] Using forced decision '%s'" % forced_id)
			return forced
		push_error("[DECISION] Forced decision '%s' is missing or invalid; using normal selection." % forced_id)

	if request != null and not request.queued_decision_id.is_empty():
		var queued_id := request.queued_decision_id
		var queued: Dictionary = _repository.get_decision(queued_id)
		if not queued.is_empty() and is_decision_valid(queued, state):
			print("[DECISION] Using queued decision '%s' (event %s)" % [queued_id, request.queued_event_id])
			return queued
		push_error("[DECISION] Queued decision '%s' is missing or invalid; using normal selection." % queued_id)

	var candidates := get_valid_decisions(state)
	# Avoid presenting the same card twice in a row (relevant for reusable cards).
	if candidates.size() > 1 and not state.current_decision_id.is_empty():
		var filtered: Array[Dictionary] = []
		for decision in candidates:
			if str(decision.get("id", "")) != state.current_decision_id:
				filtered.append(decision)
		candidates = filtered

	if request != null and not request.excluded_tags.is_empty():
		var tag_filtered: Array[Dictionary] = []
		for decision in candidates:
			if not _has_excluded_tag(decision, request.excluded_tags):
				tag_filtered.append(decision)
		if not tag_filtered.is_empty():
			candidates = tag_filtered

	if candidates.is_empty():
		return _select_fallback(state)
	return _weighted_pick(candidates, request)


## All currently eligible decisions, excluding fallback cards
## (fallback is used only when this pool is empty, PRD 03 §13).
func get_valid_decisions(state: RunState) -> Array[Dictionary]:
	var valid: Array[Dictionary] = []
	for decision in _repository.get_all_decisions_for_country(state.country_id):
		if bool(decision.get("fallback", false)):
			continue
		if bool(decision.get("queue_only", false)):
			continue
		if is_decision_valid(decision, state):
			valid.append(decision)
	return valid


func is_decision_valid(decision: Dictionary, state: RunState) -> bool:
	var id: String = str(decision.get("id", ""))
	if id.is_empty():
		return false
	if bool(decision.get("debug_only", false)):
		return false
	if not _repository.has_advisor(str(decision.get("advisor_id", ""))):
		return false
	if bool(decision.get("one_time", true)) and id in state.used_decision_ids:
		return false
	if state.day < int(decision.get("minimum_day", 1)):
		return false
	if state.day > int(decision.get("maximum_day", 9999)):
		return false
	var pacing: Variant = decision.get("pacing", {})
	if pacing is Dictionary:
		var allowed_stages: Variant = pacing.get("allowed_stages", [])
		if allowed_stages is Array and not allowed_stages.is_empty():
			if not state.current_stage_id.is_empty() and state.current_stage_id not in allowed_stages:
				return false
	var requirements: Variant = decision.get("requirements", {})
	if not (requirements is Dictionary):
		return false
	if not evaluate_requirements(requirements, state):
		return false
	return _narrative_is_valid(decision, state)


func _narrative_is_valid(decision: Dictionary, state: RunState) -> bool:
	var narrative: Variant = decision.get("narrative", {})
	if not (narrative is Dictionary) or narrative.is_empty():
		return true

	var arc_id: String = str(narrative.get("arc_id", ""))
	if arc_id.is_empty():
		return true

	if bool(narrative.get("starts_arc", false)):
		if _arc_manager != null and not _arc_manager.can_start_arc(arc_id, state):
			return false

	var branch_id: String = str(narrative.get("branch_id", ""))
	if not branch_id.is_empty():
		if not state.is_arc_active(arc_id):
			return false
		if state.get_arc_branch(arc_id) != branch_id:
			return false

	var step: int = int(narrative.get("step", 0))
	if step > 1:
		if not state.is_arc_active(arc_id):
			return false
		var runtime: Dictionary = state.get_arc_runtime(arc_id)
		var expected_step: int = int(runtime.get("current_step", 0)) + 1
		if step != expected_step:
			return false

	if bool(narrative.get("resolves_arc", false)):
		if not state.is_arc_active(arc_id):
			return false

	return true


func evaluate_requirements(requirements: Dictionary, state: RunState) -> bool:
	return RequirementsEvaluator.matches(requirements, state)


func _weighted_pick(candidates: Array[Dictionary], request: ContentRequest = null) -> Dictionary:
	var total_weight: int = 0
	var weights: Array[int] = []
	for decision in candidates:
		var weight: int = maxi(1, int(decision.get("weight", DEFAULT_WEIGHT)))
		if request != null and _is_preferred_decision(decision, request):
			weight *= PREFERRED_WEIGHT_MULTIPLIER
		weights.append(weight)
		total_weight += weight
	var roll: int = _rng.randi_range(1, total_weight)
	var cursor: int = 0
	for i in candidates.size():
		cursor += weights[i]
		if roll <= cursor:
			return candidates[i]
	return candidates.back()


func _is_preferred_decision(decision: Dictionary, request: ContentRequest) -> bool:
	if request.request_type == "advance_arc" and not request.arc_id.is_empty():
		var narrative: Variant = decision.get("narrative", {})
		if narrative is Dictionary and str(narrative.get("arc_id", "")) == request.arc_id:
			return true
	var card_type: String = str(decision.get("card_type", ""))
	if card_type in request.preferred_card_types:
		return true
	if not request.required_tags.is_empty():
		var tags: Array = decision.get("tags", [])
		for tag in request.required_tags:
			if str(tag) in tags:
				return true
	return false


func _has_excluded_tag(decision: Dictionary, excluded_tags: Array[String]) -> bool:
	var tags: Array = decision.get("tags", [])
	for tag in tags:
		if str(tag) in excluded_tags:
			return true
	return false


func _select_fallback(state: RunState) -> Dictionary:
	var country: Dictionary = _repository.get_country(state.country_id)
	var fallback_id: String = str(country.get("fallback_decision_id", ""))
	if fallback_id.is_empty():
		push_warning("[DECISION] Empty pool and no fallback configured for '%s'." % state.country_id)
		return {}
	var limit: int = int(country.get("fallback_decision_limit", DEFAULT_FALLBACK_LIMIT))
	var uses: int = 0
	for entry in state.decision_history:
		if str(entry.get("decision_id", "")) == fallback_id:
			uses += 1
	if uses >= limit:
		print("[DECISION] Fallback '%s' already shown %d time(s); content truly exhausted." % [fallback_id, uses])
		return {}
	var fallback: Dictionary = _repository.get_decision(fallback_id)
	if fallback.is_empty() or not is_decision_valid(fallback, state):
		push_warning("[DECISION] Empty pool and fallback '%s' is unavailable." % fallback_id)
		return {}
	print("[DECISION] Decision pool empty; using fallback '%s' (%d of %d uses)." % [fallback_id, uses + 1, limit])
	return fallback
