extends SceneTree

## Milestone 3 assertion tests for ContentRepository and ContentValidator.
## Run: godot --headless --path . -s tests/test_content_validation.gd

var _failures: int = 0


func _initialize() -> void:
	_test_repository_loads()
	_test_shipped_content_is_valid()
	_test_validator_catches_bad_decisions()
	_test_validator_catches_bad_endings()

	if _failures == 0:
		print("[TEST] All content validation tests passed.")
	else:
		print("[TEST] FAILED: %d assertion(s) failed." % _failures)
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("[TEST] FAIL: %s" % message)


func _test_repository_loads() -> void:
	var repo := ContentRepository.new()
	var ok := repo.load_all()
	_check(ok, "repository loads without errors")
	_check(repo.has_country("ministan"), "ministan country loaded")
	_check(repo.get_raw_advisors().size() == 9, "9 advisors loaded")
	_check(repo.get_raw_laws().size() == 75, "75 laws loaded")
	_check(repo.get_raw_endings().size() == 31, "31 endings loaded")
	_check(repo.get_all_decisions_for_country("ministan").size() == 242, "242 decisions loaded for ministan")
	_check(repo.get_raw_ruler_identities().size() == 7, "7 ruler identities loaded")
	_check(repo.get_raw_arcs().size() == 12, "12 arcs loaded")
	_check(repo.get_raw_crises().size() == 7, "7 crises loaded")
	_check(repo.get_raw_follow_up_pools().size() == 12, "12 follow-up pools loaded")
	_check(repo.has_follow_up_pool("free_pizza_consequences"), "free_pizza_consequences pool present")
	_check(repo.has_follow_up_pool("fish_currency_consequences"), "fish_currency_consequences pool present")
	_check(repo.has_follow_up_pool("antivacuum_campaign_pool"), "antivacuum_campaign_pool present")
	_check(repo.has_decision("coupon_salaries_proposal"), "short-chain coupon salaries setup present")
	_check(repo.has_decision("form_request_forms_resolution"), "short-chain form resolution present")
	_check(repo.has_decision("ministry_of_waiting_proposal"), "short-chain waiting setup present")
	_check(repo.has_decision("national_nap_resolution"), "short-chain nap resolution present")
	_check(repo.has_ending("government_by_form"), "government_by_form ending present")
	_check(repo.has_law("coupon_salaries"), "coupon_salaries law present")
	_check(repo.has_law("form_request_form_act"), "form_request_form_act law present")
	_check(repo.has_law("fish_currency_act"), "fish_currency_act law present")
	_check(repo.has_law("ministry_of_waiting"), "ministry_of_waiting law present")
	_check(repo.has_law("antivacuum_act"), "antivacuum_act law present")
	_check(repo.has_law("national_nap_hour"), "national_nap_hour law present")
	_check(repo.has_follow_up_pool("coffee_reserve_consequences"), "coffee_reserve_consequences pool present")
	_check(repo.has_follow_up_pool("bench_privatization_consequences"), "bench_privatization_consequences pool present")
	_check(repo.has_follow_up_pool("meme_department_consequences"), "meme_department_consequences pool present")
	_check(repo.has_follow_up_pool("artificial_sun_consequences"), "artificial_sun_consequences pool present")
	_check(repo.has_decision("umbrella_tax_proposal"), "short-chain umbrella setup present")
	_check(repo.has_decision("privatized_benches_proposal"), "short-chain benches setup present")
	_check(repo.has_decision("palace_gift_shop_opening"), "short-chain gift shop setup present")
	_check(repo.has_decision("bridge_to_nowhere_resolution"), "short-chain bridge resolution present")
	_check(repo.has_decision("coin_shortage_crisis"), "short-chain coin shortage setup present")
	_check(repo.has_decision("state_meme_department"), "short-chain meme setup present")
	_check(repo.has_decision("artificial_sun_pilot"), "short-chain artificial sun setup present")
	_check(repo.has_ending("corporate_ministan"), "corporate_ministan ending present")
	_check(repo.has_ending("scientific_golden_age"), "scientific_golden_age ending present")
	_check(repo.has_law("umbrella_tax"), "umbrella_tax law present")
	_check(repo.has_law("sponsored_potholes_act"), "sponsored_potholes_act law present")
	_check(repo.has_law("coin_rounding_act"), "coin_rounding_act law present")
	_check(repo.has_law("ministry_of_memes"), "ministry_of_memes law present")
	_check(repo.has_law("artificial_sun_program"), "artificial_sun_program law present")
	_check(repo.has_law("mandatory_applause"), "mandatory_applause law present")
	_check(repo.has_arc("cat_politics"), "cat_politics arc present")
	_check(repo.has_arc("traffic_military"), "traffic_military arc present")
	_check(repo.has_arc("mandatory_happiness"), "mandatory_happiness arc present")
	_check(repo.has_arc("general_boom_arc"), "general_boom_arc arc present")
	_check(repo.has_arc("doctor_maybe_arc"), "doctor_maybe_arc arc present")
	_check(repo.has_crisis("national_power_outage"), "national_power_outage crisis present")
	_check(repo.has_crisis("mass_protest"), "mass_protest crisis present")
	_check(repo.has_decision("switch_off_traffic_lights"), "example decision present")
	_check(repo.has_decision("traffic_tank_solution"), "follow-up decision present")
	_check(repo.has_advisor("general_boom"), "advisor lookup works")
	_check(repo.has_advisor("comrade_whiskers"), "new advisor lookup works")
	_check(repo.has_ruler_identity("the_smiling_tyrant"), "ruler identity lookup works")
	_check(repo.has_decision("olga_loyal_council"), "affinity-gated decision present")
	_check(repo.has_law("free_pizza_friday"), "law lookup works")
	_check(repo.has_ending("cat_republic"), "ending lookup works")
	_check(repo.get_decision("nonexistent").is_empty(), "unknown decision returns empty")


func _test_shipped_content_is_valid() -> void:
	var repo := ContentRepository.new()
	repo.load_all()
	var report := ContentValidator.new().validate_repository(repo)
	for error in report.errors:
		printerr("[TEST] Unexpected content error: %s" % error)
	_check(report.is_valid, "shipped content has zero validation errors")
	_check(report.warnings.is_empty(), "shipped content has zero validation warnings")


func _test_validator_catches_bad_decisions() -> void:
	var repo := ContentRepository.new()
	repo.load_all()
	var validator := ContentValidator.new()

	var bad_advisor := _minimal_decision()
	bad_advisor["advisor_id"] = "unknown_advisor"
	_check(not validator.validate_decision(bad_advisor, repo).is_empty(), "unknown advisor detected")

	var bad_resource := _minimal_decision()
	bad_resource["left"]["effects"] = {"corruption": 5}
	_check(not validator.validate_decision(bad_resource, repo).is_empty(), "unknown resource detected")

	var bad_law := _minimal_decision()
	bad_law["right"]["add_laws"] = ["nonexistent_law"]
	_check(not validator.validate_decision(bad_law, repo).is_empty(), "unknown law detected")

	var bad_days := _minimal_decision()
	bad_days["minimum_day"] = 10
	bad_days["maximum_day"] = 5
	_check(not validator.validate_decision(bad_days, repo).is_empty(), "invalid day range detected")

	var bad_forced := _minimal_decision()
	bad_forced["right"]["force_next_decision"] = "nonexistent_decision"
	_check(not validator.validate_decision(bad_forced, repo).is_empty(), "unknown forced decision detected")

	var missing_result := _minimal_decision()
	missing_result["left"].erase("result_text")
	_check(not validator.validate_decision(missing_result, repo).is_empty(), "missing result_text detected")

	var bad_weight := _minimal_decision()
	bad_weight["weight"] = 0
	_check(not validator.validate_decision(bad_weight, repo).is_empty(), "zero weight detected")

	var good := _minimal_decision()
	_check(validator.validate_decision(good, repo).is_empty(), "minimal valid decision passes")

	var bad_follow_up := _minimal_decision()
	bad_follow_up["right"]["follow_up"] = {"type": "soft", "decision_id": "nonexistent_decision", "minimum_delay_days": 1, "maximum_delay_days": 2}
	_check(not validator.validate_decision(bad_follow_up, repo).is_empty(), "unknown follow-up decision detected")

	var bad_pool := _minimal_decision()
	bad_pool["right"]["follow_up"] = {"type": "pool", "pool_id": "nonexistent_pool", "minimum_delay_days": 1, "maximum_delay_days": 2}
	_check(not validator.validate_decision(bad_pool, repo).is_empty(), "unknown follow-up pool detected")

	var bad_affinity := _minimal_decision()
	bad_affinity["left"]["advisor_affinity"] = {"unknown_advisor": 1}
	_check(not validator.validate_decision(bad_affinity, repo).is_empty(), "unknown advisor in affinity detected")

	var bad_trait := _minimal_decision()
	bad_trait["left"]["trait_changes"] = {"not_a_trait": 1}
	_check(not validator.validate_decision(bad_trait, repo).is_empty(), "unknown trait detected")


func _test_validator_catches_bad_endings() -> void:
	var validator := ContentValidator.new()
	var bad_ending := {
		"id": "broken_ending",
		"type": "special",
		"priority": "high",
		"title": "",
		"description": "Something",
		"conditions": {"unknown_operator": []},
	}
	var errors := validator.validate_ending(bad_ending)
	_check(errors.size() >= 3, "bad ending produces multiple errors (priority, title, condition), got %d" % errors.size())


func _minimal_decision() -> Dictionary:
	return {
		"id": "test_decision",
		"advisor_id": "auntie_olga",
		"proposal": "A perfectly reasonable test proposal about national affairs.",
		"left": {
			"label": "Decline",
			"effects": {"happiness": -2},
			"result_text": "Nothing much happens, which is suspicious.",
		},
		"right": {
			"label": "Approve",
			"effects": {"treasury": -3},
			"result_text": "Something happens, which is also suspicious.",
		},
	}
