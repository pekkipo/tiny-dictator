class_name ClosedAlphaExporter
extends RefCounted

## Manual export of closed-alpha data to user://alpha_exports/.
## Never includes save.json or device identifiers.

const EXPORTS_DIR: String = "user://alpha_exports/"
const RUNS_DIR: String = "user://alpha_logs/runs/"
const FEEDBACK_DIR: String = "user://alpha_logs/feedback/"

const KNOWN_LIMITATIONS_TEXT: String = """Tiny Dictator — Closed Alpha Known Limitations

- Unfinished build: placeholder visuals, no final art/audio.
- Desktop-oriented alpha; mobile packaging is not claimed for this milestone.
- No mid-run save: closing the app abandons the current run.
- No accounts, ads, purchases, or backend analytics upload.
- Anonymous local tester ID only (resettable); no personal data collected.
- Balance soft-gates from Milestone 2B-18 may still apply (Day40 rarity, special-ending mix).
- Debug cheats are hidden by default; unlock only for designated testers.
"""


static func export_package(logger: Node = null) -> Dictionary:
	_ensure_exports_dir()
	var stamp := Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_")
	var package_name := "tiny_dictator_alpha_%s" % stamp
	var package_dir := "%s%s/" % [EXPORTS_DIR, package_name]
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(package_dir))

	var runs: Array[Dictionary] = []
	var feedback: Array[Dictionary] = []
	var session: Dictionary = {}
	if logger != null and logger.has_method("load_all_runs"):
		runs = logger.load_all_runs()
		feedback = logger.load_all_feedback()
		if logger.has_method("get_session"):
			session = logger.get_session().to_dictionary()
	else:
		runs = _load_runs_from_disk()
		feedback = _load_feedback_from_disk()
		session = ClosedAlphaSession.new().to_dictionary()

	var summary: Dictionary = compute_summary(runs, feedback, session)
	var versions := {
		"app_version": ClosedAlphaConfig.get_alpha_version(),
		"content_version": ClosedAlphaConfig.get_content_version(),
		"content_hash": ClosedAlphaConfig.get_content_hash(),
		"project_version": str(ProjectSettings.get_setting("application/config/version", "")),
		"export_timestamp": int(Time.get_unix_time_from_system()),
		"package_name": package_name,
	}
	var manifest_snapshot: Dictionary = ClosedAlphaConfig.get_manifest_snapshot()
	manifest_snapshot["content_hash"] = versions["content_hash"]

	_write_json("%sruns.json" % package_dir, {"runs": runs})
	_write_text("%sruns.csv" % package_dir, _runs_to_csv(runs))
	_write_json("%sfeedback.json" % package_dir, {"feedback": feedback})
	_write_json("%ssummary.json" % package_dir, summary)
	_write_text("%ssummary.txt" % package_dir, summary_to_text(summary))
	_write_json("%sversions.json" % package_dir, versions)
	_write_json("%smanifest_snapshot.json" % package_dir, manifest_snapshot)
	_write_json("%ssession.json" % package_dir, session)
	_write_text("%sKNOWN_LIMITATIONS.txt" % package_dir, KNOWN_LIMITATIONS_TEXT)

	var absolute := ProjectSettings.globalize_path(package_dir)
	return {
		"package_dir": package_dir,
		"absolute_path": absolute,
		"package_name": package_name,
		"run_count": runs.size(),
		"feedback_count": feedback.size(),
	}


static func compute_summary(runs: Array, feedback: Array, session: Dictionary = {}) -> Dictionary:
	var completed: int = 0
	var abandoned: int = 0
	var restart_count: int = 0
	var ending_dist: Dictionary = {}
	var advisor_dist: Dictionary = {}
	var card_seen: Dictionary = {}
	var card_repeat_events: Dictionary = {}
	var arc_starts: Dictionary = {}
	var arc_completions: Dictionary = {}
	var crisis_starts: Dictionary = {}
	var crisis_resolutions: Dictionary = {}
	var decision_times: Array[float] = []
	var card_decision_times: Dictionary = {}
	var card_abandon_follows: Dictionary = {}
	var tester_ids: Dictionary = {}
	var slow_threshold_ms: float = 15000.0

	for run_variant in runs:
		if not (run_variant is Dictionary):
			continue
		var run: Dictionary = run_variant
		var tester_id: String = str(run.get("anonymous_tester_id", ""))
		if not tester_id.is_empty():
			tester_ids[tester_id] = int(tester_ids.get(tester_id, 0)) + 1
		var status: String = str(run.get("status", ""))
		if status == "completed":
			completed += 1
		elif status == "abandoned" or status == "interrupted":
			abandoned += 1
		if bool(run.get("restart_after_ending", false)):
			restart_count += 1

		var ending_id: String = str(run.get("ending_id", ""))
		if not ending_id.is_empty():
			ending_dist[ending_id] = int(ending_dist.get(ending_id, 0)) + 1

		for arc_id in run.get("arcs_started", []):
			arc_starts[str(arc_id)] = int(arc_starts.get(str(arc_id), 0)) + 1
		for arc_id in run.get("arcs_completed", []):
			arc_completions[str(arc_id)] = int(arc_completions.get(str(arc_id), 0)) + 1
		for crisis_id in run.get("crises_started", []):
			crisis_starts[str(crisis_id)] = int(crisis_starts.get(str(crisis_id), 0)) + 1
		for crisis_id in run.get("crises_resolved", []):
			crisis_resolutions[str(crisis_id)] = int(crisis_resolutions.get(str(crisis_id), 0)) + 1

		var seen_in_run: Dictionary = {}
		var decisions: Array = run.get("decisions", [])
		for i in range(decisions.size()):
			var entry_variant: Variant = decisions[i]
			if not (entry_variant is Dictionary):
				continue
			var entry: Dictionary = entry_variant
			var decision_id: String = str(entry.get("decision_id", ""))
			if decision_id.is_empty():
				continue
			card_seen[decision_id] = int(card_seen.get(decision_id, 0)) + 1
			if seen_in_run.has(decision_id):
				card_repeat_events[decision_id] = int(card_repeat_events.get(decision_id, 0)) + 1
			seen_in_run[decision_id] = true

			var advisor_id: String = str(entry.get("advisor_id", ""))
			if not advisor_id.is_empty():
				advisor_dist[advisor_id] = int(advisor_dist.get(advisor_id, 0)) + 1

			var dt: float = float(entry.get("decision_time_ms", 0))
			if dt > 0.0:
				decision_times.append(dt)
				if not card_decision_times.has(decision_id):
					card_decision_times[decision_id] = []
				card_decision_times[decision_id].append(dt)

			if status == "abandoned" and i == decisions.size() - 1:
				card_abandon_follows[decision_id] = int(card_abandon_follows.get(decision_id, 0)) + 1

	var feedback_categories: Dictionary = {}
	var low_rated: Array = []
	var confusing: Array = []
	var bug_reports: Array = []
	var favorites: Array = []
	for fb_variant in feedback:
		if not (fb_variant is Dictionary):
			continue
		var fb: Dictionary = fb_variant
		var ftype: String = str(fb.get("feedback_type", "general"))
		feedback_categories[ftype] = int(feedback_categories.get(ftype, 0)) + 1
		var flags: Dictionary = fb.get("flags", {})
		var decision_id: String = str(fb.get("related_decision_id", ""))
		if int(fb.get("rating", 0)) > 0 and int(fb.get("rating", 0)) <= 2 and not decision_id.is_empty():
			low_rated.append(decision_id)
		if bool(flags.get("confusing_content", false)) and not decision_id.is_empty():
			confusing.append(decision_id)
		if bool(flags.get("technical_bug", false)):
			bug_reports.append({
				"feedback_id": str(fb.get("feedback_id", "")),
				"decision_id": decision_id,
				"comment": str(fb.get("comment", "")),
			})
		if bool(flags.get("favorite_moment", false)):
			favorites.append({
				"decision_id": decision_id,
				"comment": str(fb.get("comment", "")),
			})

	var slow_cards: Array = []
	for decision_id in card_decision_times:
		var times: Array = card_decision_times[decision_id]
		var avg: float = _average(times)
		if avg >= slow_threshold_ms:
			slow_cards.append({"decision_id": decision_id, "avg_decision_time_ms": avg, "samples": times.size()})

	var runs_per_install: float = 0.0
	if tester_ids.size() > 0:
		var total_runs: int = 0
		for tid in tester_ids:
			total_runs += int(tester_ids[tid])
		runs_per_install = float(total_runs) / float(tester_ids.size())

	var restart_rate: float = 0.0
	if completed > 0:
		restart_rate = float(restart_count) / float(completed)

	return {
		"generated_at": int(Time.get_unix_time_from_system()),
		"anonymous_tester_id": str(session.get("anonymous_tester_id", "")),
		"installations_represented": tester_ids.size(),
		"completed_runs": completed,
		"abandoned_runs": abandoned,
		"total_runs": runs.size(),
		"runs_per_installation": runs_per_install,
		"restart_count": restart_count,
		"restart_rate": restart_rate,
		"unique_cards_seen": card_seen.size(),
		"card_seen_counts": card_seen,
		"repeated_card_events": card_repeat_events,
		"ending_distribution": ending_dist,
		"advisor_distribution": advisor_dist,
		"arc_starts": arc_starts,
		"arc_completions": arc_completions,
		"crisis_starts": crisis_starts,
		"crisis_resolutions": crisis_resolutions,
		"median_decision_time_ms": _median(decision_times),
		"decision_time_sample_count": decision_times.size(),
		"cards_with_long_decision_time": slow_cards,
		"cards_frequently_followed_by_abandonment": card_abandon_follows,
		"feedback_count": feedback.size(),
		"feedback_category_counts": feedback_categories,
		"low_rated_decisions": low_rated,
		"confusing_decisions": confusing,
		"bug_reports": bug_reports,
		"favorite_moments": favorites,
	}


static func summary_to_text(summary: Dictionary) -> String:
	var lines: PackedStringArray = []
	lines.append("Tiny Dictator — Closed Alpha Export Summary")
	lines.append("Generated: %d" % int(summary.get("generated_at", 0)))
	lines.append("")
	lines.append("Installations represented: %d" % int(summary.get("installations_represented", 0)))
	lines.append("Completed runs: %d" % int(summary.get("completed_runs", 0)))
	lines.append("Abandoned runs: %d" % int(summary.get("abandoned_runs", 0)))
	lines.append("Runs per installation: %.2f" % float(summary.get("runs_per_installation", 0.0)))
	lines.append("Restart rate: %.1f%%" % (100.0 * float(summary.get("restart_rate", 0.0))))
	lines.append("Unique cards seen: %d" % int(summary.get("unique_cards_seen", 0)))
	lines.append("Median decision time (ms): %.0f" % float(summary.get("median_decision_time_ms", 0.0)))
	lines.append("Feedback records: %d" % int(summary.get("feedback_count", 0)))
	lines.append("")
	lines.append("Ending distribution:")
	var ending_dist: Dictionary = summary.get("ending_distribution", {})
	if ending_dist.is_empty():
		lines.append("  (none)")
	else:
		for ending_id in ending_dist:
			lines.append("  - %s: %d" % [ending_id, int(ending_dist[ending_id])])
	lines.append("")
	lines.append("This package contains anonymous local alpha data only.")
	lines.append("It does not include save.json or personal identifiers.")
	return "\n".join(lines)


static func get_exports_dir_absolute() -> String:
	_ensure_exports_dir()
	return ProjectSettings.globalize_path(EXPORTS_DIR)


static func _runs_to_csv(runs: Array) -> String:
	var lines: PackedStringArray = []
	lines.append("run_id,anonymous_tester_id,status,start_timestamp,end_timestamp,run_duration_sec,ending_id,ruler_identity_id,medals_earned,decision_count,restart_after_ending,crash_or_fatal_marker")
	for run_variant in runs:
		if not (run_variant is Dictionary):
			continue
		var run: Dictionary = run_variant
		var decisions: Array = run.get("decisions", [])
		lines.append("%s,%s,%s,%d,%d,%d,%s,%s,%d,%d,%s,%s" % [
			_csv(str(run.get("run_id", ""))),
			_csv(str(run.get("anonymous_tester_id", ""))),
			_csv(str(run.get("status", ""))),
			int(run.get("start_timestamp", 0)),
			int(run.get("end_timestamp", 0)),
			int(run.get("run_duration_sec", 0)),
			_csv(str(run.get("ending_id", ""))),
			_csv(str(run.get("ruler_identity_id", ""))),
			int(run.get("medals_earned", 0)),
			decisions.size(),
			str(bool(run.get("restart_after_ending", false))).to_lower(),
			str(bool(run.get("crash_or_fatal_marker", false))).to_lower(),
		])
	return "\n".join(lines)


static func _csv(value: String) -> String:
	if value.contains(",") or value.contains("\"") or value.contains("\n"):
		return "\"%s\"" % value.replace("\"", "\"\"")
	return value


static func _average(values: Array) -> float:
	if values.is_empty():
		return 0.0
	var total: float = 0.0
	for v in values:
		total += float(v)
	return total / float(values.size())


static func _median(values: Array) -> float:
	if values.is_empty():
		return 0.0
	var sorted_values: Array = values.duplicate()
	sorted_values.sort()
	var mid: int = sorted_values.size() / 2
	if sorted_values.size() % 2 == 1:
		return float(sorted_values[mid])
	return (float(sorted_values[mid - 1]) + float(sorted_values[mid])) / 2.0


static func _ensure_exports_dir() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EXPORTS_DIR))


static func _write_json(path: String, data: Variant) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


static func _write_text(path: String, text: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(text)
	file.close()


static func _load_runs_from_disk() -> Array[Dictionary]:
	var runs: Array[Dictionary] = []
	var dir := DirAccess.open(RUNS_DIR)
	if dir == null:
		return runs
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var data: Dictionary = _read_json_file("%s%s" % [RUNS_DIR, file_name])
			if not data.is_empty():
				runs.append(data)
		file_name = dir.get_next()
	dir.list_dir_end()
	return runs


static func _load_feedback_from_disk() -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	var dir := DirAccess.open(FEEDBACK_DIR)
	if dir == null:
		return items
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var data: Dictionary = _read_json_file("%s%s" % [FEEDBACK_DIR, file_name])
			if not data.is_empty():
				items.append(data)
		file_name = dir.get_next()
	dir.list_dir_end()
	return items


static func _read_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var text: String = file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK or not (json.data is Dictionary):
		return {}
	return json.data
