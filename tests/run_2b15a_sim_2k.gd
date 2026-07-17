extends SceneTree

## Milestone 2B-15 Sub-batch A simulation (2000 runs).
## Run: godot --headless --path . -s tests/run_2b15a_sim_2k.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 2000
	config.base_seed = 20260721
	config.include_static_diagnostics = true
	config.export_report = true
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	print("=== 2B-15A Simulation (2000 runs) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	print("Crisis frequency: %d" % int(sim.get("crisis_frequency", 0)))
	print("Decisions never selected: %s" % str(sim.get("decisions_never_selected", [])))
	var counts: Dictionary = sim.get("decision_selection_counts", {})
	var pack_a: Array[String] = [
		"recovery_international_bank", "recovery_sell_palace_wing", "recovery_emergency_stamp_tax",
		"recovery_national_smile_day", "recovery_olga_soup_line", "recovery_maybe_mood_pilot",
		"recovery_martial_law_pause", "recovery_olga_block_captains", "recovery_zero_queue_charter",
		"recovery_elite_dinner", "recovery_cabinet_nameplates", "recovery_controlled_audit_show",
	]
	var missing: Array[String] = []
	for id in pack_a:
		var c: int = int(counts.get(id, 0))
		print("Pack A %s count=%d" % [id, c])
		if c <= 0:
			missing.append(id)
	print("Pack A never selected: %s" % str(missing))
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	quit(0 if missing.is_empty() else 1)
