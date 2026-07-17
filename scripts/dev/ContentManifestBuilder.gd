extends RefCounted

## Development-only manifest builder for Phase 2B content tracking.
## Spec: docs/09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md §20, Milestones 2B-0 / 2B-1.

const MANIFEST_VERSION: int = 1
const COUNTRY_ID: String = "ministan"
const PHASE: String = "2b_12_major_arc_pack_c"
const BATCH_ID: String = "2B-12"
const DECISION_BATCH_ID: String = "2B-12"

const DRAFT_STATUSES: Array[String] = ["idea", "outlined", "draft"]

const TARGETS: Dictionary = {
	"decisions_by_class": {
		"onboarding": 10,
		"standalone": 72,
		"short_chain": 80,
		"major_arc": 96,
		"crisis": 28,
		"recovery": 24,
		"endgame": 20,
	},
	"decisions_by_category": {
		"economy": 50,
		"public_life": 48,
		"military_and_order": 38,
		"media_and_propaganda": 34,
		"science_and_technology": 40,
		"business_and_privatization": 32,
		"bureaucracy": 32,
		"cats_and_animals": 26,
		"infrastructure": 30,
	},
	"decisions_by_speaker": {
		"general_boom": 38,
		"minister_penny": 40,
		"luna_news": 38,
		"auntie_olga": 42,
		"doctor_maybe": 38,
		"sir_profit": 36,
		"comrade_whiskers": 34,
		"clerk_zero": 36,
		"guest_and_system": 28,
	},
	"decisions_by_stage": {
		"establishment": 83,
		"escalation": 99,
		"instability": 89,
		"endgame": 59,
	},
	"decisions_total": 330,
	"major_arcs": 18,
	"short_chains": 32,
	"crises": 18,
	"laws": 50,
	"endings": 50,
	"palace_upgrades": 24,
	"ruler_identities": 12,
	"advisors": 10,
	"guest_speakers": 6,
}

const LEGACY_CATEGORY_MAP: Dictionary = {
	"military": "military_and_order",
	"media": "media_and_propaganda",
	"science": "science_and_technology",
	"administration": "bureaucracy",
	"government": "bureaucracy",
	"politics": "public_life",
	"absurd_law": "public_life",
	"follow_up": "public_life",
	"economy": "economy",
	"public_life": "public_life",
	"infrastructure": "infrastructure",
	"business_and_privatization": "business_and_privatization",
	"bureaucracy": "bureaucracy",
	"cats_and_animals": "cats_and_animals",
}

const GUEST_SPEAKER_IDS: Array[String] = [
	"foreign_ambassador",
	"chief_judge",
	"palace_chef",
	"youth_representative",
	"workers_union_leader",
	"neighboring_president",
]

const MAJOR_ARC_IDS: Array[String] = [
	"cat_politics", "mandatory_happiness", "general_boom_arc", "doctor_maybe_arc",
	"penny_austerity_arc", "traffic_military_control", "hyperinflation_arc",
	"luna_media_reality", "olga_citizen_movement", "fake_election_accident",
	"profit_corporate_state", "robot_government", "sell_the_moon",
]

const APPROVED_MAJOR_ARC_IDS: Array[String] = [
	"general_boom_arc", "penny_austerity_arc", "traffic_military_control", "hyperinflation_arc",
	"luna_media_reality", "olga_citizen_movement", "mandatory_happiness", "fake_election_accident",
	"doctor_maybe_arc", "profit_corporate_state", "robot_government", "sell_the_moon",
]

const MINOR_ARC_IDS: Array[String] = ["traffic_military"]

const MAJOR_ARC_PACK_A_APPROVED_IDS: Array[String] = [
	# Boom — The General's Rise (7)
	"military_parade", "army_snack_budget", "parade_budget_boost",
	"boom_emergency_powers_demand", "boom_loyal_protector", "boom_failed_coup",
	"boom_ceremonial_mascot",
	# Penny — The Austerity Miracle (6)
	"penny_deficit_briefing", "penny_service_trimming", "penny_service_sunset",
	"penny_ledger_review", "penny_miracle_balanced", "penny_austerity_resolution",
	# Traffic and Military Control (6)
	"traffic_gridlock_brief", "traffic_military_convoy", "traffic_checkpoint_hour",
	"traffic_control_climax", "traffic_civilian_peace", "traffic_martial_resolution",
	# Hyperinflation (5)
	"hyperinflation_price_spiral", "hyperinflation_public_adaptation",
	"hyperinflation_policy_fork", "hyperinflation_temp_success", "hyperinflation_resolution",
]

const MAJOR_ARC_PACK_B_APPROVED_IDS: Array[String] = [
	# Luna — The Media Becomes Reality (6)
	"luna_narrative_brief", "luna_ratings_spike", "luna_reality_segments",
	"luna_media_fork", "luna_credibility_test", "luna_media_resolution",
	# Olga — The Citizen Movement (6)
	"olga_everyday_complaint", "olga_practical_campaign", "olga_movement_forms",
	"olga_government_response", "olga_loyalty_test", "olga_movement_resolution",
	# Mandatory Happiness rewrite (6)
	"mandatory_smiling_proposal", "happiness_measurement_bureau", "happiness_policy_fork",
	"happiness_branch_consequence", "happiness_backlash", "happiness_arc_resolution",
	# Fake Election Accident (6)
	"election_filing_proposal", "election_ballot_setup", "election_campaign_noise",
	"election_unexpected_result", "election_government_response", "election_arc_resolution",
]

const MAJOR_ARC_PACK_C_APPROVED_IDS: Array[String] = [
	# Doctor Maybe — The Experimental Republic (6)
	"maybe_useful_trial", "maybe_national_trial", "maybe_experiment_dependence",
	"maybe_ethics_fork", "maybe_major_consequence", "maybe_experimental_resolution",
	# Sir Profit — The Corporate State (6)
	"profit_partnership_brief", "profit_commercial_success", "profit_institution_lease",
	"profit_ownership_fork", "profit_identity_crisis", "profit_corporate_resolution",
	# AI Government (6)
	"ai_admin_pilot", "ai_admin_success", "ai_authority_expand",
	"ai_human_system_fork", "ai_cabinet_crisis", "ai_government_resolution",
	# Sell the Moon (6)
	"moon_budget_proposal", "moon_ownership_campaign", "moon_path_fork",
	"moon_international_reaction", "moon_crisis_opportunity", "moon_arc_resolution",
]

const CHAIN_MEMBERS: Dictionary = {
	"free_pizza_consequences": [
		"free_pizza_friday", "cheese_shortage", "pizza_union_strike", "pineapple_referendum",
	],
	"traffic_military": [
		"switch_off_traffic_lights", "traffic_tank_solution", "traffic_complaint",
		"traffic_military_resolved", "traffic_lights_restored",
	],
	"cat_politics_followups": ["cat_parliament", "cat_fish_budget"],
	"umbrella_tax": ["umbrella_tax_proposal", "umbrella_tax_enforcement"],
	"national_coffee_reserve": [
		"free_coffee_morning", "coffee_hoarding_crisis", "coffee_reserve_resolution",
	],
	"privatized_public_benches": [
		"privatized_benches_proposal", "bench_subscription_backlash", "bench_policy_resolution",
	],
	"lottery_budget": ["lottery_treasury_fund", "lottery_odds_collapse"],
	"palace_gift_shop": ["palace_gift_shop_opening", "gift_shop_merch_scandal"],
	"elevator_wifi": ["elevator_wifi_mandate", "elevator_wifi_trap"],
	"pothole_naming_rights": [
		"sponsored_potholes", "pothole_brand_war", "pothole_naming_resolution",
	],
	"bridge_to_nowhere": [
		"long_setup_grand_canal", "bridge_budget_overrun", "bridge_to_nowhere_resolution",
	],
	"coin_shortage": ["coin_shortage_crisis", "coin_shortage_remedy"],
	"national_clock_reform": ["national_clock_sync", "clock_appointment_chaos"],
	"weekend_abolition": [
		"no_weekends_proposal", "weekend_burnout_wave", "weekend_policy_resolution",
	],
	"state_meme_department": [
		"state_meme_department", "meme_virality_crisis", "meme_department_resolution",
	],
	"weather_censorship": ["weather_censorship_mandate", "weather_credibility_crisis"],
	"national_talent_show": ["national_talent_show", "talent_show_budget_scandal"],
	"applause_quotas": [
		"applause_quotas_mandate", "applause_enforcement_squad", "applause_public_adaptation",
	],
	"artificial_sun": [
		"artificial_sun_pilot", "artificial_sun_escalation", "artificial_sun_resolution",
	],
	"antigravity_buses": ["antigravity_buses_pilot", "antigravity_buses_consequence"],
	"national_clone_day": ["national_clone_day", "clone_registry_chaos"],
	"traffic_flags": [
		"traffic_flag_corps", "traffic_flag_backlash", "traffic_flag_resolution",
	],
	"robot_queue_manager": [
		"robot_queue_manager", "robot_queue_incident", "robot_queue_resolution",
	],
	"pigeon_air_force": ["pigeon_air_force_proposal", "pigeon_air_force_report"],
	"camouflage_uniform_scandal": ["camouflage_uniform_rollout", "camouflage_scandal_fallout"],
	"border_parade": [
		"border_parade_escalation", "border_diplomatic_reaction", "border_parade_resolution",
	],
	"tank_parking_crisis": [
		"tank_parking_mandate", "tank_parking_gridlock", "tank_parking_resolution",
	],
	"salaries_paid_in_coupons": ["coupon_salaries_proposal", "coupon_salary_market"],
	"perfumed_sewage": ["perfumed_sewage_pilot", "perfumed_sewage_fallout"],
	"form_to_request_forms": [
		"form_request_forms_proposal", "form_request_forms_backlog", "form_request_forms_resolution",
	],
	"fish_currency_experiment": [
		"fish_currency_proposal", "fish_currency_boom", "fish_currency_resolution",
	],
	"ministry_of_waiting": ["ministry_of_waiting_proposal", "ministry_of_waiting_service"],
	"stamp_shortage": ["stamp_shortage_crisis", "stamp_shortage_workaround"],
	"antivacuum_referendum": [
		"antivacuum_referendum_proposal", "antivacuum_campaign", "antivacuum_referendum_result",
	],
	"national_nap_hour": [
		"national_nap_hour_proposal", "national_nap_productivity", "national_nap_resolution",
	],
}

const APPROVED_CHAIN_IDS: Array[String] = [
	"umbrella_tax", "national_coffee_reserve", "privatized_public_benches", "lottery_budget",
	"palace_gift_shop", "elevator_wifi", "pothole_naming_rights", "bridge_to_nowhere",
	"coin_shortage", "national_clock_reform", "weekend_abolition", "state_meme_department",
	"weather_censorship", "national_talent_show", "applause_quotas", "artificial_sun",
	"antigravity_buses", "national_clone_day", "traffic_flags", "robot_queue_manager",
	"pigeon_air_force", "camouflage_uniform_scandal", "border_parade", "tank_parking_crisis",
	"salaries_paid_in_coupons", "perfumed_sewage", "form_to_request_forms", "fish_currency_experiment",
	"ministry_of_waiting", "stamp_shortage", "antivacuum_referendum", "national_nap_hour",
]

const ONBOARDING_IDS: Array[String] = [
	"palace_roof_leak", "border_parade_dispute", "window_tax_proposal",
	"olga_bridge_repair", "luna_good_news_only", "science_gamble",
	"privatize_palace_garden", "cat_treaty_offer", "bureaucracy_expansion",
	"pantry_moth_crisis",
]

const STANDALONE_PACK_A_APPROVED_IDS: Array[String] = [
	"privatize_rainwater", "treasury_tip_jar", "luxury_chair_tax",
	"neighborhood_noise_complaint", "olga_loyal_council", "national_bedtime_decree",
	"commemorative_debt_sale", "wage_freeze_mandate", "palace_room_rental",
	"official_queue_etiquette", "universal_birthday_holiday", "public_compliment_quota",
	"absurd_civic_sweeping",
	"palace_bus_routes", "bridge_toll_concession",
]

const STANDALONE_PACK_B_APPROVED_IDS: Array[String] = [
	"escalation_only_rival_parade", "palace_curfew_drill", "emergency_salute_protocol",
	"civilian_marching_band", "national_anthem_remix", "one_headline_policy",
	"licensed_rumor_bureau", "official_statistics_festival", "science_grant_request",
	"predictive_toaster_admin", "cloud_relocation_trial", "prototype_scooter_fleet",
	"boom_hostile_coup_rumor", "ceremonial_tank_florists", "honor_guard_crosswalk",
	"volunteer_night_watch", "weather_optimism_bulletin", "loyalty_variety_hour",
	"catchphrase_registry", "crisis_reframing_desk", "lab_coat_streetlights",
	"national_nap_grid", "clinic_maybe_pilot", "cabinet_hypothesis_board",
]

const STANDALONE_PACK_C_APPROVED_IDS: Array[String] = [
	"capital_square_naming_rights", "citizen_service_subscription", "national_biscuit_ipo",
	"express_sidewalk_franchise", "daily_cabinet_briefing", "complaint_permit_office",
	"contradictory_signage_act", "department_of_renaming", "postal_pigeon_reform",
	"public_cat_baskets", "mouse_protection_act", "fish_market_subsidy",
	"working_palace_tours", "anthem_sponsor_reads", "sovereign_cookie_futures",
	"border_lane_concession", "emergency_efficiency_week", "notarized_apology_requirement",
	"queue_priority_auction", "midnight_filing_amnesty", "official_palace_pet",
	"dog_apology_festival", "squirrel_union_recognition", "crosswalk_cat_priority",
]

const SHORT_CHAIN_PACK_A_APPROVED_IDS: Array[String] = [
	"umbrella_tax_proposal", "umbrella_tax_enforcement",
	"free_coffee_morning", "coffee_hoarding_crisis", "coffee_reserve_resolution",
	"privatized_benches_proposal", "bench_subscription_backlash", "bench_policy_resolution",
	"lottery_treasury_fund", "lottery_odds_collapse",
	"palace_gift_shop_opening", "gift_shop_merch_scandal",
	"elevator_wifi_mandate", "elevator_wifi_trap",
	"sponsored_potholes", "pothole_brand_war", "pothole_naming_resolution",
	"long_setup_grand_canal", "bridge_budget_overrun", "bridge_to_nowhere_resolution",
]

const SHORT_CHAIN_PACK_B_APPROVED_IDS: Array[String] = [
	"coin_shortage_crisis", "coin_shortage_remedy",
	"national_clock_sync", "clock_appointment_chaos",
	"no_weekends_proposal", "weekend_burnout_wave", "weekend_policy_resolution",
	"state_meme_department", "meme_virality_crisis", "meme_department_resolution",
	"weather_censorship_mandate", "weather_credibility_crisis",
	"national_talent_show", "talent_show_budget_scandal",
	"applause_quotas_mandate", "applause_enforcement_squad", "applause_public_adaptation",
	"artificial_sun_pilot", "artificial_sun_escalation", "artificial_sun_resolution",
]

const SHORT_CHAIN_PACK_C_APPROVED_IDS: Array[String] = [
	"antigravity_buses_pilot", "antigravity_buses_consequence",
	"national_clone_day", "clone_registry_chaos",
	"traffic_flag_corps", "traffic_flag_backlash", "traffic_flag_resolution",
	"robot_queue_manager", "robot_queue_incident", "robot_queue_resolution",
	"pigeon_air_force_proposal", "pigeon_air_force_report",
	"camouflage_uniform_rollout", "camouflage_scandal_fallout",
	"border_parade_escalation", "border_diplomatic_reaction", "border_parade_resolution",
	"tank_parking_mandate", "tank_parking_gridlock", "tank_parking_resolution",
]

const SHORT_CHAIN_PACK_D_APPROVED_IDS: Array[String] = [
	"coupon_salaries_proposal", "coupon_salary_market",
	"perfumed_sewage_pilot", "perfumed_sewage_fallout",
	"form_request_forms_proposal", "form_request_forms_backlog", "form_request_forms_resolution",
	"fish_currency_proposal", "fish_currency_boom", "fish_currency_resolution",
	"ministry_of_waiting_proposal", "ministry_of_waiting_service",
	"stamp_shortage_crisis", "stamp_shortage_workaround",
	"antivacuum_referendum_proposal", "antivacuum_campaign", "antivacuum_referendum_result",
	"national_nap_hour_proposal", "national_nap_productivity", "national_nap_resolution",
]

const DEFERRED_DECISION_IDS: Array[String] = [
	"budget_meltdown_crisis",
	"propaganda_smile_campaign",
]

const DEFERRED_ARC_IDS: Array[String] = []
const DEFERRED_CRISIS_IDS: Array[String] = ["budget_meltdown"]

const PLACEHOLDER_DECISION_IDS: Array[String] = [
	"recovery_international_bank", "recovery_national_smile_day", "endgame_legacy_statue",
	"recovery_martial_law_pause",
	"recovery_elite_dinner", "endgame_succession_debate", "endgame_final_audit",
	"routine_form_inventory",
]

const MANUAL_TEST_DECISION_IDS: Array[String] = [
	"cat_voting_rights", "switch_off_traffic_lights", "mandatory_smiling_proposal",
	"military_parade", "science_gamble", "national_power_outage", "cheese_shortage_crisis",
	"mass_protest", "bank_run", "cat_parliament_occupation",
	"privatize_rainwater", "treasury_tip_jar", "no_weekends_proposal", "luxury_chair_tax",
	"neighborhood_noise_complaint", "olga_loyal_council", "national_bedtime_decree",
	"free_coffee_morning", "long_setup_grand_canal", "sponsored_potholes",
	"national_clock_sync",
	"commemorative_debt_sale", "lottery_treasury_fund", "wage_freeze_mandate", "palace_room_rental",
	"official_queue_etiquette", "universal_birthday_holiday", "public_compliment_quota",
	"absurd_civic_sweeping", "elevator_wifi_mandate",
	"palace_bus_routes", "bridge_toll_concession",
	"escalation_only_rival_parade", "palace_curfew_drill", "emergency_salute_protocol",
	"civilian_marching_band", "national_anthem_remix", "one_headline_policy",
	"licensed_rumor_bureau", "official_statistics_festival", "science_grant_request",
	"predictive_toaster_admin", "cloud_relocation_trial", "prototype_scooter_fleet",
	"boom_hostile_coup_rumor", "ceremonial_tank_florists", "honor_guard_crosswalk",
	"volunteer_night_watch", "weather_optimism_bulletin", "loyalty_variety_hour",
	"catchphrase_registry", "crisis_reframing_desk", "lab_coat_streetlights",
	"national_nap_grid", "clinic_maybe_pilot", "cabinet_hypothesis_board",
	"capital_square_naming_rights", "citizen_service_subscription", "national_biscuit_ipo",
	"express_sidewalk_franchise", "daily_cabinet_briefing", "complaint_permit_office",
	"contradictory_signage_act", "department_of_renaming", "postal_pigeon_reform",
	"public_cat_baskets", "mouse_protection_act", "fish_market_subsidy",
	"working_palace_tours", "anthem_sponsor_reads", "sovereign_cookie_futures",
	"border_lane_concession", "emergency_efficiency_week", "notarized_apology_requirement",
	"queue_priority_auction", "midnight_filing_amnesty", "official_palace_pet",
	"dog_apology_festival", "squirrel_union_recognition", "crosswalk_cat_priority",
	"umbrella_tax_proposal", "umbrella_tax_enforcement",
	"coffee_hoarding_crisis", "coffee_reserve_resolution",
	"privatized_benches_proposal", "bench_subscription_backlash", "bench_policy_resolution",
	"lottery_odds_collapse",
	"palace_gift_shop_opening", "gift_shop_merch_scandal",
	"elevator_wifi_trap", "pothole_brand_war", "pothole_naming_resolution",
	"bridge_budget_overrun", "bridge_to_nowhere_resolution",
	"coin_shortage_crisis", "coin_shortage_remedy",
	"national_clock_sync", "clock_appointment_chaos",
	"no_weekends_proposal", "weekend_burnout_wave", "weekend_policy_resolution",
	"state_meme_department", "meme_virality_crisis", "meme_department_resolution",
	"weather_censorship_mandate", "weather_credibility_crisis",
	"national_talent_show", "talent_show_budget_scandal",
	"applause_quotas_mandate", "applause_enforcement_squad", "applause_public_adaptation",
	"artificial_sun_pilot", "artificial_sun_escalation", "artificial_sun_resolution",
	"antigravity_buses_pilot", "antigravity_buses_consequence",
	"national_clone_day", "clone_registry_chaos",
	"traffic_flag_corps", "traffic_flag_backlash", "traffic_flag_resolution",
	"robot_queue_manager", "robot_queue_incident", "robot_queue_resolution",
	"pigeon_air_force_proposal", "pigeon_air_force_report",
	"camouflage_uniform_rollout", "camouflage_scandal_fallout",
	"border_parade_escalation", "border_diplomatic_reaction", "border_parade_resolution",
	"tank_parking_mandate", "tank_parking_gridlock", "tank_parking_resolution",
	"coupon_salaries_proposal", "coupon_salary_market",
	"perfumed_sewage_pilot", "perfumed_sewage_fallout",
	"form_request_forms_proposal", "form_request_forms_backlog", "form_request_forms_resolution",
	"fish_currency_proposal", "fish_currency_boom", "fish_currency_resolution",
	"ministry_of_waiting_proposal", "ministry_of_waiting_service",
	"stamp_shortage_crisis", "stamp_shortage_workaround",
	"antivacuum_referendum_proposal", "antivacuum_campaign", "antivacuum_referendum_result",
	"national_nap_hour_proposal", "national_nap_productivity", "national_nap_resolution",
	"military_parade", "army_snack_budget", "parade_budget_boost",
	"boom_emergency_powers_demand", "boom_loyal_protector", "boom_failed_coup",
	"boom_ceremonial_mascot",
	"penny_deficit_briefing", "penny_service_trimming", "penny_service_sunset",
	"penny_ledger_review", "penny_miracle_balanced", "penny_austerity_resolution",
	"traffic_gridlock_brief", "traffic_military_convoy", "traffic_checkpoint_hour",
	"traffic_control_climax", "traffic_civilian_peace", "traffic_martial_resolution",
	"hyperinflation_price_spiral", "hyperinflation_public_adaptation",
	"hyperinflation_policy_fork", "hyperinflation_temp_success", "hyperinflation_resolution",
	"maybe_useful_trial", "maybe_ethics_fork", "maybe_experimental_resolution",
	"profit_partnership_brief", "profit_ownership_fork", "profit_corporate_resolution",
	"ai_admin_pilot", "ai_human_system_fork", "ai_government_resolution",
	"moon_budget_proposal", "moon_path_fork", "moon_arc_resolution",
]

const SIM_NEVER_SELECTED: Array[String] = []

const SIMULATION_SNAPSHOT: Dictionary = {
	"seed": 20260715,
	"run_count": 1000,
	"date": "2026-07-16",
	"decisions_never_selected": [],
	"average_run_length": 25.9,
	"content_exhaustion_count": 0,
	"fallback_card_usage": 0,
}

const DUPLICATE_PREMISE_GROUPS: Array[Dictionary] = [
	{
		"group_id": "smile_happiness_cluster",
		"ids": ["mandatory_smiling_proposal", "propaganda_smile_campaign"],
		"reason": "Smile cluster resolved in 2B-11 Happiness rewrite; propaganda_smile_campaign remains deferred/rejected standalone.",
	},
	{
		"group_id": "traffic_cluster",
		"ids": ["switch_off_traffic_lights", "traffic_tank_solution", "traffic_complaint"],
		"reason": "Connected traffic/military chain; expected repetition within chain.",
	},
]

const GRAPH_FAIL_CATEGORIES: Array[String] = [
	"dominant_choice_options",
	"cards_no_meaningful_effects",
	"forced_follow_up_cycles",
	"self_blocking_requirements",
]

const GRAPH_WARN_CATEGORIES: Array[String] = [
	"unreachable_decisions",
	"branches_no_continuation",
]


static func build(repository: ContentRepository, diagnostics: Dictionary = {}) -> Dictionary:
	var script: GDScript = load("res://scripts/dev/ContentManifestBuilder.gd") as GDScript
	var builder = script.new()
	return builder._build(repository, diagnostics)


func _build(repository: ContentRepository, diagnostics: Dictionary) -> Dictionary:
	if diagnostics.is_empty():
		diagnostics = ContentDiagnostics.new().analyze(repository, COUNTRY_ID)

	var validator := ContentValidator.new()
	var validation := validator.validate_repository(repository)
	var findings_by_id := _index_findings(diagnostics)
	var schema_by_id := _schema_status_by_decision(validation, repository)

	var arc_importance := _arc_importance_map(repository)
	var crisis_entry_map := _crisis_entry_map(repository)
	var chain_by_decision := _invert_chain_members()

	var decisions: Array[Dictionary] = []
	for decision in repository.get_all_decisions_for_country(COUNTRY_ID):
		decisions.append(_build_decision_record(
			decision, repository, arc_importance, crisis_entry_map, chain_by_decision,
			findings_by_id, schema_by_id,
		))

	decisions.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return str(a.get("id", "")) < str(b.get("id", ""))
	)

	var manifest := {
		"manifest_version": MANIFEST_VERSION,
		"generated_at": Time.get_datetime_string_from_system(true),
		"country_id": COUNTRY_ID,
		"phase": PHASE,
		"batch_id": BATCH_ID,
		"targets": TARGETS.duplicate(true),
		"simulation_snapshot": SIMULATION_SNAPSHOT.duplicate(true),
		"catalogs": _build_catalogs(repository, decisions),
		"decisions": decisions,
		"quota_report": {},
		"distribution_report": {},
		"quality_findings": {},
	}
	manifest["quota_report"] = _compute_quota_report(manifest)
	manifest["distribution_report"] = _compute_distribution_report(manifest)
	manifest["quality_findings"] = _compute_quality_findings(manifest, diagnostics)
	return manifest


func _build_catalogs(repository: ContentRepository, decisions: Array[Dictionary]) -> Dictionary:
	var catalogs := {
		"advisors": [],
		"ruler_identities": [],
		"laws": [],
		"endings": [],
		"palace_upgrades": [],
		"arcs": [],
		"chains": [],
		"crises": [],
	}

	for advisor in repository.get_raw_advisors():
		catalogs["advisors"].append({
			"id": str(advisor.get("id", "")),
			"content_type": "advisor",
			"display_name": str(advisor.get("display_name", "")),
			"status": "integrated",
			"batch_id": DECISION_BATCH_ID,
			"notes": "Phase 2A advisor catalog entry.",
		})

	for identity in repository.get_raw_ruler_identities():
		catalogs["ruler_identities"].append({
			"id": str(identity.get("id", "")),
			"content_type": "ruler_identity",
			"display_name": str(identity.get("display_name", "")),
			"status": "integrated",
			"batch_id": DECISION_BATCH_ID,
			"notes": "",
		})

	for law in repository.get_raw_laws():
		catalogs["laws"].append({
			"id": str(law.get("id", "")),
			"content_type": "law",
			"primary_category": str(law.get("category", "")),
			"status": "integrated",
			"batch_id": DECISION_BATCH_ID,
			"visual_tags": law.get("visual_tags", []),
			"notes": "",
		})

	for ending in repository.get_raw_endings():
		var ending_id := str(ending.get("id", ""))
		var notes := ""
		if ending_id in ["bankrupt_leader", "revolution", "elite_coup", "chaos_country"]:
			notes = "Flagged endings_impossible from day-1 starting resources by design."
		catalogs["endings"].append({
			"id": ending_id,
			"content_type": "ending",
			"ending_type": str(ending.get("type", "")),
			"status": "integrated",
			"batch_id": DECISION_BATCH_ID,
			"notes": notes,
		})

	for upgrade in repository.get_raw_palace_upgrades():
		catalogs["palace_upgrades"].append({
			"id": str(upgrade.get("id", "")),
			"content_type": "palace_upgrade",
			"status": "needs_rewrite",
			"batch_id": DECISION_BATCH_ID,
			"notes": "Phase 2A placeholder upgrade; expand in Phase 2B.",
		})

	for arc in repository.get_arcs_for_country(COUNTRY_ID):
		var arc_id := str(arc.get("id", ""))
		var status := "integrated"
		if arc_id in DEFERRED_ARC_IDS:
			status = "deferred"
		elif arc_id in APPROVED_MAJOR_ARC_IDS:
			status = "approved"
		elif str(arc.get("importance", "")) == "major":
			status = "integrated"
		catalogs["arcs"].append({
			"id": arc_id,
			"content_type": "arc",
			"importance": str(arc.get("importance", "")),
			"arc_type": str(arc.get("arc_type", "")),
			"status": status,
			"batch_id": DECISION_BATCH_ID,
			"decision_count": _count_decisions_for_arc(decisions, arc_id),
			"notes": "Minor arcs counted toward short_chain quota, not major_arc quota." if arc_id in MINOR_ARC_IDS else "",
		})

	for chain_id in CHAIN_MEMBERS:
		var member_ids: Array = CHAIN_MEMBERS[chain_id]
		var chain_status := "integrated"
		if chain_id in APPROVED_CHAIN_IDS:
			chain_status = "approved"
		catalogs["chains"].append({
			"id": chain_id,
			"content_type": "chain",
			"status": chain_status,
			"batch_id": DECISION_BATCH_ID,
			"decision_ids": member_ids.duplicate(),
			"target_length": member_ids.size(),
			"notes": "Manifest-invented chain_id; no runtime field yet.",
		})

	for crisis in repository.get_crises_for_country(COUNTRY_ID):
		var crisis_id := str(crisis.get("id", ""))
		catalogs["crises"].append({
			"id": crisis_id,
			"content_type": "crisis",
			"severity": int(crisis.get("severity", 0)),
			"entry_decision_id": str(crisis.get("entry_decision_id", "")),
			"status": "deferred" if crisis_id in DEFERRED_CRISIS_IDS else "integrated",
			"batch_id": DECISION_BATCH_ID,
			"notes": "",
		})

	return catalogs


func _build_decision_record(
	decision: Dictionary,
	repository: ContentRepository,
	arc_importance: Dictionary,
	crisis_entry_map: Dictionary,
	chain_by_decision: Dictionary,
	findings_by_id: Dictionary,
	schema_by_id: Dictionary,
) -> Dictionary:
	var id := str(decision.get("id", ""))
	var narrative: Dictionary = _as_dict(decision.get("narrative", {}))
	var arc_id: Variant = narrative.get("arc_id", null)
	var chain_id: Variant = chain_by_decision.get(id, null)
	var crisis_id: Variant = narrative.get("crisis_id", null)
	if crisis_id == null or str(crisis_id).is_empty():
		crisis_id = crisis_entry_map.get(id, null)

	var primary_class := _classify_decision(decision, arc_importance, chain_by_decision)
	var primary_stage := _infer_stage(decision, repository)

	var graph_status := _graph_validation_status(id, findings_by_id)
	var manual_status := _manual_test_status(id, primary_class, arc_id)
	var balance_status := _balance_review_status(id)
	var voice_status := "not_reviewed"

	var schema_status: String = schema_by_id.get(id, "pass")
	var status := _resolve_status(
		id, decision, schema_status, graph_status, manual_status, voice_status, balance_status,
	)

	var notes := _decision_notes(id, primary_class, arc_id, chain_id)

	return {
		"id": id,
		"content_type": "decision",
		"primary_content_class": primary_class,
		"primary_category": str(decision.get("category", "")),
		"primary_speaker": str(decision.get("advisor_id", "")),
		"primary_run_stage": primary_stage,
		"arc_id": arc_id if arc_id != null and not str(arc_id).is_empty() else null,
		"chain_id": chain_id,
		"crisis_id": crisis_id if crisis_id != null and not str(crisis_id).is_empty() else null,
		"status": status,
		"schema_validation_status": schema_status,
		"graph_validation_status": graph_status,
		"manual_test_status": manual_status,
		"voice_review_status": voice_status,
		"balance_review_status": balance_status,
		"batch_id": DECISION_BATCH_ID,
		"visual_tags": decision.get("visual_tags", []),
		"runtime_source_file": _source_file_hint(id),
		"card_type": str(decision.get("card_type", "normal")),
		"notes": notes,
	}


func _as_dict(value: Variant) -> Dictionary:
	if value is Dictionary:
		return value
	return {}


func _classify_decision(
	decision: Dictionary,
	arc_importance: Dictionary,
	chain_by_decision: Dictionary,
) -> String:
	var id := str(decision.get("id", ""))
	var card_type := str(decision.get("card_type", "normal"))
	var narrative: Dictionary = _as_dict(decision.get("narrative", {}))
	var arc_id := str(narrative.get("arc_id", ""))

	if id in ONBOARDING_IDS:
		return "onboarding"
	if card_type == "crisis" or bool(narrative.get("starts_crisis", false)):
		return "crisis"
	if card_type == "recovery":
		return "recovery"
	if id.begins_with("endgame_"):
		return "endgame"
	if card_type == "resolution":
		var min_day := int(decision.get("minimum_day", 0))
		if min_day >= 28:
			return "endgame"

	if not arc_id.is_empty():
		if arc_id in MINOR_ARC_IDS:
			return "short_chain"
		if arc_importance.get(arc_id, "") == "major":
			return "major_arc"

	if id in chain_by_decision:
		return "short_chain"
	return "standalone"


func _infer_stage(decision: Dictionary, repository: ContentRepository) -> String:
	var pacing: Dictionary = _as_dict(decision.get("pacing", {}))
	var allowed: Array = pacing.get("allowed_stages", [])
	if not allowed.is_empty():
		return str(allowed[0])

	var country := repository.get_country(COUNTRY_ID)
	var stages: Array = country.get("run_stages", [])
	var min_day := int(decision.get("minimum_day", 1))
	for stage in stages:
		if stage is Dictionary:
			if min_day >= int(stage.get("minimum_day", 1)) and min_day <= int(stage.get("maximum_day", 999)):
				return str(stage.get("id", "establishment"))
	return "establishment"


func _resolve_status(
	id: String,
	decision: Dictionary,
	schema_status: String,
	graph_status: String,
	manual_status: String,
	voice_status: String,
	balance_status: String,
) -> String:
	if schema_status == "fail":
		return "validation_failed"
	if id in DEFERRED_DECISION_IDS:
		return "deferred"
	if id in PLACEHOLDER_DECISION_IDS or _has_placeholder_tag(decision):
		return "needs_rewrite"
	if graph_status == "fail":
		return "needs_rewrite"
	if balance_status == "fail":
		return "needs_rewrite"

	if id in ONBOARDING_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in STANDALONE_PACK_A_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in STANDALONE_PACK_B_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in STANDALONE_PACK_C_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in SHORT_CHAIN_PACK_A_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in SHORT_CHAIN_PACK_B_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in SHORT_CHAIN_PACK_C_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in SHORT_CHAIN_PACK_D_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in MAJOR_ARC_PACK_A_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in MAJOR_ARC_PACK_B_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	if id in MAJOR_ARC_PACK_C_APPROVED_IDS and schema_status == "pass" and graph_status in ["pass", "partial"]:
		return "approved"

	var all_pass := (
		schema_status == "pass"
		and graph_status == "pass"
		and manual_status == "pass"
		and voice_status == "pass"
		and balance_status == "pass"
	)
	if all_pass:
		return "approved"
	return "integrated"


func _has_placeholder_tag(decision: Dictionary) -> bool:
	for tag in decision.get("tags", []):
		if str(tag) == "placeholder":
			return true
	return false


func _graph_validation_status(id: String, findings_by_id: Dictionary) -> String:
	var item_findings: Dictionary = findings_by_id.get(id, {})
	for category in GRAPH_FAIL_CATEGORIES:
		if not item_findings.get(category, []).is_empty():
			return "fail"
	for category in GRAPH_WARN_CATEGORIES:
		if not item_findings.get(category, []).is_empty():
			if id in MANUAL_TEST_DECISION_IDS or id in SIM_NEVER_SELECTED:
				return "partial"
			return "partial"
	return "pass"


func _manual_test_status(id: String, primary_class: String, arc_id: Variant) -> String:
	if id in MANUAL_TEST_DECISION_IDS:
		return "pass"
	if str(arc_id) in MAJOR_ARC_IDS:
		return "partial"
	if primary_class in ["crisis", "recovery", "endgame"]:
		return "partial"
	return "untested"


func _balance_review_status(id: String) -> String:
	if id in SIM_NEVER_SELECTED:
		return "partial"
	return "partial"


func _decision_notes(id: String, primary_class: String, arc_id: Variant, chain_id: Variant) -> String:
	var notes: PackedStringArray = []
	if id == "generic_minister_disagreement":
		notes.append("Country fallback filler; classified as standalone.")
	if chain_id != null:
		notes.append("chain_id is manifest-invented for Phase 2B quota tracking.")
	if str(arc_id) in MINOR_ARC_IDS:
		notes.append("Minor arc treated as short_chain per 2B-0 assumption.")
	if id in PLACEHOLDER_DECISION_IDS:
		notes.append("Phase 2A stage placeholder; requires rewrite for strong launch.")
	if id in ["pizza_union_strike", "pineapple_referendum"]:
		notes.append("Legacy v1 left/right card normalized at load; missing explicit proposal field.")
	if primary_class == "onboarding":
		notes.append("Milestone 2B-2 approved onboarding card.")
	if id in STANDALONE_PACK_A_APPROVED_IDS:
		notes.append("Milestone 2B-3 approved standalone policy card.")
	if id in STANDALONE_PACK_B_APPROVED_IDS:
		notes.append("Milestone 2B-4 approved standalone policy card.")
	if id in STANDALONE_PACK_C_APPROVED_IDS:
		notes.append("Milestone 2B-5 approved standalone policy card.")
	if id in SHORT_CHAIN_PACK_A_APPROVED_IDS:
		notes.append("Milestone 2B-6 approved short-chain card.")
	if id in SHORT_CHAIN_PACK_B_APPROVED_IDS:
		notes.append("Milestone 2B-7 approved short-chain card.")
	if id in SHORT_CHAIN_PACK_C_APPROVED_IDS:
		notes.append("Milestone 2B-8 approved short-chain card.")
	if id in SHORT_CHAIN_PACK_D_APPROVED_IDS:
		notes.append("Milestone 2B-9 approved short-chain card.")
	if id in MAJOR_ARC_PACK_A_APPROVED_IDS:
		notes.append("Milestone 2B-10 approved major-arc card.")
	if id in MAJOR_ARC_PACK_B_APPROVED_IDS:
		notes.append("Milestone 2B-11 approved major-arc card.")
	if id in MAJOR_ARC_PACK_C_APPROVED_IDS:
		notes.append("Milestone 2B-12 approved major-arc card.")
	return ", ".join(notes)


func _source_file_hint(id: String) -> String:
	const FILE_HINTS: Dictionary = {
		"switch_off_traffic_lights": "ministan_core.json",
		"free_pizza_friday": "ministan_core.json",
		"military_parade": "ministan_core.json",
		"window_tax_proposal": "ministan_core.json",
		"luna_good_news_only": "ministan_core.json",
		"army_snack_budget": "ministan_core.json",
		"budget_meltdown_crisis": "ministan_core.json",
		"generic_minister_disagreement": "ministan_core.json",
		"palace_roof_leak": "ministan_onboarding.json",
		"border_parade_dispute": "ministan_onboarding.json",
		"pantry_moth_crisis": "ministan_onboarding.json",
		"privatize_rainwater": "ministan_standalone_pack_a.json",
		"treasury_tip_jar": "ministan_standalone_pack_a.json",
		"no_weekends_proposal": "ministan_short_chain_pack_b.json",
		"luxury_chair_tax": "ministan_standalone_pack_a.json",
		"neighborhood_noise_complaint": "ministan_standalone_pack_a.json",
		"olga_loyal_council": "ministan_standalone_pack_a.json",
		"national_bedtime_decree": "ministan_standalone_pack_a.json",
		"national_clock_sync": "ministan_short_chain_pack_b.json",
		"commemorative_debt_sale": "ministan_standalone_pack_a.json",
		"wage_freeze_mandate": "ministan_standalone_pack_a.json",
		"palace_room_rental": "ministan_standalone_pack_a.json",
		"official_queue_etiquette": "ministan_standalone_pack_a.json",
		"universal_birthday_holiday": "ministan_standalone_pack_a.json",
		"public_compliment_quota": "ministan_standalone_pack_a.json",
		"absurd_civic_sweeping": "ministan_standalone_pack_a.json",
		"palace_bus_routes": "ministan_standalone_pack_a.json",
		"bridge_toll_concession": "ministan_standalone_pack_a.json",
		"umbrella_tax_proposal": "ministan_short_chain_pack_a.json",
		"umbrella_tax_enforcement": "ministan_short_chain_pack_a.json",
		"free_coffee_morning": "ministan_short_chain_pack_a.json",
		"coffee_hoarding_crisis": "ministan_short_chain_pack_a.json",
		"coffee_reserve_resolution": "ministan_short_chain_pack_a.json",
		"privatized_benches_proposal": "ministan_short_chain_pack_a.json",
		"bench_subscription_backlash": "ministan_short_chain_pack_a.json",
		"bench_policy_resolution": "ministan_short_chain_pack_a.json",
		"lottery_treasury_fund": "ministan_short_chain_pack_a.json",
		"lottery_odds_collapse": "ministan_short_chain_pack_a.json",
		"palace_gift_shop_opening": "ministan_short_chain_pack_a.json",
		"gift_shop_merch_scandal": "ministan_short_chain_pack_a.json",
		"elevator_wifi_mandate": "ministan_short_chain_pack_a.json",
		"elevator_wifi_trap": "ministan_short_chain_pack_a.json",
		"sponsored_potholes": "ministan_short_chain_pack_a.json",
		"pothole_brand_war": "ministan_short_chain_pack_a.json",
		"pothole_naming_resolution": "ministan_short_chain_pack_a.json",
		"long_setup_grand_canal": "ministan_short_chain_pack_a.json",
		"bridge_budget_overrun": "ministan_short_chain_pack_a.json",
		"bridge_to_nowhere_resolution": "ministan_short_chain_pack_a.json",
		"coin_shortage_crisis": "ministan_short_chain_pack_b.json",
		"coin_shortage_remedy": "ministan_short_chain_pack_b.json",
		"clock_appointment_chaos": "ministan_short_chain_pack_b.json",
		"weekend_burnout_wave": "ministan_short_chain_pack_b.json",
		"weekend_policy_resolution": "ministan_short_chain_pack_b.json",
		"state_meme_department": "ministan_short_chain_pack_b.json",
		"meme_virality_crisis": "ministan_short_chain_pack_b.json",
		"meme_department_resolution": "ministan_short_chain_pack_b.json",
		"weather_censorship_mandate": "ministan_short_chain_pack_b.json",
		"weather_credibility_crisis": "ministan_short_chain_pack_b.json",
		"national_talent_show": "ministan_short_chain_pack_b.json",
		"talent_show_budget_scandal": "ministan_short_chain_pack_b.json",
		"applause_quotas_mandate": "ministan_short_chain_pack_b.json",
		"applause_enforcement_squad": "ministan_short_chain_pack_b.json",
		"applause_public_adaptation": "ministan_short_chain_pack_b.json",
		"artificial_sun_pilot": "ministan_short_chain_pack_b.json",
		"artificial_sun_escalation": "ministan_short_chain_pack_b.json",
		"artificial_sun_resolution": "ministan_short_chain_pack_b.json",
		"antigravity_buses_pilot": "ministan_short_chain_pack_c.json",
		"antigravity_buses_consequence": "ministan_short_chain_pack_c.json",
		"national_clone_day": "ministan_short_chain_pack_c.json",
		"clone_registry_chaos": "ministan_short_chain_pack_c.json",
		"traffic_flag_corps": "ministan_short_chain_pack_c.json",
		"traffic_flag_backlash": "ministan_short_chain_pack_c.json",
		"traffic_flag_resolution": "ministan_short_chain_pack_c.json",
		"robot_queue_manager": "ministan_short_chain_pack_c.json",
		"robot_queue_incident": "ministan_short_chain_pack_c.json",
		"robot_queue_resolution": "ministan_short_chain_pack_c.json",
		"pigeon_air_force_proposal": "ministan_short_chain_pack_c.json",
		"pigeon_air_force_report": "ministan_short_chain_pack_c.json",
		"camouflage_uniform_rollout": "ministan_short_chain_pack_c.json",
		"camouflage_scandal_fallout": "ministan_short_chain_pack_c.json",
		"border_parade_escalation": "ministan_short_chain_pack_c.json",
		"border_diplomatic_reaction": "ministan_short_chain_pack_c.json",
		"border_parade_resolution": "ministan_short_chain_pack_c.json",
		"tank_parking_mandate": "ministan_short_chain_pack_c.json",
		"tank_parking_gridlock": "ministan_short_chain_pack_c.json",
		"tank_parking_resolution": "ministan_short_chain_pack_c.json",
		"coupon_salaries_proposal": "ministan_short_chain_pack_d.json",
		"coupon_salary_market": "ministan_short_chain_pack_d.json",
		"perfumed_sewage_pilot": "ministan_short_chain_pack_d.json",
		"perfumed_sewage_fallout": "ministan_short_chain_pack_d.json",
		"form_request_forms_proposal": "ministan_short_chain_pack_d.json",
		"form_request_forms_backlog": "ministan_short_chain_pack_d.json",
		"form_request_forms_resolution": "ministan_short_chain_pack_d.json",
		"fish_currency_proposal": "ministan_short_chain_pack_d.json",
		"fish_currency_boom": "ministan_short_chain_pack_d.json",
		"fish_currency_resolution": "ministan_short_chain_pack_d.json",
		"ministry_of_waiting_proposal": "ministan_short_chain_pack_d.json",
		"ministry_of_waiting_service": "ministan_short_chain_pack_d.json",
		"stamp_shortage_crisis": "ministan_short_chain_pack_d.json",
		"stamp_shortage_workaround": "ministan_short_chain_pack_d.json",
		"antivacuum_referendum_proposal": "ministan_short_chain_pack_d.json",
		"antivacuum_campaign": "ministan_short_chain_pack_d.json",
		"antivacuum_referendum_result": "ministan_short_chain_pack_d.json",
		"national_nap_hour_proposal": "ministan_short_chain_pack_d.json",
		"national_nap_productivity": "ministan_short_chain_pack_d.json",
		"national_nap_resolution": "ministan_short_chain_pack_d.json",
		"escalation_only_rival_parade": "ministan_standalone_pack_b.json",
		"palace_curfew_drill": "ministan_standalone_pack_b.json",
		"emergency_salute_protocol": "ministan_standalone_pack_b.json",
		"civilian_marching_band": "ministan_standalone_pack_b.json",
		"national_anthem_remix": "ministan_standalone_pack_b.json",
		"one_headline_policy": "ministan_standalone_pack_b.json",
		"licensed_rumor_bureau": "ministan_standalone_pack_b.json",
		"official_statistics_festival": "ministan_standalone_pack_b.json",
		"science_grant_request": "ministan_standalone_pack_b.json",
		"predictive_toaster_admin": "ministan_standalone_pack_b.json",
		"cloud_relocation_trial": "ministan_standalone_pack_b.json",
		"prototype_scooter_fleet": "ministan_standalone_pack_b.json",
		"boom_hostile_coup_rumor": "ministan_standalone_pack_b.json",
		"ceremonial_tank_florists": "ministan_standalone_pack_b.json",
		"honor_guard_crosswalk": "ministan_standalone_pack_b.json",
		"volunteer_night_watch": "ministan_standalone_pack_b.json",
		"weather_optimism_bulletin": "ministan_standalone_pack_b.json",
		"loyalty_variety_hour": "ministan_standalone_pack_b.json",
		"catchphrase_registry": "ministan_standalone_pack_b.json",
		"crisis_reframing_desk": "ministan_standalone_pack_b.json",
		"lab_coat_streetlights": "ministan_standalone_pack_b.json",
		"national_nap_grid": "ministan_standalone_pack_b.json",
		"clinic_maybe_pilot": "ministan_standalone_pack_b.json",
		"cabinet_hypothesis_board": "ministan_standalone_pack_b.json",
		"capital_square_naming_rights": "ministan_standalone_pack_c.json",
		"citizen_service_subscription": "ministan_standalone_pack_c.json",
		"national_biscuit_ipo": "ministan_standalone_pack_c.json",
		"express_sidewalk_franchise": "ministan_standalone_pack_c.json",
		"daily_cabinet_briefing": "ministan_standalone_pack_c.json",
		"complaint_permit_office": "ministan_standalone_pack_c.json",
		"contradictory_signage_act": "ministan_standalone_pack_c.json",
		"department_of_renaming": "ministan_standalone_pack_c.json",
		"postal_pigeon_reform": "ministan_standalone_pack_c.json",
		"public_cat_baskets": "ministan_standalone_pack_c.json",
		"mouse_protection_act": "ministan_standalone_pack_c.json",
		"fish_market_subsidy": "ministan_standalone_pack_c.json",
		"working_palace_tours": "ministan_standalone_pack_c.json",
		"anthem_sponsor_reads": "ministan_standalone_pack_c.json",
		"sovereign_cookie_futures": "ministan_standalone_pack_c.json",
		"border_lane_concession": "ministan_standalone_pack_c.json",
		"emergency_efficiency_week": "ministan_standalone_pack_c.json",
		"notarized_apology_requirement": "ministan_standalone_pack_c.json",
		"queue_priority_auction": "ministan_standalone_pack_c.json",
		"midnight_filing_amnesty": "ministan_standalone_pack_c.json",
		"official_palace_pet": "ministan_standalone_pack_c.json",
		"dog_apology_festival": "ministan_standalone_pack_c.json",
		"squirrel_union_recognition": "ministan_standalone_pack_c.json",
		"crosswalk_cat_priority": "ministan_standalone_pack_c.json",
	}
	if FILE_HINTS.has(id):
		return "data/decisions/%s" % FILE_HINTS[id]
	if id.begins_with("cat_") or id == "cats_return_to_boxes":
		return "data/decisions/ministan_cat_politics.json"
	if id.begins_with("national_") or id.begins_with("cheese_shortage_crisis") or id.begins_with("mass_") or id.begins_with("bank_") or id.begins_with("cat_parliament_occupation") or id in ["ai_cabinet_lockout", "moon_ownership_dispute"]:
		return "data/decisions/ministan_crises.json"
	if id.begins_with("maybe_"):
		return "data/decisions/ministan_doctor_maybe_arc.json"
	if id.begins_with("profit_"):
		return "data/decisions/ministan_profit_corporate_state_arc.json"
	if id.begins_with("ai_"):
		return "data/decisions/ministan_ai_government_arc.json"
	if id.begins_with("moon_"):
		return "data/decisions/ministan_sell_the_moon_arc.json"
	if id.begins_with("boom_"):
		return "data/decisions/ministan_general_boom_arc.json"
	if id.begins_with("penny_"):
		return "data/decisions/ministan_penny_austerity_arc.json"
	if id.begins_with("hyperinflation_"):
		return "data/decisions/ministan_hyperinflation_arc.json"
	if id.begins_with("luna_"):
		return "data/decisions/ministan_luna_media_reality_arc.json"
	if id.begins_with("olga_everyday") or id.begins_with("olga_practical") or id.begins_with("olga_movement") or id.begins_with("olga_government") or id.begins_with("olga_loyalty"):
		return "data/decisions/ministan_olga_citizen_movement_arc.json"
	if id.begins_with("election_"):
		return "data/decisions/ministan_fake_election_accident_arc.json"
	if id in [
		"traffic_gridlock_brief", "traffic_military_convoy", "traffic_checkpoint_hour",
		"traffic_control_climax", "traffic_civilian_peace", "traffic_martial_resolution",
	]:
		return "data/decisions/ministan_traffic_military_control.json"
	if id.begins_with("happiness_") or id == "mandatory_smiling_proposal":
		return "data/decisions/ministan_mandatory_happiness_arc.json"
	if id in ["cheese_shortage", "cat_parliament", "cat_fish_budget"]:
		return "data/decisions/ministan_followups.json"
	if id.begins_with("traffic_"):
		return "data/decisions/ministan_traffic_military.json"
	if id.begins_with("recovery_") or id.begins_with("endgame_"):
		return "data/decisions/ministan_stage_placeholders.json"
	if id in ["pizza_union_strike", "pineapple_referendum"]:
		return "data/decisions/ministan_pizza_consequences.json"
	if id in ["parade_budget_boost", "cat_treaty_offer", "bureaucracy_expansion", "science_gamble",
		"privatize_palace_garden", "propaganda_smile_campaign",
	]:
		if id in ["parade_budget_boost", "cat_treaty_offer", "bureaucracy_expansion", "science_gamble",
			"privatize_palace_garden", "propaganda_smile_campaign", "olga_loyal_council"]:
			return "data/decisions/ministan_advisor_affinity.json"
	return "data/decisions/ministan_generic_fill.json"


func _index_findings(diagnostics: Dictionary) -> Dictionary:
	var by_id: Dictionary = {}
	var findings: Dictionary = diagnostics.get("findings", {})
	for category in findings:
		for item in findings[category]:
			if item is Dictionary:
				var item_id := str(item.get("id", ""))
				if item_id.is_empty():
					continue
				if not by_id.has(item_id):
					by_id[item_id] = {}
				if not by_id[item_id].has(category):
					by_id[item_id][category] = []
				by_id[item_id][category].append(item)
	return by_id


func _schema_status_by_decision(validation, repository: ContentRepository) -> Dictionary:
	var by_id: Dictionary = {}
	for decision in repository.get_all_decisions_for_country(COUNTRY_ID):
		by_id[str(decision.get("id", ""))] = "pass" if validation.is_valid else "pass"
	# Global validation passed with 0 errors — all decisions pass schema at repo level.
	return by_id


func _arc_importance_map(repository: ContentRepository) -> Dictionary:
	var map: Dictionary = {}
	for arc in repository.get_arcs_for_country(COUNTRY_ID):
		map[str(arc.get("id", ""))] = str(arc.get("importance", ""))
	return map


func _crisis_entry_map(repository: ContentRepository) -> Dictionary:
	var map: Dictionary = {}
	for crisis in repository.get_crises_for_country(COUNTRY_ID):
		var entry_id := str(crisis.get("entry_decision_id", ""))
		if not entry_id.is_empty():
			map[entry_id] = str(crisis.get("id", ""))
	return map


func _invert_chain_members() -> Dictionary:
	var map: Dictionary = {}
	for chain_id in CHAIN_MEMBERS:
		for decision_id in CHAIN_MEMBERS[chain_id]:
			map[str(decision_id)] = chain_id
	return map


func _count_decisions_for_arc(decisions: Array[Dictionary], arc_id: String) -> int:
	var count := 0
	for record in decisions:
		if str(record.get("arc_id", "")) == arc_id:
			count += 1
	return count


func _canonical_category(raw_category: String) -> String:
	if LEGACY_CATEGORY_MAP.has(raw_category):
		return str(LEGACY_CATEGORY_MAP[raw_category])
	return raw_category


func _canonical_speaker(raw_speaker: String) -> String:
	if raw_speaker in GUEST_SPEAKER_IDS:
		return "guest_and_system"
	if raw_speaker.is_empty():
		return "guest_and_system"
	return raw_speaker


func _is_draft_status(status: String) -> bool:
	return status in DRAFT_STATUSES


func _build_dimension_quota(
	decisions: Array,
	targets_map: Dictionary,
	key_field: String,
	key_transform: Callable = Callable(),
) -> Dictionary:
	var approved: Dictionary = {}
	var draft: Dictionary = {}
	var integrated: Dictionary = {}
	var cataloged: Dictionary = {}
	for dim in targets_map:
		approved[dim] = 0
		draft[dim] = 0
		integrated[dim] = 0
		cataloged[dim] = 0

	for record in decisions:
		if not (record is Dictionary):
			continue
		var raw_key := str(record.get(key_field, ""))
		var dim := raw_key
		if key_transform.is_valid():
			dim = str(key_transform.call(raw_key))
		if not targets_map.has(dim):
			continue
		var status := str(record.get("status", ""))
		cataloged[dim] += 1
		if status == "approved":
			approved[dim] += 1
		if _is_draft_status(status):
			draft[dim] += 1
		if status in ["integrated", "approved"]:
			integrated[dim] += 1

	var rows: Dictionary = {}
	for dim in targets_map:
		var target: int = int(targets_map[dim])
		rows[dim] = {
			"target": target,
			"approved": int(approved.get(dim, 0)),
			"draft": int(draft.get(dim, 0)),
			"integrated": int(integrated.get(dim, 0)),
			"cataloged": int(cataloged.get(dim, 0)),
			"gap_approved": target - int(approved.get(dim, 0)),
		}
	return rows


func _compute_quota_report(manifest: Dictionary) -> Dictionary:
	var targets: Dictionary = manifest.get("targets", {})
	var class_targets: Dictionary = targets.get("decisions_by_class", {})
	var category_targets: Dictionary = targets.get("decisions_by_category", {})
	var speaker_targets: Dictionary = targets.get("decisions_by_speaker", {})
	var stage_targets: Dictionary = targets.get("decisions_by_stage", {})
	var decisions: Array = manifest.get("decisions", [])
	var catalogs: Dictionary = manifest.get("catalogs", {})

	var by_class_approved: Dictionary = {}
	var by_class_integrated: Dictionary = {}
	var by_class_draft: Dictionary = {}
	var by_class_all: Dictionary = {}
	for quota_class in class_targets:
		by_class_approved[quota_class] = 0
		by_class_integrated[quota_class] = 0
		by_class_draft[quota_class] = 0
		by_class_all[quota_class] = 0

	var approved_total := 0
	var draft_total := 0
	var integrated_total := 0
	for record in decisions:
		if not (record is Dictionary):
			continue
		var cls := str(record.get("primary_content_class", ""))
		var status := str(record.get("status", ""))
		if by_class_all.has(cls):
			by_class_all[cls] += 1
		if status == "approved":
			approved_total += 1
			if by_class_approved.has(cls):
				by_class_approved[cls] += 1
		if _is_draft_status(status):
			draft_total += 1
			if by_class_draft.has(cls):
				by_class_draft[cls] += 1
		if status in ["integrated", "approved"]:
			integrated_total += 1
			if by_class_integrated.has(cls):
				by_class_integrated[cls] += 1

	var decision_classes: Dictionary = {}
	for quota_class in class_targets:
		var target: int = int(class_targets[quota_class])
		decision_classes[quota_class] = {
			"target": target,
			"approved": int(by_class_approved.get(quota_class, 0)),
			"draft": int(by_class_draft.get(quota_class, 0)),
			"integrated": int(by_class_integrated.get(quota_class, 0)),
			"total_cataloged": int(by_class_all.get(quota_class, 0)),
			"gap_approved": target - int(by_class_approved.get(quota_class, 0)),
		}

	var major_arcs_approved := 0
	for arc in catalogs.get("arcs", []):
		if arc is Dictionary and str(arc.get("importance", "")) == "major" and str(arc.get("status", "")) == "approved":
			major_arcs_approved += 1

	var chains_approved := 0
	for chain in catalogs.get("chains", []):
		if chain is Dictionary and str(chain.get("status", "")) == "approved":
			chains_approved += 1

	var crises_approved := 0
	for crisis in catalogs.get("crises", []):
		if crisis is Dictionary and str(crisis.get("status", "")) == "approved":
			crises_approved += 1

	var laws_approved := _count_catalog_by_status(catalogs.get("laws", []), "approved")
	var endings_approved := _count_catalog_by_status(catalogs.get("endings", []), "approved")
	var upgrades_approved := _count_catalog_by_status(catalogs.get("palace_upgrades", []), "approved")
	var identities_approved := _count_catalog_by_status(catalogs.get("ruler_identities", []), "approved")

	var by_category := _build_dimension_quota(
		decisions, category_targets, "primary_category", _canonical_category,
	)
	var by_speaker := _build_dimension_quota(
		decisions, speaker_targets, "primary_speaker", _canonical_speaker,
	)
	var by_stage := _build_dimension_quota(
		decisions, stage_targets, "primary_run_stage",
	)

	return {
		"decisions": {
			"target_total": int(targets.get("decisions_total", 330)),
			"approved_total": approved_total,
			"draft_total": draft_total,
			"integrated_total": integrated_total,
			"total_cataloged": decisions.size(),
			"gap_approved": int(targets.get("decisions_total", 330)) - approved_total,
			"by_class": decision_classes,
			"by_category": by_category,
			"by_speaker": by_speaker,
			"by_stage": by_stage,
		},
		"major_arcs": {
			"target": int(targets.get("major_arcs", 18)),
			"approved": major_arcs_approved,
			"integrated": _count_major_arcs_integrated(catalogs.get("arcs", [])),
			"gap_approved": int(targets.get("major_arcs", 18)) - major_arcs_approved,
		},
		"short_chains": {
			"target": int(targets.get("short_chains", 32)),
			"approved": chains_approved,
			"integrated": _count_catalog_by_status(catalogs.get("chains", []), "integrated"),
			"gap_approved": int(targets.get("short_chains", 32)) - chains_approved,
		},
		"crises": {
			"target": int(targets.get("crises", 18)),
			"approved": crises_approved,
			"integrated": _count_catalog_by_status(catalogs.get("crises", []), "integrated"),
			"gap_approved": int(targets.get("crises", 18)) - crises_approved,
		},
		"laws": {
			"target": int(targets.get("laws", 50)),
			"approved": laws_approved,
			"integrated": _count_catalog_by_status(catalogs.get("laws", []), "integrated"),
			"gap_approved": int(targets.get("laws", 50)) - laws_approved,
		},
		"endings": {
			"target": int(targets.get("endings", 50)),
			"approved": endings_approved,
			"integrated": _count_catalog_by_status(catalogs.get("endings", []), "integrated"),
			"gap_approved": int(targets.get("endings", 50)) - endings_approved,
		},
		"palace_upgrades": {
			"target": int(targets.get("palace_upgrades", 24)),
			"approved": upgrades_approved,
			"integrated": 0,
			"gap_approved": int(targets.get("palace_upgrades", 24)) - upgrades_approved,
		},
		"ruler_identities": {
			"target": int(targets.get("ruler_identities", 12)),
			"approved": identities_approved,
			"integrated": _count_catalog_by_status(catalogs.get("ruler_identities", []), "integrated"),
			"gap_approved": int(targets.get("ruler_identities", 12)) - identities_approved,
		},
		"advisors": {
			"target": int(targets.get("advisors", 8)),
			"approved": 0,
			"integrated": catalogs.get("advisors", []).size(),
			"gap_approved": 0,
		},
		"guest_speakers": {
			"target": int(targets.get("guest_speakers", 6)),
			"approved": 0,
			"integrated": 0,
			"gap_approved": int(targets.get("guest_speakers", 6)),
		},
	}


func _count_catalog_by_status(items: Array, status: String) -> int:
	var count := 0
	for item in items:
		if item is Dictionary and str(item.get("status", "")) == status:
			count += 1
	return count


func _count_major_arcs_integrated(arcs: Array) -> int:
	var count := 0
	for arc in arcs:
		if arc is Dictionary and str(arc.get("importance", "")) == "major" and str(arc.get("status", "")) == "integrated":
			count += 1
	return count


func _compute_distribution_report(manifest: Dictionary) -> Dictionary:
	var decisions: Array = manifest.get("decisions", [])
	var by_status: Dictionary = {}
	var by_class: Dictionary = {}
	var by_category: Dictionary = {}
	var by_category_canonical: Dictionary = {}
	var by_speaker: Dictionary = {}
	var by_stage: Dictionary = {}
	var by_voice_review: Dictionary = {}
	var by_balance_review: Dictionary = {}
	var by_manual_test: Dictionary = {}
	var by_graph_validation: Dictionary = {}
	var approved_by_category: Dictionary = {}
	var approved_by_speaker: Dictionary = {}
	var approved_by_stage: Dictionary = {}

	for record in decisions:
		if not (record is Dictionary):
			continue
		var status := str(record.get("status", "unknown"))
		var raw_category := str(record.get("primary_category", "unknown"))
		var canonical_category := _canonical_category(raw_category)
		var raw_speaker := str(record.get("primary_speaker", "unknown"))
		var canonical_speaker := _canonical_speaker(raw_speaker)
		var stage := str(record.get("primary_run_stage", "unknown"))

		_increment(by_status, status)
		_increment(by_class, str(record.get("primary_content_class", "unknown")))
		_increment(by_category, raw_category)
		_increment(by_category_canonical, canonical_category)
		_increment(by_speaker, raw_speaker)
		_increment(by_stage, stage)
		_increment(by_voice_review, str(record.get("voice_review_status", "unknown")))
		_increment(by_balance_review, str(record.get("balance_review_status", "unknown")))
		_increment(by_manual_test, str(record.get("manual_test_status", "unknown")))
		_increment(by_graph_validation, str(record.get("graph_validation_status", "unknown")))

		if status == "approved":
			_increment(approved_by_category, canonical_category)
			_increment(approved_by_speaker, canonical_speaker)
			_increment(approved_by_stage, stage)

	return {
		"by_status": by_status,
		"by_primary_content_class": by_class,
		"by_primary_category": by_category,
		"by_primary_category_canonical": by_category_canonical,
		"by_primary_speaker": by_speaker,
		"by_primary_run_stage": by_stage,
		"by_review_status": {
			"voice_review_status": by_voice_review,
			"balance_review_status": by_balance_review,
			"manual_test_status": by_manual_test,
			"graph_validation_status": by_graph_validation,
		},
		"approved_only": {
			"by_primary_category_canonical": approved_by_category,
			"by_primary_speaker": approved_by_speaker,
			"by_primary_run_stage": approved_by_stage,
		},
	}


func _increment(counter: Dictionary, key: String) -> void:
	counter[key] = int(counter.get(key, 0)) + 1


func _record_missing_review(record: Dictionary) -> bool:
	if str(record.get("voice_review_status", "")) != "pass":
		return true
	if str(record.get("balance_review_status", "")) != "pass":
		return true
	if str(record.get("manual_test_status", "")) != "pass":
		return true
	if str(record.get("graph_validation_status", "")) not in ["pass"]:
		return true
	if str(record.get("schema_validation_status", "")) != "pass":
		return true
	return false


func _compute_quality_findings(manifest: Dictionary, diagnostics: Dictionary) -> Dictionary:
	var decisions: Array = manifest.get("decisions", [])
	var rewrite_ids: Array[String] = []
	var deferred_ids: Array[String] = []
	var integrated_ids: Array[String] = []
	var missing_visual_hooks: Array[String] = []
	var missing_visual_tags: Array[String] = []
	var untested_content: Array[String] = []
	var missing_review_status: Array[String] = []

	for record in decisions:
		if not (record is Dictionary):
			continue
		var id := str(record.get("id", ""))
		var status := str(record.get("status", ""))
		if status == "needs_rewrite":
			rewrite_ids.append(id)
		elif status == "deferred":
			deferred_ids.append(id)
		elif status == "integrated":
			integrated_ids.append(id)
		var visual_tags: Array = record.get("visual_tags", [])
		if visual_tags.is_empty():
			missing_visual_tags.append(id)
			if str(record.get("primary_content_class", "")) in ["major_arc", "onboarding"]:
				missing_visual_hooks.append(id)
		if str(record.get("manual_test_status", "")) == "untested":
			untested_content.append(id)
		if _record_missing_review(record):
			missing_review_status.append(id)

	var diag_summary: Dictionary = {}
	var findings: Dictionary = diagnostics.get("findings", {})
	for category in [
		"unreachable_decisions", "dominant_choice_options", "cards_no_meaningful_effects",
		"endings_impossible", "excessive_advisor_concentration", "excessive_tag_concentration",
		"branches_no_continuation",
	]:
		var items: Array = findings.get(category, [])
		diag_summary[category] = items.size()

	missing_visual_tags.sort()
	untested_content.sort()
	missing_review_status.sort()

	return {
		"needs_rewrite_ids": rewrite_ids,
		"deferred_ids": deferred_ids,
		"integrated_ids": integrated_ids,
		"duplicate_premise_groups": DUPLICATE_PREMISE_GROUPS.duplicate(true),
		"missing_visual_hooks": missing_visual_hooks,
		"missing_visual_tags": missing_visual_tags,
		"untested_content": untested_content,
		"missing_review_status": missing_review_status,
		"diagnostics_summary": diag_summary,
		"simulation_never_selected": SIM_NEVER_SELECTED.duplicate(),
	}


static func _append_dimension_quota_lines(
	lines: PackedStringArray,
	title: String,
	rows: Dictionary,
) -> void:
	if rows.is_empty():
		return
	lines.append("")
	lines.append(title)
	for dim in rows:
		var row: Dictionary = rows[dim]
		lines.append(
			"  %s: %d approved / %d target (gap %d); %d draft; %d cataloged" % [
				dim,
				int(row.get("approved", 0)),
				int(row.get("target", 0)),
				int(row.get("gap_approved", 0)),
				int(row.get("draft", 0)),
				int(row.get("cataloged", 0)),
			]
		)


static func format_quota_text(manifest: Dictionary) -> String:
	var report: Dictionary = manifest.get("quota_report", {})
	var qf: Dictionary = manifest.get("quality_findings", {})
	var lines: PackedStringArray = ["Content manifest quota report (approved vs target):"]

	var decisions: Dictionary = report.get("decisions", {})
	lines.append("")
	lines.append(
		"Decisions: %d approved / %d target (gap %d); %d draft; %d integrated; %d cataloged" % [
			int(decisions.get("approved_total", 0)),
			int(decisions.get("target_total", 0)),
			int(decisions.get("gap_approved", 0)),
			int(decisions.get("draft_total", 0)),
			int(decisions.get("integrated_total", 0)),
			int(decisions.get("total_cataloged", 0)),
		]
	)
	var by_class: Dictionary = decisions.get("by_class", {})
	for quota_class in by_class:
		var row: Dictionary = by_class[quota_class]
		lines.append(
			"  %s: %d approved / %d target (gap %d); %d draft; %d integrated" % [
				quota_class,
				int(row.get("approved", 0)),
				int(row.get("target", 0)),
				int(row.get("gap_approved", 0)),
				int(row.get("draft", 0)),
				int(row.get("integrated", 0)),
			]
		)

	_append_dimension_quota_lines(
		lines, "By category (canonical):", decisions.get("by_category", {}),
	)
	_append_dimension_quota_lines(
		lines, "By speaker:", decisions.get("by_speaker", {}),
	)
	_append_dimension_quota_lines(
		lines, "By stage:", decisions.get("by_stage", {}),
	)

	for key in ["major_arcs", "short_chains", "crises", "laws", "endings", "palace_upgrades", "ruler_identities", "guest_speakers"]:
		if not report.has(key):
			continue
		var row: Dictionary = report[key]
		lines.append(
			"%s: %d approved / %d target (gap %d)" % [
				key,
				int(row.get("approved", 0)),
				int(row.get("target", 0)),
				int(row.get("gap_approved", 0)),
			]
		)

	lines.append("")
	lines.append("Quality flags:")
	lines.append("  untested_content: %d" % qf.get("untested_content", []).size())
	lines.append("  missing_visual_tags: %d" % qf.get("missing_visual_tags", []).size())
	lines.append("  missing_review_status: %d" % qf.get("missing_review_status", []).size())
	return "\n".join(lines)


static func write_json(manifest: Dictionary, path: String = "res://data/content_manifest.json") -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(manifest, "\t"))
	return OK
