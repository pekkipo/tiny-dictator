class_name CountryVisualState
extends RefCounted

## Pure visual state derived from RunState by CountryStateResolver.
## Consumed by CountryDiorama; carries no gameplay logic.
## Spec: docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md §10.

var prosperity: String = "normal"       # prosperous | normal | poor
var public_mood: String = "calm"        # celebrating | calm | protesting
var stability: String = "stable"        # stable | tense | chaotic
var elite_status: String = "supportive" # supportive | watching | coup_risk
var visual_tags: Array[String] = []
var summary_text: String = ""
