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


class ResourcePreserverChoiceStrategy extends SimulationChoiceStrategy:
	func pick_option(
		decision: Dictionary,
		state: RunState,
		rng: RandomNumberGenerator,
	) -> String:
		var options: Array = DecisionSchema.get_options(decision)
		if options.is_empty():
			return "left"
		var lowest_resource: String = "treasury"
		var lowest_value: int = state.get_resource("treasury")
		for resource_id in RunState.RESOURCE_IDS:
			var value: int = state.get_resource(resource_id)
			if value < lowest_value:
				lowest_value = value
				lowest_resource = resource_id
		var best_ids: Array[String] = []
		var best_score: int = -999999
		for option in options:
			var effects: Dictionary = option.get("effects", {})
			var score: int = int(effects.get(lowest_resource, 0))
			# Slight preference for not tanking other low resources.
			for resource_id in RunState.RESOURCE_IDS:
				if resource_id == lowest_resource:
					continue
				if state.get_resource(resource_id) <= lowest_value + 10:
					score += int(effects.get(resource_id, 0))
			if score > best_score:
				best_score = score
				best_ids = [str(option.get("id", "left"))]
			elif score == best_score:
				best_ids.append(str(option.get("id", "left")))
		return best_ids[rng.randi_range(0, best_ids.size() - 1)]


class PowerMaximizerChoiceStrategy extends SimulationChoiceStrategy:
	func pick_option(
		decision: Dictionary,
		_state: RunState,
		rng: RandomNumberGenerator,
	) -> String:
		var options: Array = DecisionSchema.get_options(decision)
		if options.is_empty():
			return "left"
		var best_ids: Array[String] = []
		var best_score: int = -999999
		for option in options:
			var effects: Dictionary = option.get("effects", {})
			var score: int = int(effects.get("order", 0)) * 2 + int(effects.get("elite_loyalty", 0)) * 2
			score += int(effects.get("treasury", 0))
			score -= maxi(0, -int(effects.get("happiness", 0)))
			if score > best_score:
				best_score = score
				best_ids = [str(option.get("id", "left"))]
			elif score == best_score:
				best_ids.append(str(option.get("id", "left")))
		return best_ids[rng.randi_range(0, best_ids.size() - 1)]


class ChaoticExplorerChoiceStrategy extends SimulationChoiceStrategy:
	func pick_option(
		decision: Dictionary,
		_state: RunState,
		rng: RandomNumberGenerator,
	) -> String:
		var options: Array = DecisionSchema.get_options(decision)
		if options.is_empty():
			return "left"
		var best_ids: Array[String] = []
		var best_score: int = -999999
		for option in options:
			var score: int = 0
			score += option.get("add_laws", []).size() * 5
			score += option.get("add_flags", []).size() * 3
			score += option.get("remove_laws", []).size() * 4
			score += option.get("arc_actions", []).size() * 4
			score += option.get("crisis_actions", []).size() * 4
			if not str(option.get("trigger_ending", "")).is_empty():
				score += 8
			var effects: Dictionary = option.get("effects", {})
			var variance: int = 0
			for resource_id in RunState.RESOURCE_IDS:
				variance += absi(int(effects.get(resource_id, 0)))
			score += variance
			var tags: Array = decision.get("tags", [])
			for tag in tags:
				var tag_id: String = str(tag)
				if tag_id.begins_with("joke_") or tag_id.contains("experiment") or tag_id.contains("rare"):
					score += 2
			if score > best_score:
				best_score = score
				best_ids = [str(option.get("id", "left"))]
			elif score == best_score:
				best_ids.append(str(option.get("id", "left")))
		return best_ids[rng.randi_range(0, best_ids.size() - 1)]


class HappinessPopulistChoiceStrategy extends SimulationChoiceStrategy:
	func pick_option(
		decision: Dictionary,
		_state: RunState,
		rng: RandomNumberGenerator,
	) -> String:
		var options: Array = DecisionSchema.get_options(decision)
		if options.is_empty():
			return "left"
		var best_ids: Array[String] = []
		var best_score: int = -999999
		for option in options:
			var effects: Dictionary = option.get("effects", {})
			var score: int = int(effects.get("happiness", 0)) * 3
			score += int(effects.get("order", 0))
			score -= maxi(0, -int(effects.get("elite_loyalty", 0)))
			if score > best_score:
				best_score = score
				best_ids = [str(option.get("id", "left"))]
			elif score == best_score:
				best_ids.append(str(option.get("id", "left")))
		return best_ids[rng.randi_range(0, best_ids.size() - 1)]


static func from_name(name: String) -> SimulationChoiceStrategy:
	match name:
		"first", "deterministic":
			return FirstOptionChoiceStrategy.new()
		"resource_preserver", "preserver":
			return ResourcePreserverChoiceStrategy.new()
		"power_maximizer", "power":
			return PowerMaximizerChoiceStrategy.new()
		"chaotic_explorer", "chaotic":
			return ChaoticExplorerChoiceStrategy.new()
		"happiness_populist", "populist":
			return HappinessPopulistChoiceStrategy.new()
		_:
			return RandomChoiceStrategy.new()
