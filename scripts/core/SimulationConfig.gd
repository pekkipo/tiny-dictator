class_name SimulationConfig
extends RefCounted

## Configuration for headless run simulation (Phase 2A milestone 2A-8).

const SEED_MODE_RANDOM: String = "random"
const SEED_MODE_FIXED: String = "fixed"

const DEFAULT_RUN_COUNT: int = 100
const DEFAULT_MAX_STEPS: int = 120
const DEFAULT_COUNTRY_ID: String = "ministan"
const DEFAULT_BASE_SEED: int = 20260715

var run_count: int = DEFAULT_RUN_COUNT
var country_id: String = DEFAULT_COUNTRY_ID
var seed_mode: String = SEED_MODE_FIXED
var base_seed: int = DEFAULT_BASE_SEED
var max_steps_per_run: int = DEFAULT_MAX_STEPS
var choice_strategy_name: String = "random"
var include_static_diagnostics: bool = true
var export_report: bool = true
var runs_per_chunk: int = 50


func to_dictionary() -> Dictionary:
	return {
		"run_count": run_count,
		"country_id": country_id,
		"seed_mode": seed_mode,
		"base_seed": base_seed,
		"max_steps_per_run": max_steps_per_run,
		"choice_strategy": choice_strategy_name,
		"include_static_diagnostics": include_static_diagnostics,
	}


static func for_preset(preset: String) -> SimulationConfig:
	var config := SimulationConfig.new()
	match preset:
		"100":
			config.run_count = 100
		"1000":
			config.run_count = 1000
		_:
			pass
	return config


func get_run_seed(run_index: int) -> int:
	if seed_mode == SEED_MODE_FIXED:
		return base_seed + run_index
	return base_seed + run_index if base_seed != 0 else randi()
