extends RefCounted

## Validates content_manifest.json against runtime ContentRepository.

const REQUIRED_DECISION_FIELDS: Array[String] = [
	"id", "content_type", "primary_content_class", "primary_category",
	"primary_speaker", "status", "schema_validation_status",
	"graph_validation_status", "manual_test_status", "voice_review_status",
	"balance_review_status", "batch_id",
]

const VALID_STATUSES: Array[String] = [
	"idea", "outlined", "draft", "integrated", "validation_failed",
	"simulation_failed", "needs_rewrite", "approved", "rejected", "deferred",
]

const VALID_CLASSES: Array[String] = [
	"onboarding", "standalone", "short_chain", "major_arc",
	"crisis", "recovery", "endgame",
]


static func validate(manifest: Dictionary, repository: ContentRepository) -> Dictionary:
	var errors: Array[String] = []
	var warnings: Array[String] = []
	_run_validate(manifest, repository, errors, warnings)
	return {
		"errors": errors,
		"warnings": warnings,
		"is_valid": errors.is_empty(),
	}


static func _run_validate(
	manifest: Dictionary,
	repository: ContentRepository,
	errors: Array[String],
	warnings: Array[String],
) -> void:
	if manifest.is_empty():
		errors.append("Manifest is empty")
		return

	var runtime_ids: Array[String] = []
	for decision in repository.get_all_decisions_for_country(str(manifest.get("country_id", "ministan"))):
		runtime_ids.append(str(decision.get("id", "")))

	var manifest_decisions: Array = manifest.get("decisions", [])
	var manifest_ids: Array[String] = []
	var seen_ids: Dictionary = {}

	for record in manifest_decisions:
		if not (record is Dictionary):
			errors.append("Manifest decisions array contains a non-object entry")
			continue
		_validate_decision_record(record, errors, warnings, seen_ids, manifest_ids)

	for runtime_id in runtime_ids:
		if runtime_id.is_empty():
			continue
		if runtime_id not in manifest_ids:
			errors.append("Runtime decision '%s' has no manifest record" % runtime_id)

	for manifest_id in manifest_ids:
		if not repository.has_decision(manifest_id):
			errors.append("Manifest decision '%s' has no runtime content" % manifest_id)

	_validate_quota_report(manifest, errors, warnings)


static func _validate_decision_record(
	record: Dictionary,
	errors: Array[String],
	warnings: Array[String],
	seen_ids: Dictionary,
	manifest_ids: Array[String],
) -> void:
	var id := str(record.get("id", ""))
	if id.is_empty():
		warnings.append("Manifest decision record missing 'id'")
		return

	if seen_ids.has(id):
		errors.append("Duplicate manifest decision id '%s'" % id)
		return
	seen_ids[id] = true
	manifest_ids.append(id)

	for field in REQUIRED_DECISION_FIELDS:
		if not record.has(field):
			warnings.append("Manifest decision '%s' missing required field '%s'" % [id, field])

	var status := str(record.get("status", ""))
	if not status.is_empty() and status not in VALID_STATUSES:
		warnings.append("Manifest decision '%s' has unknown status '%s'" % [id, status])

	var cls := str(record.get("primary_content_class", ""))
	if not cls.is_empty() and cls not in VALID_CLASSES:
		warnings.append("Manifest decision '%s' has unknown primary_content_class '%s'" % [id, cls])


static func _validate_quota_report(
	manifest: Dictionary,
	errors: Array[String],
	warnings: Array[String],
) -> void:
	var quota: Dictionary = manifest.get("quota_report", {})
	if quota.is_empty():
		warnings.append("Manifest missing quota_report")
		return

	var decisions: Array = manifest.get("decisions", [])
	var approved_count := 0
	var class_counts: Dictionary = {}
	for record in decisions:
		if not (record is Dictionary):
			continue
		var cls := str(record.get("primary_content_class", ""))
		class_counts[cls] = int(class_counts.get(cls, 0)) + 1
		if str(record.get("status", "")) == "approved":
			approved_count += 1

	var decisions_quota: Dictionary = quota.get("decisions", {})
	if int(decisions_quota.get("approved_total", -1)) != approved_count:
		errors.append(
			"quota_report.decisions.approved_total (%d) does not match manifest (%d)" % [
				int(decisions_quota.get("approved_total", -1)), approved_count,
			]
		)
	if int(decisions_quota.get("total_cataloged", -1)) != decisions.size():
		errors.append(
			"quota_report.decisions.total_cataloged (%d) does not match manifest (%d)" % [
				int(decisions_quota.get("total_cataloged", -1)), decisions.size(),
			]
		)

	var by_class: Dictionary = decisions_quota.get("by_class", {})
	for quota_class in by_class:
		var row: Dictionary = by_class[quota_class]
		var expected: int = int(class_counts.get(quota_class, 0))
		if int(row.get("total_cataloged", -1)) != expected:
			errors.append(
				"quota_report.by_class.%s.total_cataloged (%d) does not match manifest (%d)" % [
					quota_class, int(row.get("total_cataloged", -1)), expected,
				]
			)


static func format_result_text(result: Dictionary) -> String:
	var lines: PackedStringArray = ["Manifest validation:"]
	var errors: Array = result.get("errors", [])
	var warnings: Array = result.get("warnings", [])
	if errors.is_empty() and warnings.is_empty():
		lines.append("  OK - no errors or warnings")
		return "\n".join(lines)
	for error in errors:
		lines.append("  [ERROR] %s" % str(error))
	for warning in warnings:
		lines.append("  [WARN] %s" % str(warning))
	return "\n".join(lines)
