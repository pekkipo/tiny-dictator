# Closed Alpha — Tester Guide

**Build:** Tiny Dictator Closed Alpha `0.2.0-alpha`  
**Content baseline:** Ministan library after Milestone 2B-18 (330 approved decisions)  
**Status:** Unfinished build for external playtesting only

---

## What this is

You are playing an unfinished satirical strategy-comedy prototype. Placeholder art, no final audio, and some balance rough edges are expected.

Please play normally. Do **not** use developer cheats unless the owner asked you to unlock the hidden debug menu.

---

## Install and launch

### Option A — Godot editor (most common for this alpha)

1. Install [Godot 4.7](https://godotengine.org/download) (compatible with project features).
2. Open the project folder in Godot.
3. Press **Play** (F5). The main scene is `scenes/main/Main.tscn`.

### Option B — Desktop export (if provided)

1. Receive a macOS / Windows / Linux export from the owner.
2. Launch the binary.
3. Confirm the Start screen shows a version like:  
   `Closed Alpha 0.2.0-alpha · content 2B-18`

If export templates are missing on the build machine, the owner may only ship the editor project. That is still a valid closed-alpha build for this milestone.

---

## Recommended play

- Complete **at least 3 full runs** (start → ending).
- Try different choices; endings and advisor stories change.
- Visit **Palace & Archive** between runs if you unlock medals.
- Optional: send feedback after a memorable ending (never required).

Target for the wider alpha: **20–50 testers**, **200+ completed runs**, **≥3 runs encouraged per tester**.

---

## Reporting bugs

1. Tap **REPORT ISSUE** (Start, in-run top bar, or Run End).
2. Or open **ALPHA SETTINGS → Report issue**.
3. Mark **Technical bug**, add a short comment, include a decision ID if you know it.
4. Optionally use the issue template: `docs/alpha/CLOSED_ALPHA_ISSUE_TEMPLATE.md`.

Also note: force-quitting mid-run abandons that run (no mid-run save). That is intentional for this build.

---

## Exporting your data

1. Open **ALPHA SETTINGS** from the Start screen (or Palace).
2. Tap **Export alpha data**.
3. Tap **Open exports folder** (or locate `user://alpha_exports/` via Godot user data).
4. Send the whole folder named `tiny_dictator_alpha_<timestamp>/` to the owner.

Typical macOS Godot user data path (editor):

```text
~/Library/Application Support/Godot/app_userdata/Tiny Dictator/
```

Inside that folder look for `alpha_exports/`.

---

## What information is collected

**Collected (anonymous, local only):**

- Random local anonymous tester ID
- App / content version
- Run start/end times, duration
- Decisions seen, options chosen, decision time
- Resource snapshots around choices
- Laws / arcs / crises / ending / medals / ruler identity
- Restart-after-ending flag
- Optional feedback you submit

**Not collected:**

- Email, name, account
- Device serial / advertising ID
- Exact location
- Unrelated save files in the export package
- Backend upload (exports stay on device until you send them)

You can **Reset anonymous ID** in Alpha Settings anytime.

---

## Known limitations

- Placeholder visuals and emoji UI
- No final art, audio, ads, purchases, or accounts
- Closing the app abandons the current run
- Debug cheats hidden by default
- Balance soft-gates from 2B-18 may still appear (rare Day-40 endings, special-ending mix)
- Desktop-oriented; mobile packaging is not claimed for this alpha

---

## Thank you

Play for fun, be honest about confusion and repetition, and export your logs when you finish. Your anonymous data helps prioritize real content fixes.
