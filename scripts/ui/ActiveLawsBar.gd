extends Control

@onready var laws_container: HBoxContainer = %LawsContainer

func update_laws(law_ids: Array[String]) -> void:
	for child in laws_container.get_children():
		child.queue_free()
	for law_id in law_ids:
		var label := Label.new()
		label.text = law_id
		laws_container.add_child(label)
