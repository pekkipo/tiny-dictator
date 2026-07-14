# Tiny Dictator — Phase 1 Master PRD

**Document status:** Ready for implementation  
**Phase:** 1 — Basic playable prototype  
**Primary platform during development:** Desktop run inside Godot editor  
**Target game platforms:** Android, iOS, optional web  
**Engine:** Godot 4.x  
**Language:** GDScript  
**Primary IDE:** Cursor  
**Art policy for this phase:** Placeholders only  
**Product owner:** Aleksei Petukhov  

---

## 1. Purpose of this document set

This document is the top-level product specification for Phase 1 of **Tiny Dictator**.

Phase 1 is not intended to be a commercially complete game. It must prove that the core product is understandable, technically stable, expandable, and potentially fun before significant effort is spent on final writing, graphics, animation, monetization, audio, or content volume.

Phase 1 should answer five questions:

1. Can the player understand the game without explanation?
2. Is choosing between absurd political decisions satisfying?
3. Do the consequences feel connected to the player’s choice?
4. Does the player understand why a run ended?
5. Is the architecture clean enough to support hundreds of future scenarios without rewriting the prototype?

The prototype must be deliberately small but structurally representative of the full game.

---

## 2. Game concept

**Tiny Dictator** is a portrait-oriented casual strategy-comedy game in which the player rules a tiny fictional country.

Each turn, an advisor presents a proposal, crisis, or absurd problem. The player chooses one of two responses. That choice changes national resources, may add a law or flag, may unlock follow-up events, and may alter the visible condition of the country.

The player attempts to remain in power for as many days as possible while balancing four resources:

- Treasury
- Happiness
- Order
- Elite Loyalty

A run ends when a failure condition is reached or when a special ending is triggered.

The player should feel:

> “I made a ridiculous decision, the country visibly reacted, and now I want to see what happens next.”

---

## 3. Product principles

All implementation and design decisions in Phase 1 must follow these principles.

### 3.1 Fast comprehension

A new player should understand the interaction within ten seconds:

- Read proposal
- Compare two choices
- Choose
- See consequence
- Continue

### 3.2 Every choice produces visible feedback

A choice must not only change hidden numbers. The prototype must show at least one of the following:

- Resource value changes
- Active law added
- Country condition label changes
- Follow-up event becomes possible
- End condition is triggered
- Advisor response changes

### 3.3 Data-driven content

Decision text, choices, effects, laws, conditions, and endings must live outside UI code.

Adding a new decision should normally require editing a JSON file, not editing GDScript.

### 3.4 Small scenes and narrow script responsibilities

UI presentation, game state, content selection, resource application, and run flow must be separate responsibilities.

### 3.5 Placeholder-first development

Phase 1 must not depend on final visual assets. All screens must remain functional using:

- ColorRect
- PanelContainer
- Label
- Button
- TextureRect with temporary images
- Emojis or simple icon placeholders where appropriate

### 3.6 No premature production systems

The prototype must not include:

- Advertising SDKs
- In-app purchases
- User accounts
- Cloud sync
- Notifications
- Live operations
- Battle passes
- Real analytics SDKs
- Localization infrastructure beyond basic string readiness
- Complex procedural simulation
- Final animation systems

---

## 4. Phase structure

The current product roadmap is:

### Phase 1 — Basic playable prototype

Build the complete core loop with placeholders.

Includes:

- Main menu
- Start run
- Main game UI
- Four resources
- A small set of advisors
- A small set of decisions
- Laws and flags
- Conditional follow-ups
- Basic country condition visualization
- Run ending
- Restart flow
- Debug tools
- Local save for minimal meta state if time allows

### Phase 2 — Full experience content

Expand the game with:

- Real character writing
- Larger scenario library
- Long event chains
- Distinct countries
- More endings
- Crises
- Narrative arcs
- Meta progression
- Collections
- Balance passes
- Replay systems
- Real onboarding copy

### Phase 3 — Graphics and polish

Replace placeholders with:

- Final UI
- Advisor portraits
- Country diorama artwork
- Animations
- Sound effects
- Music
- Haptics
- Transitions
- Platform-specific polish
- Performance optimization
- Store-ready visual presentation

---

## 5. Phase 1 goals

### Goal A — Prove the gameplay loop

The player must be able to:

1. Open the game
2. Start a run
3. Receive a decision
4. Choose an option
5. See resource changes
6. See an active law or flag appear
7. Receive a conditional follow-up
8. Reach an ending
9. Restart

### Goal B — Prove content scalability

The system must support, through data:

- Normal decisions
- Decisions with prerequisites
- Decisions blocked by flags
- One-time decisions
- Reusable generic decisions
- Decisions that add laws
- Decisions that add hidden flags
- Decisions that add delayed effects
- Weighted random selection
- Forced follow-ups
- Ending conditions

### Goal C — Prove visual responsiveness

The country area must display simplified states such as:

- Prosperous
- Normal
- Poor
- Happy
- Protesting
- Stable
- Chaotic
- Elite supportive
- Coup risk

These can initially be represented by labels, colors, emojis, and a few placeholder layers.

### Goal D — Prove implementation quality

The project must:

- Run without blocking errors
- Avoid duplicated content logic in UI scripts
- Avoid hardcoded decisions in scenes
- Be understandable to Cursor in future sessions
- Have written acceptance criteria
- Include debug controls for fast testing

---

## 6. Phase 1 success criteria

Phase 1 is complete only when all mandatory criteria are met.

### Mandatory functional criteria

- A player can complete at least one full run.
- The run contains at least 15 decisions before content exhaustion under normal conditions.
- At least 3 decisions are conditional follow-ups.
- At least 4 laws can become active.
- At least 4 failure endings exist.
- At least 1 non-failure special ending exists.
- All four resources update correctly.
- Resource values are clamped to the configured range.
- A run ends immediately when an ending condition is met.
- Restarting creates a clean new run.
- Previously used one-time decisions do not repeat within the same run.
- Invalid decisions do not appear.
- Missing optional placeholder images do not crash the game.

### Mandatory UX criteria

- Current day is visible.
- All four resources are visible at all times during a decision.
- Advisor name and proposal are readable.
- Two choices are clearly distinct.
- The player receives immediate feedback after choosing.
- The ending screen clearly explains what happened.
- A restart button is visible and functional.

### Mandatory architecture criteria

- Decision content is stored in JSON.
- Laws are stored in JSON.
- Advisors are stored in JSON.
- Endings are stored in JSON.
- Run state is not stored in UI nodes.
- Decision selection is handled outside the main UI script.
- Resource mutation is handled outside the main UI script.
- No system relies on final art assets.

---

## 7. Target prototype content volume

The minimum Phase 1 content set is:

- 1 country: Ministan
- 4 advisors
- 24 standard decisions
- 6 conditional follow-up decisions
- 6 laws
- 6 hidden flags
- 5 endings
- 4 resource collapse endings
- 1 special ending
- 5 country visual states
- 1 start screen
- 1 main game screen
- 1 ending screen
- 1 optional debug overlay

Recommended target if implementation remains stable:

- 40 total decisions
- 8 laws
- 8 endings
- 2 special ending chains

---

## 8. Core user flow

```text
Launch game
  ↓
Start Screen
  ↓
Tap "Start New Rule"
  ↓
Initialize RunState
  ↓
Select valid decision
  ↓
Display advisor + proposal + two options
  ↓
Player selects option
  ↓
Apply resource effects
  ↓
Apply laws, flags, counters, delayed effects
  ↓
Show consequence feedback
  ↓
Check ending conditions
  ├── Ending reached → Run End Screen
  └── No ending → Increment day → Select next decision
```

---

## 9. Main game systems

Phase 1 contains the following systems.

### 9.1 Run State

Stores all mutable state for the current run.

### 9.2 Decision Engine

Loads and validates decision data, filters available decisions, and selects the next one.

### 9.3 Effect Resolver

Applies resource and state changes from a selected option.

### 9.4 Ending Resolver

Checks failure and special ending conditions.

### 9.5 Country Visual State

Maps current resources, laws, and flags to placeholder visual changes.

### 9.6 UI Controller

Displays current state and forwards player actions to gameplay systems.

### 9.7 Save Manager

Optional in early Phase 1; mandatory by the end if the prototype tracks unlocked endings or settings.

### 9.8 Debug Controller

Allows fast testing of decisions and endings.

---

## 10. Resource model

All resources use a range from `0` to `100`.

Default starting values:

```json
{
  "treasury": 55,
  "happiness": 55,
  "order": 55,
  "elite_loyalty": 55
}
```

A normal decision effect should usually be between `-15` and `+15`.

Effects larger than 20 should be rare and reserved for major events.

### Treasury

Represents money, tax income, public spending capacity, and economic stability.

At 0: bankruptcy ending.

### Happiness

Represents public approval and general public mood.

At 0: revolution ending.

### Order

Represents institutional stability, security, and basic control.

At 0: national chaos ending.

### Elite Loyalty

Represents support from ministers, generals, oligarchs, and institutions.

At 0: coup ending.

### Upper-bound behavior

In Phase 1, reaching 100 does not automatically end a run. Values are clamped.

Extreme positive endings may be added in Phase 2.

---

## 11. Advisor roster for Phase 1

### General Boom

Role: Military advisor  
Tone: Overconfident, aggressive, simple solutions  
Typical effects: Order up, Treasury down, Happiness down, Elite Loyalty up

### Minister Penny

Role: Treasury advisor  
Tone: Obsessed with savings and taxes  
Typical effects: Treasury up, Happiness down, Order variable

### Luna News

Role: Media advisor  
Tone: Turns every failure into a success narrative  
Typical effects: Happiness or Order up, hidden future cost

### Auntie Olga

Role: Citizen representative  
Tone: Practical, sarcastic, suspicious of government nonsense  
Typical effects: Happiness up, Treasury down, Elite Loyalty down

Phase 1 does not require full character arcs, voice acting, or final portraits.

---

## 12. Decision categories

Every decision should belong to one category for future analysis and balancing:

- Economy
- Public Life
- Military
- Media
- Infrastructure
- Absurd Law
- Crisis
- Follow-up
- Ending Setup

Categories are data tags, not separate gameplay modes in Phase 1.

---

## 13. Law model

A law is a persistent named state visible to the player.

Examples:

- Free Pizza Friday
- Mandatory Smiling
- Window Tax
- Cat Voting Rights
- No Weekends
- Tank-Based Traffic Control

A law may:

- Be displayed in the active laws bar
- Affect future decision eligibility
- Alter country visualization
- Contribute to a special ending
- Modify later effects in Phase 2

For Phase 1, laws do not need automatic recurring stat effects unless explicitly implemented as a delayed effect.

---

## 14. Hidden flags

Flags are internal state markers.

Examples:

- `traffic_lights_off`
- `pizza_policy_active`
- `mandatory_smiling_active`
- `cats_enfranchised`
- `military_controls_traffic`
- `media_blames_foreigners`

Flags are not necessarily shown to the player.

They are used for:

- Follow-up eligibility
- Blocking contradictory cards
- Special ending conditions
- Country state visualization

---

## 15. Prototype narrative philosophy

Phase 1 writing should be functional rather than perfect.

Each proposal must be:

- Understandable in one short paragraph
- Clearly attributable to an advisor
- Absurd but logically connected
- Suitable for a two-choice decision
- Capable of producing a visible consequence

Avoid:

- Long lore
- Real-world political references
- Complex ethical themes
- Multi-paragraph explanations
- Humor that requires cultural knowledge
- Real people, countries, parties, or wars

---

## 16. Main screens

### 16.1 Start Screen

Must include:

- Game title
- Short subtitle
- Start button
- Optional debug build label
- Optional “Continue” disabled or hidden in Phase 1

### 16.2 Game Screen

Must include:

- Day
- Four resources
- Country visualization area
- Advisor identity
- Proposal text
- Two choice buttons
- Active laws list
- Short feedback region

### 16.3 Run End Screen

Must include:

- Newspaper-style heading
- Ending title
- Ending description
- Final day
- Final resources
- Active laws count
- Restart button
- Main menu button optional

### 16.4 Debug Overlay

Recommended controls:

- Force next decision by ID
- Set resource values
- Add law
- Add flag
- Trigger ending
- Reset run
- Print current state
- Toggle deterministic random seed

---

## 17. Non-goals

The following are explicitly out of scope for Phase 1:

- Final art
- Commercial monetization
- Platform store integration
- Achievements
- Push notifications
- Localization UI
- Complex city building
- Physics gameplay
- Multiplayer
- Social sharing
- Cloud save
- Daily events
- Procedural text generation at runtime
- LLM integration
- User-generated decisions
- Live content delivery
- Server backend
- Anti-cheat
- Accessibility certification
- Full controller support
- Final audio

---

## 18. Risks and mitigations

### Risk: Cursor creates inconsistent architecture

Mitigation:

- Keep PRDs in `/docs`
- Keep project rules enabled
- Implement one milestone at a time
- Require Cursor to list changed files after each task
- Commit after every stable milestone

### Risk: JSON becomes too flexible and difficult to validate

Mitigation:

- Define one explicit schema
- Add startup validation
- Log malformed content clearly
- Skip invalid optional entries instead of crashing
- Treat missing required fields as development errors

### Risk: Game feels like random stat changes

Mitigation:

- Use follow-up cards
- Show active laws
- Show immediate feedback
- Change country placeholder state
- Reference prior choices in later cards

### Risk: Player cannot understand why a run ended

Mitigation:

- End immediately on failure
- Highlight collapsed resource
- Explain the cause in ending text
- Show final state summary

### Risk: Prototype becomes visually overbuilt too early

Mitigation:

- Use rectangles, labels, and emojis
- Do not generate final art until the core loop is complete
- Keep visual state interface independent from final assets

---

## 19. Implementation order

The recommended Phase 1 sequence is:

1. Project structure and autoloads
2. RunState
3. Data loader and schema validation
4. Decision Engine
5. Effect Resolver
6. Main Game Screen with placeholder UI
7. Run progression
8. Ending Resolver
9. Run End Screen
10. Active laws
11. Conditional decisions
12. Country placeholder state visualization
13. Debug overlay
14. Save unlocked endings
15. QA and balancing

Do not implement later systems before the core loop is stable.

---

## 20. Definition of done

Phase 1 is done when:

- The user can play from start to ending without developer intervention.
- The game survives repeated restarts.
- The game contains enough content to demonstrate conditional chains.
- The codebase can accept new decisions through JSON.
- The prototype can be demonstrated in under three minutes.
- All mandatory acceptance tests in `05_QA_ACCEPTANCE_AND_DELIVERY_PLAN.md` pass.
- The project has a clean Git commit tagged or named `phase-1-prototype`.
