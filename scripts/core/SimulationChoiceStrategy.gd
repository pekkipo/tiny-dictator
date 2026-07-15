class_name SimulationChoiceStrategy
extends RefCounted

## Pluggable choice picker for headless simulation.


func pick_option(
	_decision: Dictionary,
	_state: RunState,
	_rng: RandomNumberGenerator,
) -> String:
	return ""


class RandomChoiceStrategy extends SimulationChoiceStrategy:
	func pick_option(
		decision: Dictionary,
		_state: RunState,
		rng: RandomNumberGenerator,
	) -> String:
		var options: Array = DecisionSchema.get_options(decision)
		if options.is_empty():
			return "left"
		var index: int = rng.randi_range(0, options.size() - 1)
		return str(options[index].get("id", "left"))


class FirstOptionChoiceStrategy extends SimulationChoiceStrategy:
	func pick_option(
		decision: Dictionary,
		_state: RunState,
		_rng: RandomNumberGenerator,
	) -> String:
		var options: Array = DecisionSchema.get_options(decision)
		if options.is_empty():
			return "left"
		return str(options[0].get("id", "left"))


static func from_name(name: String) -> SimulationChoiceStrategy:
	match name:
		"first", "deterministic":
			return FirstOptionChoiceStrategy.new()
		_:
			return RandomChoiceStrategy.new()
