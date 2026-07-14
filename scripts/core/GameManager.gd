extends Node

## High-level run lifecycle coordinator (autoload).
## Milestone 2 scope: owns RunState and run flow. Content loading (M3),
## decision selection (M4), and effect resolution (M5) are stubbed.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §4.

var _run_state: RunState = RunState.new()


func _ready() -> void:
	initialize_game()


func initialize_game() -> void:
	# Content loading and validation arrive in Milestone 3.
	print("[BOOT] GameManager initialized.")


func start_new_run(country_id: String = "ministan") -> void:
	_run_state = RunState.new()
	_run_state.run_phase = RunState.RunPhase.INITIALIZING
	_run_state.country_id = country_id
	_run_state.random_seed = randi()
	_run_state.run_phase = RunState.RunPhase.AWAITING_DECISION
	print("[RUN] New run started: country=%s day=%d seed=%d" % [
		_run_state.country_id, _run_state.day, _run_state.random_seed,
	])
	print("[RUN] Decision selection not implemented until Milestone 4.")
	EventBus.run_started.emit(_run_state)


func restart_run() -> void:
	start_new_run(_run_state.country_id)


func return_to_main_menu() -> void:
	_run_state.run_phase = RunState.RunPhase.NOT_STARTED
	EventBus.run_reset.emit()


func get_current_state() -> RunState:
	return _run_state


func debug_set_resource(resource_id: String, value: int) -> void:
	_run_state.set_resource(resource_id, value)
	EventBus.resources_changed.emit(_run_state.get_resources())


func debug_print_state() -> void:
	print("[DEBUG] RunState: %s" % JSON.stringify(_run_state.to_dictionary(), "  "))
