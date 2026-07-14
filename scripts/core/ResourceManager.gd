class_name ResourceManager
extends RefCounted

const LOSE_THRESHOLDS := {
	"approval": 0,
	"money": 0,
}

static func apply_changes(state: RunState, changes: Dictionary) -> void:
	for key in changes:
		var current: int = state.resources.get(key, 0)
		state.resources[key] = current + int(changes[key])
	EventBus.resources_changed.emit(state.resources.duplicate(true))

static func check_lose_condition(state: RunState) -> String:
	for key in LOSE_THRESHOLDS:
		if state.resources.get(key, 0) <= LOSE_THRESHOLDS[key]:
			return "lose_%s" % key
	return ""
