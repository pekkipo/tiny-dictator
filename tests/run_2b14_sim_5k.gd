extends SceneTree

## Milestone 2B-14 final simulation (5000 runs).
## Run: godot --headless --path . -s tests/run_2b14_sim_5k.gd

func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 5000
	config.base_seed = 20260720
	config.include_static_diagnostics = true
	config.export_report = true
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	print("=== 2B-14 Final Simulation (5000 runs) ===")
	print("Content exhaustion: %d" % int(sim.get("content_exhaustion_count", 0)))
	print("Fallback usage: %d" % int(sim.get("fallback_card_usage", 0)))
	print("Average run length: %.1f" % float(sim.get("run_length", {}).get("average", 0.0)))
	print("Crisis frequency: %d" % int(sim.get("crisis_frequency", 0)))
	print("Ending distribution: %s" % str(sim.get("ending_distribution", {})))
	print("Decisions never selected: %s" % str(sim.get("decisions_never_selected", [])))
	var counts: Dictionary = sim.get("decision_selection_counts", {})
	var all_crisis: Array[String] = [
		"national_power_outage", "national_power_outage_resolution",
		"bank_run", "bank_run_resolution",
		"mass_protest", "mass_protest_resolution",
		"palace_fire", "palace_fire_resolution",
		"military_mutiny", "military_mutiny_resolution",
		"government_data_leak", "cat_parliament_occupation",
		"water_supply_turns_blue", "public_transport_strike",
		"cheese_shortage_crisis", "cheese_shortage_crisis_resolution",
		"international_border_confusion", "international_border_confusion_resolution",
		"bureaucrat_general_strike", "bureaucrat_general_strike_resolution",
		"national_internet_outage", "national_internet_outage_resolution",
		"fake_news_panic", "fake_news_panic_resolution",
		"budget_meltdown_crisis", "ai_cabinet_lockout",
		"moon_ownership_dispute", "national_festival_stampede",
	]
	var missing: Array[String] = []
	for id in all_crisis:
		var n: int = int(counts.get(id, 0))
		print("Crisis card %s count=%d" % [id, n])
		if n <= 0:
			missing.append(id)
	print("Missing activations: %s" % str(missing))
	if report.export_paths.has("json"):
		print("JSON export: %s" % report.export_paths["json"])
	quit(0 if missing.is_empty() else 1)
