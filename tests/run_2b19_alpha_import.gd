extends SceneTree

## Headless closed-alpha import runner (Milestone 2B-19).
## Usage:
##   godot --headless -s res://tests/run_2b19_alpha_import.gd -- --import-dir=res://docs/alpha/imports --write-docs=true

const DEFAULT_IMPORT_DIR: String = "user://alpha_imports/"


func _init() -> void:
	var args := _parse_args()
	var import_dir: String = str(args.get("import-dir", DEFAULT_IMPORT_DIR))
	var write_docs: bool = str(args.get("write-docs", "true")).to_lower() != "false"

	print("[ALPHA-IMPORT] import_dir=%s write_docs=%s" % [import_dir, write_docs])
	var result: Dictionary = ClosedAlphaReportGenerator.generate_and_write(import_dir, write_docs)
	var summary: Dictionary = result.get("summary", {})
	print("[ALPHA-IMPORT] packages=%d completed_runs=%d abandoned=%d feedback=%d" % [
		int(summary.get("package_count", 0)),
		int(summary.get("completed_runs", 0)),
		int(summary.get("abandoned_runs", 0)),
		int(summary.get("feedback_count", 0)),
	])
	if int(summary.get("package_count", 0)) <= 0:
		print("[ALPHA-IMPORT] %s" % ClosedAlphaReportGenerator.NO_DATA_LINE)
	quit()


func _parse_args() -> Dictionary:
	var out := {}
	for arg in OS.get_cmdline_user_args():
		if not arg.begins_with("--"):
			continue
		var body: String = arg.substr(2)
		var parts: PackedStringArray = body.split("=", true, 1)
		if parts.size() == 1:
			out[parts[0]] = "true"
		else:
			out[parts[0]] = parts[1]
	return out
