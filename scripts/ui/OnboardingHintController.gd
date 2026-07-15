class_name OnboardingHintController
extends RefCounted

## Shows one-line first-run hints when new onboarding concepts appear.

var _shown_hints: Array[String] = []


func reset() -> void:
	_shown_hints.clear()


func consume_hint_for_decision(
	decision: Dictionary,
	state: RunState,
	content: ContentRepository,
	result: DecisionResult = null,
) -> Dictionary:
	var registry: RefCounted = content.get_onboarding_registry()
	var candidates: Array[String] = []

	for concept_id in decision.get("teaches_concepts", []):
		var id: String = str(concept_id)
		if not id.is_empty() and id not in state.get_introduced_concepts():
			candidates.append(id)

	if result != null:
		if not result.added_laws.is_empty() and "laws" not in candidates:
			candidates.append("laws")
		if not result.advisor_affinity_changes.is_empty() and "affinity_feedback" not in candidates:
			candidates.append("affinity_feedback")
		if not result.ruler_trait_changes.is_empty() and "ruler_traits" not in candidates:
			candidates.append("ruler_traits")
		if str(decision.get("card_type", "")) == "crisis" and "crises" not in candidates:
			candidates.append("crises")

	if state.day <= 1 and "resources" not in state.get_introduced_concepts():
		candidates.insert(0, "resources")

	for concept_id in candidates:
		if concept_id in _shown_hints:
			continue
		var hint: String = registry.get_hint_text(concept_id)
		if hint.is_empty():
			continue
		_shown_hints.append(concept_id)
		return {"concept_id": concept_id, "text": hint}
	return {}


func consume_endings_hint(total_runs_completed: int) -> Dictionary:
	if total_runs_completed > 0:
		return {}
	if "endings_replay" in _shown_hints:
		return {}
	var hint := "Every run can end differently. Restart to discover more endings and fill your collection."
	_shown_hints.append("endings_replay")
	return {"concept_id": "endings_replay", "text": hint}
