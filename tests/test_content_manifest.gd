extends SceneTree

## Milestone 2B-0 manifest validation tests.
## Run: godot --headless --path . -s tests/test_content_manifest.gd

const ContentManifestValidator = preload("res://scripts/dev/ContentManifestValidator.gd")

const MANIFEST_PATH := "res://data/content_manifest.json"

var _failures: int = 0


func _initialize() -> void:
	var repo := ContentRepository.new()
	_check(repo.load_all(), "repository loads")

	var manifest := _load_manifest()
	_check(not manifest.is_empty(), "manifest file loads")

	var validation := ContentManifestValidator.validate(manifest, repo)
	for error in validation.errors:
		printerr("[TEST] Manifest error: %s" % error)
	_failures += validation.errors.size()

	_test_runtime_sync(manifest, repo)
	_test_no_duplicate_ids(manifest)
	_test_quota_recompute(manifest)
	_test_quality_findings(manifest)
	_test_required_fields(manifest)
	_test_expected_counts(manifest)

	if _failures == 0:
		print("[TEST] All content manifest tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _load_manifest() -> Dictionary:
	if not FileAccess.file_exists(MANIFEST_PATH):
		return {}
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}


func _test_runtime_sync(manifest: Dictionary, repo: ContentRepository) -> void:
	var runtime_ids: Array[String] = []
	for decision in repo.get_all_decisions_for_country("ministan"):
		runtime_ids.append(str(decision.get("id", "")))

	var manifest_ids: Array[String] = []
	for record in manifest.get("decisions", []):
		if record is Dictionary:
			manifest_ids.append(str(record.get("id", "")))

	_check(runtime_ids.size() == manifest_ids.size(),
		"runtime and manifest decision counts match (%d vs %d)" % [runtime_ids.size(), manifest_ids.size()])

	for runtime_id in runtime_ids:
		_check(runtime_id in manifest_ids, "runtime decision '%s' has manifest record" % runtime_id)
	for manifest_id in manifest_ids:
		_check(repo.has_decision(manifest_id), "manifest decision '%s' exists in runtime" % manifest_id)


func _test_no_duplicate_ids(manifest: Dictionary) -> void:
	var seen: Dictionary = {}
	for record in manifest.get("decisions", []):
		if not (record is Dictionary):
			continue
		var id := str(record.get("id", ""))
		_check(not seen.has(id), "no duplicate manifest id '%s'" % id)
		seen[id] = true


func _test_quota_recompute(manifest: Dictionary) -> void:
	var decisions: Array = manifest.get("decisions", [])
	var approved := 0
	var class_counts: Dictionary = {}
	for record in decisions:
		if not (record is Dictionary):
			continue
		var cls := str(record.get("primary_content_class", ""))
		class_counts[cls] = int(class_counts.get(cls, 0)) + 1
		if str(record.get("status", "")) == "approved":
			approved += 1

	var quota: Dictionary = manifest.get("quota_report", {}).get("decisions", {})
	_check(int(quota.get("approved_total", -1)) == approved,
		"quota_report approved_total matches manifest (%d)" % approved)
	_check(int(quota.get("total_cataloged", -1)) == decisions.size(),
		"quota_report total_cataloged matches manifest size")
	_check(quota.has("draft_total"), "quota_report has draft_total")
	_check(quota.has("by_category"), "quota_report has by_category")
	_check(quota.has("by_speaker"), "quota_report has by_speaker")
	_check(quota.has("by_stage"), "quota_report has by_stage")

	var by_class: Dictionary = quota.get("by_class", {})
	for quota_class in by_class:
		var row: Dictionary = by_class[quota_class]
		_check(int(row.get("total_cataloged", -1)) == int(class_counts.get(quota_class, 0)),
			"quota by_class %s total_cataloged matches" % quota_class)


func _test_quality_findings(manifest: Dictionary) -> void:
	var qf: Dictionary = manifest.get("quality_findings", {})
	_check(qf.has("untested_content"), "quality_findings has untested_content")
	_check(qf.has("missing_visual_tags"), "quality_findings has missing_visual_tags")
	_check(qf.has("missing_review_status"), "quality_findings has missing_review_status")
	_check(qf.get("untested_content", []).size() > 0, "untested_content populated")
	_check(qf.get("missing_review_status", []).size() > 0, "missing_review_status populated")

	var dist: Dictionary = manifest.get("distribution_report", {})
	_check(dist.has("by_review_status"), "distribution_report has by_review_status")


func _test_required_fields(manifest: Dictionary) -> void:
	for record in manifest.get("decisions", []):
		if not (record is Dictionary):
			continue
		for field in ContentManifestValidator.REQUIRED_DECISION_FIELDS:
			_check(record.has(field), "decision '%s' has field '%s'" % [record.get("id", ""), field])


func _test_expected_counts(manifest: Dictionary) -> void:
	_check(manifest.get("decisions", []).size() == 76, "manifest has 76 decisions")
	_check(manifest.get("catalogs", {}).get("arcs", []).size() == 6, "manifest has 6 arcs")
	_check(manifest.get("catalogs", {}).get("crises", []).size() == 7, "manifest has 7 crises")
	_check(manifest.get("catalogs", {}).get("laws", []).size() == 12, "manifest has 12 laws")
	_check(manifest.get("catalogs", {}).get("endings", []).size() == 11, "manifest has 11 endings")
	_check(manifest.get("catalogs", {}).get("advisors", []).size() == 8, "manifest has 8 advisors")
	_check(manifest.get("catalogs", {}).get("ruler_identities", []).size() == 7, "manifest has 7 ruler identities")
	_check(manifest.get("catalogs", {}).get("palace_upgrades", []).size() == 3, "manifest has 3 palace upgrades")
	_check(manifest.get("catalogs", {}).get("chains", []).size() == 3, "manifest has 3 chains")

	var approved: int = int(manifest.get("quota_report", {}).get("decisions", {}).get("approved_total", -1))
	_check(approved == 10, "onboarding pack approved count (got %d)" % approved)
	var onboarding_approved: int = int(
		manifest.get("quota_report", {}).get("decisions", {}).get("by_class", {}).get("onboarding", {}).get("approved", -1)
	)
	_check(onboarding_approved == 10, "onboarding class has 10 approved (got %d)" % onboarding_approved)
