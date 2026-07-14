extends Node

signal run_started(scenario_id: String)
signal run_ended(ending_id: String)
signal day_advanced(day: int)
signal decision_presented(decision: DecisionData)
signal decision_resolved(decision_id: String, choice_id: String)
signal resources_changed(resources: Dictionary)
signal law_enacted(law: LawData)
signal screen_changed(screen_name: String)
