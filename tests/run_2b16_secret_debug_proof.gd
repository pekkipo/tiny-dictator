extends SceneTree

## Debug reachability proof for 2B-16 secret endgame cards.
## Run: godot --headless --path . -s tests/run_2b16_secret_debug_proof.gd

func _initialize() -> void:
	await process_frame
	var repo := ContentRepository.new()
	if not repo.load_all():
		printerr("[PROOF] repo failed to load")
		quit(1)
		return
	var engine := DecisionEngine.new(repo, RandomNumberGenerator.new())
	var failures: int = 0

	failures += 0 if _prove(engine, repo, "endgame_secret_toaster_election", ["predictive_toaster_act"], [], []) else 1
	failures += 0 if _prove(engine, repo, "endgame_secret_wrong_map", ["border_parade_act"], ["cheese_arc_complete"], []) else 1
	failures += 0 if _prove(engine, repo, "endgame_secret_palace_micronation", ["palace_public_tour_act"], ["palace_reno_complete"], []) else 1
	failures += 0 if _prove(engine, repo, "endgame_secret_forms_awaken", ["form_sovereignty_act"], ["zero_forms_complete"], []) else 1

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
	for used_id in used:
		state.mark_decision_used(str(used_id))
	var decision: Dictionary = repo.get_decision(decision_id)
	var valid: bool = engine.is_decision_valid(decision, state, true)
	print("[PROOF] %s valid=%s" % [decision_id, valid])
	return valid
