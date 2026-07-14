# Tiny Dictator — Phase 1 UI/UX and Scene Specification

**Scope:** Screen hierarchy, Godot scene structure, interactions, placeholder presentation, responsive portrait layout  
**Dependency:** `00_PHASE_1_MASTER_PRD.md`, `01_CORE_GAMEPLAY_AND_STATE_PRD.md`

---

## 1. UX objective

The Phase 1 interface must make the core loop understandable without relying on polished graphics.

The player must always know:

- What day it is
- What the current national resources are
- Who is speaking
- What decision is being proposed
- What the two options are
- What changed after making a decision
- Which laws are active
- Why the run ended

The interface must be designed for portrait mobile screens, but the first implementation may be tested in a desktop Godot window.

---

## 2. Target reference resolution

Use:

```text
Width: 1080
Height: 1920
Orientation: Portrait
```

Recommended project configuration:

```text
Display / Window / Size / Viewport Width = 1080
Display / Window / Size / Viewport Height = 1920
Display / Window / Stretch / Mode = canvas_items
Display / Window / Stretch / Aspect = expand
```

All UI must use anchors and containers. Avoid fixed pixel positions unless they are internal margins or controlled component dimensions.

---

## 3. Screen list

Mandatory Phase 1 screens:

1. Boot/Main scene
2. Start Screen
3. Game Screen
4. Run End Screen

Recommended developer-only screen/component:

5. Debug Overlay

Optional:

6. Error Screen for invalid content

---

## 4. Scene architecture

Recommended root structure:

```text
scenes/
  main/
    Main.tscn
  screens/
    StartScreen.tscn
    GameScreen.tscn
    RunEndScreen.tscn
  components/
    ResourceBar.tscn
    ResourceItem.tscn
    CountryDiorama.tscn
    DecisionCard.tscn
    AdvisorHeader.tscn
    ActiveLawsBar.tscn
    ChoiceButton.tscn
    ResultPanel.tscn
    DebugOverlay.tscn
```

Recommended scripts:

```text
scripts/ui/
  Main.gd
  StartScreen.gd
  GameScreen.gd
  RunEndScreen.gd
  ResourceBar.gd
  ResourceItem.gd
  CountryDiorama.gd
  DecisionCard.gd
  ActiveLawsBar.gd
  ResultPanel.gd
  DebugOverlay.gd
```

---

## 5. Main scene

### Purpose

Owns screen switching and persistent overlay layers.

### Recommended node tree

```text
Main (Control)
├── Background (ColorRect)
├── ScreenContainer (Control)
├── TransitionLayer (CanvasLayer)
│   └── FadeRect (ColorRect)
└── DebugLayer (CanvasLayer)
    └── DebugOverlay
```

### Responsibilities

- Show Start Screen on initial launch
- Switch between Start, Game, and Run End screens
- Avoid reloading the whole project between screens
- Receive high-level flow events from GameManager
- Optional fade transition
- Keep debug overlay accessible

### Non-responsibilities

- Must not calculate resource effects
- Must not select decisions
- Must not store current run state

---

## 6. Start Screen specification

### Goal

Let the player begin immediately.

### Required content

- Game title: `TINY DICTATOR`
- Subtitle: `Your country. Their problem.`
- Primary CTA: `START NEW RULE`
- Small version label: `Prototype v0.1`
- Optional short explanation:
  `Approve absurd laws. Balance the country. Stay in power.`

### Recommended node tree

```text
StartScreen (Control)
├── SafeAreaMargin (MarginContainer)
│   └── MainVBox (VBoxContainer)
│       ├── TopSpacer (Control)
│       ├── CrownPlaceholder (Label)
│       ├── TitleLabel (Label)
│       ├── SubtitleLabel (Label)
│       ├── CountryPlaceholder (PanelContainer)
│       │   └── CountryText (Label)
│       ├── ExplanationLabel (Label)
│       ├── StartButton (Button)
│       ├── BottomSpacer (Control)
│       └── VersionLabel (Label)
```

### Interactions

- Start button calls `GameManager.start_new_run()`.
- Button is disabled after click until the Game Screen is displayed.
- Pressing Enter/Space may activate Start during desktop testing.

### Placeholder style

- Warm cream or light beige background
- Dark title
- Red primary CTA
- Simple crown emoji or shape
- Country placeholder may display `🏛️ 🏘️ 🌳`

---

## 7. Game Screen layout

The Game Screen is the primary interface.

### Vertical structure

Recommended screen allocation:

```text
Top resource bar: 12–15%
Country diorama: 28–34%
Advisor + decision card: 34–40%
Active laws + feedback/navigation: 12–18%
```

### Recommended node tree

```text
GameScreen (Control)
├── SafeAreaMargin (MarginContainer)
│   └── MainVBox (VBoxContainer)
│       ├── TopBar (PanelContainer)
│       │   └── TopBarVBox (VBoxContainer)
│       │       ├── DayRow (HBoxContainer)
│       │       │   ├── CountryLabel (Label)
│       │       │   ├── DaySpacer (Control)
│       │       │   └── DayLabel (Label)
│       │       └── ResourceBar
│       ├── CountryDiorama
│       ├── DecisionCard
│       ├── ResultPanel
│       └── ActiveLawsBar
```

`ResultPanel` may be hidden until a decision is selected.

---

## 8. Top Bar

### Content

- Country name: `MINISTAN`
- Day label: `DAY 1`
- Four resource items

### Resource display

Each resource item includes:

- Placeholder icon
- Current numeric value
- Short name or tooltip
- Optional progress bar

Recommended abbreviated presentation:

```text
💰 55   🙂 55   🛡 55   👑 55
```

For readability, use icon plus number in the main row and full names in tooltips/debug.

### Resource color states

Placeholder colors:

- 61–100: positive/neutral
- 31–60: warning-neutral
- 1–30: danger
- 0: collapsed

Do not rely only on color. The number must always be visible.

### Delta feedback

After a decision:

- Changed resources briefly show `+8` or `-10`
- Values update
- Optional small scale animation
- Delta disappears after result confirmation

No complex tween is required, but simple visual emphasis is expected.

---

## 9. Country Diorama placeholder

### Purpose

Represent the country’s current condition without final art.

### Required capabilities

The component accepts a visual state object and displays:

- General prosperity
- Public mood
- Order/stability
- Elite/coup risk
- Active law props

### Recommended placeholder node tree

```text
CountryDiorama (PanelContainer)
└── DioramaRoot (Control)
    ├── SkyBackground (ColorRect)
    ├── GroundBackground (ColorRect)
    ├── PalacePlaceholder (Label)
    ├── HousesPlaceholder (Label)
    ├── CitizensPlaceholder (Label)
    ├── SpecialPropsLayer (HBoxContainer)
    ├── MoodOverlay (ColorRect)
    └── StateDescriptionLabel (Label)
```

### Minimum visual states

#### Prosperity

- `prosperous`
- `normal`
- `poor`

Based primarily on Treasury.

#### Public mood

- `celebrating`
- `calm`
- `protesting`

Based primarily on Happiness.

#### Stability

- `stable`
- `tense`
- `chaotic`

Based primarily on Order.

#### Elite status

- `supportive`
- `watching`
- `coup_risk`

Based primarily on Elite Loyalty.

### Example placeholder output

```text
🏛️  🏠 🏠 🏠
🙂 🙂 🍕 🐱
Country state: Poor, protesting, tense, elite watching
```

### Active law props

Examples:

- Free Pizza Friday → `🍕`
- Mandatory Smiling → `😁`
- Cat Voting Rights → `🐱`
- Tank Traffic Control → `🪖`
- Window Tax → `🪟`

The component should derive props through a law-to-visual mapping file or dictionary.

---

## 10. Decision Card

### Purpose

Present the current advisor, proposal, and two choices.

### Recommended node tree

```text
DecisionCard (PanelContainer)
└── CardMargin (MarginContainer)
    └── CardVBox (VBoxContainer)
        ├── AdvisorRow (HBoxContainer)
        │   ├── AdvisorPortraitPlaceholder (TextureRect or Label)
        │   └── AdvisorTextVBox (VBoxContainer)
        │       ├── AdvisorNameLabel (Label)
        │       └── AdvisorRoleLabel (Label)
        ├── Separator (HSeparator)
        ├── ProposalLabel (Label)
        ├── OptionalKnownEffectsLabel (Label)
        └── ChoicesRow (HBoxContainer)
            ├── LeftChoiceButton
            └── RightChoiceButton
```

### Advisor presentation

Placeholder portrait options:

- Emoji
- Colored circle with initials
- Generic temporary image
- Label such as `GB`, `MP`, `LN`, `AO`

Required:

- Advisor name
- Advisor role
- Proposal text

### Proposal constraints

Prototype UI should support:

- 40–220 characters comfortably
- Automatic line wrapping
- Variable card height within reasonable limits
- No text clipping

If content exceeds the supported length, validation should warn.

---

## 11. Choice buttons

### Required content

Each button must show:

- Choice label
- Optional visible effect summary

Example:

```text
NO FREE LUNCH
Treasury +4
Happiness -8
```

and:

```text
GIVE THEM PIZZA
Treasury -10
Happiness +14
```

### Interaction states

- Normal
- Hover/focus for desktop
- Pressed
- Disabled during resolution
- Selected highlight during result
- Hidden or disabled during ending transition

### Input behavior

- Tap/click selects
- Keyboard shortcut optional:
  - Left Arrow or A = left option
  - Right Arrow or D = right option
- Input must be ignored if run phase is not `AWAITING_DECISION`

### Visible effect policy

Phase 1 should display resource effects exactly as configured unless an effect is marked hidden.

Example:

```json
"visible_effects": ["treasury", "happiness"]
```

If absent, all immediate resource effects are visible.

Hidden effects are not listed before the choice but appear in result feedback.

---

## 12. Result Panel

### Purpose

Allow the player to understand what happened before continuing.

### Recommended node tree

```text
ResultPanel (PanelContainer)
└── ResultMargin (MarginContainer)
    └── ResultVBox (VBoxContainer)
        ├── ResultTextLabel (Label)
        ├── DeltaSummaryLabel (Label)
        ├── NewLawLabel (Label)
        └── ContinueButton (Button)
```

### Behavior

Before choice:

- Hidden

After choice:

- Decision buttons disabled
- Result panel becomes visible
- Shows result text
- Shows actual applied deltas
- Shows law activation message
- Continue button appears

Example:

```text
Citizens celebrate. The Treasury receives a very large cheese invoice.

Treasury -10
Happiness +14
New law: Free Pizza Friday
```

### Continue behavior

When clicked:

- GameManager checks endings
- If ending: transition to Run End Screen
- If no ending: increment day and show next decision
- Result panel hides

This explicit Continue step is mandatory for Phase 1 because it makes debugging and comprehension easier.

---

## 13. Active Laws Bar

### Purpose

Show persistent consequences from previous choices.

### Recommended node tree

```text
ActiveLawsBar (PanelContainer)
└── LawsMargin (MarginContainer)
    └── LawsVBox (VBoxContainer)
        ├── HeaderLabel (Label)
        └── LawsFlow (HFlowContainer)
```

### Display rules

Each law chip shows:

- Placeholder icon
- Short law name or tooltip
- Optional compact layout

Example:

```text
ACTIVE LAWS
🍕 Free Pizza   😁 Mandatory Smiling   🐱 Cat Voting
```

If there are more than five active laws:

- Show first five
- Show `+N more`
- Full inspection is out of scope

When no laws are active:

```text
No laws yet. The country is briefly normal.
```

---

## 14. Run End Screen

### Goal

Clearly communicate the ending and invite immediate replay.

### Recommended node tree

```text
RunEndScreen (Control)
├── Background (ColorRect)
└── SafeAreaMargin (MarginContainer)
    └── NewspaperPanel (PanelContainer)
        └── NewspaperMargin (MarginContainer)
            └── NewspaperVBox (VBoxContainer)
                ├── MastheadLabel (Label)
                ├── DateLabel (Label)
                ├── EndingTitleLabel (Label)
                ├── EndingImagePlaceholder (PanelContainer)
                │   └── EndingIconLabel (Label)
                ├── EndingDescriptionLabel (Label)
                ├── FinalStatsGrid (GridContainer)
                ├── LegacySummaryLabel (Label)
                ├── RestartButton (Button)
                └── MainMenuButton (Button)
```

### Required copy

Masthead:

```text
THE MINISTAN TIMES
```

Required data:

- Ending title
- Ending description
- Final day
- Four final resources
- Number of active laws
- Optional “Most important decision”

### Example

```text
THE MINISTAN TIMES

PEOPLE HAD ENOUGH

After 12 days in power, the Supreme Leader discovered that mandatory smiling did not create actual happiness.

Final Happiness: 0
Active Laws: 4
Legacy: Three pizza reforms, one traffic disaster, no working windows.
```

### Buttons

- `RULE AGAIN` starts a clean run
- `MAIN MENU` returns to Start Screen

---

## 15. Debug Overlay

### Visibility

Developer-only.

Toggle key:

```text
F1 or backtick
```

### Recommended controls

- Current run phase
- Current decision ID
- Force decision input
- Set each resource to numeric value
- Add law by ID
- Add flag by ID
- Advance day
- Trigger each ending
- Restart run
- Print state JSON
- Set fixed random seed
- Reload content files

### Safety

- Overlay must not intercept input when hidden.
- Debug actions must call normal game APIs where possible.
- Debug code may be excluded in release later.

---

## 16. Navigation and transitions

Phase 1 may use simple screen replacement.

Recommended transition:

- Fade out 0.15 seconds
- Switch screen
- Fade in 0.15 seconds

No complex animation is required.

### Navigation rules

- Start Screen → Game Screen
- Game Screen → Run End Screen
- Run End Screen → Game Screen on restart
- Run End Screen → Start Screen on main menu
- No back navigation during a run in Phase 1

---

## 17. Responsive behavior

The game must remain usable across common portrait aspect ratios.

Requirements:

- Top and bottom safe-area margins
- Choice buttons remain visible without scrolling
- Proposal text wraps
- Country area may shrink before decision controls
- Minimum touch target size approximately 48 logical pixels
- No essential information hidden behind device cutouts

Desktop window resizing should preserve layout.

---

## 18. Placeholder theme

Recommended temporary theme values:

```text
Background: warm cream
Panels: dark navy or charcoal
Primary action: muted green
Secondary/reject action: muted red
Gold accent: resource/crown
Text: dark or white depending on panel
Danger: red
Positive delta: green
Negative delta: red
```

No requirement to match final brand.

### Typography

Use Godot default font in Phase 1.

Recommended relative hierarchy:

- Title: very large
- Ending title: large
- Day/resource values: medium-large
- Advisor name: medium
- Proposal: medium, highly readable
- Choice label: medium-bold
- Metadata: small

---

## 19. Accessibility basics for prototype

Even before final polish:

- Do not communicate resource state through color alone.
- Use numbers and signs.
- Ensure sufficient text contrast.
- Support mouse and keyboard during desktop testing.
- Avoid flashing effects.
- Keep text concise.
- Buttons must have readable labels.

Full accessibility implementation is Phase 3.

---

## 20. Empty/error states

### Missing advisor image

Show initials or placeholder icon.

### Missing law data

Show raw law ID in debug build and log warning.

### No valid decision

Show safe development message and trigger fallback ending.

### Invalid decision content

Skip invalid card and log error.

### Missing result text

Generate a neutral fallback:

```text
The country reacts to your decision.
```

---

## 21. UI acceptance criteria

1. All required screens render at 1080×1920.
2. The game remains usable when proposal text reaches 220 characters.
3. Choice buttons never overlap.
4. Resources remain visible during decision selection.
5. Result feedback is visible before the next card.
6. Active laws update immediately.
7. The ending screen identifies the ending and final day.
8. Restart works without duplicated scenes or stale UI.
9. Missing placeholder images do not break layout.
10. Debug overlay can force at least one ending.
11. UI does not directly mutate RunState.
12. Repeated screen changes do not create duplicate signal connections.
