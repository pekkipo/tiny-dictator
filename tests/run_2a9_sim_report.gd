extends SceneTree

## One-off 2A-9 simulation report exporter.
## Run: godot --headless --path . -s tests/run_2a9_sim_report.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 1000
	config.base_seed = 20260715
	config.include_static_diagnostics = true
	config.export_report = true

	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation

	print("=== 2A-9 Simulation Report (1000 runs) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	print("Arc start rates: %s" % str(sim.get("arc_start_rates", {})))
	print("Arc completion rates: %s" % str(sim.get("arc_completion_rates", {})))
	print("Ending distribution: %s" % str(sim.get("ending_distribution", {})))
	print("Ruler identity distribution: %s" % str(sim.get("ruler_identity_distribution", {})))
	print("Decisions never selected: %s" % str(sim.get("decisions_never_selected", [])))
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	if report.export_paths.has("text"):
		print("Text export: %s" % report.export_paths["text"])

	var diagnostics: Dictionary = report.static_diagnostics
	print("Static diagnostics total findings: %d" % int(diagnostics.get("summary", {}).get("total_findings", 0)))
	quit(0)
