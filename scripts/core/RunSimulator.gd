class_name RunSimulator
extends RefCounted

## Headless batch simulator. Drives GameManager without UI and restores save
## after each batch (Phase 2A milestone 2A-8).

const CONTENT_EXHAUSTED_ENDING_ID: String = "content_exhausted"

var _game_manager: Node
var _last_report: SimulationReport = null


func _init(game_manager: Node) -> void:
	_game_manager = game_manager


func _save_manager() -> Node:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return null
	return tree.root.get_node_or_null("SaveManager")


func get_last_report() -> SimulationReport:
	return _last_report


func run_batch(
	config: SimulationConfig,
	strategy: SimulationChoiceStrategy = null,
) -> SimulationReport:
	if strategy == null:
		strategy = SimulationChoiceStrategy.from_name(config.choice_strategy_name)

	var save_manager: Node = _save_manager()
	var save_snapshot: Dictionary = save_manager.create_snapshot()
	save_manager.set_persistence_enabled(false)

	var report := SimulationReport.new_simulation(config.to_dictionary())
	var aggregate := report.simulation
	var errors: Array[String] = []

	_game_manager.begin_simulation_batch(config)

	var run_lengths: Array[int] = []
	var ending_counts: Dictionary = {}
	var identity_counts: Dictionary = {}
	var decision_counts: Dictionary = {}
	var arc_start_counts: Dictionary = {}
	var arc_completion_counts: Dictionary = {}
	var total_completed_arcs: int = 0
	var total_medals: int = 0
	var crisis_runs: int = 0
	var content_exhaustion_count: int = 0
	var fallback_usage: int = 0
	var resource_totals: Dictionary = {}
	for resource_id in RunState.RESOURCE_IDS:
		resource_totals[resource_id] = 0

	var content: ContentRepository = _game_manager.get_content()
	var country: Dictionary = content.get_country(config.country_id)
	var fallback_id: String = str(country.get("fallback_decision_id", ""))

	for run_index in range(config.run_count):
		var run_seed: int = config.get_run_seed(run_index)
		_game_manager.start_simulated_run(config.country_id, run_seed)

		var state: RunState = _game_manager.get_current_state()
		var rng := RandomNumberGenerator.new()
		rng.seed = run_seed

		var steps: int = 0
		var run_had_crisis: bool = false
		var run_arc_starts: Dictionary = {}

		while state.run_phase != RunState.RunPhase.ENDED and steps < config.max_steps_per_run:
			var decision: Dictionary = _game_manager.get_current_decision()
			if decision.is_empty():
				errors.append("Run %d step %d: empty decision before ending." % [run_index + 1, steps])
				break

			var decision_id: String = str(decision.get("id", ""))
			decision_counts[decision_id] = int(decision_counts.get(decision_id, 0)) + 1
			if str(decision.get("card_type", "")) == "crisis":
				run_had_crisis = true
			if decision_id == fallback_id:
				fallback_usage += 1

			var narrative: Variant = decision.get("narrative", {})
			if narrative is Dictionary and bool(narrative.get("starts_arc", false)):
				var arc_id: String = str(narrative.get("arc_id", ""))
				if not arc_id.is_empty():
					run_arc_starts[arc_id] = true

			var option_id: String = strategy.pick_option(decision, state, rng)
			if _game_manager.resolve_choice(option_id) == null:
				errors.append("Run %d step %d: resolve_choice failed for '%s'." % [
					run_index + 1, steps, decision_id,
				])
				break
			_game_manager.continue_after_result()
			steps += 1
			state = _game_manager.get_current_state()

		if state.run_phase != RunState.RunPhase.ENDED:
			errors.append("Run %d did not reach an ending within %d steps." % [
				run_index + 1, config.max_steps_per_run,
			])
			continue

		var summary: RunSummary = _game_manager.get_last_summary()
		if summary == null:
			errors.append("Run %d ended without summary." % (run_index + 1))
			continue

		run_lengths.append(summary.final_day)
		ending_counts[summary.ending_id] = int(ending_counts.get(summary.ending_id, 0)) + 1
		var identity_key: String = summary.ruler_identity_id if not summary.ruler_identity_id.is_empty() else "(none)"
		identity_counts[identity_key] = int(identity_counts.get(identity_key, 0)) + 1
		total_medals += summary.medals_earned
		if summary.ending_id == CONTENT_EXHAUSTED_ENDING_ID:
			content_exhaustion_count += 1
		if run_had_crisis:
			crisis_runs += 1

		for arc_id in run_arc_starts:
			arc_start_counts[arc_id] = int(arc_start_counts.get(arc_id, 0)) + 1
		for arc_id in state.completed_arc_ids:
			arc_completion_counts[arc_id] = int(arc_completion_counts.get(arc_id, 0)) + 1
		total_completed_arcs += state.completed_arc_ids.size()

		for resource_id in RunState.RESOURCE_IDS:
			resource_totals[resource_id] += int(summary.final_resources.get(resource_id, 0))

	_game_manager.end_simulation_batch()

	var completed_runs: int = run_lengths.size()
	aggregate["run_count"] = completed_runs
	if completed_runs > 0:
		var length_sum: int = 0
		var min_length: int = run_lengths[0]
		var max_length: int = run_lengths[0]
		for length in run_lengths:
			length_sum += length
			min_length = mini(min_length, length)
			max_length = maxi(max_length, length)
		aggregate["run_length"] = {
			"average": float(length_sum) / float(completed_runs),
			"min": min_length,
			"max": max_length,
		}
	aggregate["ending_distribution"] = ending_counts
	aggregate["ruler_identity_distribution"] = identity_counts
	aggregate["crisis_frequency"] = crisis_runs
	aggregate["average_completed_arcs"] = float(total_completed_arcs) / float(maxi(1, completed_runs))
	aggregate["content_exhaustion_count"] = content_exhaustion_count
	aggregate["fallback_card_usage"] = fallback_usage
	aggregate["average_medals_earned"] = float(total_medals) / float(maxi(1, completed_runs))
	aggregate["decision_selection_counts"] = decision_counts

	var never_selected: Array[String] = []
	for decision in content.get_all_decisions_for_country(config.country_id):
		var id: String = str(decision.get("id", ""))
		if id.is_empty() or bool(decision.get("debug_only", false)):
			continue
		if bool(decision.get("fallback", false)):
			continue
		if not decision_counts.has(id):
			never_selected.append(id)
	never_selected.sort()
	aggregate["decisions_never_selected"] = never_selected

	var avg_resources: Dictionary = {}
	if completed_runs > 0:
		for resource_id in resource_totals:
			avg_resources[resource_id] = float(resource_totals[resource_id]) / float(completed_runs)
	aggregate["average_final_resources"] = avg_resources

	var arc_start_rates: Dictionary = {}
	var arc_completion_rates: Dictionary = {}
	for arc in content.get_arcs_for_country(config.country_id):
		var arc_id: String = str(arc.get("id", ""))
		arc_start_rates[arc_id] = float(int(arc_start_counts.get(arc_id, 0))) / float(maxi(1, completed_runs))
		arc_completion_rates[arc_id] = float(int(arc_completion_counts.get(arc_id, 0))) / float(maxi(1, completed_runs))
	aggregate["arc_start_rates"] = arc_start_rates
	aggregate["arc_completion_rates"] = arc_completion_rates
	aggregate["errors"] = errors

	if config.include_static_diagnostics:
		var diagnostics := ContentDiagnostics.new()
		report.set_static_diagnostics(diagnostics.analyze(content, config.country_id))

	save_manager.restore_snapshot(save_snapshot)
	save_manager.set_persistence_enabled(true)

	if config.export_report:
		report.export_to_user_diagnostics("simulation")

	_last_report = report
	return report


func run_static_diagnostics(country_id: String = "ministan", export: bool = true) -> SimulationReport:
	var report := SimulationReport.new_static_diagnostics()
	report.config = {"country_id": country_id}
	var content: ContentRepository = _game_manager.get_content()
	var diagnostics := ContentDiagnostics.new()
	report.set_static_diagnostics(diagnostics.analyze(content, country_id))
	if export:
		report.export_to_user_diagnostics("content_diagnostics")
	_last_report = report
	return report
