extends Node

## Cross-run meta progression: Medals, Ending Archive, palace upgrades.
## Spec: docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md §19, §28.7.

const KNOWN_META_REQUIREMENT_KEYS: Array[String] = [
	"minimum_endings_unlocked",
	"minimum_medals",
	"required_ending_ids",
	"minimum_total_runs",
]


func _ready() -> void:
	pass


func process_run_end(summary: RunSummary, state: RunState, content: ContentRepository) -> Dictionary:
	var ending_id: String = summary.ending_id
	var final_day: int = summary.final_day

	var ending_result := record_ending_reached(ending_id, final_day)
	var is_new: bool = bool(ending_result.get("is_new", false))

	var rewards: Dictionary = calculate_run_rewards(state, content, ending_id, is_new)
	var earned: int = int(rewards.get("total", 0))

	SaveManager.set_total_runs_completed(SaveManager.get_total_runs_completed() + 1)
	SaveManager.set_medals(SaveManager.get_medals() + earned)

	summary.medals_earned = earned
	summary.medals_total_after = SaveManager.get_medals()
	summary.is_new_ending = is_new
	summary.reward_breakdown = rewards.get("breakdown", {})
	summary.completed_arc_bonuses = rewards.get("completed_arc_bonuses", [])

	SaveManager.set_last_run_summary({
		"ending_id": summary.ending_id,
		"final_day": summary.final_day,
		"final_resources": summary.final_resources,
		"laws_count": summary.active_laws.size(),
		"random_seed": summary.random_seed,
		"medals_earned": summary.medals_earned,
		"medals_total_after": summary.medals_total_after,
		"is_new_ending": summary.is_new_ending,
		"reward_breakdown": summary.reward_breakdown,
	})

	SaveManager.merge_introduced_onboarding_concepts(state.get_introduced_concepts())

	EventBus.meta_progression_updated.emit()
	return rewards


func calculate_run_rewards(
	state: RunState,
	content: ContentRepository,
	ending_id: String,
	is_new_ending: bool,
) -> Dictionary:
	var config: Dictionary = content.get_meta_rewards()
	var divisor: int = maxi(1, int(config.get("days_survived_divisor", 3)))
	var base: int = int(floor(float(state.day) / float(divisor)))
	var new_ending_bonus: int = int(config.get("new_ending_bonus", 5)) if is_new_ending else 0

	var major_bonus: int = 0
	var minor_bonus: int = 0
	var arc_bonuses: Array[Dictionary] = []
	var major_rate: int = int(config.get("completed_major_arc_bonus", 3))
	var minor_rate: int = int(config.get("completed_minor_arc_bonus", 1))

	for arc_id in state.completed_arc_ids:
		var arc: Dictionary = content.get_arc(arc_id)
		var importance: String = str(arc.get("importance", "major"))
		var display_name: String = str(arc.get("display_name", arc_id))
		if importance == "minor":
			minor_bonus += minor_rate
			arc_bonuses.append({"arc_id": arc_id, "display_name": display_name, "importance": "minor", "bonus": minor_rate})
		else:
			major_bonus += major_rate
			arc_bonuses.append({"arc_id": arc_id, "display_name": display_name, "importance": "major", "bonus": major_rate})

	var total: int = base + new_ending_bonus + major_bonus + minor_bonus
	return {
		"total": total,
		"breakdown": {
			"base": base,
			"new_ending": new_ending_bonus,
			"major_arcs": major_bonus,
			"minor_arcs": minor_bonus,
		},
		"completed_arc_bonuses": arc_bonuses,
	}


func record_ending_reached(ending_id: String, final_day: int) -> Dictionary:
	if ending_id.is_empty():
		return {"is_new": false, "record": {}}

	var records: Dictionary = SaveManager.get_ending_records()
	var is_new: bool = not records.has(ending_id)
	var now: int = int(Time.get_unix_time_from_system())

	if is_new:
		records[ending_id] = {
			"ending_id": ending_id,
			"unlocked": true,
			"first_unlocked_at": now,
			"times_reached": 1,
			"best_day": maxi(0, final_day),
		}
	else:
		var record: Dictionary = records[ending_id].duplicate(true)
		record["times_reached"] = int(record.get("times_reached", 0)) + 1
		record["best_day"] = maxi(int(record.get("best_day", 0)), maxi(0, final_day))
		records[ending_id] = record

	SaveManager.set_ending_records(records)
	EventBus.meta_progression_updated.emit()
	return {"is_new": is_new, "record": records[ending_id].duplicate(true)}


func get_medals() -> int:
	return SaveManager.get_medals()


func add_medals(delta: int) -> void:
	SaveManager.set_medals(SaveManager.get_medals() + delta)
	EventBus.meta_progression_updated.emit()


func spend_medals(cost: int) -> bool:
	if cost < 0 or SaveManager.get_medals() < cost:
		return false
	SaveManager.set_medals(SaveManager.get_medals() - cost)
	EventBus.meta_progression_updated.emit()
	return true


func get_ending_record(ending_id: String) -> Dictionary:
	var records: Dictionary = SaveManager.get_ending_records()
	return records.get(ending_id, {}).duplicate(true)


func get_all_ending_records() -> Dictionary:
	return SaveManager.get_ending_records().duplicate(true)


func get_unlocked_ending_ids() -> Array:
	return SaveManager.get_unlocked_endings()


func get_total_runs_completed() -> int:
	return SaveManager.get_total_runs_completed()


func is_upgrade_purchased(upgrade_id: String) -> bool:
	var upgrades: Dictionary = SaveManager.get_palace_upgrades()
	var entry: Dictionary = upgrades.get(upgrade_id, {})
	return bool(entry.get("purchased", false))


func get_purchased_upgrades() -> Dictionary:
	return SaveManager.get_palace_upgrades().duplicate(true)


func can_purchase_upgrade(upgrade_id: String, content: ContentRepository) -> bool:
	if is_upgrade_purchased(upgrade_id):
		return false
	var upgrade: Dictionary = content.get_palace_upgrade(upgrade_id)
	if upgrade.is_empty():
		return false
	var cost: int = int(upgrade.get("medal_cost", 0))
	if SaveManager.get_medals() < cost:
		return false
	return _meets_meta_requirements(upgrade.get("requirements", {}))


func purchase_upgrade(upgrade_id: String, content: ContentRepository) -> bool:
	if not can_purchase_upgrade(upgrade_id, content):
		return false
	var upgrade: Dictionary = content.get_palace_upgrade(upgrade_id)
	var cost: int = int(upgrade.get("medal_cost", 0))
	if not spend_medals(cost):
		return false
	var upgrades: Dictionary = SaveManager.get_palace_upgrades()
	upgrades[upgrade_id] = {
		"purchased": true,
		"purchased_at": int(Time.get_unix_time_from_system()),
	}
	SaveManager.set_palace_upgrades(upgrades)
	EventBus.meta_progression_updated.emit()
	return true


func clear_upgrade(upgrade_id: String) -> void:
	var upgrades: Dictionary = SaveManager.get_palace_upgrades()
	if upgrades.erase(upgrade_id):
		SaveManager.set_palace_upgrades(upgrades)
		EventBus.meta_progression_updated.emit()


func reset_meta_progression() -> void:
	SaveManager.reset_meta_progression()
	EventBus.meta_progression_updated.emit()


func get_save_version() -> int:
	return SaveManager.get_save_version()


func get_upgrade_status(upgrade_id: String, content: ContentRepository) -> String:
	if is_upgrade_purchased(upgrade_id):
		return "purchased"
	if can_purchase_upgrade(upgrade_id, content):
		return "available"
	return "locked"


func format_requirements_hint(requirements: Dictionary) -> String:
	if requirements.is_empty():
		return "No requirements"
	var parts: PackedStringArray = []
	if requirements.has("minimum_endings_unlocked"):
		parts.append("%d ending(s) unlocked" % int(requirements["minimum_endings_unlocked"]))
	if requirements.has("minimum_total_runs"):
		parts.append("%d run(s) completed" % int(requirements["minimum_total_runs"]))
	if requirements.has("minimum_medals"):
		parts.append("%d medal(s) owned" % int(requirements["minimum_medals"]))
	var required_endings: Variant = requirements.get("required_ending_ids", [])
	if required_endings is Array and not required_endings.is_empty():
		parts.append("endings: %s" % ", ".join(required_endings))
	return ", ".join(parts) if not parts.is_empty() else "Requirements unmet"


func _meets_meta_requirements(requirements: Variant) -> bool:
	if not requirements is Dictionary or requirements.is_empty():
		return true
	if requirements.has("minimum_endings_unlocked"):
		if get_unlocked_ending_ids().size() < int(requirements["minimum_endings_unlocked"]):
			return false
	if requirements.has("minimum_medals"):
		if SaveManager.get_medals() < int(requirements["minimum_medals"]):
			return false
	if requirements.has("minimum_total_runs"):
		if SaveManager.get_total_runs_completed() < int(requirements["minimum_total_runs"]):
			return false
	var required_endings: Variant = requirements.get("required_ending_ids", [])
	if required_endings is Array:
		for ending_id in required_endings:
			if not SaveManager.is_ending_unlocked(str(ending_id)):
				return false
	return true
