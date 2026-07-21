extends Node

## Closed-alpha local event logger (Milestone 2B-19).
## Records anonymous run telemetry under user://alpha_logs/. No personal data.
## No-ops when closed alpha is disabled or a simulation is active.

const LOGS_DIR: String = "user://alpha_logs/"
const RUNS_DIR: String = "user://alpha_logs/runs/"
const FEEDBACK_DIR: String = "user://alpha_logs/feedback/"
const INDEX_PATH: String = "user://alpha_logs/index.json"
const ACTIVE_RUN_PATH: String = "user://alpha_logs/active_run.json"

var _session: ClosedAlphaSession = null
var _active_run: Dictionary = {}
var _decision_presented_at_ms: int = 0
var _last_completed_run_id: String = ""
var _logging_enabled: bool = false


func _ready() -> void:
	_logging_enabled = ClosedAlphaConfig.is_enabled()
	if not _logging_enabled:
		return
	_ensure_dirs()
	_session = ClosedAlphaSession.new()
	_mark_interrupted_active_run()
	EventBus.run_started.connect(_on_run_started)
	EventBus.decision_presented.connect(_on_decision_presented)
	EventBus.decision_resolved.connect(_on_decision_resolved)
	EventBus.law_added.connect(_on_law_added)
	EventBus.arc_started.connect(_on_arc_started)
	EventBus.arc_completed.connect(_on_arc_completed)
	EventBus.arc_failed.connect(_on_arc_failed)
	EventBus.crisis_started.connect(_on_crisis_started)
	EventBus.crisis_resolved.connect(_on_crisis_resolved)
	EventBus.crisis_failed.connect(_on_crisis_failed)
	EventBus.run_ended.connect(_on_run_ended)
	print("[ALPHA] Closed-alpha logging active. Tester ID: %s" % _session.anonymous_tester_id)


func is_active() -> bool:
	return _logging_enabled and not GameManager.is_simulation_active()


func get_session() -> ClosedAlphaSession:
	if _session == null:
		_session = ClosedAlphaSession.new()
	return _session


func get_anonymous_tester_id() -> String:
	return get_session().anonymous_tester_id


func reset_anonymous_id() -> String:
	return get_session().reset_identity()


func get_active_run_id() -> String:
	return str(_active_run.get("run_id", ""))


func get_last_completed_run_id() -> String:
	return _last_completed_run_id


func mark_restart_after_ending(run_id: String = "") -> void:
	if not _logging_enabled:
		return
	var target_id: String = run_id if not run_id.is_empty() else _last_completed_run_id
	if target_id.is_empty():
		return
	var path: String = "%s%s.json" % [RUNS_DIR, target_id]
	var data: Dictionary = _read_json(path)
	if data.is_empty():
		return
	data["restart_after_ending"] = true
	_write_json(path, data)
	_update_index_entry(target_id, {"restart_after_ending": true})


func submit_feedback(fields: Dictionary) -> Dictionary:
	if not _logging_enabled:
		return {}
	_ensure_dirs()
	var feedback_id: String = ClosedAlphaSession._new_id()
	var run_id: String = str(fields.get("related_run_id", ""))
	if run_id.is_empty():
		run_id = get_active_run_id()
		if run_id.is_empty():
			run_id = _last_completed_run_id
	var record := {
		"feedback_id": feedback_id,
		"anonymous_tester_id": get_anonymous_tester_id(),
		"app_version": ClosedAlphaConfig.get_alpha_version(),
		"content_version": ClosedAlphaConfig.get_content_version(),
		"created_at": int(Time.get_unix_time_from_system()),
		"feedback_type": str(fields.get("feedback_type", "general")),
		"related_decision_id": str(fields.get("related_decision_id", "")),
		"related_run_id": run_id,
		"rating": int(fields.get("rating", 0)),
		"comment": str(fields.get("comment", "")).substr(0, 2000),
		"flags": {
			"confusing_content": bool(fields.get("confusing_content", false)),
			"repeated_content": bool(fields.get("repeated_content", false)),
			"technical_bug": bool(fields.get("technical_bug", false)),
			"offensive_or_inappropriate": bool(fields.get("offensive_or_inappropriate", false)),
			"favorite_moment": bool(fields.get("favorite_moment", false)),
		},
	}
	_write_json("%s%s.json" % [FEEDBACK_DIR, feedback_id], record)
	if not run_id.is_empty():
		_link_feedback_to_run(run_id, feedback_id)
	return record


func load_all_runs() -> Array[Dictionary]:
	var runs: Array[Dictionary] = []
	_ensure_dirs()
	var dir := DirAccess.open(RUNS_DIR)
	if dir == null:
		return runs
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var data: Dictionary = _read_json("%s%s" % [RUNS_DIR, file_name])
			if not data.is_empty():
				runs.append(data)
		file_name = dir.get_next()
	dir.list_dir_end()
	return runs


func load_all_feedback() -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	_ensure_dirs()
	var dir := DirAccess.open(FEEDBACK_DIR)
	if dir == null:
		return items
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var data: Dictionary = _read_json("%s%s" % [FEEDBACK_DIR, file_name])
			if not data.is_empty():
				items.append(data)
		file_name = dir.get_next()
	dir.list_dir_end()
	return items


func compute_local_summary() -> Dictionary:
	return ClosedAlphaExporter.compute_summary(load_all_runs(), load_all_feedback(), get_session().to_dictionary())


func _on_run_started(run_state: RunState) -> void:
	if not is_active():
		return
	_mark_interrupted_active_run()
	var run_id: String = ClosedAlphaSession._new_id()
	var now: int = int(Time.get_unix_time_from_system())
	_active_run = {
		"anonymous_tester_id": get_anonymous_tester_id(),
		"app_version": ClosedAlphaConfig.get_alpha_version(),
		"content_version": ClosedAlphaConfig.get_content_version(),
		"content_hash": ClosedAlphaConfig.get_content_hash(),
		"run_id": run_id,
		"start_timestamp": now,
		"end_timestamp": 0,
		"run_duration_sec": 0,
		"status": "in_progress",
		"decisions": [],
		"laws_activated": [],
		"arcs_started": [],
		"arcs_completed": [],
		"arcs_failed": [],
		"crises_started": [],
		"crises_resolved": [],
		"crises_failed": [],
		"ending_id": "",
		"ruler_identity_id": "",
		"medals_earned": 0,
		"restart_after_ending": false,
		"crash_or_fatal_marker": false,
		"feedback_ids": [],
		"random_seed": run_state.random_seed if run_state != null else 0,
		"country_id": run_state.country_id if run_state != null else "",
	}
	_decision_presented_at_ms = 0
	_persist_active_run()
	_write_run_file()
	_update_index_entry(run_id, {
		"status": "in_progress",
		"start_timestamp": now,
	})


func _on_decision_presented(_decision: Dictionary) -> void:
	if not is_active() or _active_run.is_empty():
		return
	_decision_presented_at_ms = Time.get_ticks_msec()


func _on_decision_resolved(result: DecisionResult) -> void:
	if not is_active() or _active_run.is_empty() or result == null:
		return
	var now_ms: int = Time.get_ticks_msec()
	var decision_ms: int = 0
	if _decision_presented_at_ms > 0:
		decision_ms = maxi(0, now_ms - _decision_presented_at_ms)
	_decision_presented_at_ms = 0

	var state: RunState = GameManager.get_current_state()
	var history: Array = state.decision_history if state != null else []
	var resources_before: Dictionary = {}
	var resources_after: Dictionary = {}
	if not history.is_empty():
		var last: Dictionary = history[history.size() - 1]
		resources_before = last.get("resource_before", {})
		resources_after = last.get("resource_after", {})

	var entry := {
		"day": state.day if state != null else 0,
		"decision_id": result.decision_id,
		"advisor_id": "",
		"selected_option_id": result.selected_option_id,
		"decision_time_ms": decision_ms,
		"resources_before": resources_before.duplicate(true) if resources_before is Dictionary else {},
		"resources_after": resources_after.duplicate(true) if resources_after is Dictionary else {},
		"added_laws": result.added_laws.duplicate(),
	}
	if state != null and not history.is_empty():
		entry["advisor_id"] = str(history[history.size() - 1].get("advisor_id", ""))

	var decisions: Array = _active_run.get("decisions", [])
	decisions.append(entry)
	_active_run["decisions"] = decisions
	_write_run_file()
	_persist_active_run()


func _on_law_added(law_id: String) -> void:
	if not is_active() or _active_run.is_empty() or law_id.is_empty():
		return
	var laws: Array = _active_run.get("laws_activated", [])
	if law_id not in laws:
		laws.append(law_id)
		_active_run["laws_activated"] = laws
		_write_run_file()


func _on_arc_started(arc_id: String, _runtime: Dictionary) -> void:
	_append_unique_list("arcs_started", arc_id)


func _on_arc_completed(arc_id: String, _runtime: Dictionary) -> void:
	_append_unique_list("arcs_completed", arc_id)


func _on_arc_failed(arc_id: String, _runtime: Dictionary) -> void:
	_append_unique_list("arcs_failed", arc_id)


func _on_crisis_started(crisis_id: String, _runtime: Dictionary) -> void:
	_append_unique_list("crises_started", crisis_id)


func _on_crisis_resolved(crisis_id: String, _runtime: Dictionary) -> void:
	_append_unique_list("crises_resolved", crisis_id)


func _on_crisis_failed(crisis_id: String, _runtime: Dictionary) -> void:
	_append_unique_list("crises_failed", crisis_id)


func _on_run_ended(summary: RunSummary) -> void:
	if not is_active() or _active_run.is_empty():
		return
	var now: int = int(Time.get_unix_time_from_system())
	var start_ts: int = int(_active_run.get("start_timestamp", now))
	_active_run["end_timestamp"] = now
	_active_run["run_duration_sec"] = maxi(0, now - start_ts)
	_active_run["status"] = "completed"
	_active_run["crash_or_fatal_marker"] = false
	if summary != null:
		_active_run["ending_id"] = summary.ending_id
		_active_run["ruler_identity_id"] = summary.ruler_identity_id
		_active_run["medals_earned"] = summary.medals_earned
		_active_run["final_day"] = summary.final_day
		_active_run["final_resources"] = summary.final_resources.duplicate(true)
		_active_run["active_laws"] = summary.active_laws.duplicate()
	_last_completed_run_id = str(_active_run.get("run_id", ""))
	_write_run_file()
	_update_index_entry(_last_completed_run_id, {
		"status": "completed",
		"end_timestamp": now,
		"ending_id": str(_active_run.get("ending_id", "")),
	})
	_clear_active_run_marker()
	_active_run = {}


func _append_unique_list(key: String, value: String) -> void:
	if not is_active() or _active_run.is_empty() or value.is_empty():
		return
	var list: Array = _active_run.get(key, [])
	if value not in list:
		list.append(value)
		_active_run[key] = list
		_write_run_file()


func _link_feedback_to_run(run_id: String, feedback_id: String) -> void:
	var path: String = "%s%s.json" % [RUNS_DIR, run_id]
	var data: Dictionary = _read_json(path)
	if data.is_empty():
		return
	var ids: Array = data.get("feedback_ids", [])
	if feedback_id not in ids:
		ids.append(feedback_id)
		data["feedback_ids"] = ids
		_write_json(path, data)
	if not _active_run.is_empty() and str(_active_run.get("run_id", "")) == run_id:
		_active_run["feedback_ids"] = data.get("feedback_ids", [])


func _mark_interrupted_active_run() -> void:
	if not FileAccess.file_exists(ACTIVE_RUN_PATH):
		return
	var marker: Dictionary = _read_json(ACTIVE_RUN_PATH)
	var run_id: String = str(marker.get("run_id", ""))
	if run_id.is_empty():
		_clear_active_run_marker()
		return
	var path: String = "%s%s.json" % [RUNS_DIR, run_id]
	var data: Dictionary = _read_json(path)
	if data.is_empty():
		_clear_active_run_marker()
		return
	if str(data.get("status", "")) == "completed":
		_clear_active_run_marker()
		return
	var now: int = int(Time.get_unix_time_from_system())
	data["status"] = "abandoned"
	data["crash_or_fatal_marker"] = true
	data["end_timestamp"] = now
	data["run_duration_sec"] = maxi(0, now - int(data.get("start_timestamp", now)))
	_write_json(path, data)
	_update_index_entry(run_id, {
		"status": "abandoned",
		"crash_or_fatal_marker": true,
		"end_timestamp": now,
	})
	_clear_active_run_marker()


func _persist_active_run() -> void:
	if _active_run.is_empty():
		return
	_write_json(ACTIVE_RUN_PATH, {
		"run_id": str(_active_run.get("run_id", "")),
		"start_timestamp": int(_active_run.get("start_timestamp", 0)),
	})


func _clear_active_run_marker() -> void:
	if FileAccess.file_exists(ACTIVE_RUN_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(ACTIVE_RUN_PATH))


func _write_run_file() -> void:
	if _active_run.is_empty():
		return
	var run_id: String = str(_active_run.get("run_id", ""))
	if run_id.is_empty():
		return
	_write_json("%s%s.json" % [RUNS_DIR, run_id], _active_run)


func _update_index_entry(run_id: String, patch: Dictionary) -> void:
	var index: Dictionary = _read_json(INDEX_PATH)
	if index.is_empty():
		index = {"runs": {}}
	var runs: Dictionary = index.get("runs", {})
	var entry: Dictionary = runs.get(run_id, {"run_id": run_id})
	for key in patch:
		entry[key] = patch[key]
	runs[run_id] = entry
	index["runs"] = runs
	index["updated_at"] = int(Time.get_unix_time_from_system())
	_write_json(INDEX_PATH, index)


func _ensure_dirs() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(LOGS_DIR))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(RUNS_DIR))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(FEEDBACK_DIR))


static func _write_json(path: String, data: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_warning("[ALPHA] Cannot write %s" % path)
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


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
