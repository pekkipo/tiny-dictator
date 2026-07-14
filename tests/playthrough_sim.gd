extends SceneTree

## PRD 05 §8 playability session, automated: plays five full runs with
## seeded random choices and prints one record per run plus aggregates.
## Run: godot --headless --path . -s tests/playthrough_sim.gd

const RUN_COUNT: int = 5
const MAX_STEPS: int = 100

var _failures: int = 0


func _initialize() -> void:
	await process_frame
	var game_manager: Node = root.get_node("GameManager")
	var chooser := RandomNumberGenerator.new()
	chooser.seed = 20260714

	var endings_seen: Dictionary = {}
	var total_decisions: int = 0

	print("[SIM] run | seed        | days | decisions | laws | ending")
	for i in range(RUN_COUNT):
		game_manager.start_new_run()
		var state: RunState = game_manager.get_current_state()
		var steps: int = 0
		while state.run_phase != RunState.RunPhase.ENDED and steps < MAX_STEPS:
			var side: String = "left" if chooser.randf() < 0.5 else "right"
			if game_manager.resolve_choice(side) == null:
				break
			game_manager.continue_after_result()
			steps += 1

		var summary: RunSummary = game_manager.get_last_summary()
		_check(state.run_phase == RunState.RunPhase.ENDED, "run %d reached an ending (not a technical dead end)" % (i + 1))
		_check(summary != null and not summary.ending_id.is_empty(), "run %d produced a summary" % (i + 1))
		if summary == null:
			continue
		endings_seen[summary.ending_id] = true
		total_decisions += summary.decision_history.size()
		print("[SIM]  %d  | %11d |  %2d  |    %2d     |  %d   | %s" % [
			i + 1, summary.random_seed, summary.final_day,
			summary.decision_history.size(), summary.active_laws.size(), summary.ending_id,
		])

	var avg: float = float(total_decisions) / RUN_COUNT
	print("[SIM] distinct endings: %d, average decisions per run: %.1f" % [endings_seen.size(), avg])

	if _failures == 0:
		print("[TEST] Playthrough simulation completed without technical failures.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)
