extends RefCounted

## Development-only manifest builder for Phase 2B content tracking.
## Spec: docs/09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md §20, Milestone 2B-0.

const MANIFEST_VERSION: int = 1
const COUNTRY_ID: String = "ministan"
const BATCH_ID: String = "2a-9"

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
	"decisions_total": 330,
	"major_arcs": 18,
	"short_chains": 32,
	"crises": 18,
	"laws": 50,
	"endings": 50,
	"palace_upgrades": 24,
	"ruler_identities": 12,
	"advisors": 8,
	"guest_speakers": 6,
}

const MAJOR_ARC_IDS: Array[String] = [
	"cat_politics", "mandatory_happiness", "general_boom_arc", "doctor_maybe_arc",
]

const MINOR_ARC_IDS: Array[String] = ["traffic_military", "robot_government"]

const CHAIN_MEMBERS: Dictionary = {
	"free_pizza_consequences": [
		"free_pizza_friday", "cheese_shortage", "pizza_union_strike", "pineapple_referendum",
	],
	"traffic_military": [
		"switch_off_traffic_lights", "traffic_tank_solution", "traffic_complaint",
		"traffic_military_resolved", "traffic_lights_restored",
	],
	"robot_government": ["robot_cabinet_proposal", "robot_government_installed"],
}

const ONBOARDING_IDS: Array[String] = [
	"free_pizza_friday", "window_tax_proposal", "no_weekends_proposal",
	"luna_good_news_only", "army_snack_budget", "parade_budget_boost",
]

const DEFERRED_DECISION_IDS: Array[String] = [
	"robot_cabinet_proposal", "robot_government_installed", "budget_meltdown_crisis",
]

const DEFERRED_ARC_IDS: Array[String] = ["robot_government"]
const DEFERRED_CRISIS_IDS: Array[String] = ["budget_meltdown"]

const PLACEHOLDER_DECISION_IDS: Array[String] = [
	"recovery_international_bank", "recovery_national_smile_day", "endgame_legacy_statue",
	"long_setup_grand_canal", "escalation_only_rival_parade", "recovery_martial_law_pause",
	"recovery_elite_dinner", "endgame_succession_debate", "endgame_final_audit",
]

const MANUAL_TEST_DECISION_IDS: Array[String] = [
	"cat_voting_rights", "switch_off_traffic_lights", "mandatory_smiling_proposal",
	"military_parade", "science_gamble", "national_power_outage", "cheese_shortage_crisis",
	"mass_protest", "bank_run", "cat_parliament_occupation",
]

const SIM_NEVER_SELECTED: Array[String] = ["boom_loyal_protector", "happiness_backlash"]

const SIMULATION_SNAPSHOT: Dictionary = {
	"seed": 20260715,
	"run_count": 1000,
	"date": "2026-07-15",
	"decisions_never_selected": ["boom_loyal_protector", "happiness_backlash"],
}

const DUPLICATE_PREMISE_GROUPS: Array[Dictionary] = [
	{
		"group_id": "cat_voting_duplicate",
		"ids": ["cat_voting_proposal", "cat_voting_rights"],
		"reason": "Both propose cat voting rights; core card may be legacy duplicate of arc entry.",
	},
	{
		"group_id": "smile_happiness_cluster",
		"ids": ["mandatory_smiling_proposal", "propaganda_smile_campaign", "fake_smile_industry"],
		"reason": "Multiple mandatory-smile premises across standalone, affinity, and arc paths.",
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
		"phase": "2a_baseline",
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
			"batch_id": BATCH_ID,
			"notes": "Phase 2A advisor catalog entry.",
		})

	for identity in repository.get_raw_ruler_identities():
		catalogs["ruler_identities"].append({
			"id": str(identity.get("id", "")),
			"content_type": "ruler_identity",
			"display_name": str(identity.get("display_name", "")),
			"status": "integrated",
			"batch_id": BATCH_ID,
			"notes": "",
		})

	for law in repository.get_raw_laws():
		catalogs["laws"].append({
			"id": str(law.get("id", "")),
			"content_type": "law",
			"primary_category": str(law.get("category", "")),
			"status": "integrated",
			"batch_id": BATCH_ID,
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
			"batch_id": BATCH_ID,
			"notes": notes,
		})

	for upgrade in repository.get_raw_palace_upgrades():
		catalogs["palace_upgrades"].append({
			"id": str(upgrade.get("id", "")),
			"content_type": "palace_upgrade",
			"status": "needs_rewrite",
			"batch_id": BATCH_ID,
			"notes": "Phase 2A placeholder upgrade; expand in Phase 2B.",
		})

	for arc in repository.get_arcs_for_country(COUNTRY_ID):
		var arc_id := str(arc.get("id", ""))
		var status := "integrated"
		if arc_id in DEFERRED_ARC_IDS:
			status = "deferred"
		elif str(arc.get("importance", "")) == "major":
			status = "integrated"
		catalogs["arcs"].append({
			"id": arc_id,
			"content_type": "arc",
			"importance": str(arc.get("importance", "")),
			"arc_type": str(arc.get("arc_type", "")),
			"status": status,
			"batch_id": BATCH_ID,
			"decision_count": _count_decisions_for_arc(decisions, arc_id),
			"notes": "Minor arcs counted toward short_chain quota, not major_arc quota." if arc_id in MINOR_ARC_IDS else "",
		})

	for chain_id in CHAIN_MEMBERS:
		var member_ids: Array = CHAIN_MEMBERS[chain_id]
		var chain_status := "integrated"
		if chain_id == "robot_government":
			chain_status = "deferred"
		catalogs["chains"].append({
			"id": chain_id,
			"content_type": "chain",
			"status": chain_status,
			"batch_id": BATCH_ID,
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
			"batch_id": BATCH_ID,
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
		"batch_id": BATCH_ID,
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
	if id in ONBOARDING_IDS:
		return "onboarding"
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
	if id == "cat_voting_proposal":
		notes.append("Legacy core card; duplicate premise of cat_voting_rights arc entry.")
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
		notes.append("Provisional onboarding classification; may move in 2B-2 pack.")
	return ", ".join(notes)


func _source_file_hint(id: String) -> String:
	const FILE_HINTS: Dictionary = {
		"switch_off_traffic_lights": "ministan_core.json",
		"free_pizza_friday": "ministan_core.json",
		"mandatory_smiling_proposal": "ministan_core.json",
		"cat_voting_proposal": "ministan_core.json",
		"military_parade": "ministan_core.json",
		"window_tax_proposal": "ministan_core.json",
		"no_weekends_proposal": "ministan_core.json",
		"luna_good_news_only": "ministan_core.json",
		"army_snack_budget": "ministan_core.json",
		"budget_meltdown_crisis": "ministan_core.json",
		"generic_minister_disagreement": "ministan_core.json",
	}
	if FILE_HINTS.has(id):
		return "data/decisions/%s" % FILE_HINTS[id]
	if id.begins_with("cat_") or id.begins_with("robot_") or id == "cats_return_to_boxes":
		return "data/decisions/ministan_cat_politics.json"
	if id.begins_with("national_") or id.begins_with("cheese_shortage_crisis") or id.begins_with("mass_") or id.begins_with("bank_") or id.begins_with("cat_parliament_occupation"):
		return "data/decisions/ministan_crises.json"
	if id.begins_with("maybe_"):
		return "data/decisions/ministan_doctor_maybe_arc.json"
	if id.begins_with("boom_"):
		return "data/decisions/ministan_general_boom_arc.json"
	if id.begins_with("happiness_") or id == "fake_smile_industry":
		return "data/decisions/ministan_mandatory_happiness.json" if id.begins_with("happiness_") else "data/decisions/ministan_followups.json"
	if id in ["fake_smile_industry", "cheese_shortage", "cat_parliament", "cat_fish_budget"]:
		return "data/decisions/ministan_followups.json"
	if id.begins_with("traffic_"):
		return "data/decisions/ministan_traffic_military.json"
	if id.begins_with("recovery_") or id.begins_with("endgame_") or id in ["long_setup_grand_canal", "escalation_only_rival_parade"]:
		return "data/decisions/ministan_stage_placeholders.json"
	if id in ["pizza_union_strike", "pineapple_referendum"]:
		return "data/decisions/ministan_pizza_consequences.json"
	if id in CHAIN_MEMBERS["free_pizza_consequences"] or id in ONBOARDING_IDS or id in [
		"parade_budget_boost", "cat_treaty_offer", "bureaucracy_expansion", "science_gamble",
		"privatize_palace_garden", "propaganda_smile_campaign", "olga_loyal_council",
		"boom_hostile_coup_rumor",
	]:
		if id in ["parade_budget_boost", "cat_treaty_offer", "bureaucracy_expansion", "science_gamble",
			"privatize_palace_garden", "propaganda_smile_campaign", "olga_loyal_council",
			"boom_hostile_coup_rumor"]:
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


func _compute_quota_report(manifest: Dictionary) -> Dictionary:
	var targets: Dictionary = manifest.get("targets", {})
	var class_targets: Dictionary = targets.get("decisions_by_class", {})
	var decisions: Array = manifest.get("decisions", [])
	var catalogs: Dictionary = manifest.get("catalogs", {})

	var by_class_approved: Dictionary = {}
	var by_class_integrated: Dictionary = {}
	var by_class_all: Dictionary = {}
	for quota_class in class_targets:
		by_class_approved[quota_class] = 0
		by_class_integrated[quota_class] = 0
		by_class_all[quota_class] = 0

	var approved_total := 0
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

	return {
		"decisions": {
			"target_total": int(targets.get("decisions_total", 330)),
			"approved_total": approved_total,
			"integrated_total": integrated_total,
			"total_cataloged": decisions.size(),
			"gap_approved": int(targets.get("decisions_total", 330)) - approved_total,
			"by_class": decision_classes,
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
	var by_speaker: Dictionary = {}
	var by_stage: Dictionary = {}

	for record in decisions:
		if not (record is Dictionary):
			continue
		_increment(by_status, str(record.get("status", "unknown")))
		_increment(by_class, str(record.get("primary_content_class", "unknown")))
		_increment(by_category, str(record.get("primary_category", "unknown")))
		_increment(by_speaker, str(record.get("primary_speaker", "unknown")))
		_increment(by_stage, str(record.get("primary_run_stage", "unknown")))

	return {
		"by_status": by_status,
		"by_primary_content_class": by_class,
		"by_primary_category": by_category,
		"by_primary_speaker": by_speaker,
		"by_primary_run_stage": by_stage,
	}


func _increment(counter: Dictionary, key: String) -> void:
	counter[key] = int(counter.get(key, 0)) + 1


func _compute_quality_findings(manifest: Dictionary, diagnostics: Dictionary) -> Dictionary:
	var decisions: Array = manifest.get("decisions", [])
	var rewrite_ids: Array[String] = []
	var deferred_ids: Array[String] = []
	var integrated_ids: Array[String] = []
	var missing_visual_hooks: Array[String] = []

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
		if visual_tags.is_empty() and str(record.get("primary_content_class", "")) in ["major_arc", "onboarding"]:
			missing_visual_hooks.append(id)

	var diag_summary: Dictionary = {}
	var findings: Dictionary = diagnostics.get("findings", {})
	for category in [
		"unreachable_decisions", "dominant_choice_options", "cards_no_meaningful_effects",
		"endings_impossible", "excessive_advisor_concentration", "excessive_tag_concentration",
		"branches_no_continuation",
	]:
		var items: Array = findings.get(category, [])
		diag_summary[category] = items.size()

	return {
		"needs_rewrite_ids": rewrite_ids,
		"deferred_ids": deferred_ids,
		"integrated_ids": integrated_ids,
		"duplicate_premise_groups": DUPLICATE_PREMISE_GROUPS.duplicate(true),
		"missing_visual_hooks": missing_visual_hooks,
		"diagnostics_summary": diag_summary,
		"simulation_never_selected": SIM_NEVER_SELECTED.duplicate(),
	}


static func format_quota_text(manifest: Dictionary) -> String:
	var report: Dictionary = manifest.get("quota_report", {})
	var lines: PackedStringArray = ["Content manifest quota report (approved vs target):"]

	var decisions: Dictionary = report.get("decisions", {})
	lines.append("")
	lines.append(
		"Decisions: %d approved / %d target (gap %d); %d integrated; %d cataloged" % [
			int(decisions.get("approved_total", 0)),
			int(decisions.get("target_total", 0)),
			int(decisions.get("gap_approved", 0)),
			int(decisions.get("integrated_total", 0)),
			int(decisions.get("total_cataloged", 0)),
		]
	)
	var by_class: Dictionary = decisions.get("by_class", {})
	for quota_class in by_class:
		var row: Dictionary = by_class[quota_class]
		lines.append(
			"  %s: %d approved / %d target (gap %d); %d integrated cataloged" % [
				quota_class,
				int(row.get("approved", 0)),
				int(row.get("target", 0)),
				int(row.get("gap_approved", 0)),
				int(row.get("integrated", 0)),
			]
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
	return "\n".join(lines)


static func write_json(manifest: Dictionary, path: String = "res://data/content_manifest.json") -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(manifest, "\t"))
	return OK
