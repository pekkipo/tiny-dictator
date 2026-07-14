class_name EndingData
extends RefCounted

var id: String = ""
var title: String = ""
var description: String = ""
var flavor: String = ""
var conditions: Dictionary = {}

static func from_dict(data: Dictionary) -> EndingData:
	var ending := EndingData.new()
	ending.id = data.get("id", "")
	ending.title = data.get("title", "")
	ending.description = data.get("description", "")
	ending.flavor = data.get("flavor", "")
	ending.conditions = data.get("conditions", {})
	return ending
