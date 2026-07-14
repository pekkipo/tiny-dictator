extends Control

@onready var resource_bar: Control = %ResourceBar
@onready var active_laws_bar: Control = %ActiveLawsBar
@onready var country_diorama: Control = %CountryDiorama
@onready var decision_card: Control = %DecisionCard
@onready var advisor_portrait: Control = %AdvisorPortrait

func _ready() -> void:
	EventBus.decision_presented.connect(_on_decision_presented)
	EventBus.resources_changed.connect(_on_resources_changed)
	decision_card.choice_selected.connect(_on_choice_selected)
	_refresh_from_state()

func _refresh_from_state() -> void:
	var state := GameManager.state
	resource_bar.update_resources(state.resources)
	active_laws_bar.update_laws(state.active_laws)
	country_diorama.update_state(state)

func _on_decision_presented(decision: DecisionData) -> void:
	decision_card.show_decision(decision)
	_update_advisor(decision.advisor_id)

func _update_advisor(advisor_id: String) -> void:
	var name_label: Label = advisor_portrait.get_node("%NameLabel")
	var title_label: Label = advisor_portrait.get_node("%TitleLabel")
	name_label.text = advisor_id.capitalize()
	title_label.text = "Advisor"

func _on_resources_changed(resources: Dictionary) -> void:
	resource_bar.update_resources(resources)
	country_diorama.update_state(GameManager.state)

func _on_choice_selected(decision_id: String, choice_id: String) -> void:
	GameManager.resolve_choice(decision_id, choice_id)
