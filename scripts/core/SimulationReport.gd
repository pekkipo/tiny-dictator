class_name SimulationReport
extends RefCounted

## Aggregated simulation and diagnostics output (Phase 2A milestone 2A-8).

const DIAGNOSTICS_DIR: String = "user://diagnostics/"

var report_type: String = "simulation"
var generated_at: int = 0
var config: Dictionary = {}
var simulation: Dictionary = {}
var static_diagnostics: Dictionary = {}
var export_paths: Dictionary = {}


func _init() -> void:
	generated_at = int(Time.get_unix_time_from_system())


static func new_simulation(config_dict: Dictionary) -> SimulationReport:
	var report := SimulationReport.new()
	report.report_type = "simulation"
	report.config = config_dict.duplicate(true)
	report.simulation = {
		"run_count": 0,
		"run_length": {"average": 0.0, "min": 0, "max": 0},
		"ending_distribution": {},
		"ruler_identity_distribution": {},
		"crisis_frequency": 0,
		"arc_start_rates": {},
		"arc_completion_rates": {},
		"average_completed_arcs": 0.0,
		"average_final_resources": {},
		"decision_selection_counts": {},
		"decisions_never_selected": [],
		"content_exhaustion_count": 0,
		"fallback_card_usage": 0,
		"average_medals_earned": 0.0,
		"errors": [],
	}
	return report


static func new_static_diagnostics() -> SimulationReport:
	var report := SimulationReport.new()
	report.report_type = "content_diagnostics"
	report.static_diagnostics = ContentDiagnostics.empty_report()
	return report


func set_static_diagnostics(data: Dictionary) -> void:
	static_diagnostics = data.duplicate(true)


func to_dictionary() -> Dictionary:
	var payload := {
		"type": report_type,
		"generated_at": generated_at,
		"config": config.duplicate(true),
	}
	if not simulation.is_empty():
		payload["simulation"] = simulation.duplicate(true)
	if not static_diagnostics.is_empty():
		payload["static_diagnostics"] = static_diagnostics.duplicate(true)
	return payload


func to_text() -> String:
	var lines: PackedStringArray = []
	lines.append("Tiny Dictator — %s report" % report_type.replace("_", " ").capitalize())
	lines.append("Generated: %d" % generated_at)
	lines.append("")

	if not config.is_empty():
		lines.append("Configuration:")
		for key in config:
			lines.append("  %s: %s" % [key, str(config[key])])
		lines.append("")

	if not simulation.is_empty():
		lines.append("Simulation summary:")
		lines.append("  Runs: %d" % int(simulation.get("run_count", 0)))
		var run_length: Dictionary = simulation.get("run_length", {})
		lines.append("  Run length — avg: %.1f  min: %d  max: %d" % [
			float(run_length.get("average", 0.0)),
			int(run_length.get("min", 0)),
			int(run_length.get("max", 0)),
		])
		lines.append("")
		lines.append("Ending distribution:")
		var ending_dist: Dictionary = simulation.get("ending_distribution", {})
		var total_runs: int = maxi(1, int(simulation.get("run_count", 0)))
		for ending_id in ending_dist:
			var count: int = int(ending_dist[ending_id])
			lines.append("  - %s: %d (%.1f%%)" % [ending_id, count, 100.0 * float(count) / float(total_runs)])
		lines.append("")
		lines.append("Ruler identity distribution:")
		for identity_id in simulation.get("ruler_identity_distribution", {}):
			var id_count: int = int(simulation["ruler_identity_distribution"][identity_id])
			lines.append("  - %s: %d" % [identity_id if not identity_id.is_empty() else "(none)", id_count])
		lines.append("")
		lines.append("Crisis frequency (runs with >=1 crisis): %d" % int(simulation.get("crisis_frequency", 0)))
		lines.append("Average completed arcs: %.2f" % float(simulation.get("average_completed_arcs", 0.0)))
		lines.append("Content exhaustion count: %d" % int(simulation.get("content_exhaustion_count", 0)))
		lines.append("Fallback card usage: %d" % int(simulation.get("fallback_card_usage", 0)))
		lines.append("Average medals earned: %.2f" % float(simulation.get("average_medals_earned", 0.0)))
		lines.append("")
		var avg_resources: Dictionary = simulation.get("average_final_resources", {})
		if not avg_resources.is_empty():
			lines.append("Average final resources:")
			for resource_id in avg_resources:
				lines.append("  %s: %.1f" % [resource_id, float(avg_resources[resource_id])])
			lines.append("")
		var never_selected: Array = simulation.get("decisions_never_selected", [])
		if not never_selected.is_empty():
			lines.append("Decisions never selected (%d):" % never_selected.size())
			for decision_id in never_selected:
				lines.append("  - %s" % decision_id)
			lines.append("")

	if not static_diagnostics.is_empty():
		lines.append(ContentDiagnostics.format_report_text(static_diagnostics))

	return "\n".join(lines)


func export_to_user_diagnostics(prefix: String = "") -> Dictionary:
	_ensure_diagnostics_dir()
	var stamp := Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_")
	if prefix.is_empty():
		prefix = report_type
	var base_name := "%s_%s" % [prefix, stamp]
	var json_path := "%s%s.json" % [DIAGNOSTICS_DIR, base_name]
	var text_path := "%s%s.txt" % [DIAGNOSTICS_DIR, base_name]
	_write_export_files(json_path, text_path)
	export_paths = {"json": json_path, "text": text_path}
	return export_paths.duplicate(true)


func export_to_stable_names(json_name: String, text_name: String) -> Dictionary:
	_ensure_diagnostics_dir()
	var json_path := "%s%s" % [DIAGNOSTICS_DIR, json_name]
	var text_path := "%s%s" % [DIAGNOSTICS_DIR, text_name]
	_write_export_files(json_path, text_path)
	export_paths = {"json": json_path, "text": text_path}
	return export_paths.duplicate(true)


func _write_export_files(json_path: String, text_path: String) -> void:
	var json_file := FileAccess.open(json_path, FileAccess.WRITE)
	if json_file != null:
		json_file.store_string(JSON.stringify(to_dictionary(), "\t"))
		json_file.close()

	var text_file := FileAccess.open(text_path, FileAccess.WRITE)
	if text_file != null:
		text_file.store_string(to_text())
		text_file.close()


static func get_diagnostics_dir_absolute() -> String:
	return ProjectSettings.globalize_path(DIAGNOSTICS_DIR)


static func _ensure_diagnostics_dir() -> void:
	var absolute := ProjectSettings.globalize_path(DIAGNOSTICS_DIR)
	DirAccess.make_dir_recursive_absolute(absolute)


static func get_latest_export_path(extension: String = "txt") -> String:
	_ensure_diagnostics_dir()
	var dir := DirAccess.open(DIAGNOSTICS_DIR)
	if dir == null:
		return ""
	var best_name := ""
	var best_time := 0
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".%s" % extension):
			var modified := FileAccess.get_modified_time("%s%s" % [DIAGNOSTICS_DIR, file_name])
			if modified >= best_time:
				best_time = modified
				best_name = file_name
		file_name = dir.get_next()
	dir.list_dir_end()
	if best_name.is_empty():
		return ""
	return "%s%s" % [DIAGNOSTICS_DIR, best_name]
