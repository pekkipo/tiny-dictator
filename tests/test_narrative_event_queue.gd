extends SceneTree

## Milestone 2A-4 tests: NarrativeEventQueue and integration.
## Run: godot --headless --path . -s tests/test_narrative_event_queue.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	await process_frame
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_hard_follow_up_priority()
	_test_soft_follow_up_timing()
	_test_pool_selection()
	_test_cancellation()
	_test_overdue_mandatory()
	_test_consumed_not_repeating()
	_test_restart_cleanup()
	_test_old_save_compatibility()
	_test_arc_and_stage_intact()
	_test_free_pizza_enqueue()

	if _failures == 0:
		print("[TEST] All NarrativeEventQueue tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _fresh_state(day: int = 3) -> RunState:
	var state := RunState.new()
	state.country_id = "ministan"
	state.day = day
	state.current_stage_id = "establishment"
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	return state


func _make_rng(seed_value: int = 4242) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	return rng


func _make_engine(rng: RandomNumberGenerator) -> DecisionEngine:
	var engine := DecisionEngine.new(_repo, rng)
	engine.set_arc_manager(load("res://scripts/core/ArcManager.gd").new(_repo))
	return engine


func _make_queue(engine: DecisionEngine, rng: RandomNumberGenerator) -> NarrativeEventQueue:
	var queue := NarrativeEventQueue.new(_repo)
	queue.set_decision_engine(engine)
	queue.set_rng(rng)
	return queue


func _make_director() -> ContentDirector:
	return ContentDirector.new(_repo)


func _enqueue_soft(
	queue: NarrativeEventQueue,
	state: RunState,
	decision_id: String,
	min_delay: int,
	max_delay: int,
	required_flags: Array = [],
	blocked_flags: Array = [],
) -> String:
	return queue.add_event({
		"source_decision_id": "test_source",
		"source_option_id": "approve",
		"follow_up": {
			"type": "soft",
			"decision_id": decision_id,
			"minimum_delay_days": min_delay,
			"maximum_delay_days": max_delay,
			"priority": 70,
			"required_flags": required_flags,
			"blocked_flags": blocked_flags,
		},
	}, state)


func _enqueue_pool(
	queue: NarrativeEventQueue,
	state: RunState,
	pool_id: String,
	min_delay: int,
	max_delay: int,
	required_flags: Array = [],
) -> String:
	return queue.add_event({
		"source_decision_id": "test_source",
		"source_option_id": "approve",
		"follow_up": {
			"type": "pool",
			"pool_id": pool_id,
			"minimum_delay_days": min_delay,
			"maximum_delay_days": max_delay,
			"priority": 60,
			"required_flags": required_flags,
		},
	}, state)


func _test_hard_follow_up_priority() -> void:
	var state := _fresh_state(3)
	state.add_flag("pizza_policy_active")
	var rng := _make_rng()
	var engine := _make_engine(rng)
	var queue := _make_queue(engine, rng)
	var director := _make_director()

	_enqueue_soft(queue, state, "cheese_shortage", 0, 2, ["pizza_policy_active"])
	state.day = 6
	queue.update_for_day(state.day, state)
	_check(bool(state.narrative_event_queue[0].get("mandatory", false)), "queued event is mandatory when overdue")
	_check(queue.get_due_events(state).size() == 1, "mandatory queued event is due")

	engine.set_forced_decision("free_pizza_friday")
	var request: ContentRequest = director.build_request(state, engine, queue)
	_check(request.request_type == "forced_follow_up", "forced follow-up beats mandatory queued event")
	var picked: Dictionary = engine.select_next_decision(state, request)
	_check(str(picked.get("id", "")) == "free_pizza_friday", "forced decision selected over queue")


func _test_soft_follow_up_timing() -> void:
	var state := _fresh_state(3)
	state.add_flag("pizza_policy_active")
	var rng := _make_rng()
	var engine := _make_engine(rng)
	var queue := _make_queue(engine, rng)
	var director := _make_director()

	_enqueue_soft(queue, state, "cheese_shortage", 2, 5, ["pizza_policy_active"])
	queue.update_for_day(state.day, state)
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_PENDING, "event pending before earliest day")

	state.day = 4
	queue.update_for_day(state.day, state)
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_PENDING, "still pending on day before earliest")

	state.day = 5
	queue.update_for_day(state.day, state)
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_ELIGIBLE, "eligible inside window")

	var request: ContentRequest = director.build_request(state, engine, queue)
	_check(request.request_type == "queued_event", "queued_event request inside window")
	_check(request.queued_decision_id == "cheese_shortage", "soft follow-up targets cheese_shortage")
	var picked: Dictionary = engine.select_next_decision(state, request)
	_check(str(picked.get("id", "")) == "cheese_shortage", "cheese_shortage selected from queue")


func _test_pool_selection() -> void:
	var state := _fresh_state(5)
	state.add_flag("pizza_policy_active")
	var rng_a := _make_rng(9999)
	var rng_b := _make_rng(9999)
	var engine := _make_engine(rng_a)
	var queue := _make_queue(engine, rng_a)

	_enqueue_pool(queue, state, "free_pizza_consequences", 0, 2, ["pizza_policy_active"])
	queue.update_for_day(state.day, state)

	var first: String = queue.resolve_pool_decision("free_pizza_consequences", state)
	queue.set_rng(rng_b)
	var second: String = queue.resolve_pool_decision("free_pizza_consequences", state)
	_check(not first.is_empty(), "pool resolves a decision")
	_check(first == second, "same seed picks same pool member")
	_check(first in ["cheese_shortage", "pizza_union_strike", "pineapple_referendum"], "pool member is valid")


func _test_cancellation() -> void:
	var state := _fresh_state(5)
	state.add_flag("pizza_policy_active")
	var queue := _make_queue(_make_engine(_make_rng()), _make_rng())

	var event_id: String = _enqueue_soft(queue, state, "cheese_shortage", 0, 3, ["pizza_policy_active"])
	queue.update_for_day(state.day, state)
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_ELIGIBLE, "eligible before cancellation")

	state.remove_flag("pizza_policy_active")
	queue.update_for_day(state.day, state)
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_CANCELLED, "missing required flag cancels event")

	state = _fresh_state(5)
	state.add_flag("pizza_policy_active")
	event_id = _enqueue_soft(
		queue, state, "cheese_shortage", 0, 3, ["pizza_policy_active"], ["pizza_program_cancelled"],
	)
	queue.update_for_day(state.day, state)
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_ELIGIBLE, "eligible before blocked flag")

	state.add_flag("pizza_program_cancelled")
	queue.update_for_day(state.day, state)
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_CANCELLED, "blocked flag cancels event")
	_check(not event_id.is_empty(), "event id generated for cancellation test")


func _test_overdue_mandatory() -> void:
	var state := _fresh_state(3)
	state.add_flag("pizza_policy_active")
	var rng := _make_rng()
	var engine := _make_engine(rng)
	var queue := _make_queue(engine, rng)
	var director := _make_director()

	_enqueue_soft(queue, state, "cheese_shortage", 2, 5, ["pizza_policy_active"])
	state.day = 10
	queue.update_for_day(state.day, state)
	_check(bool(state.narrative_event_queue[0].get("mandatory", false)), "overdue event marked mandatory")

	var request: ContentRequest = director.build_request(state, engine, queue)
	_check(request.request_type == "mandatory_queued_event", "mandatory_queued_event request when overdue")
	_check(request.mandatory, "request mandatory flag set")
	var picked: Dictionary = engine.select_next_decision(state, request)
	_check(str(picked.get("id", "")) == "cheese_shortage", "overdue mandatory selects cheese_shortage")


func _test_consumed_not_repeating() -> void:
	var state := _fresh_state(5)
	state.add_flag("pizza_policy_active")
	var queue := _make_queue(_make_engine(_make_rng()), _make_rng())

	var event_id: String = _enqueue_soft(queue, state, "cheese_shortage", 0, 3, ["pizza_policy_active"])
	queue.update_for_day(state.day, state)
	queue.consume_event(event_id, state, "cheese_shortage")
	_check(queue.get_due_events(state).is_empty(), "consumed event not due again")
	_check(state.narrative_event_queue[0]["status"] == NarrativeEventQueue.STATUS_CONSUMED, "status is consumed")


func _test_restart_cleanup() -> void:
	var state := _fresh_state(4)
	var queue := _make_queue(_make_engine(_make_rng()), _make_rng())
	_enqueue_soft(queue, state, "cheese_shortage", 1, 3)
	_check(state.narrative_event_queue.size() == 1, "queue has entry before reset")
	state.reset()
	_check(state.narrative_event_queue.is_empty(), "reset clears narrative event queue")


func _test_old_save_compatibility() -> void:
	var legacy := RunState.new()
	legacy.from_dictionary({
		"day": 4,
		"resources": {"treasury": 40, "happiness": 50, "order": 55, "elite_loyalty": 55},
		"active_arcs": {"cat_politics": {"arc_id": "cat_politics", "status": "active", "current_step": 1}},
	})
	_check(legacy.narrative_event_queue.is_empty(), "legacy save without queue field loads safely")
	_check(legacy.is_arc_active("cat_politics"), "legacy arc state preserved")


func _test_arc_and_stage_intact() -> void:
	var state := _fresh_state(4)
	var director := _make_director()
	_check(director.resolve_stage_id(state) == "establishment", "stage derivation intact at day 4")

	state.day = 8
	director.update_stage(state)
	_check(state.current_stage_id == "escalation", "stage advances to escalation on day 8")

	var arcs: RefCounted = load("res://scripts/core/ArcManager.gd").new(_repo)
	_check(arcs.start_arc(state, "cat_politics", "support_cats"), "arc manager still starts arcs")
	_check(state.is_arc_active("cat_politics"), "arc remains active after queue milestone")


func _test_free_pizza_enqueue() -> void:
	var state := _fresh_state(3)
	var resolver := EffectResolver.new()
	var decision: Dictionary = _repo.get_decision("free_pizza_friday")
	var result: DecisionResult = resolver.apply_option(decision, "approve", state, _repo)
	_check(result.queued_follow_ups.size() == 1, "approve pizza enqueues follow-up")
	_check(str(result.queued_follow_ups[0]["follow_up"]["decision_id"]) == "cheese_shortage", "pizza follow-up targets cheese_shortage")

	var queue := _make_queue(_make_engine(_make_rng()), _make_rng())
	queue.add_event(result.queued_follow_ups[0], state)
	_check(state.narrative_event_queue.size() == 1, "queue entry stored on state")
	_check(int(state.narrative_event_queue[0]["earliest_day"]) == 5, "earliest day is created + 2")
	_check(int(state.narrative_event_queue[0]["latest_day"]) == 8, "latest day is created + 5")
