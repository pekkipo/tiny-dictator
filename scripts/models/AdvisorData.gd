class_name AdvisorData
extends RefCounted

var id: String = ""
var name: String = ""
var title: String = ""
var portrait: String = ""
var personality_tags: Array[String] = []

static func from_dict(data: Dictionary) -> AdvisorData:
	var advisor := AdvisorData.new()
	advisor.id = data.get("id", "")
	advisor.name = data.get("name", "")
	advisor.title = data.get("title", "")
	advisor.portrait = data.get("portrait", "")
	for tag in data.get("personality_tags", []):
		advisor.personality_tags.append(str(tag))
	return advisor
