extends SceneTree

## Schema/smoke tests for closed-alpha infrastructure.
## Uses synthetic schema samples marked non-user — never treated as alpha results.

func _init() -> void:
	var failures: Array[String] = []
	failures.append_array(_test_config())
	failures.append_array(_test_session())
	failures.append_array(_test_export_summary_schema())
	failures.append_array(_test_importer_empty())
	failures.append_array(_test_importer_schema_fixture())

	if failures.is_empty():
		print("[PASS] run_2b19_alpha_smoke: all checks passed")
		quit(0)
	else:
		for failure in failures:
			push_error("[FAIL] %s" % failure)
		print("[FAIL] run_2b19_alpha_smoke: %d failure(s)" % failures.size())
		quit(1)


func _test_config() -> Array[String]:
	var failures: Array[String] = []
	ClosedAlphaConfig.reload()
	if not ClosedAlphaConfig.is_enabled():
		failures.append("closed_alpha_enabled should be true in data/config/closed_alpha.json")
	if ClosedAlphaConfig.get_alpha_version().is_empty():
		failures.append("alpha_version missing")
	if ClosedAlphaConfig.is_analytics_backend_enabled():
		failures.append("analytics_backend_enabled must stay false")
	return failures


func _test_session() -> Array[String]:
	var failures: Array[String] = []
	var session := ClosedAlphaSession.new()
	var first: String = session.anonymous_tester_id
	if first.is_empty() or not first.contains("-"):
		failures.append("anonymous_tester_id not generated")
	var second: String = session.reset_identity()
	if second.is_empty() or second == first:
		failures.append("reset_identity should generate a new id")
	if session.reset_count < 1:
		failures.append("reset_count should increment")
	return failures


func _test_export_summary_schema() -> Array[String]:
	var failures: Array[String] = []
	## Synthetic schema sample — NOT external tester data.
	var schema_run := {
		"_schema_fixture": true,
		"anonymous_tester_id": "00000000-0000-0000-0000-000000000001",
		"app_version": "0.2.0-alpha",
		"content_version": "2B-18",
		"run_id": "schema-run-1",
		"start_timestamp": 1,
		"end_timestamp": 10,
		"run_duration_sec": 9,
		"status": "completed",
		"decisions": [
			{
				"day": 1,
				"decision_id": "schema_card_a",
				"advisor_id": "general_boom",
				"selected_option_id": "approve",
				"decision_time_ms": 1200,
				"resources_before": {"treasury": 50},
				"resources_after": {"treasury": 45},
				"added_laws": [],
			},
		],
		"laws_activated": [],
		"arcs_started": ["schema_arc"],
		"arcs_completed": [],
		"crises_started": [],
		"crises_resolved": [],
		"ending_id": "schema_ending",
		"ruler_identity_id": "",
		"medals_earned": 1,
		"restart_after_ending": false,
		"crash_or_fatal_marker": false,
		"feedback_ids": [],
	}
	var summary: Dictionary = ClosedAlphaExporter.compute_summary([schema_run], [], {})
	for key in [
		"completed_runs", "abandoned_runs", "ending_distribution", "advisor_distribution",
		"median_decision_time_ms", "unique_cards_seen", "restart_rate",
	]:
		if not summary.has(key):
			failures.append("summary missing key %s" % key)
	if int(summary.get("completed_runs", 0)) != 1:
		failures.append("schema fixture should count 1 completed run in compute_summary only")
	return failures


func _test_importer_empty() -> Array[String]:
	var failures: Array[String] = []
	var result: Dictionary = ClosedAlphaReportGenerator.generate_and_write(
		"user://alpha_imports_empty_test_missing/",
		false,
	)
	var md: String = str(result.get("results_markdown", ""))
	if not md.contains(ClosedAlphaReportGenerator.NO_DATA_LINE):
		failures.append("empty import must state no external dataset imported")
	return failures


func _test_importer_schema_fixture() -> Array[String]:
	var failures: Array[String] = []
	## Temporary package used only to validate importer plumbing — marked non-user.
	var package_dir := "user://alpha_schema_fixture_package/tiny_dictator_alpha_schema_only/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(package_dir))
	var runs_doc := {
		"runs": [{
			"_schema_fixture": true,
			"anonymous_tester_id": "schema-only",
			"status": "completed",
			"run_id": "schema-only-run",
			"start_timestamp": 1,
			"end_timestamp": 2,
			"decisions": [],
			"ending_id": "schema_ending",
			"restart_after_ending": false,
			"crash_or_fatal_marker": false,
			"arcs_started": [],
			"arcs_completed": [],
			"crises_started": [],
			"crises_resolved": [],
			"feedback_ids": [],
		}],
		"note": "SCHEMA FIXTURE — NOT EXTERNAL TESTER DATA",
	}
	var feedback_doc := {"feedback": [], "note": "SCHEMA FIXTURE — NOT EXTERNAL TESTER DATA"}
	_write_json("%sruns.json" % package_dir, runs_doc)
	_write_json("%sfeedback.json" % package_dir, feedback_doc)

	var imported: Dictionary = ClosedAlphaReportGenerator.import_packages_from_dir(
		"user://alpha_schema_fixture_package/"
	)
	if int(imported.get("package_count", 0)) != 1:
		failures.append("schema fixture package not imported")
	## Do not write docs from schema fixture — would pollute RESULTS with fake data.
	return failures


func _write_json(path: String, data: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
