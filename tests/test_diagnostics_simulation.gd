extends SceneTree

## Milestone 2A-8 diagnostics and simulation tests.
## Run: godot --headless --path . -s tests/test_diagnostics_simulation.gd

const FIXTURE_PATH: String = "res://tests/fixtures/diagnostics_graph.json"

var _failures: int = 0


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var save_manager: Node = root.get_node("SaveManager")

	_test_save_not_mutated(game_manager, save_manager)
	_test_deterministic_fixed_seed(game_manager)
	_test_report_generation(game_manager)
	_test_simulator_1000_runs(game_manager)
	_test_fixture_unreachable(game_manager)
	_test_fixture_forced_cycle(game_manager)
	_test_fixture_arc_without_resolution(game_manager)
	_test_fixture_dominant_option(game_manager)
	_test_empty_content_handling()
	_test_content_exhaustion_detection(game_manager)

	if _failures == 0:
		print("[TEST] All diagnostics and simulation tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_save_not_mutated(game_manager: Node, save_manager: Node) -> void:
	save_manager.set_medals(42)
	save_manager.set_total_runs_completed(7)
	var before: Dictionary = save_manager.create_snapshot()

	var config := SimulationConfig.new()
	config.run_count = 100
	config.base_seed = 424242
	config.include_static_diagnostics = false
	config.export_report = false

	var simulator := RunSimulator.new(game_manager)
	simulator.run_batch(config)

	var after: Dictionary = save_manager.get_data()
	_check(before == after, "simulation does not mutate real save data")
	_check(save_manager.get_medals() == 42, "medals unchanged after simulation")
	_check(save_manager.get_total_runs_completed() == 7, "total runs unchanged after simulation")


func _test_deterministic_fixed_seed(game_manager: Node) -> void:
	var strategy := SimulationChoiceStrategy.FirstOptionChoiceStrategy.new()
	var config := SimulationConfig.new()
	config.run_count = 5
	config.seed_mode = SimulationConfig.SEED_MODE_FIXED
	config.base_seed = 999001
	config.include_static_diagnostics = false
	config.export_report = false

	var simulator := RunSimulator.new(game_manager)
	var report_a: SimulationReport = simulator.run_batch(config, strategy)
	var report_b: SimulationReport = simulator.run_batch(config, strategy)

	var sim_a: Dictionary = report_a.simulation
	var sim_b: Dictionary = report_b.simulation
	_check(sim_a.get("ending_distribution", {}) == sim_b.get("ending_distribution", {}),
		"fixed seed reproduces ending distribution")
	_check(sim_a.get("decision_selection_counts", {}) == sim_b.get("decision_selection_counts", {}),
		"fixed seed reproduces decision selection counts")


func _test_report_generation(game_manager: Node) -> void:
	var config := SimulationConfig.new()
	config.run_count = 3
	config.base_seed = 123456
	config.include_static_diagnostics = true
	config.export_report = true

	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var payload: Dictionary = report.to_dictionary()

	_check(payload.has("config"), "report has config")
	_check(payload.has("simulation"), "report has simulation block")
	_check(payload["simulation"].has("run_length"), "report has run_length")
	_check(payload["simulation"].has("ending_distribution"), "report has ending_distribution")
	_check(payload["simulation"].has("decisions_never_selected"), "report has decisions_never_selected")
	_check(payload["simulation"].has("content_exhaustion_count"), "report has content_exhaustion_count")
	_check(payload["simulation"].has("fallback_card_usage"), "report has fallback_card_usage")
	_check(payload["simulation"].has("average_medals_earned"), "report has average_medals_earned")
	_check(not report.to_text().is_empty(), "text report is non-empty")
	_check(report.export_paths.has("json"), "json export path recorded")
	_check(report.export_paths.has("text"), "text export path recorded")


func _test_simulator_1000_runs(game_manager: Node) -> void:
	var config := SimulationConfig.new()
	config.run_count = 1000
	config.base_seed = 1000001
	config.include_static_diagnostics = false
	config.export_report = false

	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	_check(int(sim.get("run_count", 0)) == 1000, "1000 runs completed")
	var errors: Array = sim.get("errors", [])
	_check(errors.is_empty(), "1000 runs completed without blocking errors (%d errors)" % errors.size())


func _test_fixture_unreachable(_game_manager: Node) -> void:
	var repo := ContentRepository.load_test_bundle(FIXTURE_PATH)
	var diagnostics := ContentDiagnostics.new()
	var report: Dictionary = diagnostics.analyze(repo, "testland")
	var findings: Array = report["findings"].get("unreachable_decisions", [])
	var ids: Array[String] = []
	for item in findings:
		if item is Dictionary:
			ids.append(str(item.get("id", "")))
	_check("unreachable_island" in ids, "fixture unreachable card detected")


func _test_fixture_forced_cycle(_game_manager: Node) -> void:
	var repo := ContentRepository.load_test_bundle(FIXTURE_PATH)
	var diagnostics := ContentDiagnostics.new()
	var report: Dictionary = diagnostics.analyze(repo, "testland")
	var findings: Array = report["findings"].get("forced_follow_up_cycles", [])
	_check(not findings.is_empty(), "fixture forced-follow-up cycle detected")


func _test_fixture_arc_without_resolution(_game_manager: Node) -> void:
	var repo := ContentRepository.load_test_bundle(FIXTURE_PATH)
	var diagnostics := ContentDiagnostics.new()
	var report: Dictionary = diagnostics.analyze(repo, "testland")
	var findings: Array = report["findings"].get("arcs_no_reachable_resolution", [])
	var ids: Array[String] = []
	for item in findings:
		if item is Dictionary:
			ids.append(str(item.get("id", "")))
	_check("dead_end_arc" in ids, "fixture arc without resolution detected")


func _test_fixture_dominant_option(_game_manager: Node) -> void:
	var repo := ContentRepository.load_test_bundle(FIXTURE_PATH)
	var diagnostics := ContentDiagnostics.new()
	var report: Dictionary = diagnostics.analyze(repo, "testland")
	var findings: Array = report["findings"].get("dominant_choice_options", [])
	var ids: Array[String] = []
	for item in findings:
		if item is Dictionary:
			ids.append(str(item.get("id", "")))
	_check("dominant_card" in ids, "fixture dominant option warning detected")


func _test_empty_content_handling() -> void:
	var repo := ContentRepository.new()
	var diagnostics := ContentDiagnostics.new()
	var report: Dictionary = diagnostics.analyze(repo, "missing_country")
	_check(report.has("findings"), "empty repo returns structured findings")
	_check(report.has("summary"), "empty repo returns summary")
	_check(not report["findings"]["invalid_references"].is_empty(), "missing country flagged")


func _test_content_exhaustion_detection(game_manager: Node) -> void:
	var repo := ContentRepository.load_test_bundle(FIXTURE_PATH)
	game_manager.debug_set_content_repository(repo)

	var config := SimulationConfig.new()
	config.run_count = 5
	config.country_id = "testland"
	config.base_seed = 777001
	config.max_steps_per_run = 20
	config.include_static_diagnostics = false
	config.export_report = false

	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var exhaustion_count: int = int(report.simulation.get("content_exhaustion_count", 0))
	_check(exhaustion_count >= 1, "content exhaustion detected in thin test bundle (%d)" % exhaustion_count)

	game_manager.reload_content()
