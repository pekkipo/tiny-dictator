extends VBoxContainer

## One resource readout: icon + value, with optional delta feedback.
## Color communicates danger but the number is always visible (PRD 02 §8).

const COLOR_POSITIVE: Color = Color(0.65, 0.9, 0.65)
const COLOR_WARNING: Color = Color(0.95, 0.88, 0.6)
const COLOR_DANGER: Color = Color(0.98, 0.55, 0.45)
const COLOR_COLLAPSED: Color = Color(1.0, 0.25, 0.2)
const COLOR_DELTA_UP: Color = Color(0.45, 0.85, 0.45)
const COLOR_DELTA_DOWN: Color = Color(0.95, 0.4, 0.35)


func set_display(icon: String, value: int) -> void:
	%ValueLabel.text = "%s %d" % [icon, value]
	%ValueLabel.add_theme_color_override("font_color", _value_color(value))


func show_delta(delta: int) -> void:
	if delta == 0:
		clear_delta()
		return
	%DeltaLabel.text = "%+d" % delta
	%DeltaLabel.add_theme_color_override("font_color", COLOR_DELTA_UP if delta > 0 else COLOR_DELTA_DOWN)
	%DeltaLabel.visible = true


func clear_delta() -> void:
	%DeltaLabel.visible = false


func _value_color(value: int) -> Color:
	if value <= 0:
		return COLOR_COLLAPSED
	if value <= 30:
		return COLOR_DANGER
	if value <= 60:
		return COLOR_WARNING
	return COLOR_POSITIVE
