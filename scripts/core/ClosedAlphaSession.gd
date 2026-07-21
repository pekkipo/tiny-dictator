class_name ClosedAlphaSession
extends RefCounted

## Locally generated anonymous tester/session ID for closed alpha.
## No email, name, device serial, advertising ID, or location.

const SESSION_PATH: String = "user://alpha_session.json"

var anonymous_tester_id: String = ""
var created_at: int = 0
var reset_count: int = 0


func _init() -> void:
	load_or_create()


func load_or_create() -> void:
	if FileAccess.file_exists(SESSION_PATH):
		var file := FileAccess.open(SESSION_PATH, FileAccess.READ)
		if file != null:
			var text: String = file.get_as_text()
			file.close()
			var json := JSON.new()
			if json.parse(text) == OK and json.data is Dictionary:
				var data: Dictionary = json.data
				anonymous_tester_id = str(data.get("anonymous_tester_id", ""))
				created_at = int(data.get("created_at", 0))
				reset_count = int(data.get("reset_count", 0))
				if not anonymous_tester_id.is_empty():
					return
	_generate_new(false)


func reset_identity() -> String:
	_generate_new(true)
	return anonymous_tester_id


func to_dictionary() -> Dictionary:
	return {
		"anonymous_tester_id": anonymous_tester_id,
		"created_at": created_at,
		"reset_count": reset_count,
	}


func _generate_new(is_reset: bool) -> void:
	if is_reset:
		reset_count += 1
	anonymous_tester_id = _new_id()
	created_at = int(Time.get_unix_time_from_system())
	_persist()


func _persist() -> void:
	var file := FileAccess.open(SESSION_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("[ALPHA] Cannot write session file.")
		return
	file.store_string(JSON.stringify(to_dictionary(), "\t"))
	file.close()


static func _new_id() -> String:
	var crypto := Crypto.new()
	var bytes: PackedByteArray = crypto.generate_random_bytes(16)
	var hex: String = bytes.hex_encode()
	## Format as UUID-like: 8-4-4-4-12
	return "%s-%s-%s-%s-%s" % [
		hex.substr(0, 8),
		hex.substr(8, 4),
		hex.substr(12, 4),
		hex.substr(16, 4),
		hex.substr(20, 12),
	]
