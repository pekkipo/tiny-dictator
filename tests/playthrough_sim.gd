extends SceneTree

## PRD 05 §8 playability session, automated: plays five full runs via RunSimulator.
## Run: godot --headless --path . -s tests/playthrough_sim.gd

const RUN_COUNT: int = 5

var _failures: int = 0


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")

	var config := SimulationConfig.new()
	config.run_count = RUN_COUNT
	config.base_seed = 20260714
	config.seed_mode = SimulationConfig.SEED_MODE_FIXED
	config.include_static_diagnostics = false
	config.export_report = false

	var simulator := RunSimulator.new(game_manager)
	var report: SimulationReport = simulator.run_batch(config)
	var sim: Dictionary = report.simulation

	print("[SIM] run | seed        | days | decisions | ending")
	var run_count: int = int(sim.get("run_count", 0))
	_check(run_count == RUN_COUNT, "all %d runs completed" % RUN_COUNT)

	var ending_dist: Dictionary = sim.get("ending_distribution", {})
	print("[SIM] distinct endings: %d" % ending_dist.size())
	var run_length: Dictionary = sim.get("run_length", {})
	print("[SIM] average run length: %.1f days" % float(run_length.get("average", 0.0)))

	var errors: Array = sim.get("errors", [])
	for error in errors:
		printerr("[SIM] %s" % str(error))
	_check(errors.is_empty(), "playthrough simulation completed without technical failures")

	if _failures == 0:
		print("[TEST] Playthrough simulation completed without technical failures.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)
