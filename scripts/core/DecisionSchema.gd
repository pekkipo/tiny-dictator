class_name DecisionSchema
extends RefCounted

## Single normalization point for decision content (Phase 2A PRD §12).
## Legacy (schema v1) decisions use fixed "left"/"right" objects; schema v2
## uses an "options" array. Everything downstream (engine, resolver, UI,
## validator) reads only the normalized "options" model produced here.

const LEGACY_VERSION: int = 1
const CURRENT_VERSION: int = 2

const DEFAULT_CARD_TYPE: String = "normal"

## Placeholder card types per PRD 2A §13. Later milestones give these
## real behavior; for now they only affect the card banner.
const CARD_TYPES: Array[String] = [
	"normal", "crisis", "advisor", "consequence",
	"resolution", "recovery", "ending_setup",
]

const MIN_OPTIONS: int = 2
const MAX_OPTIONS: int = 3

## Maps legacy choose_left()/choose_right() inputs onto option indices when
## a v2 card has no option literally named "left"/"right".
const LEGACY_ALIASES: Dictionary = {"left": 0, "right": 1}


## Normalizes a decision in place (idempotent, safe to call repeatedly):
## - fills in schema_version (1 for legacy, 2 when "options" is authored),
## - fills in card_type ("normal"),
## - maps v2 "base_weight" onto the "weight" field the engine reads,
## - builds "options" from legacy "left"/"right" with ids "left"/"right".
## Legacy "left"/"right" keys are kept untouched for compatibility.
static func normalize(decision: Dictionary) -> Dictionary:
	var authored_v2: bool = decision.get("options") is Array
	if not decision.has("schema_version"):
		decision["schema_version"] = CURRENT_VERSION if authored_v2 else LEGACY_VERSION
	if not decision.has("card_type"):
		decision["card_type"] = DEFAULT_CARD_TYPE
	if decision.has("base_weight") and not decision.has("weight"):
		decision["weight"] = int(decision["base_weight"])
	if not authored_v2:
		var options: Array = []
		for side in ["left", "right"]:
			var option: Variant = decision.get(side)
			if option is Dictionary:
				var normalized: Dictionary = option.duplicate(true)
				normalized["id"] = side
				options.append(normalized)
		decision["options"] = options
	if decision.has("pacing") and decision["pacing"] is Dictionary:
		var pacing: Dictionary = decision["pacing"].duplicate(true)
		if pacing.has("allowed_stages") and pacing["allowed_stages"] is Array:
			var allowed_stages: Array[String] = []
			for stage_id in pacing["allowed_stages"]:
				if stage_id is String:
					allowed_stages.append(stage_id)
			pacing["allowed_stages"] = allowed_stages
		decision["pacing"] = pacing
	return decision


static func get_options(decision: Dictionary) -> Array:
	normalize(decision)
	return decision.get("options", [])


## Finds an option by id. Legacy ids "left"/"right" fall back to positional
## aliases (first/second option) so choose_left()/choose_right() keep
## working against v2 cards with authored option ids.
static func get_option(decision: Dictionary, option_id: String) -> Dictionary:
	var options: Array = get_options(decision)
	for option in options:
		if option is Dictionary and str(option.get("id", "")) == option_id:
			return option
	var alias_index: int = int(LEGACY_ALIASES.get(option_id, -1))
	if alias_index >= 0 and alias_index < options.size() and options[alias_index] is Dictionary:
		return options[alias_index]
	return {}
