extends SceneTree

## Build and validate content manifest for Milestone 2B-0.
## Run: godot --headless --path . -s tests/run_content_manifest.gd
## Optional: godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit

const ContentManifestBuilder = preload("res://scripts/dev/ContentManifestBuilder.gd")
const ContentManifestValidator = preload("res://scripts/dev/ContentManifestValidator.gd")
const ContentManifestAuditWriter = preload("res://scripts/dev/ContentManifestAuditWriter.gd")

const MANIFEST_PATH := "res://data/content_manifest.json"
const AUDIT_PATH := "res://docs/content/PHASE_2A_CONTENT_AUDIT.md"

var _export_audit: bool = false


func _initialize() -> void:
	_parse_args()
	var repo := ContentRepository.new()
	if not repo.load_all():
		printerr("[MANIFEST] Failed to load content repository")
		quit(1)
		return

	var diagnostics := ContentDiagnostics.new().analyze(repo, "ministan")
	var manifest := ContentManifestBuilder.build(repo, diagnostics)
	var validation := ContentManifestValidator.validate(manifest, repo)

	print(ContentManifestBuilder.format_quota_text(manifest))
	print("")
	print(ContentManifestValidator.format_result_text(validation))

	var write_err := ContentManifestBuilder.write_json(manifest, MANIFEST_PATH)
	if write_err != OK:
		printerr("[MANIFEST] Failed to write %s (error %d)" % [MANIFEST_PATH, write_err])
		quit(1)
		return
	print("[MANIFEST] Wrote %s" % MANIFEST_PATH)

	if _export_audit:
		var audit_err := _write_audit_markdown(manifest, validation)
		if audit_err != OK:
			printerr("[MANIFEST] Failed to write audit doc")
			quit(1)
			return
		print("[MANIFEST] Wrote %s" % AUDIT_PATH)

	if not validation.get("is_valid", false):
		printerr("[MANIFEST] Validation failed")
		quit(1)
		return

	print("[MANIFEST] Manifest build and validation passed.")
	quit(0)


func _parse_args() -> void:
	for arg in OS.get_cmdline_user_args():
		if str(arg) == "--export-audit":
			_export_audit = true


func _write_audit_markdown(manifest: Dictionary, validation) -> Error:
	var file := FileAccess.open(AUDIT_PATH, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(ContentManifestAuditWriter.format(manifest, validation))
	return OK
