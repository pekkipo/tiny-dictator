extends SceneTree

## Phase 2A-10 QA orchestrator — runs the full headless acceptance matrix.
## Run: godot --headless --path . -s tests/run_phase_2a_qa.gd

const SUITES: Array[String] = [
	"res://tests/test_content_validation.gd",
	"res://tests/test_schema_v2.gd",
	"res://tests/test_content_director.gd",
	"res://tests/test_arc_manager.gd",
	"res://tests/test_narrative_event_queue.gd",
	"res://tests/test_crisis_manager.gd",
	"res://tests/test_advisor_ruler_identity.gd",
	"res://tests/test_meta_progression.gd",
	"res://tests/test_run_state.gd",
	"res://tests/test_game_manager.gd",
	"res://tests/test_save_manager.gd",
	"res://tests/test_decision_engine.gd",
	"res://tests/test_effect_resolver.gd",
	"res://tests/test_ending_resolver.gd",
	"res://tests/test_debug_overlay.gd",
	"res://tests/test_manual_path_verification.gd",
	"res://tests/test_diagnostics_simulation.gd",
	"res://tests/test_onboarding_coverage.gd",
]

var _failures: int = 0


func _initialize() -> void:
	await process_frame
	var godot_bin: String = OS.get_executable_path()
	for suite_path in SUITES:
		var ok := _run_suite(godot_bin, suite_path)
		if not ok:
			_failures += 1
	if _failures == 0:
		print("[QA] Phase 2A acceptance matrix passed (%d suites)." % SUITES.size())
	else:
		printerr("[QA] Phase 2A acceptance matrix failed: %d suite(s)." % _failures)
	quit(1 if _failures > 0 else 0)


func _run_suite(godot_bin: String, suite_path: String) -> bool:
	var output: Array = []
	var args: PackedStringArray = ["--headless", "--path", ProjectSettings.globalize_path("res://"), "-s", suite_path]
	var exit_code: int = OS.execute(godot_bin, args, output, true, false)
	var tail: String = output[-1] if not output.is_empty() else ""
	print("[QA] %s -> exit %d (%s)" % [suite_path, exit_code, tail.strip_edges()])
	return exit_code == 0
