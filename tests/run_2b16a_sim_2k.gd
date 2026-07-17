extends SceneTree

## Milestone 2B-16A endgame pack simulation (2000 runs).
## Run: godot --headless --path . -s tests/run_2b16a_sim_2k.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 2000
	config.base_seed = 20260724
	config.include_static_diagnostics = true
	config.export_report = true
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	print("=== 2B-16A Endgame Simulation (2000 runs) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	var counts: Dictionary = sim.get("decision_selection_counts", {})
	var pack: Array[String] = [
		"endgame_media_forms_convergence", "endgame_boom_olga_ceasefire", "endgame_civic_stack_verdict",
		"endgame_legacy_statue", "endgame_beloved_retirement", "endgame_country_somehow_works",
		"endgame_climax_smiling_tyrant", "endgame_climax_spreadsheet_emperor",
		"endgame_secret_toaster_election", "endgame_secret_wrong_map",
	]
	var missing: Array[String] = []
	var early: Array[String] = []
	for id in pack:
		var c: int = int(counts.get(id, 0))
		print("Endgame %s count=%d" % [id, c])
		if c <= 0:
			missing.append(id)
	print("Pack A never selected: %s" % str(missing))
	print("Ending distribution sample: %s" % str(sim.get("ending_distribution", {})))
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	# Secrets may be rare/never in random play; ordinary endgame should appear.
	var ordinary: Array[String] = [
		"endgame_media_forms_convergence", "endgame_boom_olga_ceasefire", "endgame_civic_stack_verdict",
		"endgame_legacy_statue", "endgame_beloved_retirement", "endgame_country_somehow_works",
		"endgame_climax_smiling_tyrant", "endgame_climax_spreadsheet_emperor",
	]
	var ordinary_missing: Array[String] = []
	for id in ordinary:
		if int(counts.get(id, 0)) <= 0:
			ordinary_missing.append(id)
	print("Ordinary endgame never selected: %s" % str(ordinary_missing))
	quit(0 if ordinary_missing.is_empty() else 1)
