extends SceneTree

## Milestone 8 tests: CountryStateResolver logic + CountryDiorama rendering.
## Run: godot --headless --path . -s tests/test_country_state.gd

var _failures: int = 0
var _repo: ContentRepository
var _resolver: CountryStateResolver


func _initialize() -> void:
	_repo = ContentRepository.new()
	_repo.load_all()
	_resolver = CountryStateResolver.new()

	_test_default_state()
	_test_threshold_tiers()
	_test_law_visual_tags()
	_test_visual_map_loaded()
	await _test_diorama_component()

	if _failures == 0:
		print("[TEST] All CountryState tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_default_state() -> void:
	# 55 everywhere sits in the middle tier of each track.
	var visual := _resolver.resolve(RunState.new(), _repo)
	_check(visual.prosperity == "normal", "55 treasury -> normal")
	_check(visual.public_mood == "calm", "55 happiness -> calm")
	_check(visual.stability == "tense", "55 order -> tense (middle tier)")
	_check(visual.elite_status == "watching", "55 elite -> watching")
	_check(visual.visual_tags.is_empty(), "no laws -> no visual tags")
	_check(visual.summary_text == "Getting by, calm, tense, elite watching", "summary text composed, got '%s'" % visual.summary_text)


func _test_threshold_tiers() -> void:
	var state := RunState.new()

	# Boundaries: >60 healthy, 31-60 middling, <=30 bad.
	state.set_resource("treasury", 61)
	_check(_resolver.resolve(state, _repo).prosperity == "prosperous", "treasury 61 -> prosperous")
	state.set_resource("treasury", 60)
	_check(_resolver.resolve(state, _repo).prosperity == "normal", "treasury 60 -> normal")
	state.set_resource("treasury", 31)
	_check(_resolver.resolve(state, _repo).prosperity == "normal", "treasury 31 -> normal")
	state.set_resource("treasury", 30)
	_check(_resolver.resolve(state, _repo).prosperity == "poor", "treasury 30 -> poor")

	state.set_resource("happiness", 90)
	_check(_resolver.resolve(state, _repo).public_mood == "celebrating", "happiness 90 -> celebrating")
	state.set_resource("happiness", 10)
	_check(_resolver.resolve(state, _repo).public_mood == "protesting", "happiness 10 -> protesting")

	state.set_resource("order", 25)
	_check(_resolver.resolve(state, _repo).stability == "chaotic", "order 25 -> chaotic")

	state.set_resource("elite_loyalty", 75)
	_check(_resolver.resolve(state, _repo).elite_status == "supportive", "elite 75 -> supportive")
	state.set_resource("elite_loyalty", 5)
	_check(_resolver.resolve(state, _repo).elite_status == "coup_risk", "elite 5 -> coup_risk")


func _test_law_visual_tags() -> void:
	var state := RunState.new()
	state.add_law("free_pizza_friday")
	state.add_law("cat_voting_rights")
	var visual := _resolver.resolve(state, _repo)
	_check(visual.visual_tags.size() == 2, "two laws -> two tags")
	_check("pizza_stalls" in visual.visual_tags, "pizza law adds pizza_stalls tag")
	_check("cats_in_square" in visual.visual_tags, "cat law adds cats_in_square tag")

	# Duplicate tags collapse; unknown laws are ignored safely.
	state.add_law("nonexistent_law")
	visual = _resolver.resolve(state, _repo)
	_check(visual.visual_tags.size() == 2, "unknown law adds no tags")


func _test_visual_map_loaded() -> void:
	var visual_map := _repo.get_visual_map()
	_check(not visual_map.is_empty(), "visual map loaded from JSON")
	_check(visual_map.get("pizza_stalls") == "🍕", "pizza_stalls maps to pizza emoji")
	# Every shipped law tag must be mapped (validator warns otherwise).
	for law in _repo.get_raw_laws():
		for tag in law.get("visual_tags", []):
			_check(visual_map.has(str(tag)), "tag '%s' has a prop mapping" % tag)


func _test_diorama_component() -> void:
	await process_frame
	var diorama: PanelContainer = (load("res://scenes/components/CountryDiorama.tscn") as PackedScene).instantiate()
	root.add_child(diorama)
	await process_frame

	# Bad state: poor, protesting, chaotic, coup risk, two law props.
	var state := RunState.new()
	state.set_resource("treasury", 10)
	state.set_resource("happiness", 5)
	state.set_resource("order", 0)
	state.set_resource("elite_loyalty", 20)
	state.add_law("free_pizza_friday")
	state.add_law("tank_traffic_control")
	var visual := _resolver.resolve(state, _repo)
	diorama.update_visual_state(visual, _repo.get_visual_map())
	await process_frame

	_check("🏚️" in diorama.get_node("%HousesPlaceholder").text, "poor prosperity shows ruined houses")
	_check("🪧" in diorama.get_node("%CitizensPlaceholder").text, "protesting mood shows protest signs")
	_check("🗡️" in diorama.get_node("%PalacePlaceholder").text, "coup risk shows dagger at palace")
	_check(diorama.get_node("%MoodOverlay").color.a > 0.0, "chaotic stability tints the overlay")
	_check(diorama.get_node("%SpecialPropsLayer").get_child_count() == 2, "two law props rendered")
	_check("poor" in diorama.get_node("%StateDescriptionLabel").text.to_lower(), "description shows summary text")

	# Recovery: props are cleared and rebuilt, colors reset.
	var healthy_state := RunState.new()
	healthy_state.set_resource("order", 70)
	var healthy := _resolver.resolve(healthy_state, _repo)
	diorama.update_visual_state(healthy, _repo.get_visual_map())
	await process_frame
	_check(diorama.get_node("%SpecialPropsLayer").get_child_count() == 0, "props cleared when laws gone")
	_check(diorama.get_node("%MoodOverlay").color.a == 0.0, "stable overlay is transparent")
	_check("🏘️" in diorama.get_node("%HousesPlaceholder").text, "normal prosperity restores houses")

	diorama.queue_free()
	await process_frame
