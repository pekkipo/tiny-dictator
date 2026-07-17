extends SceneTree

## Milestone 2B-14 Sub-batch A simulation (2000 runs).
## Run: godot --headless --path . -s tests/run_2b14a_sim_2k.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 2000
	config.base_seed = 20260717
	config.include_static_diagnostics = true
	config.export_report = true
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	print("=== 2B-14A Simulation (2000 runs) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	print("Crisis frequency: %d" % int(sim.get("crisis_frequency", 0)))
	print("Decisions never selected: %s" % str(sim.get("decisions_never_selected", [])))
	var counts: Dictionary = sim.get("decision_selection_counts", {})
	var pack_a: Array[String] = [
		"national_power_outage", "national_power_outage_resolution",
		"bank_run", "bank_run_resolution",
		"mass_protest", "mass_protest_resolution",
		"palace_fire", "palace_fire_resolution",
		"military_mutiny", "military_mutiny_resolution",
		"government_data_leak", "cat_parliament_occupation",
		"water_supply_turns_blue", "public_transport_strike",
	]
	for id in pack_a:
		print("Pack A %s count=%d" % [id, int(counts.get(id, 0))])
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	quit(0)
