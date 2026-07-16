extends SceneTree

## Milestone 2B-1 scaffolding validation tests.
## Run: godot --headless --path . -s tests/test_content_scaffolding.gd

const ContentScaffoldingValidator = preload("res://scripts/dev/ContentScaffoldingValidator.gd")
const ContentManifestBuilder = preload("res://scripts/dev/ContentManifestBuilder.gd")

var _failures: int = 0


func _initialize() -> void:
	var repo := ContentRepository.new()
	_check(repo.load_all(), "repository loads")

	var result := ContentScaffoldingValidator.validate_all(repo)
	for error in result.errors:
		printerr("[TEST] Scaffolding error: %s" % error)
	_failures += result.errors.size()

	for warning in result.warnings:
		print("[TEST] Scaffolding warning: %s" % warning)

	_test_manifest_reporting(repo)
	_test_runtime_decision_file_count()

	if _failures == 0:
		print("[TEST] All content scaffolding tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_manifest_reporting(repo: ContentRepository) -> void:
	var manifest := ContentManifestBuilder.build(repo, {})
	var quota: Dictionary = manifest.get("quota_report", {}).get("decisions", {})
	_check(quota.has("draft_total"), "quota_report has draft_total")
	_check(quota.has("by_category"), "quota_report has by_category")
	_check(quota.has("by_speaker"), "quota_report has by_speaker")
	_check(quota.has("by_stage"), "quota_report has by_stage")

	var qf: Dictionary = manifest.get("quality_findings", {})
	_check(qf.has("untested_content"), "quality_findings has untested_content")
	_check(qf.has("missing_visual_tags"), "quality_findings has missing_visual_tags")
	_check(qf.has("missing_review_status"), "quality_findings has missing_review_status")
	_check(qf.get("untested_content", []).size() > 0, "untested_content list populated")
	_check(qf.get("missing_review_status", []).size() > 0, "missing_review_status list populated")

	var quota_text := ContentManifestBuilder.format_quota_text(manifest)
	_check(quota_text.find("draft") >= 0, "format_quota_text mentions draft counts")
	_check(quota_text.find("By category") >= 0, "format_quota_text includes category quota")
	_check(manifest.get("phase", "") == "2b_8_short_chain_pack_c", "manifest phase is 2b_8_short_chain_pack_c")


func _test_runtime_decision_file_count() -> void:
	var json_files: Array[String] = []
	_collect_json_files("res://data/decisions/", json_files)
	_check(json_files.size() > 0, "runtime decision json files exist")
	_check(not DirAccess.dir_exists_absolute("res://data/decisions/ministan/onboarding"),
		"no premature ministan/onboarding runtime folder")


func _collect_json_files(dir_path: String, out: Array[String]) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return
	dir.list_dir_begin()
	var entry_name := dir.get_next()
	while entry_name != "":
		if entry_name.begins_with("."):
			entry_name = dir.get_next()
			continue
		var full_path := dir_path.path_join(entry_name)
		if dir.current_is_dir():
			_collect_json_files(full_path, out)
		elif entry_name.ends_with(".json"):
			out.append(full_path)
		entry_name = dir.get_next()
	dir.list_dir_end()
