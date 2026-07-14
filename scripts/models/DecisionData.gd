class_name DecisionData
extends RefCounted

var id: String = ""
var scenario_id: String = ""
var title: String = ""
var description: String = ""
var advisor_id: String = ""
var tags: Array[String] = []
var choices: Array[Dictionary] = []

static func from_dict(data: Dictionary) -> DecisionData:
	var decision := DecisionData.new()
	decision.id = data.get("id", "")
	decision.scenario_id = data.get("scenario_id", "")
	decision.title = data.get("title", "")
	decision.description = data.get("description", "")
	decision.advisor_id = data.get("advisor_id", "")
	for tag in data.get("tags", []):
		decision.tags.append(str(tag))
	decision.choices = data.get("choices", [])
	return decision
