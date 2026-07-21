class_name ClosedAlphaReportGenerator
extends RefCounted

## Imports closed-alpha export packages and writes analysis markdown.
## Never invents tester results. Empty import → explicit no-dataset message.

const RESULTS_PATH: String = "res://docs/alpha/CLOSED_ALPHA_RESULTS.md"
const BACKLOG_PATH: String = "res://docs/alpha/CLOSED_ALPHA_CONTENT_FIX_BACKLOG.md"
const NO_DATA_LINE: String = "No external closed-alpha dataset has been imported."


static func import_packages_from_dir(import_dir: String) -> Dictionary:
	var packages: Array[Dictionary] = []
	var absolute: String = ProjectSettings.globalize_path(import_dir)
	var dir := DirAccess.open(import_dir)
	if dir == null:
		dir = DirAccess.open(absolute)
	if dir == null:
		return {
			"package_count": 0,
			"runs": [],
			"feedback": [],
			"packages": [],
			"error": "import directory not found: %s" % import_dir,
		}

	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if dir.current_is_dir() and not name.begins_with(".") and name.begins_with("tiny_dictator_alpha_"):
			var package_path: String = "%s/%s" % [import_dir.rstrip("/"), name]
			var package: Dictionary = _load_package(package_path)
			if not package.is_empty():
				packages.append(package)
		name = dir.get_next()
	dir.list_dir_end()

	var all_runs: Array = []
	var all_feedback: Array = []
	for package in packages:
		for run in package.get("runs", []):
			all_runs.append(run)
		for fb in package.get("feedback", []):
			all_feedback.append(fb)

	return {
		"package_count": packages.size(),
		"runs": all_runs,
		"feedback": all_feedback,
		"packages": packages,
		"error": "",
	}


static func generate_and_write(import_dir: String, write_docs: bool = true) -> Dictionary:
	var imported: Dictionary = import_packages_from_dir(import_dir)
	var summary: Dictionary = ClosedAlphaExporter.compute_summary(
		imported.get("runs", []),
		imported.get("feedback", []),
		{},
	)
	summary["package_count"] = int(imported.get("package_count", 0))
	summary["import_dir"] = import_dir
	summary["import_error"] = str(imported.get("error", ""))

	var results_md: String = format_results_markdown(summary, imported)
	var backlog_md: String = format_backlog_markdown(summary, imported)

	if write_docs:
		_write_text(RESULTS_PATH, results_md)
		_write_text(BACKLOG_PATH, backlog_md)

	return {
		"summary": summary,
		"imported": imported,
		"results_path": RESULTS_PATH,
		"backlog_path": BACKLOG_PATH,
		"results_markdown": results_md,
		"backlog_markdown": backlog_md,
	}


static func format_results_markdown(summary: Dictionary, imported: Dictionary) -> String:
	var package_count: int = int(imported.get("package_count", 0))
	var lines: PackedStringArray = []
	lines.append("# Closed Alpha — Results")
	lines.append("")
	if package_count <= 0:
		lines.append("**Status:** No analysis yet")
		lines.append("**Milestone 2B-19:** READY_FOR_EXTERNAL_TESTING (not complete)")
		lines.append("")
		lines.append("---")
		lines.append("")
		lines.append("## Dataset")
		lines.append("")
		lines.append("**%s**" % NO_DATA_LINE)
		lines.append("")
		lines.append("This file must not be filled with invented testers, sessions, runs, survey answers, retention stats, favorite characters, confusing cards, bugs, or conclusions.")
		lines.append("")
		if not str(imported.get("error", "")).is_empty():
			lines.append("Import note: `%s`" % str(imported.get("error", "")))
			lines.append("")
		return "\n".join(lines)

	lines.append("**Status:** Imported external packages")
	lines.append("**Packages:** %d" % package_count)
	lines.append("**Generated:** %d" % int(summary.get("generated_at", 0)))
	lines.append("")
	lines.append("## Metrics")
	lines.append("")
	lines.append("| Metric | Value |")
	lines.append("|---|---|")
	lines.append("| Installations | %d |" % int(summary.get("installations_represented", 0)))
	lines.append("| Testers represented | %d |" % int(summary.get("installations_represented", 0)))
	lines.append("| Completed runs | %d |" % int(summary.get("completed_runs", 0)))
	lines.append("| Abandoned runs | %d |" % int(summary.get("abandoned_runs", 0)))
	lines.append("| Runs per installation | %.2f |" % float(summary.get("runs_per_installation", 0.0)))
	lines.append("| Restart rate | %.1f%% |" % (100.0 * float(summary.get("restart_rate", 0.0))))
	lines.append("| Median decision time (ms) | %.0f |" % float(summary.get("median_decision_time_ms", 0.0)))
	lines.append("| Unique cards seen | %d |" % int(summary.get("unique_cards_seen", 0)))
	lines.append("| Feedback records | %d |" % int(summary.get("feedback_count", 0)))
	lines.append("")
	lines.append("## Ending distribution")
	lines.append("")
	_append_count_dict(lines, summary.get("ending_distribution", {}))
	lines.append("")
	lines.append("## Advisor exposure")
	lines.append("")
	_append_count_dict(lines, summary.get("advisor_distribution", {}))
	lines.append("")
	lines.append("## Arc starts / completions")
	lines.append("")
	lines.append("Starts:")
	_append_count_dict(lines, summary.get("arc_starts", {}))
	lines.append("Completions:")
	_append_count_dict(lines, summary.get("arc_completions", {}))
	lines.append("")
	lines.append("## Crisis starts / resolutions")
	lines.append("")
	lines.append("Starts:")
	_append_count_dict(lines, summary.get("crisis_starts", {}))
	lines.append("Resolutions:")
	_append_count_dict(lines, summary.get("crisis_resolutions", {}))
	lines.append("")
	lines.append("## Cards with long decision time")
	lines.append("")
	var slow: Array = summary.get("cards_with_long_decision_time", [])
	if slow.is_empty():
		lines.append("*None above threshold.*")
	else:
		for item in slow:
			if item is Dictionary:
				lines.append("- `%s` avg %.0f ms (n=%d)" % [
					str(item.get("decision_id", "")),
					float(item.get("avg_decision_time_ms", 0.0)),
					int(item.get("samples", 0)),
				])
	lines.append("")
	lines.append("## Cards frequently followed by abandonment")
	lines.append("")
	_append_count_dict(lines, summary.get("cards_frequently_followed_by_abandonment", {}))
	lines.append("")
	lines.append("## Feedback categories")
	lines.append("")
	_append_count_dict(lines, summary.get("feedback_category_counts", {}))
	lines.append("")
	lines.append("## Low-rated decisions")
	lines.append("")
	_append_string_list(lines, summary.get("low_rated_decisions", []))
	lines.append("")
	lines.append("## Confusing decisions")
	lines.append("")
	_append_string_list(lines, summary.get("confusing_decisions", []))
	lines.append("")
	lines.append("## Bug reports")
	lines.append("")
	var bugs: Array = summary.get("bug_reports", [])
	if bugs.is_empty():
		lines.append("*None.*")
	else:
		for bug in bugs:
			if bug is Dictionary:
				lines.append("- [%s] `%s`: %s" % [
					str(bug.get("feedback_id", "")),
					str(bug.get("decision_id", "")),
					str(bug.get("comment", "")),
				])
	lines.append("")
	lines.append("## Favorite moments")
	lines.append("")
	var favorites: Array = summary.get("favorite_moments", [])
	if favorites.is_empty():
		lines.append("*None.*")
	else:
		for fav in favorites:
			if fav is Dictionary:
				lines.append("- `%s`: %s" % [str(fav.get("decision_id", "")), str(fav.get("comment", ""))])
	lines.append("")
	lines.append("## Free-text feedback appendix")
	lines.append("")
	var feedback: Array = imported.get("feedback", [])
	if feedback.is_empty():
		lines.append("*No free-text feedback.*")
	else:
		for fb in feedback:
			if fb is Dictionary:
				var comment: String = str(fb.get("comment", "")).strip_edges()
				if comment.is_empty():
					continue
				lines.append("- (%s / rating %d) %s" % [
					str(fb.get("feedback_type", "")),
					int(fb.get("rating", 0)),
					comment,
				])
	lines.append("")
	return "\n".join(lines)


static func format_backlog_markdown(summary: Dictionary, imported: Dictionary) -> String:
	var package_count: int = int(imported.get("package_count", 0))
	var lines: PackedStringArray = []
	lines.append("# Closed Alpha — Content Fix Backlog")
	lines.append("")
	if package_count <= 0:
		lines.append("**Status:** Empty pending real external alpha data")
		lines.append("**Milestone 2B-19:** READY_FOR_EXTERNAL_TESTING (not complete)")
		lines.append("")
		lines.append("---")
		lines.append("")
		lines.append("**%s**" % NO_DATA_LINE)
		lines.append("")
		lines.append("Do not invent backlog items.")
		lines.append("")
		lines.append("## P0")
		lines.append("")
		lines.append("*None — no dataset.*")
		lines.append("")
		lines.append("## P1")
		lines.append("")
		lines.append("*None — no dataset.*")
		lines.append("")
		lines.append("## P2")
		lines.append("")
		lines.append("*None — no dataset.*")
		lines.append("")
		lines.append("## P3")
		lines.append("")
		lines.append("*None — no dataset.*")
		lines.append("")
		return "\n".join(lines)

	lines.append("**Status:** Draft from imported alpha data")
	lines.append("**Generated:** %d" % int(summary.get("generated_at", 0)))
	lines.append("")
	lines.append("Priorities: P0 crash/data-loss/blockers · P1 major comprehension · P2 weak/repetitive · P3 polish")
	lines.append("")
	lines.append("## P0")
	lines.append("")
	var bugs: Array = summary.get("bug_reports", [])
	if bugs.is_empty():
		lines.append("*No technical bug feedback flagged. Review abandon/crash markers manually.*")
	else:
		for bug in bugs:
			if bug is Dictionary:
				lines.append("- [ ] P0 candidate: `%s` — %s" % [
					str(bug.get("decision_id", "(no decision)")),
					str(bug.get("comment", "")),
				])
	lines.append("")
	lines.append("## P1")
	lines.append("")
	var confusing: Array = summary.get("confusing_decisions", [])
	if confusing.is_empty():
		lines.append("*No confusing-content flags.*")
	else:
		for decision_id in confusing:
			lines.append("- [ ] Confusing decision: `%s`" % str(decision_id))
	lines.append("")
	lines.append("## P2")
	lines.append("")
	var repeats: Dictionary = summary.get("repeated_card_events", {})
	if repeats.is_empty():
		lines.append("*No within-run repeat events recorded.*")
	else:
		for decision_id in repeats:
			lines.append("- [ ] Repetition: `%s` (%d within-run repeats)" % [str(decision_id), int(repeats[decision_id])])
	var low: Array = summary.get("low_rated_decisions", [])
	for decision_id in low:
		lines.append("- [ ] Low-rated decision: `%s`" % str(decision_id))
	lines.append("")
	lines.append("## P3")
	lines.append("")
	lines.append("*Add polish/copy items after manual review of free-text appendix.*")
	lines.append("")
	return "\n".join(lines)


static func _load_package(package_path: String) -> Dictionary:
	var runs_path: String = "%s/runs.json" % package_path
	var feedback_path: String = "%s/feedback.json" % package_path
	var runs_doc: Dictionary = _read_json(runs_path)
	var feedback_doc: Dictionary = _read_json(feedback_path)
	if runs_doc.is_empty() and feedback_doc.is_empty():
		return {}
	return {
		"path": package_path,
		"runs": runs_doc.get("runs", []),
		"feedback": feedback_doc.get("feedback", []),
		"versions": _read_json("%s/versions.json" % package_path),
		"session": _read_json("%s/session.json" % package_path),
	}


static func _append_count_dict(lines: PackedStringArray, data: Dictionary) -> void:
	if data.is_empty():
		lines.append("*None.*")
		return
	for key in data:
		lines.append("- `%s`: %d" % [str(key), int(data[key])])


static func _append_string_list(lines: PackedStringArray, data: Array) -> void:
	if data.is_empty():
		lines.append("*None.*")
		return
	for item in data:
		lines.append("- `%s`" % str(item))


static func _read_json(path: String) -> Dictionary:
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


static func _write_text(path: String, text: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_warning("[ALPHA] Cannot write %s" % path)
		return
	file.store_string(text)
	file.close()
