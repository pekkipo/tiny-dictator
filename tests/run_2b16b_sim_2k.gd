extends SceneTree

## Milestone 2B-16B endgame pack simulation (2000 runs).
## Run: godot --headless --path . -s tests/run_2b16b_sim_2k.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 2000
	config.base_seed = 20260725
	config.include_static_diagnostics = true
	config.export_report = true
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	print("=== 2B-16B Endgame Simulation (2000 runs) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	var counts: Dictionary = sim.get("decision_selection_counts", {})
	var pack: Array[String] = [
		"endgame_succession_debate", "endgame_final_audit", "endgame_profit_zero_ownership",
		"endgame_cabinet_loyalty_ledger", "endgame_peaceful_democracy_seal",
		"endgame_scientific_golden_age", "endgame_climax_cat_servant",
		"endgame_climax_technocratic_accident", "endgame_secret_palace_micronation",
		"endgame_secret_forms_awaken",
	]
	var missing: Array[String] = []
	for id in pack:
		var c: int = int(counts.get(id, 0))
		print("Endgame %s count=%d" % [id, c])
		if c <= 0:
			missing.append(id)
	print("Pack B never selected: %s" % str(missing))
	var ordinary: Array[String] = [
		"endgame_succession_debate", "endgame_final_audit", "endgame_profit_zero_ownership",
		"endgame_cabinet_loyalty_ledger", "endgame_peaceful_democracy_seal",
		"endgame_scientific_golden_age", "endgame_climax_cat_servant",
		"endgame_climax_technocratic_accident",
	]
	var ordinary_missing: Array[String] = []
	for id in ordinary:
		if int(counts.get(id, 0)) <= 0:
			ordinary_missing.append(id)
	print("Ordinary Pack B never selected: %s" % str(ordinary_missing))
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	quit(0 if ordinary_missing.is_empty() else 1)
