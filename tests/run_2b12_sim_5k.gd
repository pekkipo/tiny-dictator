extends SceneTree

## Milestone 2B-12 Pack C final simulation (5000 runs).
## Run: godot --headless --path . -s tests/run_2b12_sim_5k.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 5000
	config.base_seed = 20260718
	config.include_static_diagnostics = true
	config.export_report = true
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	print("=== 2B-12 Final Simulation (5000 runs, Random) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	print("Arc start rates: %s" % str(sim.get("arc_start_rates", {})))
	print("Arc completion rates: %s" % str(sim.get("arc_completion_rates", {})))
	print("Ending distribution: %s" % str(sim.get("ending_distribution", {})))
	print("Decisions never selected: %s" % str(sim.get("decisions_never_selected", [])))
	print("Crisis frequency: %d" % int(sim.get("crisis_frequency", 0)))
	print("Avg completed arcs: %.2f" % float(sim.get("average_completed_arcs", 0.0)))
	print("Advisor concentration: %s" % str(sim.get("advisor_concentration", {})))
	print("Stage concentration: %s" % str(sim.get("stage_concentration", {})))
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	quit(0)
