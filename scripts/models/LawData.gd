class_name LawData
extends RefCounted

var id: String = ""
var name: String = ""
var description: String = ""
var icon: String = ""
var effects: Dictionary = {}

static func from_dict(data: Dictionary) -> LawData:
	var law := LawData.new()
	law.id = data.get("id", "")
	law.name = data.get("name", "")
	law.description = data.get("description", "")
	law.icon = data.get("icon", "")
	law.effects = data.get("effects", {})
	return law
