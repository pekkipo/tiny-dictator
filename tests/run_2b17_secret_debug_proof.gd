extends SceneTree

## Debug reachability proof for 2B-17 secret endings (incl. accidental moon).
## Run: godot --headless --path . -s tests/run_2b17_secret_debug_proof.gd

func _initialize() -> void:
	await process_frame
	var repo := ContentRepository.new()
	if not repo.load_all():
		printerr("[PROOF] repo failed to load")
		quit(1)
		return
	var engine := DecisionEngine.new(repo, RandomNumberGenerator.new())
	var failures: int = 0

	failures += 0 if _prove(engine, repo, "endgame_secret_toaster_election", ["ai_cabinet_pilot"], [], []) else 1
	failures += 0 if _prove(engine, repo, "endgame_secret_wrong_map", ["border_parade_act"], ["cheese_arc_complete"], []) else 1
	failures += 0 if _prove(engine, repo, "endgame_secret_palace_micronation", ["palace_subscription_plan"], ["palace_reno_complete"], []) else 1
	failures += 0 if _prove(engine, repo, "endgame_secret_forms_awaken", ["form_request_form_act"], ["zero_forms_complete"], []) else 1

	# Accidental moon: force ending via explicit trigger path on moon_arc_resolution
	var moon := repo.get_decision("moon_arc_resolution")
	var has_trigger := false
	for option in DecisionSchema.get_options(moon):
		if str(option.get("trigger_ending", "")) == "accidental_moon_replacement":
			has_trigger = true
	failures += 0 if has_trigger else 1
	print("[PROOF] accidental_moon_replacement explicit trigger on moon_arc_resolution=%s" % str(has_trigger))

	# Condition match proof
	var state := RunState.new()
	state.country_id = "ministan"
	state.day = 30
	state.add_flag("moon_replacement_pending")
	var ending: Dictionary = repo.get_ending("accidental_moon_replacement")
	var ok: bool = RequirementsEvaluator.matches(ending.get("conditions", {}), state)
	failures += 0 if ok else 1
	print("[PROOF] accidental_moon_replacement conditions match=%s" % str(ok))

	print("[PROOF] failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _prove(
	engine: DecisionEngine,
	repo: ContentRepository,
	decision_id: String,
	laws: Array,
	flag_ids: Array,
	used: Array,
) -> bool:
	var state := RunState.new()
	state.country_id = "ministan"
	state.day = 28
	state.current_stage_id = "endgame"
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	for law_id in laws:
		state.add_law(str(law_id))
	for flag_id in flag_ids:
		state.add_flag(str(flag_id))
	for decision in used:
		state.used_decision_ids.append(str(decision))
	var decision: Dictionary = repo.get_decision(decision_id)
	var valid: bool = engine.is_decision_valid(decision, state)
	print("[PROOF] %s valid=%s" % [decision_id, str(valid)])
	return valid
