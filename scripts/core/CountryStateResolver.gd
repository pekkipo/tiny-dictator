class_name CountryStateResolver
extends RefCounted

## Derives a CountryVisualState from RunState resources and active laws.
## Pure logic: never touches UI nodes (PRD 04 §10).
## Thresholds match the ResourceItem danger coloring (PRD 02 §8):
## >60 healthy, 31-60 middling, <=30 bad.

const HIGH_THRESHOLD: int = 60
const LOW_THRESHOLD: int = 30

const SUMMARY_WORDS: Dictionary = {
	"prosperous": "Prosperous", "normal": "Getting by", "poor": "Poor",
	"celebrating": "celebrating", "calm": "calm", "protesting": "protesting",
	"stable": "stable", "tense": "tense", "chaotic": "chaotic",
	"supportive": "elite supportive", "watching": "elite watching", "coup_risk": "elite plotting",
}


func resolve(state: RunState, repository: ContentRepository) -> CountryVisualState:
	var visual := CountryVisualState.new()
	visual.prosperity = _tier(state.treasury, "prosperous", "normal", "poor")
	visual.public_mood = _tier(state.happiness, "celebrating", "calm", "protesting")
	visual.stability = _tier(state.order, "stable", "tense", "chaotic")
	visual.elite_status = _tier(state.elite_loyalty, "supportive", "watching", "coup_risk")

	for law_id in state.active_laws:
		for tag in repository.get_law(law_id).get("visual_tags", []):
			var tag_id := str(tag)
			if tag_id not in visual.visual_tags:
				visual.visual_tags.append(tag_id)

	visual.summary_text = "%s, %s, %s, %s" % [
		SUMMARY_WORDS[visual.prosperity],
		SUMMARY_WORDS[visual.public_mood],
		SUMMARY_WORDS[visual.stability],
		SUMMARY_WORDS[visual.elite_status],
	]
	return visual


func _tier(value: int, high: String, mid: String, low: String) -> String:
	if value > HIGH_THRESHOLD:
		return high
	if value > LOW_THRESHOLD:
		return mid
	return low
