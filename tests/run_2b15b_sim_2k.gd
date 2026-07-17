extends SceneTree

## Milestone 2B-15 Sub-batch B simulation (2000 runs).
## Run: godot --headless --path . -s tests/run_2b15b_sim_2k.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 2000
	config.base_seed = 20260722
	config.include_static_diagnostics = true
	config.export_report = true
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	print("=== 2B-15B Simulation (2000 runs) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	print("Crisis frequency: %d" % int(sim.get("crisis_frequency", 0)))
	print("Decisions never selected: %s" % str(sim.get("decisions_never_selected", [])))
	var counts: Dictionary = sim.get("decision_selection_counts", {})
	var pack_b: Array[String] = [
		"recovery_foreign_picnic_grant", "recovery_austerity_clipboards", "recovery_maybe_miracle_bond",
		"recovery_workers_shift_relief", "recovery_civic_half_day", "recovery_endgame_hope_reel",
		"recovery_whiskers_alley_truce", "recovery_boom_cone_grid", "recovery_endgame_quiet_hours",
		"recovery_prestige_fountain", "recovery_shared_blame_board", "recovery_endgame_title_lottery",
	]
	var missing: Array[String] = []
	for id in pack_b:
		var c: int = int(counts.get(id, 0))
		print("Pack B %s count=%d" % [id, c])
		if c <= 0:
			missing.append(id)
	print("Pack B never selected: %s" % str(missing))
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	quit(0 if missing.is_empty() else 1)
