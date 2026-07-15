extends SceneTree

## Milestone 2A-6 tests: advisor affinity, ruler traits, and ruler identity.
## Run: godot --headless --path . -s tests/test_advisor_ruler_identity.gd

var _failures: int = 0
var _repo: ContentRepository


func _initialize() -> void:
	await process_frame
	_repo = ContentRepository.new()
	_repo.load_all()

	_test_affinity_initialization()
	_test_affinity_clamping()
	_test_affinity_eligibility()
	_test_trait_accumulation()
	_test_ruler_identity_resolution()
	_test_feedback_no_exact_values()
	_test_debug_visibility()
	_test_restart_cleanup()
	_test_old_save_compatibility()
	_test_arc_crisis_queue_intact()

	if _failures == 0:
		print("[TEST] All advisor/ruler identity tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _fresh_state() -> RunState:
	var state := RunState.new()
	state.country_id = "ministan"
	state.day = 5
	state.run_phase = RunState.RunPhase.AWAITING_DECISION
	for resource_id in RunState.RESOURCE_IDS:
		state.set_resource(resource_id, 55)
	return state


func _test_affinity_initialization() -> void:
	var state := _fresh_state()
	var advisor_manager := AdvisorRelationshipManager.new()
	advisor_manager.initialize_for_run(state, _repo)
	_check(_repo.get_raw_advisors().size() == 8, "catalog has 8 advisors")
	for advisor in _repo.get_raw_advisors():
		var advisor_id: String = str(advisor.get("id", ""))
		_check(state.get_advisor_affinity(advisor_id) == 0, "affinity starts at 0 for %s" % advisor_id)


func _test_affinity_clamping() -> void:
	var state := _fresh_state()
	state.advisor_affinity["general_boom"] = 4
	var applied_high: int = state.change_advisor_affinity("general_boom", 3)
	_check(state.get_advisor_affinity("general_boom") == 5, "affinity clamped at +5")
	_check(applied_high == 1, "applied high delta is +1, got %d" % applied_high)

	state.advisor_affinity["auntie_olga"] = -4
	var applied_low: int = state.change_advisor_affinity("auntie_olga", -3)
	_check(state.get_advisor_affinity("auntie_olga") == -5, "affinity clamped at -5")
	_check(applied_low == -1, "applied low delta is -1, got %d" % applied_low)


func _test_affinity_eligibility() -> void:
	var state := _fresh_state()
	var loyal_decision: Dictionary = _repo.get_decision("olga_loyal_council")
	_check(not loyal_decision.is_empty(), "loyal decision exists")

	state.advisor_affinity["auntie_olga"] = 2
	_check(
		not RequirementsEvaluator.matches(loyal_decision.get("requirements", {}), state),
		"loyal card blocked below threshold",
	)

	state.advisor_affinity["auntie_olga"] = 3
	_check(
		RequirementsEvaluator.matches(loyal_decision.get("requirements", {}), state),
		"loyal card eligible at threshold",
	)

	var hostile_decision: Dictionary = _repo.get_decision("boom_hostile_coup_rumor")
	state.advisor_affinity["general_boom"] = -2
	_check(
		not RequirementsEvaluator.matches(hostile_decision.get("requirements", {}), state),
		"hostile card blocked above threshold",
	)
	state.advisor_affinity["general_boom"] = -3
	_check(
		RequirementsEvaluator.matches(hostile_decision.get("requirements", {}), state),
		"hostile card eligible at threshold",
	)


func _test_trait_accumulation() -> void:
	var state := _fresh_state()
	var trait_manager := RulerTraitManager.new()
	trait_manager.initialize_for_run(state)
	var resolver := EffectResolver.new()
	var decision: Dictionary = _repo.get_decision("parade_budget_boost")
	var result := resolver.apply_option(
		decision, "fund_parade", state, _repo, null, null,
		AdvisorRelationshipManager.new(), trait_manager,
	)
	_check(state.get_ruler_trait("authoritarian") == 2, "authoritarian trait accumulated")
	_check(state.get_ruler_trait("populist") == -1, "populist trait can decrease")
	_check(result.ruler_trait_changes.has("authoritarian"), "result records trait changes")


func _test_ruler_identity_resolution() -> void:
	var trait_manager := RulerTraitManager.new()

	var tyrant_state := _fresh_state()
	trait_manager.initialize_for_run(tyrant_state)
	tyrant_state.ruler_traits["authoritarian"] = 5
	tyrant_state.ruler_traits["propagandist"] = 4
	var tyrant: Dictionary = trait_manager.resolve_identity(tyrant_state, _repo)
	_check(tyrant.get("id") == "the_smiling_tyrant", "authoritarian/propagandist resolves to Smiling Tyrant")

	var cat_state := _fresh_state()
	trait_manager.initialize_for_run(cat_state)
	cat_state.ruler_traits["cat_friendly"] = 6
	cat_state.ruler_traits["populist"] = 2
	var cat: Dictionary = trait_manager.resolve_identity(cat_state, _repo)
	_check(cat.get("id") == "supreme_cat_servant", "cat_friendly resolves to Supreme Cat Servant")

	var blank_state := _fresh_state()
	trait_manager.initialize_for_run(blank_state)
	var fallback: Dictionary = trait_manager.resolve_identity(blank_state, _repo)
	_check(fallback.get("id") == "the_accidental_ruler", "empty traits resolve to fallback")


func _test_feedback_no_exact_values() -> void:
	var advisor_manager := AdvisorRelationshipManager.new()
	var lines: Array[String] = advisor_manager.build_feedback_lines(
		{"general_boom": 1, "auntie_olga": -2}, _repo,
	)
	_check(lines.size() == 2, "two feedback lines generated")
	for line in lines:
		_check("=" not in line, "feedback line has no numeric affinity: %s" % line)
		_check(not line.contains("-2"), "feedback line hides exact delta: %s" % line)


func _test_debug_visibility() -> void:
	var state := _fresh_state()
	var advisor_manager := AdvisorRelationshipManager.new()
	var trait_manager := RulerTraitManager.new()
	advisor_manager.initialize_for_run(state, _repo)
	trait_manager.initialize_for_run(state)
	state.change_advisor_affinity("general_boom", 2)
	state.change_ruler_trait("bureaucratic", 3)

	var serialized: Dictionary = state.to_dictionary()
	_check(serialized.has("advisor_affinity"), "serialized state includes advisor_affinity")
	_check(serialized.has("ruler_traits"), "serialized state includes ruler_traits")
	_check(int(serialized["advisor_affinity"]["general_boom"]) == 2, "exact affinity in debug snapshot")
	_check(int(serialized["ruler_traits"]["bureaucratic"]) == 3, "exact traits in debug snapshot")

	var affinity_text: String = AdvisorRelationshipManager.format_affinity_dict(state, _repo)
	_check(affinity_text.contains("general_boom=2"), "debug affinity formatting shows exact value")


func _test_restart_cleanup() -> void:
	var state := _fresh_state()
	var advisor_manager := AdvisorRelationshipManager.new()
	var trait_manager := RulerTraitManager.new()
	advisor_manager.initialize_for_run(state, _repo)
	trait_manager.initialize_for_run(state)
	state.change_advisor_affinity("clerk_zero", 3)
	state.change_ruler_trait("scientific", 4)
	state.reset()
	advisor_manager.initialize_for_run(state, _repo)
	trait_manager.initialize_for_run(state)
	_check(state.get_advisor_affinity("clerk_zero") == 0, "restart clears affinity")
	_check(state.get_ruler_trait("scientific") == 0, "restart clears traits")


func _test_old_save_compatibility() -> void:
	var legacy := {
		"country_id": "ministan",
		"day": 8,
		"resources": {"treasury": 40, "happiness": 50, "order": 60, "elite_loyalty": 45},
		"active_laws": [],
		"flags": [],
		"counters": {},
		"used_decision_ids": [],
		"decision_history": [],
		"current_decision_id": "",
		"current_stage_id": "escalation",
		"active_arcs": {},
		"completed_arc_ids": [],
		"failed_arc_ids": [],
		"narrative_event_queue": [],
		"active_crisis": {},
		"run_phase": "AWAITING_DECISION",
		"random_seed": 999,
	}

	var state := RunState.new()
	state.from_dictionary(legacy)
	var advisor_manager := AdvisorRelationshipManager.new()
	advisor_manager.ensure_loaded_advisors(state, _repo)
	var trait_manager := RulerTraitManager.new()
	trait_manager.ensure_loaded_traits(state)

	_check(state.get_advisor_affinity("general_boom") == 0, "legacy save defaults affinity to 0")
	_check(state.get_ruler_trait("authoritarian") == 0, "legacy save defaults traits to 0")
	_check(state.day == 8, "legacy save preserves day")


func _test_arc_crisis_queue_intact() -> void:
	var state := _fresh_state()
	state.active_arcs["cat_politics"] = {
		"arc_id": "cat_politics", "status": "active", "current_step": 2, "branch_id": "support_cats",
	}
	state.active_crisis = {"crisis_id": "national_power_outage", "status": "active", "started_day": 5}
	state.narrative_event_queue.append({
		"event_id": "evt_test",
		"status": "pending",
		"decision_id": "free_pizza_hangover",
		"earliest_day": 6,
		"latest_day": 10,
		"priority": 50,
	})
	state.advisor_affinity["comrade_whiskers"] = 2
	state.ruler_traits["cat_friendly"] = 3

	var restored := RunState.new()
	restored.from_dictionary(state.to_dictionary())
	_check(restored.is_arc_active("cat_politics"), "arc survives affinity serialization")
	_check(str(restored.active_crisis.get("crisis_id", "")) == "national_power_outage", "crisis survives")
	_check(restored.narrative_event_queue.size() == 1, "queue survives")
	_check(restored.get_advisor_affinity("comrade_whiskers") == 2, "affinity survives round-trip")
	_check(restored.get_ruler_trait("cat_friendly") == 3, "traits survive round-trip")
