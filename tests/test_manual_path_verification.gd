extends SceneTree

## Phase 2A-10 manual-path verification via GameManager debug APIs.
## Mirrors the editor debug-overlay checklist in headless form.
## Run: godot --headless --path . -s tests/test_manual_path_verification.gd

const REQUIRED_ARCS: Array[String] = [
	"cat_politics", "traffic_military", "mandatory_happiness",
	"general_boom_arc", "doctor_maybe_arc",
]
const REQUIRED_CRISES: Array[String] = [
	"national_power_outage", "cheese_shortage_crisis", "mass_protest",
	"bank_run", "cat_parliament_occupation",
]
const SPECIAL_ENDINGS: Array[String] = [
	"cat_republic", "nation_in_darkness", "eternal_smile_state",
	"general_boom_coup", "accidental_moon_replacement",
]

var _failures: int = 0
var _gm: Node


func _initialize() -> void:
	await process_frame
	_gm = root.get_node("GameManager")
	_gm.start_new_run()

	_test_arc_debug_paths()
	_test_crisis_debug_paths()
	_test_queue_paths()
	_test_recovery_bias()
	_test_advisor_affinity_gates()
	_test_ruler_traits()
	_test_special_endings_force()
	_test_meta_separate_from_run()
	_test_restart_stability()
	_test_data_only_reload()

	if _failures == 0:
		print("[TEST] All manual path verification tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_arc_debug_paths() -> void:
	for arc_id in REQUIRED_ARCS:
		_gm.restart_run()
		_check(_gm.debug_start_arc(arc_id), "debug can start arc '%s'" % arc_id)
		_check(_gm.debug_advance_arc(arc_id), "debug can advance arc '%s'" % arc_id)
		_check(_gm.debug_complete_arc(arc_id), "debug can complete arc '%s'" % arc_id)
		var state: RunState = _gm.get_current_state()
		_check(arc_id in state.completed_arc_ids, "arc '%s' recorded completed" % arc_id)


func _test_crisis_debug_paths() -> void:
	for crisis_id in REQUIRED_CRISES:
		_gm.restart_run()
		_check(_gm.debug_force_crisis(crisis_id), "debug can force crisis '%s'" % crisis_id)
		var crisis_state: Dictionary = _gm.debug_get_crisis_state()
		_check(str(crisis_state.get("crisis_id", "")) == crisis_id, "crisis '%s' active" % crisis_id)
		_check(_gm.debug_resolve_crisis(crisis_id), "debug can resolve crisis '%s'" % crisis_id)


func _test_queue_paths() -> void:
	_gm.restart_run()
	var event_id := "evt_manual_test"
	_check(_gm.debug_add_queued_event(
		event_id, "free_pizza_hangover", 3, 8, 70, {}, ["cancelled_flag"]
	), "debug can enqueue soft follow-up")
	var queue: Array = _gm.debug_get_queue_state()
	_check(not queue.is_empty(), "queue has pending event")
	_check(_gm.debug_cancel_queued_event(event_id), "debug can cancel queued event")
	_check(_gm.debug_get_queue_state().is_empty(), "queue empty after cancel")

	_gm.restart_run()
	_check(_gm.debug_add_queued_event(event_id, "cheese_shortage", 2, 6, 60), "debug can enqueue pool/hard event")
	_check(_gm.debug_force_queued_event(event_id), "debug can force queued event")


func _test_recovery_bias() -> void:
	_gm.restart_run()
	_gm.debug_set_resource("treasury", 20)
	_gm.debug_advance_day()
	var request: Dictionary = _gm.debug_get_last_content_request()
	_check(str(request.get("request_type", "")) in ["recovery", "normal"],
		"low treasury produces recovery-aware request (got %s)" % request.get("request_type", ""))


func _test_advisor_affinity_gates() -> void:
	_gm.restart_run()
	_gm.debug_set_advisor_affinity("general_boom", 3)
	var state: RunState = _gm.get_current_state()
	_check(state.get_advisor_affinity("general_boom") == 3, "affinity set via debug")
	_check(_gm.debug_get_advisor_affinity().get("general_boom", 0) == 3, "affinity visible in debug readout")


func _test_ruler_traits() -> void:
	_gm.restart_run()
	_check(_gm.debug_change_trait("authoritarian", 2), "debug can change ruler trait")
	_check(_gm.debug_get_ruler_traits().get("authoritarian", 0) == 2, "trait visible in debug readout")


func _test_special_endings_force() -> void:
	for ending_id in SPECIAL_ENDINGS:
		_gm.restart_run()
		_gm.debug_trigger_ending(ending_id)
		var state: RunState = _gm.get_current_state()
		_check(state.run_phase == RunState.RunPhase.ENDED, "ending '%s' ends run" % ending_id)
		_check(_gm.get_last_summary().ending_id == ending_id, "ending id '%s' recorded" % ending_id)


func _test_meta_separate_from_run() -> void:
	var meta: Node = root.get_node("MetaProgressionManager")
	var medals_before: int = meta.get_medals()
	_gm.restart_run()
	_gm.debug_trigger_ending("bankrupt_leader")
	var medals_after: int = meta.get_medals()
	_check(medals_after >= medals_before, "meta medals update on run end")
	_gm.restart_run()
	var state: RunState = _gm.get_current_state()
	_check(state.day == 1, "restart resets run state")
	_check(meta.get_medals() == medals_after, "restart preserves meta medals")


func _test_restart_stability() -> void:
	for i in range(3):
		_gm.restart_run()
		var state: RunState = _gm.get_current_state()
		_check(state.run_phase == RunState.RunPhase.AWAITING_DECISION, "restart %d awaiting decision" % i)
		_check(state.active_arcs.is_empty(), "restart %d clears arcs" % i)
		_check(state.narrative_event_queue.is_empty(), "restart %d clears queue" % i)
		_check(state.active_crisis.is_empty(), "restart %d clears crisis" % i)


func _test_data_only_reload() -> void:
	var before_count: int = _gm.get_content().get_all_decisions_for_country("ministan").size()
	_gm.reload_content()
	var after_count: int = _gm.get_content().get_all_decisions_for_country("ministan").size()
	_check(after_count == before_count, "reload content preserves decision count (%d)" % after_count)
	_check(_gm.get_content().has_arc("cat_politics"), "reload content keeps arcs")
