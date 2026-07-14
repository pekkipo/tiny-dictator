extends Control

@onready var mood_label: Label = %MoodLabel

func update_state(state: RunState) -> void:
	var approval: int = state.resources.get("approval", 50)
	if approval >= 70:
		mood_label.text = "The streets are calm."
	elif approval >= 40:
		mood_label.text = "Uneasy whispers in the market."
	else:
		mood_label.text = "Smoke on the horizon."
