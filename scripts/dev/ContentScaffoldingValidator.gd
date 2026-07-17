extends RefCounted

## Validates Milestone 2B-1 planning docs (voice bible, catalogs).
## Spec: docs/09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md Milestone 2B-1.

const VOICE_BIBLE_PATH := "res://docs/content/MINISTAN_CHARACTER_VOICE_BIBLE.md"
const ARC_CATALOG_PATH := "res://docs/content/MINISTAN_ARC_CATALOG.md"
const CHAIN_CATALOG_PATH := "res://docs/content/MINISTAN_CHAIN_CATALOG.md"
const CRISIS_CATALOG_PATH := "res://docs/content/MINISTAN_CRISIS_CATALOG.md"
const STYLE_GUIDE_PATH := "res://docs/content/MINISTAN_CONTENT_STYLE_GUIDE.md"

const MAIN_ADVISOR_IDS: Array[String] = [
	"general_boom",
	"minister_penny",
	"luna_news",
	"auntie_olga",
	"doctor_maybe",
	"sir_profit",
	"comrade_whiskers",
	"clerk_zero",
]

const GUEST_SPEAKER_IDS: Array[String] = [
	"foreign_ambassador",
	"chief_judge",
	"palace_chef",
	"youth_representative",
	"workers_union_leader",
	"neighboring_president",
]

const ADVISOR_REQUIRED_SUBSECTIONS: Array[String] = [
	"**Role:**",
	"**Core desire:**",
	"**Fear:**",
	"**Relationship with the ruler:**",
	"**Sentence length:**",
	"**Vocabulary:**",
	"**Preferred metaphors:**",
	"**Joke style:**",
	"**Emotional range:**",
	"**Behavior when loyal:**",
	"**Behavior when hostile:**",
	"**Typical mechanical trade-offs:**",
	"**Prohibited phrases and patterns:**",
	"**Canonical proposals",
	"**Canonical results",
	"**Out of character",
]

const ARC_IDS: Array[String] = [
	"arc_general_boom_rise",
	"arc_penny_austerity",
	"arc_luna_media_reality",
	"arc_olga_citizen_movement",
	"arc_maybe_experimental_republic",
	"arc_profit_corporate_state",
	"arc_whiskers_cat_revolution",
	"arc_zero_government_of_forms",
	"arc_cat_politics",
	"arc_mandatory_happiness",
	"arc_traffic_military_control",
	"arc_ai_government",
	"arc_sell_the_moon",
	"arc_hyperinflation",
	"arc_national_festival_economy",
	"arc_fake_election_accident",
	"arc_international_cheese_crisis",
	"arc_palace_renovation_scandal",
]

const CHAIN_IDS: Array[String] = [
	"chain_umbrella_tax",
	"chain_national_coffee_reserve",
	"chain_privatized_public_benches",
	"chain_lottery_budget",
	"chain_coin_shortage",
	"chain_weekend_abolition",
	"chain_palace_gift_shop",
	"chain_pothole_naming_rights",
	"chain_elevator_wifi",
	"chain_bridge_to_nowhere",
	"chain_traffic_flags",
	"chain_perfumed_sewage",
	"chain_national_clock_reform",
	"chain_state_meme_department",
	"chain_weather_censorship",
	"chain_applause_quotas",
	"chain_national_talent_show",
	"chain_artificial_sun",
	"chain_robot_queue_manager",
	"chain_antigravity_buses",
	"chain_national_clone_day",
	"chain_pigeon_air_force",
	"chain_border_parade",
	"chain_camouflage_uniform_scandal",
	"chain_tank_parking_crisis",
	"chain_salaries_paid_in_coupons",
	"chain_form_to_request_forms",
	"chain_ministry_of_waiting",
	"chain_stamp_shortage",
	"chain_antivacuum_referendum",
	"chain_fish_currency_experiment",
	"chain_national_nap_hour",
]

const CRISIS_IDS: Array[String] = [
	"crisis_national_power_outage",
	"crisis_bank_run",
	"crisis_mass_protest",
	"crisis_cheese_shortage",
	"crisis_palace_fire",
	"crisis_government_data_leak",
	"crisis_military_mutiny",
	"crisis_cat_parliament_occupation",
	"crisis_national_internet_outage",
	"crisis_water_supply_turns_blue",
	"crisis_international_border_confusion",
	"crisis_currency_collapse",
	"crisis_public_transport_strike",
	"crisis_ai_cabinet_lockout",
	"crisis_moon_ownership_dispute",
	"crisis_bureaucrat_general_strike",
	"crisis_fake_news_panic",
	"crisis_national_festival_stampede",
]

const CATALOG_REQUIRED_FIELDS: Array[String] = [
	"**Title:**",
	"**Status:**",
	"**Target cards:**",
	"**Primary speaker:**",
	"**Category:**",
	"**Intended stage:**",
	"**Premise:**",
	"**Dependencies:**",
	"**Likely laws:**",
	"**Likely endings:**",
	"**Known risks:**",
]

const RUNTIME_DECISION_DIR := "res://data/decisions/"


static func validate_all(repository: ContentRepository = null) -> Dictionary:
	var errors: Array[String] = []
	var warnings: Array[String] = []
	_validate_voice_bible(errors, warnings)
	_validate_catalog(ARC_CATALOG_PATH, ARC_IDS, "arc", errors, warnings)
	_validate_catalog(CHAIN_CATALOG_PATH, CHAIN_IDS, "chain", errors, warnings)
	_validate_catalog(CRISIS_CATALOG_PATH, CRISIS_IDS, "crisis", errors, warnings)
	_validate_planning_docs_exist(errors)
	if repository != null:
		_validate_no_runtime_leakage(repository, errors, warnings)
	return {
		"errors": errors,
		"warnings": warnings,
		"is_valid": errors.is_empty(),
	}


static func _read_text(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


static func _validate_voice_bible(errors: Array[String], _warnings: Array[String]) -> void:
	var text := _read_text(VOICE_BIBLE_PATH)
	if text.is_empty():
		errors.append("Voice bible missing or unreadable: %s" % VOICE_BIBLE_PATH)
		return

	for advisor_id in MAIN_ADVISOR_IDS:
		var header := "## %s" % advisor_id
		if header not in text:
			errors.append("Voice bible missing main advisor section: %s" % advisor_id)
			continue
		var section := _extract_section(text, header, "## ")
		for subsection in ADVISOR_REQUIRED_SUBSECTIONS:
			if subsection not in section:
				errors.append("Voice bible advisor '%s' missing subsection: %s" % [advisor_id, subsection])
		var example_count := section.count("EXAMPLE — NOT RUNTIME")
		if example_count < 15:
			errors.append(
				"Voice bible advisor '%s' needs 15+ NOT RUNTIME examples (got %d)" % [advisor_id, example_count]
			)

	for guest_id in GUEST_SPEAKER_IDS:
		var guest_header := "## %s" % guest_id
		if guest_header not in text:
			errors.append("Voice bible missing guest speaker section: %s" % guest_id)
			continue
		var guest_section := _extract_section(text, guest_header, "## ")
		if guest_section.count("EXAMPLE — NOT RUNTIME") < 4:
			errors.append("Voice bible guest '%s' needs 4 NOT RUNTIME examples" % guest_id)


static func _extract_section(text: String, header: String, next_header_prefix: String) -> String:
	var start := text.find(header)
	if start < 0:
		return ""
	var body_start := start + header.length()
	var rest := text.substr(body_start)
	var next_pos := rest.find("\n%s" % next_header_prefix)
	if next_pos < 0:
		return rest
	return rest.substr(0, next_pos)


static func _validate_catalog(
	path: String,
	expected_ids: Array[String],
	label: String,
	errors: Array[String],
	_warnings: Array[String],
) -> void:
	var text := _read_text(path)
	if text.is_empty():
		errors.append("%s catalog missing or unreadable: %s" % [label, path])
		return

	var seen: Dictionary = {}
	for catalog_id in expected_ids:
		var header := "### %s" % catalog_id
		if header not in text:
			errors.append("%s catalog missing entry: %s" % [label, catalog_id])
			continue
		if seen.has(catalog_id):
			errors.append("%s catalog duplicate ID: %s" % [label, catalog_id])
		seen[catalog_id] = true
		var section := _extract_section(text, header, "### ")
		for field in CATALOG_REQUIRED_FIELDS:
			if field not in section:
				errors.append("%s catalog entry '%s' missing field: %s" % [label, catalog_id, field])

	for catalog_id in seen:
		if not _is_snake_case_id(catalog_id):
			errors.append("%s catalog ID not snake_case: %s" % [label, catalog_id])


static func _is_snake_case_id(id: String) -> bool:
	if id.is_empty():
		return false
	for i in range(id.length()):
		var ch: String = id[i]
		if not (ch == "_" or (ch >= "a" and ch <= "z") or (ch >= "0" and ch <= "9")):
			return false
	return true


static func _validate_planning_docs_exist(errors: Array[String]) -> void:
	for path in [STYLE_GUIDE_PATH, VOICE_BIBLE_PATH, ARC_CATALOG_PATH, CHAIN_CATALOG_PATH, CRISIS_CATALOG_PATH]:
		if not FileAccess.file_exists(path):
			errors.append("Missing planning doc: %s" % path)


static func _validate_no_runtime_leakage(
	repository: ContentRepository,
	errors: Array[String],
	warnings: Array[String],
) -> void:
	var runtime_count := repository.get_all_decisions_for_country("ministan").size()
	if runtime_count != 279:
		errors.append("Expected 279 runtime decisions, got %d" % runtime_count)

	var voice_text := _read_text(VOICE_BIBLE_PATH)
	if "EXAMPLE — NOT RUNTIME" not in voice_text:
		warnings.append("Voice bible missing NOT RUNTIME marker")

	for decision in repository.get_all_decisions_for_country("ministan"):
		var id := str(decision.get("id", ""))
		if voice_text.find('"%s"' % id) >= 0 or voice_text.find("`%s`" % id) >= 0:
			warnings.append("Voice bible may reference runtime decision id: %s" % id)


static func format_result_text(result: Dictionary) -> String:
	var lines: PackedStringArray = ["Scaffolding validation:"]
	if result.get("is_valid", false):
		lines.append("PASS")
	else:
		lines.append("FAIL")
	for error in result.get("errors", []):
		lines.append("  ERROR: %s" % error)
	for warning in result.get("warnings", []):
		lines.append("  WARN: %s" % warning)
	return "\n".join(lines)
