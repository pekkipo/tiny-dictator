extends PanelContainer

## Renders a CountryVisualState with emoji/color placeholders (PRD 02 §9).
## Pure presentation: never derives gameplay rules itself (PRD 04 §11).

const SKY_COLORS: Dictionary = {
	"celebrating": Color(0.55, 0.8, 0.95),
	"calm": Color(0.62, 0.72, 0.85),
	"protesting": Color(0.52, 0.53, 0.6),
}

const GROUND_COLORS: Dictionary = {
	"prosperous": Color(0.48, 0.7, 0.42),
	"normal": Color(0.62, 0.65, 0.42),
	"poor": Color(0.56, 0.48, 0.36),
}

## Stability is shown as a tint over the whole scene.
const MOOD_OVERLAY_COLORS: Dictionary = {
	"stable": Color(0, 0, 0, 0),
	"tense": Color(0.9, 0.55, 0.1, 0.1),
	"chaotic": Color(0.85, 0.15, 0.1, 0.22),
}

const PALACE_TEXTS: Dictionary = {
	"supportive": "🏛️ 👑",
	"watching": "🏛️ 👀",
	"coup_risk": "🏛️ 🗡️",
}

const HOUSES_TEXTS: Dictionary = {
	"prosperous": "🏘️ ⛲ 🏘️ 🏘️ 🌳",
	"normal": "🏘️ 🏘️ 🏘️ 🌳",
	"poor": "🏚️ 🏚️ 🌵",
}

const CITIZENS_TEXTS: Dictionary = {
	"celebrating": "🎉 😀 😀 🎊 😀",
	"calm": "🙂 🚶 🙂 🙂",
	"protesting": "😠 🪧 😠 🪧 😠",
}


func update_visual_state(visual: CountryVisualState, visual_map: Dictionary) -> void:
	%SkyBackground.color = SKY_COLORS.get(visual.public_mood, SKY_COLORS["calm"])
	%GroundBackground.color = GROUND_COLORS.get(visual.prosperity, GROUND_COLORS["normal"])
	%MoodOverlay.color = MOOD_OVERLAY_COLORS.get(visual.stability, MOOD_OVERLAY_COLORS["stable"])
	%PalacePlaceholder.text = PALACE_TEXTS.get(visual.elite_status, PALACE_TEXTS["supportive"])
	%HousesPlaceholder.text = HOUSES_TEXTS.get(visual.prosperity, HOUSES_TEXTS["normal"])
	%CitizensPlaceholder.text = CITIZENS_TEXTS.get(visual.public_mood, CITIZENS_TEXTS["calm"])
	%StateDescriptionLabel.text = "Country state: %s" % visual.summary_text

	var props: HBoxContainer = %SpecialPropsLayer
	for child in props.get_children():
		child.queue_free()
	for tag in visual.visual_tags:
		# Unknown tags are ignored per PRD 04 §16 (validator already warns).
		if not visual_map.has(tag):
			continue
		var prop := Label.new()
		prop.text = str(visual_map[tag])
		prop.add_theme_font_size_override("font_size", 34)
		props.add_child(prop)
