extends Control

@onready var money_label: Label = %MoneyLabel
@onready var approval_label: Label = %ApprovalLabel
@onready var military_label: Label = %MilitaryLabel
@onready var corruption_label: Label = %CorruptionLabel

func update_resources(resources: Dictionary) -> void:
	money_label.text = "Money: %d" % resources.get("money", 0)
	approval_label.text = "Approval: %d" % resources.get("approval", 0)
	military_label.text = "Military: %d" % resources.get("military", 0)
	corruption_label.text = "Corruption: %d" % resources.get("corruption", 0)
