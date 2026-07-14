# Tiny Dictator — Phase 1 QA, Acceptance, and Delivery Plan

**Scope:** Test matrix, acceptance criteria, balancing checks, prototype handoff  
**Purpose:** Determine whether Phase 1 is truly complete

---

## 1. QA philosophy

Phase 1 QA is not about visual perfection. It is about proving that the prototype is:

- Playable
- Understandable
- Stable
- Repeatable
- Expandable
- Safe against malformed content
- Easy to debug

Every major system must be testable without waiting for random conditions.

---

## 2. Test environments

Minimum:

- Godot editor play mode on development Mac
- Resizable desktop window
- Portrait viewport 1080×1920

Recommended before Phase 1 sign-off:

- One Android device export
- One narrow phone aspect ratio
- One tall phone aspect ratio

iOS export may wait until later if export setup is not ready.

---

## 3. Smoke test

Perform after every major milestone.

### Boot

- Project opens.
- No GDScript parse errors.
- Main scene is configured.
- Start Screen appears.
- Start button is enabled.

### New run

- Start button opens Game Screen.
- Day is 1.
- Four resources show defaults.
- Decision is visible.
- Advisor name is visible.
- Both choices are visible.

### Choice

- Clicking a choice disables both buttons.
- Resources update.
- Result text appears.
- Law/flag effects apply.
- Continue button appears.

### Continue

- If no ending, day increments.
- New decision appears.
- Result panel resets.
- Buttons are enabled.

### Ending

- A zero resource ends run.
- Ending screen appears.
- Final day and resources are correct.
- Restart starts clean run.

---

## 4. Functional test cases

### TC-001 Start a new run

**Precondition:** Start Screen visible  
**Action:** Press Start  
**Expected:**

- RunState created
- Day = 1
- Resources = configured defaults
- No laws
- No flags
- No history
- First valid decision shown

### TC-002 Prevent double resolution

**Precondition:** Decision visible  
**Action:** Rapidly click same choice multiple times  
**Expected:**

- Decision resolves once
- Day does not skip
- Effects applied once
- History contains one record

### TC-003 Resource clamping upper bound

**Precondition:** Treasury = 95  
**Action:** Apply +10 Treasury  
**Expected:**

- Final Treasury = 100
- Displayed applied delta = +5

### TC-004 Resource clamping lower bound

**Precondition:** Happiness = 5  
**Action:** Apply -10 Happiness  
**Expected:**

- Final Happiness = 0
- Displayed applied delta = -5
- Revolution ending triggers

### TC-005 Add law once

**Precondition:** Law inactive  
**Action:** Choose option that adds law  
**Expected:**

- Law appears once
- Active law bar updates
- Country visual props update

### TC-006 Duplicate law protection

**Precondition:** Law active  
**Action:** Apply same add law operation  
**Expected:**

- No duplicate
- No crash
- Optional warning

### TC-007 Flag requirement

**Precondition:** `traffic_lights_off` absent  
**Action:** Request valid decisions  
**Expected:**

- `traffic_tank_solution` absent

Then add flag:

**Expected:**

- `traffic_tank_solution` becomes eligible

### TC-008 Blocked flag

**Precondition:** `military_controls_traffic` active  
**Expected:**

- Setup traffic decision no longer appears if blocked

### TC-009 One-time decision

**Action:** Resolve one-time card, continue many days  
**Expected:**

- Card never reappears in same run

### TC-010 Reusable decision

**Action:** Resolve reusable fallback card  
**Expected:**

- It may appear later
- It does not appear immediately twice

### TC-011 Forced next decision

**Action:** Select option with forced follow-up  
**Expected:**

- Follow-up is next card
- Weighting does not replace it

### TC-012 Missing forced follow-up

**Precondition:** Debug content points to invalid ID  
**Expected:**

- Error logged
- Normal selection used
- Game remains playable

### TC-013 Weighted selection

**Action:** Run 1,000 debug selections from same eligible pool  
**Expected:**

- Higher-weight cards appear more frequently
- No invalid cards selected

Exact statistical distribution is not required, but obvious inversion is a failure.

### TC-014 Fixed seed

**Action:** Start two runs with same seed and make same choices  
**Expected:**

- Decision sequence matches until state differs

### TC-015 Explicit ending

**Action:** Select option with `trigger_ending`  
**Expected:**

- Correct ending appears immediately after result Continue

### TC-016 Ending priority

**Precondition:** Choice triggers special ending and reduces resource to 0  
**Expected:**

- Higher-priority special ending appears

### TC-017 Multiple resource collapse

**Action:** Choice reduces multiple resources to 0  
**Expected:**

- Configured priority ending appears
- Summary includes all final resource values

### TC-018 Maximum day

**Precondition:** Reach configured max day without other ending  
**Expected:**

- Survival ending appears

### TC-019 Content exhaustion

**Precondition:** Mark all normal decisions used and invalidate follow-ups  
**Expected:**

- Fallback decision or fallback ending
- No empty card
- Error details logged

### TC-020 Restart cleanliness

**Action:** Finish run, restart  
**Expected:**

- Day reset
- Resources reset
- Laws cleared
- Flags cleared
- Counters cleared
- History cleared
- Old result panel hidden
- No duplicated signals

---

## 5. UI test cases

### UI-001 Long proposal

Use 220-character proposal.

Expected:

- Text wraps
- No clipping
- Choice buttons visible

### UI-002 Long choice labels

Use 32-character labels.

Expected:

- Text wraps or scales within button
- Buttons do not overlap

### UI-003 Many active laws

Add eight laws.

Expected:

- First configured maximum shown
- Overflow indicated
- Screen remains usable

### UI-004 Low-resource danger

Set each resource to 20.

Expected:

- Numeric value visible
- Danger styling visible
- No reliance on color only

### UI-005 Missing portrait

Remove placeholder portrait path.

Expected:

- Advisor initials/icon shown
- No broken layout

### UI-006 Resize window

Resize desktop window across portrait aspect ratios.

Expected:

- Layout adapts
- No controls leave visible area
- No important text overlaps

### UI-007 Result state

After choice:

- Choice buttons disabled
- Selected choice visually indicated
- Result text visible
- Continue visible

### UI-008 Ending screen

Expected:

- Ending title is dominant
- Description readable
- Final stats visible
- Restart button visible without scrolling

---

## 6. Content validation tests

### CV-001 Duplicate decision ID

Expected:

- Fatal validation error
- Start blocked in debug

### CV-002 Missing advisor ID

Expected:

- Error names decision and advisor ID

### CV-003 Invalid law ID

Expected:

- Error names decision, option, and law ID

### CV-004 Invalid resource ID

Expected:

- Error or warning
- Unknown effect ignored safely

### CV-005 Missing result text

Expected:

- Warning or validation error based on strictness
- Safe fallback if runtime reaches it

### CV-006 Invalid JSON

Expected:

- File path and parse error shown
- Game does not crash
- Start blocked if required file unavailable

### CV-007 Invalid ending ID

Expected:

- Error during validation

### CV-008 Invalid day range

`minimum_day > maximum_day`

Expected:

- Validation error

### CV-009 Zero or negative weight

Expected:

- Validation warning/error
- Card excluded or default weight applied according to chosen policy

### CV-010 Unknown optional field

Expected:

- Non-fatal warning in development
- Runtime ignores field

---

## 7. Debug overlay acceptance

The debug overlay must allow:

- Toggle visibility
- View current seed
- View current decision ID
- View flags
- View laws
- View counters
- Set each resource
- Force a decision
- Trigger an ending
- Restart
- Print state
- Reload content

Test:

- Hidden overlay does not intercept gameplay input.
- Invalid debug ID produces message, not crash.
- Resource edits immediately update UI.

---

## 8. Playability test session

Run at least five complete internal playthroughs.

For each run record:

- Seed
- Final day
- Ending
- Number of unique decisions
- Number of laws
- Any repeated card
- Any confusing effect
- Any dead-end
- Any text clipping
- Any technical error

Target:

- At least three distinct endings observed
- At least one conditional chain observed per run
- No run ends because of technical failure
- Average run length at least 8 decisions
- No unavoidable identical sequence every run

---

## 9. Prototype fun evaluation

After the implementation is stable, conduct a small qualitative test with 3–5 people.

Ask them to play without explanation.

Observe:

- Do they know where to click?
- Do they read the resource effects?
- Do they understand laws persist?
- Do they notice follow-ups reference earlier choices?
- Do they understand why they lost?
- Do they restart?

Ask only after the session:

1. What did you think the goal was?
2. Which decision was most memorable?
3. Did your previous choices seem to matter?
4. Why did your run end?
5. Would you start another run?
6. What felt confusing or slow?

Phase 1 does not require strong retention, but at least half of testers should voluntarily restart or express interest in another run.

---

## 10. Balance guidelines

The goal is not perfect balance. The goal is to avoid obviously broken runs.

### Starting resources

Default 55.

### Normal effects

Typical:

```text
Small: 2–5
Medium: 6–10
Large: 11–15
Major: 16–25
```

### Guidelines

- Most choices affect 2–3 resources.
- Positive effects should usually have a cost.
- Avoid choices where one option is strictly better in every visible way unless hidden consequence justifies it.
- Avoid too many -15 effects early.
- Ensure no advisor always produces the same obvious response.
- Give the player recovery opportunities.

### Run length target

Prototype target:

```text
8–20 decisions
```

Max-day ending:

```text
30
```

---

## 11. Performance checklist

- No JSON parsing during every frame.
- No repeated scene instantiation leaks.
- No duplicated signal callbacks.
- No continuously growing node lists.
- No large placeholder textures.
- No warnings repeated every frame.
- Stable editor run for ten consecutive restarts.

---

## 12. Save test cases

If SaveManager is included:

### SAVE-001 Unlock ending

- Reach ending
- Close and reopen game
- Ending remains unlocked

### SAVE-002 Corrupt save file

- Replace save with invalid JSON
- Game creates safe default
- Warning logged

### SAVE-003 Version mismatch

- Save version differs
- Safe migration or reset
- No crash

### SAVE-004 Reset save

- Debug reset clears unlocked endings
- New default save created

---

## 13. Phase 1 exit criteria

Phase 1 can be accepted only if:

### Product

- Core loop is understandable.
- Choices visibly affect the game.
- At least one chain references a prior choice.
- At least five endings are reachable.
- Ending screen motivates replay.

### Engineering

- No blocking errors.
- Content is data-driven.
- Run state is separated from UI.
- Validation catches broken content.
- Restart is clean.
- Debug tools cover major states.

### Content

- Minimum inventory is present.
- No real-world political references.
- Text fits prototype UI.
- No obvious impossible chains.

### Documentation

- All Phase 1 PRDs are in repository.
- Cursor rules reference them.
- README explains how to run.
- Known limitations are documented.

---

## 14. Delivery package

At Phase 1 completion, repository should contain:

```text
/docs Phase 1 PRDs
/scenes complete prototype screens
/scripts core and UI systems
/data prototype content
/assets/placeholders
/tests or test runner
README.md
KNOWN_ISSUES.md
```

Recommended README sections:

- Project purpose
- Godot version
- How to open
- How to run
- Project structure
- How to add a decision
- How to use debug overlay
- Current limitations

Recommended `KNOWN_ISSUES.md`:

- Missing final art
- Placeholder typography
- No mobile export polish
- No production save migration
- Limited content volume
- No monetization
- No localization

---

## 15. Final sign-off checklist

```text
[ ] Project opens in Godot
[ ] Start Screen works
[ ] New run starts cleanly
[ ] Four resources function
[ ] Decision Engine filters correctly
[ ] Weighted selection works
[ ] Forced follow-up works
[ ] Laws and flags work
[ ] Result panel works
[ ] Country placeholder reacts
[ ] Resource endings work
[ ] Special ending works
[ ] Max-day ending works
[ ] Run End Screen works
[ ] Restart works repeatedly
[ ] Debug overlay works
[ ] Content validation passes
[ ] Save works if included
[ ] Five internal playthroughs completed
[ ] No blocking known issue
[ ] Git milestone committed
```
