class_name RunState
extends RefCounted

var scenario_id: String = ""
var day: int = 1
var resources: Dictionary = {}
var active_laws: Array[String] = []
var flags: Dictionary = {}
var seen_decisions: Array[String] = []
var ending_id: String = ""

func reset(scenario: Dictionary) -> void:
	scenario_id = scenario.get("id", "")
	day = 1
	resources = scenario.get("starting_resources", {}).duplicate(true)
	active_laws.clear()
	flags.clear()
	seen_decisions.clear()
	ending_id = ""

func has_flag(flag: String) -> bool:
	return flags.get(flag, false)

func set_flag(flag: String, value: bool = true) -> void:
	flags[flag] = value
