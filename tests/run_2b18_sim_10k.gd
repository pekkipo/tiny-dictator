#!/usr/bin/env -S godot --headless --path .
extends SceneTree

## Milestone 2B-18 full-library simulation (10000 runs, 5 strategies).
## Run: godot --headless --path . -s tests/run_2b18_sim_10k.gd

const STRATEGIES: Array[String] = [
	"random",
	"resource_preserver",
	"power_maximizer",
	"chaotic_explorer",
	"happiness_populist",
]
const RUNS_PER_STRATEGY: int = 2000
const BASE_SEEDS: Dictionary = {
	"random": 20260720,
	"resource_preserver": 20260721,
	"power_maximizer": 20260722,
	"chaotic_explorer": 20260723,
	"happiness_populist": 20260724,
}


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var combined: Dictionary = {
		"run_count": 0,
		"total_cards_selected": 0,
		"content_exhaustion_count": 0,
		"fallback_card_usage": 0,
		"day40_reaches": 0,
		"special_endings": 0,
		"generic_failures": 0,
		"run_lengths": [],
		"ending_distribution": {},
		"ending_by_strategy": {},
		"decision_selection_counts": {},
		"option_selection_counts": {},
		"arc_start_rates_acc": {},
		"arc_completion_rates_acc": {},
		"crisis_activation_counts": {},
		"law_activation_counts": {},
		"advisor_appearance_distribution": {},
		"recovery_selection_counts": {},
		"seeds": [],
		"strategies": {},
		"unique_ratio_sum": 0.0,
		"unique_ratio_samples": 0,
		"same_advisor_triple_events": 0,
		"advisor_sequences": 0,
		"medals_sum": 0.0,
		"medal_samples": 0,
		"repeated_content_frequency": 0,
		"palace_affordable_sum": 0.0,
	}

	var strategy_index: int = 0
	for strategy_name in STRATEGIES:
		var config := SimulationConfig.new()
		config.run_count = RUNS_PER_STRATEGY
		config.base_seed = int(BASE_SEEDS.get(strategy_name, 20260720 + strategy_index))
		config.choice_strategy_name = strategy_name
		config.include_static_diagnostics = strategy_name == "random"
		config.export_report = false
		var simulator := RunSimulator.new(game_manager)
		var report: SimulationReport = simulator.run_batch(config)
		var sim: Dictionary = report.simulation
		combined["strategies"][strategy_name] = {
			"run_count": int(sim.get("run_count", 0)),
			"base_seed": config.base_seed,
			"seeds": sim.get("seeds", []),
			"run_length": sim.get("run_length", {}),
			"content_exhaustion_count": int(sim.get("content_exhaustion_count", 0)),
			"fallback_card_usage": int(sim.get("fallback_card_usage", 0)),
			"fallback_card_share": float(sim.get("fallback_card_share", 0.0)),
			"day40_reach_rate": float(sim.get("day40_reach_rate", 0.0)),
			"special_ending_share": float(sim.get("special_ending_share", 0.0)),
			"generic_resource_failure_share": float(sim.get("generic_resource_failure_share", 0.0)),
			"average_unique_card_ratio": float(sim.get("average_unique_card_ratio", 0.0)),
			"ending_distribution": sim.get("ending_distribution", {}),
			"arc_start_rates": sim.get("arc_start_rates", {}),
			"arc_completion_rates": sim.get("arc_completion_rates", {}),
		}
		combined["ending_by_strategy"][strategy_name] = sim.get("ending_distribution", {})
		_merge_counts(combined["ending_distribution"], sim.get("ending_distribution", {}))
		_merge_counts(combined["decision_selection_counts"], sim.get("decision_selection_counts", {}))
		_merge_counts(combined["option_selection_counts"], sim.get("option_selection_counts", {}))
		_merge_counts(combined["crisis_activation_counts"], sim.get("crisis_activation_counts", {}))
		_merge_counts(combined["law_activation_counts"], sim.get("law_activation_counts", {}))
		_merge_counts(combined["advisor_appearance_distribution"], sim.get("advisor_appearance_distribution", {}))
		_merge_counts(combined["recovery_selection_counts"], sim.get("recovery_selection_counts", {}))
		combined["run_count"] = int(combined["run_count"]) + int(sim.get("run_count", 0))
		combined["total_cards_selected"] = int(combined["total_cards_selected"]) + int(sim.get("total_cards_selected", 0))
		combined["content_exhaustion_count"] = int(combined["content_exhaustion_count"]) + int(sim.get("content_exhaustion_count", 0))
		combined["fallback_card_usage"] = int(combined["fallback_card_usage"]) + int(sim.get("fallback_card_usage", 0))
		combined["day40_reaches"] = int(combined["day40_reaches"]) + int(round(float(sim.get("day40_reach_rate", 0.0)) * float(sim.get("run_count", 0))))
		combined["special_endings"] = int(combined["special_endings"]) + int(round(float(sim.get("special_ending_share", 0.0)) * float(sim.get("run_count", 0))))
		combined["generic_failures"] = int(combined["generic_failures"]) + int(round(float(sim.get("generic_resource_failure_share", 0.0)) * float(sim.get("run_count", 0))))
		combined["unique_ratio_sum"] = float(combined["unique_ratio_sum"]) + float(sim.get("average_unique_card_ratio", 0.0))
		combined["unique_ratio_samples"] = int(combined["unique_ratio_samples"]) + 1
		combined["same_advisor_triple_events"] = int(combined["same_advisor_triple_events"]) + int(sim.get("same_advisor_triple_events", 0))
		combined["repeated_content_frequency"] = int(combined["repeated_content_frequency"]) + int(sim.get("repeated_content_frequency", 0))
		combined["medals_sum"] = float(combined["medals_sum"]) + float(sim.get("average_medals_earned", 0.0))
		combined["medal_samples"] = int(combined["medal_samples"]) + 1
		combined["palace_affordable_sum"] = float(combined["palace_affordable_sum"]) + float(sim.get("average_palace_upgrades_affordable", 0.0))
		for seed_value in sim.get("seeds", []):
			combined["seeds"].append(seed_value)
		var rl: Dictionary = sim.get("run_length", {})
		combined["run_lengths"].append({
			"strategy": strategy_name,
			"average": float(rl.get("average", 0.0)),
			"min": int(rl.get("min", 0)),
			"median": float(rl.get("median", 0.0)),
			"p25": float(rl.get("p25", 0.0)),
			"p75": float(rl.get("p75", 0.0)),
			"p90": float(rl.get("p90", 0.0)),
			"max": int(rl.get("max", 0)),
		})
		# Accumulate arc rates (average later)
		_merge_float_counts(combined["arc_start_rates_acc"], sim.get("arc_start_rates", {}))
		_merge_float_counts(combined["arc_completion_rates_acc"], sim.get("arc_completion_rates", {}))
		print("=== Strategy '%s' (%d runs) seed=%d ===" % [strategy_name, RUNS_PER_STRATEGY, config.base_seed])
		print("Exhaustion=%d Fallback=%d share=%.4f AvgLen=%.1f Day40=%.1f%% Special=%.1f%% GenericFail=%.1f%% Unique=%.1f%%" % [
			int(sim.get("content_exhaustion_count", 0)),
			int(sim.get("fallback_card_usage", 0)),
			float(sim.get("fallback_card_share", 0.0)),
			float(rl.get("average", 0.0)),
			float(sim.get("day40_reach_rate", 0.0)) * 100.0,
			float(sim.get("special_ending_share", 0.0)) * 100.0,
			float(sim.get("generic_resource_failure_share", 0.0)) * 100.0,
			float(sim.get("average_unique_card_ratio", 0.0)) * 100.0,
		])
		if strategy_name == "random" and not report.static_diagnostics.is_empty():
			combined["static_diagnostics"] = report.static_diagnostics
		strategy_index += 1

	var total_runs: int = maxi(1, int(combined["run_count"]))
	var total_cards: int = maxi(1, int(combined["total_cards_selected"]))
	var never_selected: Array = _never_selected(game_manager, combined["decision_selection_counts"])
	var final_report := {
		"type": "phase_2b_18_final_simulation",
		"run_count": total_runs,
		"runs_per_strategy": RUNS_PER_STRATEGY,
		"strategies": combined["strategies"],
		"seeds": combined["seeds"],
		"run_length_by_strategy": combined["run_lengths"],
		"ending_distribution": combined["ending_distribution"],
		"ending_distribution_by_strategy": combined["ending_by_strategy"],
		"content_exhaustion_count": combined["content_exhaustion_count"],
		"fallback_card_usage": combined["fallback_card_usage"],
		"fallback_card_share": float(combined["fallback_card_usage"]) / float(total_cards),
		"day40_reach_rate": float(combined["day40_reaches"]) / float(total_runs),
		"special_ending_share": float(combined["special_endings"]) / float(total_runs),
		"generic_resource_failure_share": float(combined["generic_failures"]) / float(total_runs),
		"average_unique_card_ratio": float(combined["unique_ratio_sum"]) / float(maxi(1, int(combined["unique_ratio_samples"]))),
		"same_advisor_triple_events": combined["same_advisor_triple_events"],
		"repeated_content_frequency": combined["repeated_content_frequency"],
		"average_medals_earned": float(combined["medals_sum"]) / float(maxi(1, int(combined["medal_samples"]))),
		"average_palace_upgrades_affordable": float(combined["palace_affordable_sum"]) / float(maxi(1, int(combined["medal_samples"]))),
		"decision_selection_counts": combined["decision_selection_counts"],
		"option_selection_counts": combined["option_selection_counts"],
		"decisions_never_selected": never_selected,
		"crisis_activation_counts": combined["crisis_activation_counts"],
		"law_activation_counts": combined["law_activation_counts"],
		"advisor_appearance_distribution": combined["advisor_appearance_distribution"],
		"recovery_selection_counts": combined["recovery_selection_counts"],
		"arc_start_rates_sum": combined["arc_start_rates_acc"],
		"arc_completion_rates_sum": combined["arc_completion_rates_acc"],
		"static_diagnostics": combined.get("static_diagnostics", {}),
		"targets": {
			"content_exhaustion": 0,
			"fallback_card_share_max": 0.01,
			"avg_run_length_min": 18,
			"avg_run_length_max": 30,
			"day40_min": 0.08,
			"day40_max": 0.20,
			"special_ending_min": 0.25,
			"special_ending_max": 0.45,
			"generic_failure_min": 0.40,
			"generic_failure_max": 0.65,
			"never_selected_ordinary_max": 0.03,
			"unique_card_ratio_min": 0.95,
			"approved_decisions": 330,
		},
	}

	# Average arc rates across strategies
	var arc_start_avg: Dictionary = {}
	var arc_complete_avg: Dictionary = {}
	for arc_id in combined["arc_start_rates_acc"]:
		arc_start_avg[arc_id] = float(combined["arc_start_rates_acc"][arc_id]) / float(STRATEGIES.size())
	for arc_id in combined["arc_completion_rates_acc"]:
		arc_complete_avg[arc_id] = float(combined["arc_completion_rates_acc"][arc_id]) / float(STRATEGIES.size())
	final_report["arc_start_rates"] = arc_start_avg
	final_report["arc_completion_rates"] = arc_complete_avg

	print("=== 2B-18 Final Combined (%d runs) ===" % total_runs)
	print("Exhaustion=%d Fallback=%d share=%.4f Day40=%.1f%% Special=%.1f%% GenericFail=%.1f%% Unique=%.1f%% NeverSelected=%d" % [
		int(final_report["content_exhaustion_count"]),
		int(final_report["fallback_card_usage"]),
		float(final_report["fallback_card_share"]),
		float(final_report["day40_reach_rate"]) * 100.0,
		float(final_report["special_ending_share"]) * 100.0,
		float(final_report["generic_resource_failure_share"]) * 100.0,
		float(final_report["average_unique_card_ratio"]) * 100.0,
		never_selected.size(),
	])

	SimulationReport._ensure_diagnostics_dir()
	var json_path := "user://diagnostics/phase_2b_18_final_simulation.json"
	var text_path := "user://diagnostics/phase_2b_18_final_simulation.txt"
	var json_file := FileAccess.open(json_path, FileAccess.WRITE)
	if json_file != null:
		json_file.store_string(JSON.stringify(final_report, "\t"))
		json_file.close()
	var text_file := FileAccess.open(text_path, FileAccess.WRITE)
	if text_file != null:
		text_file.store_string(_format_text(final_report))
		text_file.close()
	print("Exported %s" % json_path)
	print("Exported %s" % text_path)
	print("Absolute: %s" % ProjectSettings.globalize_path(json_path))
	quit(0)


func _merge_counts(dst: Dictionary, src: Dictionary) -> void:
	for key in src:
		dst[key] = int(dst.get(key, 0)) + int(src[key])


func _merge_float_counts(dst: Dictionary, src: Dictionary) -> void:
	for key in src:
		dst[key] = float(dst.get(key, 0.0)) + float(src[key])


func _never_selected(game_manager: Node, counts: Dictionary) -> Array:
	var content: ContentRepository = game_manager.get_content()
	var never_selected: Array = []
	for decision in content.get_all_decisions_for_country("ministan"):
		var id: String = str(decision.get("id", ""))
		if id.is_empty() or bool(decision.get("debug_only", false)) or bool(decision.get("fallback", false)):
			continue
		if not counts.has(id):
			never_selected.append(id)
	never_selected.sort()
	return never_selected


func _format_text(report: Dictionary) -> String:
	var lines: PackedStringArray = []
	lines.append("Tiny Dictator — Phase 2B-18 Final Simulation")
	lines.append("Runs: %d" % int(report.get("run_count", 0)))
	lines.append("Content exhaustion: %d" % int(report.get("content_exhaustion_count", 0)))
	lines.append("Fallback usage: %d (share %.4f)" % [
		int(report.get("fallback_card_usage", 0)),
		float(report.get("fallback_card_share", 0.0)),
	])
	lines.append("Day 40 reach: %.1f%%" % (float(report.get("day40_reach_rate", 0.0)) * 100.0))
	lines.append("Special endings: %.1f%%" % (float(report.get("special_ending_share", 0.0)) * 100.0))
	lines.append("Generic resource failure: %.1f%%" % (float(report.get("generic_resource_failure_share", 0.0)) * 100.0))
	lines.append("Avg unique-card ratio: %.1f%%" % (float(report.get("average_unique_card_ratio", 0.0)) * 100.0))
	lines.append("Never selected decisions: %d" % int(report.get("decisions_never_selected", []).size()))
	lines.append("")
	lines.append("Run length by strategy:")
	for entry in report.get("run_length_by_strategy", []):
		lines.append("  %s avg=%.1f median=%.1f min=%d max=%d" % [
			entry.get("strategy", ""),
			float(entry.get("average", 0.0)),
			float(entry.get("median", 0.0)),
			int(entry.get("min", 0)),
			int(entry.get("max", 0)),
		])
	return "\n".join(lines)
