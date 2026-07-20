#!/usr/bin/env -S godot --headless --path .
extends SceneTree

## Milestone 2B-17 simulation (10000 runs).
## Run: godot --headless --path . -s tests/run_2b17_sim_10k.gd

const CANONICAL_LAWS: Array[String] = [
	"window_tax", "umbrella_tax", "free_pizza_friday", "coupon_salaries", "luxury_chair_tax",
	"national_lottery_budget", "coin_rounding_act", "emergency_cheese_bonds",
	"mandatory_smiling", "national_bedtime", "three_day_weekend", "national_nap_hour",
	"national_coffee_reserve", "compliment_quota_law", "universal_birthday", "queue_etiquette_law",
	"tank_traffic_control", "mandatory_marching", "pigeon_air_force", "palace_curfew_act",
	"border_parade_act", "emergency_salute_law",
	"ministry_of_memes", "weather_optimism_act", "mandatory_applause", "one_headline_policy",
	"public_rumor_license", "national_reality_show",
	"artificial_sun_program", "robot_civil_service", "antigravity_transit", "moon_replacement_research",
	"clone_holiday", "ai_cabinet_pilot",
	"privatize_air", "corporate_capital_naming", "sponsored_potholes_act", "rent_a_ministry",
	"palace_subscription_plan",
	"form_request_form_act", "ministry_of_waiting", "triple_stamp_requirement", "complaint_permit_act",
	"national_filing_week",
	"cat_voting_rights", "fish_market_subsidy_act", "antivacuum_act", "cat_parliament_seats",
	"mouse_protection_law", "official_nap_zones",
]

const SECRETS: Array[String] = [
	"toaster_elected_president", "wrong_map_republic", "palace_micronation",
	"forms_become_citizens", "cat_republic", "accidental_moon_replacement",
]


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var combined_counts: Dictionary = {}
	var combined_endings: Dictionary = {}
	var combined_laws: Dictionary = {}
	var total_exhaustion: int = 0
	var total_fallback: int = 0
	var total_medals: float = 0.0
	var medal_samples: int = 0
	var strategies: Array[String] = ["random", "first"]
	var per_strategy: int = 5000
	for strategy_name in strategies:
		var config := SimulationConfig.new()
		config.run_count = per_strategy
		config.base_seed = 20260717 if strategy_name == "random" else 20260718
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
		var law_freq: Dictionary = sim.get("law_activation_counts", {})
		if law_freq.is_empty():
			law_freq = sim.get("laws_activated", {})
		for lid in law_freq:
			combined_laws[lid] = int(combined_laws.get(lid, 0)) + int(law_freq[lid])
		var medals: Variant = sim.get("average_medals_earned", sim.get("medals_earned_average", 0))
		if float(medals) > 0.0:
			total_medals += float(medals)
			medal_samples += 1
		if report.export_paths.has("json"):
			print("JSON export: %s" % report.export_paths["json"])

	print("=== 2B-17 Final Combined (10000 runs) ===")
	print("Content exhaustion: %d" % total_exhaustion)
	print("Fallback usage: %d" % total_fallback)
	if medal_samples > 0:
		print("Avg medals (strategy mean): %.2f" % (total_medals / float(medal_samples)))

	var never_laws: Array[String] = []
	for lid in CANONICAL_LAWS:
		var c: int = int(combined_laws.get(lid, 0))
		print("Law %s activations=%d" % [lid, c])
		if c <= 0:
			never_laws.append(lid)
	print("Laws never activated: %s" % str(never_laws))

	var never_endings: Array[String] = []
	for eid in combined_endings.keys():
		pass
	# Check collectible endings from repo via counts
	print("Ending distribution: %s" % str(combined_endings))
	for secret_id in SECRETS:
		print("Secret ending %s count=%d" % [secret_id, int(combined_endings.get(secret_id, 0))])

	# Decision class stability signal
	print("Decision selection sample size keys=%d" % combined_counts.size())
	quit(0)
