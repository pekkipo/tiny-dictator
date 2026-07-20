extends SceneTree

## Quick law-activation check after 2B-17 self-gate fixes.
## Run: godot --headless --path . -s tests/run_2b17_law_check_2k.gd

const LAWS: Array[String] = [
	"window_tax", "national_coffee_reserve", "universal_birthday", "moon_replacement_research",
	"privatize_air", "rent_a_ministry", "antivacuum_act",
]


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var config := SimulationConfig.new()
	config.run_count = 2000
	config.base_seed = 20260719
	config.choice_strategy_name = "random"
	config.include_static_diagnostics = false
	config.export_report = false
	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var laws: Dictionary = report.simulation.get("law_activation_counts", {})
	var endings: Dictionary = report.simulation.get("ending_distribution", {})
	var missing: Array[String] = []
	for lid in LAWS:
		var c: int = int(laws.get(lid, 0))
		print("Law %s activations=%d" % [lid, c])
		if c <= 0:
			missing.append(lid)
	print("Missing focus laws: %s" % str(missing))
	print("accidental_moon_replacement=%d moon_new_owner=%d" % [
		int(endings.get("accidental_moon_replacement", 0)),
		int(endings.get("moon_new_owner", 0)),
	])
	print("Avg medals=%.2f Exhaustion=%d Fallback=%d" % [
		float(report.simulation.get("average_medals_earned", 0.0)),
		int(report.simulation.get("content_exhaustion_count", 0)),
		int(report.simulation.get("fallback_card_usage", 0)),
	])
	quit(0 if missing.is_empty() else 1)
