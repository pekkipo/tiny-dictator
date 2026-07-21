extends SceneTree
func _initialize() -> void:
	await process_frame
	var gm: Node = root.get_node("GameManager")
	var report: SimulationReport = RunSimulator.new(gm).run_static_diagnostics("ministan", true)
	print(ContentDiagnostics.format_report_text(report.static_diagnostics))
	var err_count:=0; var warn_count:=0
	var findings: Dictionary = report.static_diagnostics.get("findings", {})
	for cat in findings:
		for item in findings[cat]:
			if str(item.get("severity",""))=="error": err_count+=1
			elif str(item.get("severity",""))=="warning": warn_count+=1
	print("BLOCKING_ERRORS=%d WARNINGS=%d TOTAL=%d" % [err_count, warn_count, int(report.static_diagnostics.get("summary",{}).get("total_findings",0))])
	# write markdown path helper
	var abs_json := ""
	if report.export_paths.has("json"):
		abs_json = ProjectSettings.globalize_path(str(report.export_paths["json"]))
	print("EXPORT_JSON=%s" % abs_json)
	quit(0 if err_count==0 else 1)
