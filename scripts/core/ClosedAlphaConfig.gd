class_name ClosedAlphaConfig
extends RefCounted

## Development-configured closed-alpha mode (Milestone 2B-19).
## All alpha-only UI and logging must gate on is_enabled().

const CONFIG_PATH: String = "res://data/config/closed_alpha.json"
const MANIFEST_PATH: String = "res://data/content_manifest.json"

static var _cached: Dictionary = {}
static var _loaded: bool = false


static func reload() -> void:
	_loaded = false
	_cached = {}
	_ensure_loaded()


static func is_enabled() -> bool:
	return bool(_get_config_value("closed_alpha_enabled", false))


static func get_alpha_version() -> String:
	var configured: String = str(_get_config_value("alpha_version", ""))
	if not configured.is_empty():
		return configured
	return str(ProjectSettings.get_setting("application/config/version", "0.0.0"))


static func is_hidden_debug_menu_enabled() -> bool:
	return bool(_get_config_value("hidden_debug_menu_enabled", false))


static func is_analytics_backend_enabled() -> bool:
	## Closed alpha never sends data to a backend unless explicitly approved.
	return bool(_get_config_value("analytics_backend_enabled", false))


static func get_content_version() -> String:
	var source: String = str(_get_config_value("content_version_source", "manifest"))
	if source == "manifest":
		var batch_id: String = get_manifest_batch_id()
		if not batch_id.is_empty():
			return batch_id
	return get_alpha_version()


static func get_manifest_batch_id() -> String:
	var manifest: Dictionary = _load_json(MANIFEST_PATH)
	return str(manifest.get("batch_id", ""))


static func get_manifest_snapshot() -> Dictionary:
	var manifest: Dictionary = _load_json(MANIFEST_PATH)
	if manifest.is_empty():
		return {}
	return {
		"batch_id": str(manifest.get("batch_id", "")),
		"manifest_version": manifest.get("manifest_version", 0),
		"generated_at": str(manifest.get("generated_at", "")),
		"phase": str(manifest.get("phase", "")),
	}


static func get_content_hash() -> String:
	## Lightweight fingerprint of the manifest file (not cryptographic security).
	if not FileAccess.file_exists(MANIFEST_PATH):
		return ""
	return FileAccess.get_md5(MANIFEST_PATH)


static func get_version_label() -> String:
	var content: String = get_content_version()
	if content.is_empty():
		return "Closed Alpha %s" % get_alpha_version()
	return "Closed Alpha %s · content %s" % [get_alpha_version(), content]


static func get_raw() -> Dictionary:
	_ensure_loaded()
	return _cached.duplicate(true)


static func _get_config_value(key: String, default_value: Variant) -> Variant:
	_ensure_loaded()
	return _cached.get(key, default_value)


static func _ensure_loaded() -> void:
	if _loaded:
		return
	_cached = _load_json(CONFIG_PATH)
	if _cached.is_empty():
		_cached = {
			"closed_alpha_enabled": false,
			"alpha_version": "0.0.0",
			"content_version_source": "manifest",
			"hidden_debug_menu_enabled": false,
			"analytics_backend_enabled": false,
		}
	_loaded = true


static func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var text: String = file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK or not (json.data is Dictionary):
		push_warning("[ALPHA] Failed to parse %s" % path)
		return {}
	return json.data
