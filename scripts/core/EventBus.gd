extends Node

## Global signal hub. Spec: docs/01_CORE_GAMEPLAY_AND_STATE_PRD.md §21.

signal run_started(run_state: RunState)
signal decision_presented(decision: Dictionary)
signal decision_resolved(result: DecisionResult)
signal resources_changed(changes: Dictionary)
signal law_added(law_id: String)
signal law_removed(law_id: String)
signal flag_added(flag_id: String)
signal country_visual_state_changed(state: CountryVisualState)
signal ending_triggered(ending_data: Dictionary)
signal run_ended(summary: RunSummary)
signal run_reset
signal stage_changed(stage_id: String)
signal arc_started(arc_id: String, runtime: Dictionary)
signal arc_advanced(arc_id: String, runtime: Dictionary)
signal arc_completed(arc_id: String, runtime: Dictionary)
signal arc_failed(arc_id: String, runtime: Dictionary)
signal arc_paused(arc_id: String, runtime: Dictionary)
signal crisis_started(crisis_id: String, runtime: Dictionary)
signal crisis_resolved(crisis_id: String, runtime: Dictionary)
signal crisis_failed(crisis_id: String, runtime: Dictionary)
