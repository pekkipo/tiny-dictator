extends HBoxContainer

## Displays the four resources with delta feedback (PRD 02 §8).

const RESOURCE_ICONS: Dictionary = {
	"treasury": "💰",
	"happiness": "🙂",
	"order": "🛡",
	"elite_loyalty": "👑",
}

@onready var _items: Dictionary = {
	"treasury": %TreasuryItem,
	"happiness": %HappinessItem,
	"order": %OrderItem,
	"elite_loyalty": %EliteItem,
}


func update_resources(resources: Dictionary) -> void:
	for resource_id in _items:
		var item: Control = _items[resource_id]
		item.set_display(RESOURCE_ICONS[resource_id], int(resources.get(resource_id, 0)))
		item.clear_delta()


## Shows the actual applied deltas next to values; values must be updated first.
func show_deltas(changes: Dictionary) -> void:
	for resource_id in _items:
		_items[resource_id].show_delta(int(changes.get(resource_id, 0)))
