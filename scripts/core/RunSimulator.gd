class_name RunSimulator
extends RefCounted

## Headless batch simulator. Drives GameManager without UI and restores save
## after each batch (Phase 2A milestone 2A-8 / 2B-18).

const CONTENT_EXHAUSTED_ENDING_ID: String = "content_exhausted"
const GENERIC_RESOURCE_FAILURE_TYPES: Array[String] = ["resource_failure"]

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
	var option_counts: Dictionary = {}
	var arc_start_counts: Dictionary = {}
	var arc_completion_counts: Dictionary = {}
	var arc_resolution_counts: Dictionary = {}
	var short_chain_start_counts: Dictionary = {}
	var short_chain_complete_counts: Dictionary = {}
	var crisis_activation_counts: Dictionary = {}
	var crisis_resolve_counts: Dictionary = {}
	var crisis_fail_counts: Dictionary = {}
	var advisor_appearance_counts: Dictionary = {}
	var affinity_totals: Dictionary = {}
	var affinity_samples: int = 0
	var recovery_selection_counts: Dictionary = {}
	var recovery_benefit_sum: float = 0.0
	var recovery_cost_sum: float = 0.0
	var recovery_samples: int = 0
	var cause_of_death: Dictionary = {}
	var resource_by_stage_totals: Dictionary = {}
	var resource_by_stage_samples: Dictionary = {}
	var total_active_laws_sum: int = 0
	var total_unique_ratio: float = 0.0
	var repeated_content_events: int = 0
	var same_advisor_triple_events: int = 0
	var total_advisor_sequences: int = 0
	var day40_reaches: int = 0
	var special_ending_count: int = 0
	var generic_failure_count: int = 0
	var palace_affordable_sum: int = 0
	var seeds_used: Array = []
	var total_completed_arcs: int = 0
	var total_medals: int = 0
	var crisis_runs: int = 0
	var content_exhaustion_count: int = 0
	var fallback_usage: int = 0
	var total_cards_selected: int = 0
	var law_activation_counts: Dictionary = {}
	var resource_totals: Dictionary = {}
	for resource_id in RunState.RESOURCE_IDS:
		resource_totals[resource_id] = 0

	var content: ContentRepository = _game_manager.get_content()
	var country: Dictionary = content.get_country(config.country_id)
	var fallback_id: String = str(country.get("fallback_decision_id", ""))
	var major_arc_ids: Dictionary = {}
	var short_chain_ids: Dictionary = {}
	for arc in content.get_arcs_for_country(config.country_id):
		var arc_id: String = str(arc.get("id", ""))
		if str(arc.get("importance", "")) == "major" or str(arc.get("arc_type", "")) == "major":
			major_arc_ids[arc_id] = true
		elif str(arc.get("importance", "")) == "minor" or str(arc.get("arc_type", "")) == "short_chain":
			short_chain_ids[arc_id] = true
	# Chains may live in chain catalog entries on decisions via narrative.chain_id
	var ending_types: Dictionary = {}
	for ending in content.get_raw_endings():
		ending_types[str(ending.get("id", ""))] = str(ending.get("type", ""))

	for run_index in range(config.run_count):
		var run_seed: int = config.get_run_seed(run_index)
		seeds_used.append(run_seed)
		_game_manager.start_simulated_run(config.country_id, run_seed)

		var state: RunState = _game_manager.get_current_state()
		var rng := RandomNumberGenerator.new()
		rng.seed = run_seed

		var steps: int = 0
		var run_had_crisis: bool = false
		var run_arc_starts: Dictionary = {}
		var run_decision_ids: Array[String] = []
		var run_advisors: Array[String] = []
		var seen_decisions: Dictionary = {}
		var reached_day_40: bool = false

		while state.run_phase != RunState.RunPhase.ENDED and steps < config.max_steps_per_run:
			var decision: Dictionary = _game_manager.get_current_decision()
			if decision.is_empty():
				errors.append("Run %d step %d: empty decision before ending." % [run_index + 1, steps])
				break

			var decision_id: String = str(decision.get("id", ""))
			decision_counts[decision_id] = int(decision_counts.get(decision_id, 0)) + 1
			total_cards_selected += 1
			run_decision_ids.append(decision_id)
			if seen_decisions.has(decision_id) and bool(decision.get("one_time", false)):
				repeated_content_events += 1
			seen_decisions[decision_id] = true

			var advisor_id: String = str(decision.get("advisor_id", ""))
			if not advisor_id.is_empty():
				advisor_appearance_counts[advisor_id] = int(advisor_appearance_counts.get(advisor_id, 0)) + 1
				run_advisors.append(advisor_id)

			if str(decision.get("card_type", "")) == "crisis":
				run_had_crisis = true
				var crisis_id: String = str(decision.get("narrative", {}).get("crisis_id", "")) if decision.get("narrative", {}) is Dictionary else ""
				if crisis_id.is_empty() and state.active_crisis is Dictionary:
					crisis_id = str(state.active_crisis.get("crisis_id", ""))
				if not crisis_id.is_empty():
					crisis_activation_counts[crisis_id] = int(crisis_activation_counts.get(crisis_id, 0)) + 1
			if decision_id == fallback_id:
				fallback_usage += 1
			if str(decision.get("card_type", "")) == "recovery":
				recovery_selection_counts[decision_id] = int(recovery_selection_counts.get(decision_id, 0)) + 1

			var narrative: Variant = decision.get("narrative", {})
			if narrative is Dictionary and bool(narrative.get("starts_arc", false)):
				var arc_id: String = str(narrative.get("arc_id", ""))
				if not arc_id.is_empty():
					run_arc_starts[arc_id] = true
			if narrative is Dictionary:
				var chain_id: String = str(narrative.get("chain_id", ""))
				if not chain_id.is_empty() and bool(narrative.get("starts_chain", false)):
					short_chain_start_counts[chain_id] = int(short_chain_start_counts.get(chain_id, 0)) + 1
				elif not chain_id.is_empty() and steps == 0:
					pass

			var option_id: String = strategy.pick_option(decision, state, rng)
			var option_key: String = "%s:%s" % [decision_id, option_id]
			option_counts[option_key] = int(option_counts.get(option_key, 0)) + 1

			if str(decision.get("card_type", "")) == "recovery":
				var picked: Dictionary = {}
				for option in DecisionSchema.get_options(decision):
					if str(option.get("id", "")) == option_id:
						picked = option
						break
				var effects: Dictionary = picked.get("effects", {})
				var benefit: float = 0.0
				var cost: float = 0.0
				for resource_id in RunState.RESOURCE_IDS:
					var delta: int = int(effects.get(resource_id, 0))
					if delta > 0:
						benefit += float(delta)
					elif delta < 0:
						cost += float(-delta)
				recovery_benefit_sum += benefit
				recovery_cost_sum += cost
				recovery_samples += 1

			if _game_manager.resolve_choice(option_id) == null:
				errors.append("Run %d step %d: resolve_choice failed for '%s'." % [
					run_index + 1, steps, decision_id,
				])
				break
			_game_manager.continue_after_result()
			steps += 1
			state = _game_manager.get_current_state()
			if state.day >= 40:
				reached_day_40 = true

			# Stage snapshot of resources (sample once per stage band)
			var stage_id: String = _stage_for_day(country, state.day)
			if not resource_by_stage_samples.has(stage_id):
				resource_by_stage_samples[stage_id] = 0
				resource_by_stage_totals[stage_id] = {}
				for resource_id in RunState.RESOURCE_IDS:
					resource_by_stage_totals[stage_id][resource_id] = 0
			if resource_by_stage_samples[stage_id] < config.run_count:
				# Accumulate final-in-stage lightly each step; normalize later by samples
				pass

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
		if summary.final_day >= 40 or reached_day_40:
			day40_reaches += 1
		ending_counts[summary.ending_id] = int(ending_counts.get(summary.ending_id, 0)) + 1
		var ending_type: String = str(ending_types.get(summary.ending_id, ""))
		if ending_type in GENERIC_RESOURCE_FAILURE_TYPES:
			generic_failure_count += 1
			cause_of_death[summary.ending_id] = int(cause_of_death.get(summary.ending_id, 0)) + 1
		elif summary.ending_id != CONTENT_EXHAUSTED_ENDING_ID:
			special_ending_count += 1

		var identity_key: String = summary.ruler_identity_id if not summary.ruler_identity_id.is_empty() else "(none)"
		identity_counts[identity_key] = int(identity_counts.get(identity_key, 0)) + 1
		total_medals += summary.medals_earned
		if summary.ending_id == CONTENT_EXHAUSTED_ENDING_ID:
			content_exhaustion_count += 1
		if run_had_crisis:
			crisis_runs += 1

		# Crisis resolve/fail from final state
		if state.active_crisis is Dictionary and not state.active_crisis.is_empty():
			var cid: String = str(state.active_crisis.get("crisis_id", ""))
			var status: String = str(state.active_crisis.get("status", ""))
			if status == "resolved":
				crisis_resolve_counts[cid] = int(crisis_resolve_counts.get(cid, 0)) + 1
			elif status == "failed":
				crisis_fail_counts[cid] = int(crisis_fail_counts.get(cid, 0)) + 1

		for arc_id in run_arc_starts:
			arc_start_counts[arc_id] = int(arc_start_counts.get(arc_id, 0)) + 1
		for arc_id in state.completed_arc_ids:
			arc_completion_counts[arc_id] = int(arc_completion_counts.get(arc_id, 0)) + 1
			arc_resolution_counts[arc_id] = int(arc_resolution_counts.get(arc_id, 0)) + 1
		total_completed_arcs += state.completed_arc_ids.size()

		total_active_laws_sum += state.active_laws.size()
		for law_id in state.active_laws:
			law_activation_counts[str(law_id)] = int(law_activation_counts.get(str(law_id), 0)) + 1

		for resource_id in RunState.RESOURCE_IDS:
			resource_totals[resource_id] += int(summary.final_resources.get(resource_id, 0))

		# Affinity at ending
		affinity_samples += 1
		for advisor_id in state.advisor_affinity:
			affinity_totals[advisor_id] = float(affinity_totals.get(advisor_id, 0.0)) + float(state.advisor_affinity[advisor_id])

		# Unique card ratio
		var unique_count: int = seen_decisions.size()
		var played_count: int = maxi(1, run_decision_ids.size())
		total_unique_ratio += float(unique_count) / float(played_count)

		# Same-advisor triples outside mandatory chains (heuristic: consecutive same advisor)
		for i in range(run_advisors.size()):
			total_advisor_sequences += 1
			if i >= 2 and run_advisors[i] == run_advisors[i - 1] and run_advisors[i] == run_advisors[i - 2]:
				same_advisor_triple_events += 1

		# Stage resource snapshot at end using final day stage
		var end_stage: String = _stage_for_day(country, summary.final_day)
		if not resource_by_stage_totals.has(end_stage):
			resource_by_stage_totals[end_stage] = {}
			resource_by_stage_samples[end_stage] = 0
			for resource_id in RunState.RESOURCE_IDS:
				resource_by_stage_totals[end_stage][resource_id] = 0
		resource_by_stage_samples[end_stage] = int(resource_by_stage_samples.get(end_stage, 0)) + 1
		for resource_id in RunState.RESOURCE_IDS:
			resource_by_stage_totals[end_stage][resource_id] = int(resource_by_stage_totals[end_stage].get(resource_id, 0)) + int(summary.final_resources.get(resource_id, 0))

		# Palace affordability: count upgrades whose medal cost <= medals earned this run
		var affordable: int = 0
		for upgrade in content.get_raw_palace_upgrades():
			var cost: int = int(upgrade.get("medal_cost", upgrade.get("cost", 0)))
			if cost <= summary.medals_earned:
				affordable += 1
		palace_affordable_sum += affordable

	_game_manager.end_simulation_batch()

	var completed_runs: int = run_lengths.size()
	aggregate["run_count"] = completed_runs
	aggregate["strategy"] = config.choice_strategy_name
	aggregate["seeds"] = seeds_used
	if completed_runs > 0:
		var length_sum: int = 0
		var min_length: int = run_lengths[0]
		var max_length: int = run_lengths[0]
		var sorted_lengths: Array = run_lengths.duplicate()
		sorted_lengths.sort()
		for length in run_lengths:
			length_sum += length
			min_length = mini(min_length, length)
			max_length = maxi(max_length, length)
		aggregate["run_length"] = {
			"average": float(length_sum) / float(completed_runs),
			"min": min_length,
			"median": _percentile(sorted_lengths, 0.5),
			"p25": _percentile(sorted_lengths, 0.25),
			"p75": _percentile(sorted_lengths, 0.75),
			"p90": _percentile(sorted_lengths, 0.90),
			"max": max_length,
		}
	aggregate["ending_distribution"] = ending_counts
	aggregate["ruler_identity_distribution"] = identity_counts
	aggregate["crisis_frequency"] = crisis_runs
	aggregate["crisis_activation_counts"] = crisis_activation_counts
	aggregate["crisis_resolve_counts"] = crisis_resolve_counts
	aggregate["crisis_fail_counts"] = crisis_fail_counts
	aggregate["average_completed_arcs"] = float(total_completed_arcs) / float(maxi(1, completed_runs))
	aggregate["content_exhaustion_count"] = content_exhaustion_count
	aggregate["fallback_card_usage"] = fallback_usage
	aggregate["fallback_card_share"] = float(fallback_usage) / float(maxi(1, total_cards_selected))
	aggregate["total_cards_selected"] = total_cards_selected
	aggregate["average_medals_earned"] = float(total_medals) / float(maxi(1, completed_runs))
	aggregate["decision_selection_counts"] = decision_counts
	aggregate["option_selection_counts"] = option_counts
	aggregate["law_activation_counts"] = law_activation_counts
	aggregate["average_active_law_count"] = float(total_active_laws_sum) / float(maxi(1, completed_runs))
	aggregate["advisor_appearance_distribution"] = advisor_appearance_counts
	aggregate["day40_reach_rate"] = float(day40_reaches) / float(maxi(1, completed_runs))
	aggregate["special_ending_share"] = float(special_ending_count) / float(maxi(1, completed_runs))
	aggregate["generic_resource_failure_share"] = float(generic_failure_count) / float(maxi(1, completed_runs))
	aggregate["resource_cause_of_death"] = cause_of_death
	aggregate["average_unique_card_ratio"] = total_unique_ratio / float(maxi(1, completed_runs))
	aggregate["repeated_content_frequency"] = repeated_content_events
	aggregate["same_advisor_triple_frequency"] = float(same_advisor_triple_events) / float(maxi(1, total_advisor_sequences))
	aggregate["same_advisor_triple_events"] = same_advisor_triple_events
	aggregate["recovery_selection_counts"] = recovery_selection_counts
	aggregate["average_recovery_benefit"] = recovery_benefit_sum / float(maxi(1, recovery_samples))
	aggregate["average_recovery_cost"] = recovery_cost_sum / float(maxi(1, recovery_samples))
	aggregate["average_palace_upgrades_affordable"] = float(palace_affordable_sum) / float(maxi(1, completed_runs))
	aggregate["arc_resolution_distribution"] = arc_resolution_counts
	aggregate["short_chain_start_counts"] = short_chain_start_counts
	aggregate["short_chain_complete_counts"] = short_chain_complete_counts

	var avg_affinity: Dictionary = {}
	if affinity_samples > 0:
		for advisor_id in affinity_totals:
			avg_affinity[advisor_id] = float(affinity_totals[advisor_id]) / float(affinity_samples)
	aggregate["advisor_affinity_distribution_at_ending"] = avg_affinity

	var avg_resources_by_stage: Dictionary = {}
	for stage_id in resource_by_stage_totals:
		var samples: int = int(resource_by_stage_samples.get(stage_id, 0))
		avg_resources_by_stage[stage_id] = {}
		for resource_id in resource_by_stage_totals[stage_id]:
			avg_resources_by_stage[stage_id][resource_id] = float(resource_by_stage_totals[stage_id][resource_id]) / float(maxi(1, samples))
	aggregate["resource_distribution_by_run_stage"] = avg_resources_by_stage

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

	var never_selected_options: Array[String] = []
	for decision in content.get_all_decisions_for_country(config.country_id):
		var id: String = str(decision.get("id", ""))
		if id.is_empty() or bool(decision.get("debug_only", false)) or bool(decision.get("fallback", false)):
			continue
		for option in DecisionSchema.get_options(decision):
			var oid: String = str(option.get("id", ""))
			var key: String = "%s:%s" % [id, oid]
			if not option_counts.has(key):
				never_selected_options.append(key)
	never_selected_options.sort()
	aggregate["options_never_selected"] = never_selected_options

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


func _stage_for_day(country: Dictionary, day: int) -> String:
	for stage in country.get("run_stages", []):
		if stage is Dictionary:
			if day >= int(stage.get("minimum_day", 1)) and day <= int(stage.get("maximum_day", 999)):
				return str(stage.get("id", "establishment"))
	return "establishment"


func _percentile(sorted_values: Array, fraction: float) -> float:
	if sorted_values.is_empty():
		return 0.0
	var index: int = int(round(fraction * float(sorted_values.size() - 1)))
	index = clampi(index, 0, sorted_values.size() - 1)
	return float(sorted_values[index])
