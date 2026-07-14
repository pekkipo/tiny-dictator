extends Node

enum Screen {
	START,
	GAME,
	RUN_END,
	COLLECTION,
	PALACE,
}

var state: RunState = RunState.new()
var decision_engine: DecisionEngine = DecisionEngine.new()

var _scenarios: Array[Dictionary] = []
var _current_screen: Screen = Screen.START

func _ready() -> void:
	_load_scenarios()
	decision_engine.load_decisions("res://data/decisions/ministan_decisions.json")

func _load_scenarios() -> void:
	var file := FileAccess.open("res://data/scenarios/scenarios.json", FileAccess.READ)
	if file == null:
		push_error("GameManager: failed to load scenarios")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Dictionary:
		_scenarios = parsed.get("scenarios", [])

func start_run(scenario_id: String = "ministan") -> void:
	var scenario := _find_scenario(scenario_id)
	if scenario.is_empty():
		push_error("GameManager: unknown scenario %s" % scenario_id)
		return
	state.reset(scenario)
	EventBus.run_started.emit(scenario_id)
	_change_screen(Screen.GAME)
	_present_next_decision()

func resolve_choice(decision_id: String, choice_id: String) -> void:
	var decision := decision_engine.get_decision_by_id(decision_id)
	if decision.is_empty():
		return
	var choice := _find_choice(decision, choice_id)
	if choice.is_empty():
		return

	state.seen_decisions.append(decision_id)
	ResourceManager.apply_changes(state, choice.get("resource_changes", {}))
	for flag in choice.get("set_flags", []):
		state.set_flag(flag)
	for law_id in choice.get("enact_laws", []):
		state.active_laws.append(law_id)

	EventBus.decision_resolved.emit(decision_id, choice_id)
	state.day += 1
	EventBus.day_advanced.emit(state.day)

	var lose_reason := ResourceManager.check_lose_condition(state)
	if not lose_reason.is_empty():
		end_run(lose_reason)
		return

	_present_next_decision()

func end_run(ending_id: String) -> void:
	state.ending_id = ending_id
	EventBus.run_ended.emit(ending_id)
	_change_screen(Screen.RUN_END)

func go_to_start() -> void:
	_change_screen(Screen.START)

func go_to_collection() -> void:
	_change_screen(Screen.COLLECTION)

func go_to_palace() -> void:
	_change_screen(Screen.PALACE)

func _present_next_decision() -> void:
	var valid := decision_engine.get_valid_decisions(state)
	if valid.is_empty():
		end_run("survived")
		return
	var decision_dict: Dictionary = valid[0]
	var decision := DecisionData.from_dict(decision_dict)
	EventBus.decision_presented.emit(decision)

func _find_scenario(scenario_id: String) -> Dictionary:
	for scenario in _scenarios:
		if scenario.get("id", "") == scenario_id:
			return scenario
	return {}


func _find_choice(decision: Dictionary, choice_id: String) -> Dictionary:
	for choice in decision.get("choices", []):
		if choice.get("id", "") == choice_id:
			return choice
	return {}

func _change_screen(screen: Screen) -> void:
	_current_screen = screen
	EventBus.screen_changed.emit(Screen.keys()[screen])
