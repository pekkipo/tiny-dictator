extends SceneTree

## Milestone 2B-16 final simulation (10000 runs across available strategies).
## Run: godot --headless --path . -s tests/run_2b16_sim_10k.gd

const PACK: Array[String] = [
	"endgame_media_forms_convergence", "endgame_boom_olga_ceasefire", "endgame_civic_stack_verdict",
	"endgame_legacy_statue", "endgame_beloved_retirement", "endgame_country_somehow_works",
	"endgame_climax_smiling_tyrant", "endgame_climax_spreadsheet_emperor",
	"endgame_secret_toaster_election", "endgame_secret_wrong_map",
	"endgame_succession_debate", "endgame_final_audit", "endgame_profit_zero_ownership",
	"endgame_cabinet_loyalty_ledger", "endgame_peaceful_democracy_seal",
	"endgame_scientific_golden_age", "endgame_climax_cat_servant",
	"endgame_climax_technocratic_accident", "endgame_secret_palace_micronation",
	"endgame_secret_forms_awaken",
]

const SECRETS: Array[String] = [
	"endgame_secret_toaster_election", "endgame_secret_wrong_map",
	"endgame_secret_palace_micronation", "endgame_secret_forms_awaken",
]


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var combined_counts: Dictionary = {}
	var combined_endings: Dictionary = {}
	var total_exhaustion: int = 0
	var total_fallback: int = 0
	var strategies: Array[String] = ["random", "first"]
	var per_strategy: int = 5000
	for strategy_name in strategies:
		var config := SimulationConfig.new()
		config.run_count = per_strategy
		config.base_seed = 20260726 if strategy_name == "random" else 20260727
		config.choice_strategy_name = strategy_name
		config.include_static_diagnostics = strategy_name == "random"
		config.export_report = strategy_name == "random"
		var simulator := RunSimulator.new(game_manager)
		var report: SimulationReport = simulator.run_batch(config)
		var sim: Dictionary = report.simulation
		print("=== Strategy '%s' (%d runs) ===" % [strategy_name, per_strategy])
		print("Exhaustion: %d Fallback: %d Avg length: %.1f" % [
			int(sim.get("content_exhaustion_count", 0)),
			int(sim.get("fallback_card_usage", 0)),
			float(sim.get("run_length", {}).get("average", 0.0)),
		])
		total_exhaustion += int(sim.get("content_exhaustion_count", 0))
		total_fallback += int(sim.get("fallback_card_usage", 0))
		var counts: Dictionary = sim.get("decision_selection_counts", {})
		for id in counts:
			combined_counts[id] = int(combined_counts.get(id, 0)) + int(counts[id])
		var endings: Dictionary = sim.get("ending_distribution", {})
		for eid in endings:
			combined_endings[eid] = int(combined_endings.get(eid, 0)) + int(endings[eid])
		if report.export_paths.has("json"):
			print("JSON export: %s" % report.export_paths["json"])

	print("=== 2B-16 Final Combined (10000 runs) ===")
	print("Content exhaustion: %d" % total_exhaustion)
	print("Fallback usage: %d" % total_fallback)
	var missing: Array[String] = []
	for id in PACK:
		var c: int = int(combined_counts.get(id, 0))
		print("Endgame %s count=%d" % [id, c])
		if c <= 0 and id not in SECRETS:
			missing.append(id)
	print("Ordinary endgame never selected: %s" % str(missing))
	var secret_hits: Dictionary = {}
	for id in SECRETS:
		secret_hits[id] = int(combined_counts.get(id, 0))
	print("Secret selection counts: %s" % str(secret_hits))
	print("Ending distribution: %s" % str(combined_endings))
	quit(0 if missing.is_empty() else 1)
