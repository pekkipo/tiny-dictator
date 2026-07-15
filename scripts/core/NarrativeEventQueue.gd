class_name NarrativeEventQueue
extends RefCounted

## Owns delayed and soft narrative follow-ups stored on RunState.
## Spec: docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md §11, §28.3.

const DEFAULT_PRIORITY: int = 50
const PRIORITY_BOOST_MAX: int = 30
const MANDATORY_PRIORITY_BONUS: int = 100

const STATUS_PENDING: String = "pending"
const STATUS_ELIGIBLE: String = "eligible"
const STATUS_CONSUMED: String = "consumed"
const STATUS_CANCELLED: String = "cancelled"
const STATUS_EXPIRED: String = "expired"

const TYPE_HARD: String = "hard_follow_up"
const TYPE_SOFT: String = "soft_follow_up"
const TYPE_POOL: String = "pool_follow_up"

var _repository: ContentRepository
var _decision_engine: DecisionEngine = null
var _rng: RandomNumberGenerator = null
var _event_counter: int = 0


func _init(repository: ContentRepository) -> void:
	_repository = repository


func set_decision_engine(engine: DecisionEngine) -> void:
	_decision_engine = engine


func set_rng(rng: RandomNumberGenerator) -> void:
	_rng = rng


func add_event(event_data: Dictionary, state: RunState) -> String:
	var follow_up: Dictionary = event_data.get("follow_up", {})
	if follow_up.is_empty():
		return ""

	var follow_type: String = str(follow_up.get("type", ""))
	if follow_type in ["hard"]:
		return ""

	var min_delay: int = maxi(0, int(follow_up.get("minimum_delay_days", 0)))
	var max_delay: int = maxi(min_delay, int(follow_up.get("maximum_delay_days", min_delay)))
	var created_day: int = state.day
	var event_id: String = _make_event_id()

	var entry: Dictionary = {
		"event_id": event_id,
		"source_decision_id": str(event_data.get("source_decision_id", "")),
		"source_option_id": str(event_data.get("source_option_id", "")),
		"event_type": _event_type_from_follow(follow_type),
		"decision_id": str(follow_up.get("decision_id", "")),
		"pool_id": str(follow_up.get("pool_id", "")),
		"created_day": created_day,
		"earliest_day": created_day + min_delay,
		"latest_day": created_day + max_delay,
		"priority": int(follow_up.get("priority", DEFAULT_PRIORITY)),
		"required_flags": _string_array(follow_up.get("required_flags", [])),
		"blocked_flags": _string_array(follow_up.get("blocked_flags", [])),
		"status": STATUS_PENDING,
		"mandatory": false,
	}
	state.narrative_event_queue.append(entry)
	print("[QUEUE] Added %s from %s/%s (days %d-%d)" % [
		event_id, entry["source_decision_id"], entry["source_option_id"],
		entry["earliest_day"], entry["latest_day"],
	])
	return event_id


func cancel_events_from_source(source_decision_id: String, state: RunState) -> void:
	for i in state.narrative_event_queue.size():
		var event: Dictionary = state.narrative_event_queue[i]
		if str(event.get("source_decision_id", "")) != source_decision_id:
			continue
		var status: String = str(event.get("status", ""))
		if status in [STATUS_PENDING, STATUS_ELIGIBLE]:
			event["status"] = STATUS_CANCELLED
			event["mandatory"] = false
			state.narrative_event_queue[i] = event


func cancel_event(event_id: String, state: RunState) -> bool:
	for i in state.narrative_event_queue.size():
		var event: Dictionary = state.narrative_event_queue[i]
		if str(event.get("event_id", "")) != event_id:
			continue
		var status: String = str(event.get("status", ""))
		if status not in [STATUS_PENDING, STATUS_ELIGIBLE]:
			return false
		event["status"] = STATUS_CANCELLED
		event["mandatory"] = false
		state.narrative_event_queue[i] = event
		return true
	return false


func update_for_day(day: int, state: RunState) -> void:
	for i in state.narrative_event_queue.size():
		var event: Dictionary = state.narrative_event_queue[i]
		var status: String = str(event.get("status", ""))
		if status not in [STATUS_PENDING, STATUS_ELIGIBLE]:
			continue

		var requirements_met: bool = _requirements_met(event, state)
		var earliest_day: int = int(event.get("earliest_day", 0))
		var latest_day: int = int(event.get("latest_day", 0))

		if not requirements_met:
			if day > latest_day:
				event["status"] = STATUS_EXPIRED
				event["mandatory"] = false
			elif status == STATUS_ELIGIBLE:
				event["status"] = STATUS_CANCELLED
				event["mandatory"] = false
			state.narrative_event_queue[i] = event
			continue

		if day < earliest_day:
			event["status"] = STATUS_PENDING
			event["mandatory"] = false
		elif day > latest_day:
			event["status"] = STATUS_ELIGIBLE
			event["mandatory"] = true
		else:
			event["status"] = STATUS_ELIGIBLE
			event["mandatory"] = false

		state.narrative_event_queue[i] = event


func get_due_events(state: RunState) -> Array[Dictionary]:
	var due: Array[Dictionary] = []
	for event in state.narrative_event_queue:
		if str(event.get("status", "")) != STATUS_ELIGIBLE:
			continue
		due.append(event.duplicate(true))

	due.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var day: int = state.day
		return get_effective_priority(a, day) > get_effective_priority(b, day)
	)
	return due


func get_effective_priority(event: Dictionary, day: int) -> int:
	var base: int = int(event.get("priority", DEFAULT_PRIORITY))
	var earliest_day: int = int(event.get("earliest_day", 0))
	var latest_day: int = int(event.get("latest_day", earliest_day))
	var window: int = maxi(1, latest_day - earliest_day)
	var progress: float = clampf(float(day - earliest_day) / float(window), 0.0, 1.0)
	var effective: int = base + int(progress * PRIORITY_BOOST_MAX)
	if bool(event.get("mandatory", false)):
		effective += MANDATORY_PRIORITY_BONUS
	return effective


func resolve_target_decision(event: Dictionary, state: RunState) -> String:
	var decision_id: String = str(event.get("decision_id", ""))
	if not decision_id.is_empty():
		return decision_id

	var pool_id: String = str(event.get("pool_id", ""))
	if pool_id.is_empty():
		return ""
	return resolve_pool_decision(pool_id, state)


func resolve_pool_decision(pool_id: String, state: RunState) -> String:
	var pool: Dictionary = _repository.get_follow_up_pool(pool_id)
	if pool.is_empty():
		push_error("[QUEUE] Unknown follow-up pool '%s'." % pool_id)
		return ""

	var candidates: Array[String] = []
	for decision_id in pool.get("decision_ids", []):
		var id: String = str(decision_id)
		if id.is_empty() or not _repository.has_decision(id):
			continue
		var decision: Dictionary = _repository.get_decision(id)
		if _decision_engine != null and not _decision_engine.is_decision_valid(decision, state):
			continue
		candidates.append(id)

	if candidates.is_empty():
		return ""

	if _rng == null:
		return candidates[0]
	return candidates[_rng.randi_range(0, candidates.size() - 1)]


func consume_event(event_id: String, state: RunState, decision_id: String = "") -> bool:
	for i in state.narrative_event_queue.size():
		var event: Dictionary = state.narrative_event_queue[i]
		if str(event.get("event_id", "")) != event_id:
			continue
		if not decision_id.is_empty():
			event["decision_id"] = decision_id
		event["status"] = STATUS_CONSUMED
		event["mandatory"] = false
		state.narrative_event_queue[i] = event
		print("[QUEUE] Consumed %s -> %s" % [event_id, event.get("decision_id", "")])
		return true
	return false


func _requirements_met(event: Dictionary, state: RunState) -> bool:
	for flag_id in event.get("required_flags", []):
		if not state.has_flag(str(flag_id)):
			return false
	for flag_id in event.get("blocked_flags", []):
		if state.has_flag(str(flag_id)):
			return false
	return true


func _event_type_from_follow(follow_type: String) -> String:
	match follow_type:
		"soft":
			return TYPE_SOFT
		"pool":
			return TYPE_POOL
		_:
			return TYPE_SOFT


func _make_event_id() -> String:
	_event_counter += 1
	return "evt_%04x" % _event_counter


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for item in value:
			result.append(str(item))
	return result
