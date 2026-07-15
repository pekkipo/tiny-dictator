class_name ContentRequest
extends RefCounted

## Describes what kind of decision card ContentDirector wants next.
## DecisionEngine uses this as a soft bias, not a hard filter.

var request_type: String = "standalone"
var arc_id: String = ""
var preferred_card_types: Array[String] = []
var required_tags: Array[String] = []
var excluded_tags: Array[String] = []
var priority: int = 0
var reason: String = ""
var queued_decision_id: String = ""
var queued_event_id: String = ""
var mandatory: bool = false


func to_dictionary() -> Dictionary:
	return {
		"request_type": request_type,
		"arc_id": arc_id,
		"preferred_card_types": preferred_card_types.duplicate(),
		"required_tags": required_tags.duplicate(),
		"excluded_tags": excluded_tags.duplicate(),
		"priority": priority,
		"reason": reason,
		"queued_decision_id": queued_decision_id,
		"queued_event_id": queued_event_id,
		"mandatory": mandatory,
	}
