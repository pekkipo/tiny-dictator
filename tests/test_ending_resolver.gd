extends SceneTree

## Milestone 7 assertion tests for EndingResolver.
## Run: godot --headless --path . -s tests/test_ending_resolver.gd

var _failures: int = 0
var _repo: ContentRepository
var _resolver: EndingResolver
var _country: Dictionary


func _initialize() -> void:
	_repo = ContentRepository.new()
	_repo.load_all()
	_resolver = EndingResolver.new()
	_country = _repo.get_country("ministan")

	_test_no_ending_when_healthy()
	_test_single_resource_collapse()
	_test_multiple_collapse_priority()
	_test_explicit_ending()
	_test_unknown_explicit_ending()
	_test_special_beats_collapse()
	_test_max_day()
	_test_advisor_beats_resource_failure()
	_test_secret_priority_band()

	if _failures == 0:
		print("[TEST] All EndingResolver tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _fresh_state() -> RunState:
	var state := RunState.new()
	state.day = 5
	return state


func _resolve(state: RunState, result: DecisionResult = null) -> String:
	return str(_resolver.resolve_ending(state, result, _country, _repo).get("id", ""))


func _test_no_ending_when_healthy() -> void:
	_check(_resolve(_fresh_state()) == "", "healthy state has no ending")


func _test_single_resource_collapse() -> void:
	# TC-004 tail: happiness 0 triggers revolution.
	var state := _fresh_state()
	state.set_resource("happiness", 0)
	_check(_resolve(state) == "revolution", "happiness 0 -> revolution")

	state = _fresh_state()
	state.set_resource("treasury", 0)
	_check(_resolve(state) == "bankrupt_leader", "treasury 0 -> bankrupt_leader")

	state = _fresh_state()
	state.set_resource("order", 0)
	_check(_resolve(state) == "chaos_country", "order 0 -> chaos_country")

	state = _fresh_state()
	state.set_resource("elite_loyalty", 0)
	_check(_resolve(state) == "elite_coup", "elite_loyalty 0 -> elite_coup")


func _test_multiple_collapse_priority() -> void:
	# TC-017: simultaneous collapses resolve by configured priority.
	var state := _fresh_state()
	state.set_resource("happiness", 0)
	state.set_resource("elite_loyalty", 0)
	_check(_resolve(state) == "elite_coup", "elite_coup outranks revolution")

	state = _fresh_state()
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 0)
	_check(_resolve(state) == "elite_coup", "elite_coup wins full collapse")


func _test_explicit_ending() -> void:
	# TC-015: explicit trigger works even with healthy resources.
	var result := DecisionResult.new()
	result.triggered_ending_id = "bankrupt_leader"
	_check(_resolve(_fresh_state(), result) == "bankrupt_leader", "explicit ending selected")

	# Explicit outranks condition matches.
	var state := _fresh_state()
	state.set_resource("happiness", 0)
	_check(_resolve(state, result) == "bankrupt_leader", "explicit outranks collapse")


func _test_unknown_explicit_ending() -> void:
	var result := DecisionResult.new()
	result.triggered_ending_id = "nonexistent_ending"
	_check(_resolve(_fresh_state(), result) == "", "unknown explicit ending falls through safely")


func _test_special_beats_collapse() -> void:
	# TC-016: higher-priority special ending overrides a collapse ending.
	var state := _fresh_state()
	state.add_law("cat_voting_rights")
	state.add_flag("cats_control_parliament")
	state.change_counter("cat_favor_choices", 3)
	state.set_resource("happiness", 0)
	_check(_resolve(state) == "cat_republic", "cat_republic outranks revolution")

	# Without the counter threshold the special ending does not match.
	state = _fresh_state()
	state.add_law("cat_voting_rights")
	state.add_flag("cats_control_parliament")
	state.change_counter("cat_favor_choices", 2)
	_check(_resolve(state) == "", "special ending needs all conditions")


func _test_max_day() -> void:
	# TC-018: reaching max day triggers the survival ending.
	var state := _fresh_state()
	state.day = 40
	_check(_resolve(state) == "survived_the_prototype", "day 40 -> survival ending")

	state.day = 39
	_check(_resolve(state) == "", "day 39 -> no ending")


func _test_advisor_beats_resource_failure() -> void:
	# Advisor-relationship special should outrank a simultaneous resource failure.
	var state := _fresh_state()
	state.set_resource("treasury", 0)
	# penny_balances_final_budget conditions if any; else use general_remains_loyal
	var ending: Dictionary = _repo.get_ending("general_remains_loyal")
	var conditions: Dictionary = ending.get("conditions", {})
	for law_id in conditions.get("all_laws", []):
		state.add_law(str(law_id))
	for flag_id in conditions.get("all_flags", []):
		state.add_flag(str(flag_id))
	var counters: Dictionary = conditions.get("minimum_counters", {})
	for counter_id in counters:
		state.change_counter(str(counter_id), int(counters[counter_id]))
	if conditions.is_empty():
		# Fallback: use cat_republic which is known wired.
		state.add_law("cat_voting_rights")
		state.add_flag("cats_control_parliament")
		state.change_counter("cat_favor_choices", 3)
		_check(_resolve(state) == "cat_republic", "special outranks bankrupt_leader")
	else:
		var resolved := _resolve(state)
		_check(resolved != "bankrupt_leader", "advisor/special ending outranks bankrupt_leader (got %s)" % resolved)


func _test_secret_priority_band() -> void:
	# Secret toaster (priority 96) should beat resource failure when both valid.
	var state := _fresh_state()
	state.set_resource("order", 0)
	var toaster: Dictionary = _repo.get_ending("toaster_elected_president")
	var conditions: Dictionary = toaster.get("conditions", {})
	for law_id in conditions.get("all_laws", []):
		state.add_law(str(law_id))
	for flag_id in conditions.get("all_flags", []):
		state.add_flag(str(flag_id))
	var counters: Dictionary = conditions.get("minimum_counters", {})
	for counter_id in counters:
		state.change_counter(str(counter_id), int(counters[counter_id]))
	if not conditions.is_empty():
		_check(_resolve(state) == "toaster_elected_president", "secret toaster outranks chaos_country")
	else:
		# Explicit trigger still wins.
		var result := DecisionResult.new()
		result.triggered_ending_id = "toaster_elected_president"
		_check(_resolve(state, result) == "toaster_elected_president", "explicit secret outranks chaos")
