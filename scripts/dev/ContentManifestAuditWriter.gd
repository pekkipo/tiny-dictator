extends RefCounted

## Generates docs/content/PHASE_2A_CONTENT_AUDIT.md from manifest data.


static func format(manifest: Dictionary, validation) -> String:
	var lines: PackedStringArray = []
	lines.append("# Phase 2A Content Audit")
	lines.append("")
	lines.append("**Milestone:** 2B-1 — Voice Bible and Production Scaffolding")
	lines.append("**Generated:** %s" % str(manifest.get("generated_at", "")))
	lines.append("**Country:** %s" % str(manifest.get("country_id", "")))
	lines.append("**Manifest version:** %d" % int(manifest.get("manifest_version", 0)))
	lines.append("")
	lines.append("> Machine-readable source of truth: [`data/content_manifest.json`](../data/content_manifest.json)")
	lines.append("> Regenerate: `godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit`")
	lines.append("")

	_append_executive_summary(lines, manifest)
	_append_quota_gaps(lines, manifest)
	_append_distribution(lines, manifest)
	_append_dimension_quotas(lines, manifest)
	_append_class_breakdown(lines, manifest)
	_append_catalog_inventory(lines, manifest)
	_append_quality_findings(lines, manifest)
	_append_rewrite_lists(lines, manifest)
	_append_assumptions(lines)
	_append_maintenance(lines)
	_append_manual_checklist(lines)
	_append_validation_status(lines, validation)

	return "\n".join(lines) + "\n"


static func _append_executive_summary(lines: PackedStringArray, manifest: Dictionary) -> void:
	lines.append("## 1. Executive inventory")
	lines.append("")
	var quota: Dictionary = manifest.get("quota_report", {})
	var decisions: Dictionary = quota.get("decisions", {})
	lines.append("| Metric | Current cataloged | Approved | 2B target | Gap |")
	lines.append("|---|---:|---:|---:|---:|")
	lines.append("| Decisions | %d | %d | %d | %d |" % [
		int(decisions.get("total_cataloged", 0)),
		int(decisions.get("approved_total", 0)),
		int(decisions.get("target_total", 0)),
		int(decisions.get("gap_approved", 0)),
	])
	for key in ["major_arcs", "short_chains", "crises", "laws", "endings", "palace_upgrades", "ruler_identities"]:
		var row: Dictionary = quota.get(key, {})
		lines.append("| %s | %d | %d | %d | %d |" % [
			key.replace("_", " ").capitalize(),
			int(row.get("integrated", 0)) + int(row.get("approved", 0)),
			int(row.get("approved", 0)),
			int(row.get("target", 0)),
			int(row.get("gap_approved", 0)),
		])
	lines.append("")
	lines.append("**Approved decision count:** %d (voice bible complete; approval requires rubric ≥16/20 per batch)." % int(decisions.get("approved_total", 0)))
	lines.append("**Draft decision count:** %d" % int(decisions.get("draft_total", 0)))
	lines.append("")


static func _append_quota_gaps(lines: PackedStringArray, manifest: Dictionary) -> void:
	lines.append("## 2. Decision-class quota gaps (approved vs target)")
	lines.append("")
	lines.append("| Primary content class | Cataloged | Integrated | Approved | Target | Gap |")
	lines.append("|---|---:|---:|---:|---:|---:|")
	var by_class: Dictionary = manifest.get("quota_report", {}).get("decisions", {}).get("by_class", {})
	for quota_class in by_class:
		var row: Dictionary = by_class[quota_class]
		lines.append("| %s | %d | %d | %d | %d | %d |" % [
			quota_class,
			int(row.get("total_cataloged", 0)),
			int(row.get("integrated", 0)),
			int(row.get("approved", 0)),
			int(row.get("target", 0)),
			int(row.get("gap_approved", 0)),
		])
	lines.append("")


static func _append_distribution(lines: PackedStringArray, manifest: Dictionary) -> void:
	lines.append("## 3. Distribution reports")
	lines.append("")
	var dist: Dictionary = manifest.get("distribution_report", {})
	for section in [
		"by_status", "by_primary_content_class", "by_primary_category",
		"by_primary_category_canonical", "by_primary_speaker", "by_primary_run_stage",
	]:
		lines.append("### %s" % section)
		lines.append("")
		var data: Dictionary = dist.get(section, {})
		if data.is_empty():
			lines.append("_No data._")
		else:
			for key in data:
				lines.append("- **%s:** %d" % [key, int(data[key])])
		lines.append("")


static func _append_dimension_quotas(lines: PackedStringArray, manifest: Dictionary) -> void:
	var decisions_quota: Dictionary = manifest.get("quota_report", {}).get("decisions", {})
	for title_key in [
		["## 3b. Category quota (canonical)", "by_category"],
		["## 3c. Speaker quota", "by_speaker"],
		["## 3d. Stage quota", "by_stage"],
	]:
		var title: String = title_key[0]
		var key: String = title_key[1]
		var rows: Dictionary = decisions_quota.get(key, {})
		if rows.is_empty():
			continue
		lines.append(title)
		lines.append("")
		lines.append("| Dimension | Cataloged | Approved | Draft | Target | Gap |")
		lines.append("|---|---:|---:|---:|---:|---:|")
		for dim in rows:
			var row: Dictionary = rows[dim]
			lines.append("| %s | %d | %d | %d | %d | %d |" % [
				dim,
				int(row.get("cataloged", 0)),
				int(row.get("approved", 0)),
				int(row.get("draft", 0)),
				int(row.get("target", 0)),
				int(row.get("gap_approved", 0)),
			])
		lines.append("")


static func _append_class_breakdown(lines: PackedStringArray, manifest: Dictionary) -> void:
	lines.append("## 4. Decision IDs by primary content class")
	lines.append("")
	var by_class: Dictionary = {}
	for record in manifest.get("decisions", []):
		if not (record is Dictionary):
			continue
		var cls := str(record.get("primary_content_class", "unknown"))
		if not by_class.has(cls):
			by_class[cls] = []
		(by_class[cls] as Array).append(str(record.get("id", "")))
	for cls in by_class:
		(by_class[cls] as Array).sort()
		lines.append("### %s (%d)" % [cls, (by_class[cls] as Array).size()])
		lines.append("")
		for id in by_class[cls]:
			lines.append("- `%s`" % id)
		lines.append("")


static func _append_catalog_inventory(lines: PackedStringArray, manifest: Dictionary) -> void:
	lines.append("## 5. Non-decision catalogs")
	lines.append("")
	var catalogs: Dictionary = manifest.get("catalogs", {})
	for key in ["arcs", "chains", "crises", "laws", "endings", "advisors", "ruler_identities", "palace_upgrades"]:
		var items: Array = catalogs.get(key, [])
		lines.append("### %s (%d)" % [key, items.size()])
		lines.append("")
		for item in items:
			if item is Dictionary:
				lines.append("- `%s` — status: %s" % [str(item.get("id", "")), str(item.get("status", ""))])
		lines.append("")


static func _append_quality_findings(lines: PackedStringArray, manifest: Dictionary) -> void:
	lines.append("## 6. Quality findings")
	lines.append("")
	var qf: Dictionary = manifest.get("quality_findings", {})
	lines.append("### Static diagnostics summary")
	lines.append("")
	var diag: Dictionary = qf.get("diagnostics_summary", {})
	for category in diag:
		lines.append("- **%s:** %d" % [category, int(diag[category])])
	lines.append("")
	lines.append("### Duplicate or similar premise groups")
	lines.append("")
	for group in qf.get("duplicate_premise_groups", []):
		if group is Dictionary:
			lines.append("- **%s:** %s — %s" % [
				str(group.get("group_id", "")),
				str(group.get("ids", [])),
				str(group.get("reason", "")),
			])
	lines.append("")
	lines.append("### Simulation never-selected (1000-run snapshot)")
	lines.append("")
	for id in qf.get("simulation_never_selected", []):
		lines.append("- `%s`" % str(id))
	lines.append("")
	lines.append("### Missing visual hooks (major_arc / onboarding without visual_tags)")
	lines.append("")
	for id in qf.get("missing_visual_hooks", []):
		lines.append("- `%s`" % str(id))
	lines.append("")
	lines.append("### Missing visual tags (all decisions)")
	lines.append("")
	for id in qf.get("missing_visual_tags", []):
		lines.append("- `%s`" % str(id))
	lines.append("")
	lines.append("### Untested content (manual_test_status = untested)")
	lines.append("")
	for id in qf.get("untested_content", []):
		lines.append("- `%s`" % str(id))
	lines.append("")
	lines.append("### Missing review status (any gate not pass)")
	lines.append("")
	for id in qf.get("missing_review_status", []):
		lines.append("- `%s`" % str(id))
	lines.append("")
	var review_dist: Dictionary = manifest.get("distribution_report", {}).get("by_review_status", {})
	if not review_dist.is_empty():
		lines.append("### Review status distribution")
		lines.append("")
		for gate in review_dist:
			lines.append("#### %s" % gate)
			lines.append("")
			var gate_data: Dictionary = review_dist[gate]
			for key in gate_data:
				lines.append("- **%s:** %d" % [key, int(gate_data[key])])
			lines.append("")


static func _append_rewrite_lists(lines: PackedStringArray, manifest: Dictionary) -> void:
	lines.append("## 7. Rewrite, defer, and reclassify recommendations")
	lines.append("")
	var qf: Dictionary = manifest.get("quality_findings", {})
	lines.append("### Needs rewrite")
	lines.append("")
	for id in qf.get("needs_rewrite_ids", []):
		lines.append("- `%s`" % str(id))
	lines.append("")
	lines.append("### Deferred (extra beyond 2A-9 required set)")
	lines.append("")
	for id in qf.get("deferred_ids", []):
		lines.append("- `%s`" % str(id))
	lines.append("")
	lines.append("### Reclassification notes")
	lines.append("")
	lines.append("- Minor arcs (`traffic_military`, `robot_government`) count toward **short_chain**, not major_arc.")
	lines.append("- `generic_minister_disagreement` is **standalone** fallback filler.")
	lines.append("- `cat_voting_proposal` was **rejected** in 2B-5A (duplicate of arc `cat_voting_rights`); removed from runtime.")
	lines.append("- `chain_id` values are manifest-invented; runtime JSON has no chain field yet.")
	lines.append("")


static func _append_assumptions(lines: PackedStringArray) -> void:
	lines.append("## 8. Assumptions and unresolved issues")
	lines.append("")
	lines.append("1. **Planning catalogs** — [`MINISTAN_ARC_CATALOG.md`](MINISTAN_ARC_CATALOG.md), [`MINISTAN_CHAIN_CATALOG.md`](MINISTAN_CHAIN_CATALOG.md), [`MINISTAN_CRISIS_CATALOG.md`](MINISTAN_CRISIS_CATALOG.md) are authoritative for 2B production inventory.")
	lines.append("2. **Voice bible complete** — approval still requires per-card rubric ≥16/20 during batch review.")
	lines.append("3. **Unreachable diagnostics** — 42 optimistic-graph warnings expected for arc-gated cards.")
	lines.append("4. **Resource-failure endings** — `bankrupt_leader`, `revolution`, `elite_coup`, `chaos_country` flagged impossible from day-1 by design.")
	lines.append("5. **Guest speakers** — 0 of 6 target in runtime; voice cards in voice bible only.")
	lines.append("6. **Simulation snapshot** — embedded from Phase 2A 1000-run report (seed 20260715).")
	lines.append("7. **Onboarding pack** — Milestone 2B-2 complete: 10 approved onboarding decisions with Content Director bias.")
	lines.append("")


static func _append_maintenance(lines: PackedStringArray) -> void:
	lines.append("## 9. Manifest maintenance")
	lines.append("")
	lines.append("1. After any content JSON change, run:")
	lines.append("   ```bash")
	lines.append("   godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit")
	lines.append("   ```")
	lines.append("2. Run `tests/test_content_manifest.gd` in CI or before content PRs.")
	lines.append("3. Update per-record `status` and review gates manually during batch review (2B-1+).")
	lines.append("4. Only `approved` decisions count toward the 330 strong-launch target.")
	lines.append("5. `quota_report` is always recomputed from manifest records — never edit gaps by hand.")
	lines.append("")


static func _append_manual_checklist(lines: PackedStringArray) -> void:
	lines.append("## 10. Manual test checklist")
	lines.append("")
	var items: PackedStringArray = [
		"`godot --headless --path . -s tests/run_content_manifest.gd` — quota includes draft/category/speaker/stage gaps",
		"`godot --headless --path . -s tests/test_content_manifest.gd` — manifest sync passes",
		"`godot --headless --path . -s tests/test_content_scaffolding.gd` — voice bible + catalogs complete",
		"`godot --headless --path . -s tests/test_content_validation.gd` — 74 decisions, 0 validator errors",
		"`godot --headless --path . -s tests/run_phase_2a_qa.gd` — full QA matrix passes",
		"Open `data/content_manifest.json` — 74 decision records, no duplicate IDs",
		"Spot-read each advisor in `MINISTAN_CHARACTER_VOICE_BIBLE.md` — 5 proposals/results/out-of-character present",
		"Spot-read arc/chain/crisis catalogs — 18/32/18 entries with required fields",
		"Confirm `docs/content/drafts/` has no runtime JSON; no new `data/decisions/*.json`",
		"Confirm canonical examples marked NOT RUNTIME",
		"Launch editor — boot run, resolve 3 decisions — behavior unchanged",
	]
	for i in range(items.size()):
		lines.append("%d. %s" % [i + 1, items[i]])
	lines.append("")


static func _append_validation_status(
	lines: PackedStringArray,
	validation,
) -> void:
	lines.append("## 11. Manifest validation status")
	lines.append("")
	if validation.is_valid:
		lines.append("**PASS** — manifest syncs with runtime content.")
	else:
		lines.append("**FAIL** — see errors below.")
	for error in validation.errors:
		lines.append("- ERROR: %s" % error)
	for warning in validation.warnings:
		lines.append("- WARN: %s" % warning)
	lines.append("")
