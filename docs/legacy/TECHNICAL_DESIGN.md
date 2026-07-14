# Tiny Dictator — Technical Design

## Engine
Godot 4, GDScript, portrait 2D mobile layout.

## Main systems
- GameManager: high-level game flow
- RunState: current run state
- DecisionEngine: loads and filters decision JSON
- ResourceManager: applies effects and checks failure
- CountryDiorama: updates visuals based on laws/resources/flags
- SaveManager: saves unlocked endings and meta progression

## Data-driven content
Decision cards live in JSON files.

Each decision can define:
- id
- advisor_id
- text
- left choice
- right choice
- visible effects
- hidden effects
- added laws
- added flags
- required flags
- blocked flags
- follow-up events
- weight