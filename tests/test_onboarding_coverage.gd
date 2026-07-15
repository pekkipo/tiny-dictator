extends SceneTree

## Milestone 2B-2 onboarding coverage checks.
## Run: godot --headless --path . -s tests/test_onboarding_coverage.gd

const ONBOARDING_IDS: Array[String] = [
	"palace_roof_leak", "border_parade_dispute", "window_tax_proposal",
	"olga_bridge_repair", "luna_good_news_only", "science_gamble",
	"privatize_palace_garden", "cat_treaty_offer", "bureaucracy_expansion",
	"pantry_moth_crisis",
]

const ALL_CONCEPTS: Array[String] = [
	"resources", "visible_effects", "hidden_consequences", "laws", "advisors",
	"affinity_feedback", "ruler_traits", "delayed_followups", "hard_followups",
	"crises", "endings_replay", "no_perfect_option",
]

var _failures: int = 0


func _initialize() -> void:
	await process_frame
	var repo := ContentRepository.new()
	_check(repo.load_all(), "repository loads")

	_test_onboarding_decisions_exist(repo)
	_test_concept_registry(repo)
	_test_director_bias(repo)
	await _test_first_run_simulation_coverage()
	await _test_restart_preserves_concepts()

	if _failures == 0:
		print("[TEST] All onboarding coverage tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_onboarding_decisions_exist(repo: ContentRepository) -> void:
	for decision_id in ONBOARDING_IDS:
		var decision: Dictionary = repo.get_decision(decision_id)
		_check(not decision.is_empty(), "onboarding decision '%s' exists" % decision_id)
		var tags: Array = decision.get("tags", [])
		_check("onboarding" in tags, "'%s' tagged onboarding" % decision_id)


func _test_concept_registry(repo: ContentRepository) -> void:
	var registry: RefCounted = repo.get_onboarding_registry()
	_check(registry.get_all_concept_ids().size() == ALL_CONCEPTS.size(), "concept registry loaded")
	for concept_id in ALL_CONCEPTS:
		_check(concept_id in registry.get_all_concept_ids(), "concept '%s' registered" % concept_id)
		_check(not registry.get_hint_text(concept_id).is_empty(), "hint for '%s'" % concept_id)


func _test_director_bias(repo: ContentRepository) -> void:
	var director = ContentDirector.new(repo)
	var engine := DecisionEngine.new(repo, RandomNumberGenerator.new())
	var state := RunState.new()
	state.country_id = "ministan"
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	state.day = 1
	state.current_stage_id = "establishment"
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)

	var request = director.build_request(state, engine)
	_check(request.request_type == "onboarding", "day 1 fresh run -> onboarding request")
	_check(not request.missing_onboarding_concepts.is_empty(), "missing concepts populated")
	_check(request.onboarding_weight_multiplier >= 2, "onboarding weight multiplier set")

	state.mark_concepts_introduced(ALL_CONCEPTS)
	request = director.build_request(state, engine)
	_check(request.request_type == "standalone", "all concepts taught -> standalone request")


func _test_first_run_simulation_coverage() -> void:
	var game_manager: Node = root.get_node("GameManager")
	var save_manager: Node = root.get_node("SaveManager")
	var snapshot: Dictionary = save_manager.create_snapshot()
	save_manager.restore_snapshot({
		"version": 2,
		"medals": 0,
		"total_runs_completed": 0,
		"unlocked_country_ids": ["ministan"],
		"ending_records": {},
		"palace_upgrades": {},
		"unlocked_endings": [],
		"settings": {"debug_enabled": true},
		"last_run_summary": {},
		"introduced_onboarding_concepts": [],
	})
	save_manager.set_persistence_enabled(false)

	var config := SimulationConfig.new()
	config.run_count = 200
	config.base_seed = 20260715
	config.max_steps_per_run = 40
	config.choice_strategy_name = "random"

	game_manager.begin_simulation_batch(config)
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	game_manager.end_simulation_batch()
	save_manager.set_persistence_enabled(true)
	save_manager.restore_snapshot(snapshot)

	var sim: Dictionary = report.simulation
	var selection_counts: Dictionary = sim.get("decision_selection_counts", {})
	var seen_onboarding: int = 0
	for decision_id in ONBOARDING_IDS:
		if int(selection_counts.get(decision_id, 0)) > 0:
			seen_onboarding += 1
	_check(seen_onboarding == ONBOARDING_IDS.size(), "all onboarding ids selected in 200 runs, got %d/%d" % [
		seen_onboarding, ONBOARDING_IDS.size(),
	])
	_check(int(sim.get("run_count", 0)) == 200, "completed 200 runs")
	_check(int(sim.get("content_exhaustion_count", 0)) == 0, "no content exhaustion in first-run sim")


func _test_restart_preserves_concepts() -> void:
	var game_manager: Node = root.get_node("GameManager")
	game_manager.start_new_run()
	var state: RunState = game_manager.get_current_state()
	state.mark_concepts_introduced(["resources", "laws"])
	game_manager.restart_run()
	var restarted: RunState = game_manager.get_current_state()
	_check(restarted.get_introduced_concepts().is_empty(), "restart clears per-run introduced concepts")
	_check(restarted.day == 1, "restart resets day")
