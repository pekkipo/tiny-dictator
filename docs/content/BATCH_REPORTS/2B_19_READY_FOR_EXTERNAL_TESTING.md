# Milestone 2B-19 — Closed Alpha

**Status:** READY_FOR_EXTERNAL_TESTING  
**Not complete:** real external tester data has not been imported  
**Do not start:** Milestone 2B-20

---

## Verdict

Closed-alpha infrastructure, documentation, export workflow, and analysis tooling are in place for the full Ministan library (post 2B-18).  

**No fabricated testers, sessions, runs, survey answers, retention stats, favorite characters, confusing cards, bugs, or closed-alpha conclusions were created.**

Until real `tiny_dictator_alpha_*` packages are collected and analyzed against Part J criteria, this milestone remains **READY_FOR_EXTERNAL_TESTING**, not complete.

---

## Changed files

### Config / project
- `data/config/closed_alpha.json` — `closed_alpha_enabled` and alpha version flags
- `project.godot` — `config/version=0.2.0-alpha`, `ClosedAlphaLogger` autoload
- `export_presets.cfg` — macOS / Windows / Linux desktop closed-alpha presets
- `.gitignore` — ignore `/builds/`
- `KNOWN_ISSUES.md` — desktop alpha export note

### Core systems
- `scripts/core/ClosedAlphaConfig.gd`
- `scripts/core/ClosedAlphaSession.gd`
- `scripts/core/ClosedAlphaLogger.gd`
- `scripts/core/ClosedAlphaExporter.gd`
- `scripts/core/EventBus.gd` — alpha UI signals
- `scripts/core/SaveManager.gd` — `debug_enabled` helpers; default false

### UI
- `scripts/ui/Main.gd` — hosts alpha settings/feedback panels
- `scripts/ui/StartScreen.gd` + `scenes/screens/StartScreen.tscn`
- `scripts/ui/RunEndScreen.gd` + `scenes/screens/RunEndScreen.tscn`
- `scripts/ui/MetaProgressScreen.gd` + `scenes/screens/MetaProgressScreen.tscn`
- `scripts/ui/GameScreen.gd` + `scenes/screens/GameScreen.tscn`
- `scripts/ui/DebugOverlay.gd` — cheats gated in alpha
- `scripts/ui/AlphaFeedbackPanel.gd` + `scenes/components/AlphaFeedbackPanel.tscn`
- `scripts/ui/AlphaSettingsPanel.gd` + `scenes/components/AlphaSettingsPanel.tscn`

### Analysis tooling
- `scripts/dev/ClosedAlphaReportGenerator.gd`
- `tests/run_2b19_alpha_import.gd`
- `tests/run_2b19_alpha_smoke.gd`

### Docs (`docs/alpha/`)
- `CLOSED_ALPHA_TESTER_GUIDE.md`
- `CLOSED_ALPHA_RESEARCH_PLAN.md`
- `CLOSED_ALPHA_FEEDBACK_QUESTIONS.md`
- `CLOSED_ALPHA_BUILD_CHECKLIST.md`
- `CLOSED_ALPHA_DATA_IMPORT_GUIDE.md`
- `CLOSED_ALPHA_ISSUE_TEMPLATE.md`
- `CLOSED_ALPHA_RESULTS.md` — placeholder (no dataset)
- `CLOSED_ALPHA_CONTENT_FIX_BACKLOG.md` — placeholder (no dataset)
- This report

**Content inventory:** unchanged (330 approved decisions preserved).

---

## Alpha logging and export format

### Local storage
- Session: `user://alpha_session.json` (anonymous tester ID)
- Runs: `user://alpha_logs/runs/<run_id>.json`
- Feedback: `user://alpha_logs/feedback/<feedback_id>.json`
- Active-run marker: `user://alpha_logs/active_run.json` (interrupted runs → abandoned on next boot)

### Export package (`user://alpha_exports/tiny_dictator_alpha_<timestamp>/`)
| File | Purpose |
|---|---|
| `runs.json` / `runs.csv` | Run logs |
| `feedback.json` | Feedback records |
| `summary.json` / `summary.txt` | Aggregated metrics |
| `versions.json` | App + content version + hash |
| `manifest_snapshot.json` | Manifest batch/phase snapshot |
| `session.json` | Anonymous ID metadata |
| `KNOWN_LIMITATIONS.txt` | Tester-facing limitations |

Export **excludes** `user://save.json` and device identifiers. No backend upload (`analytics_backend_enabled: false`).

---

## Anonymous information collected

Collected locally only:

- Random UUID-like anonymous tester ID (resettable)
- App version / content version / content hash
- Run IDs, timestamps, duration, status (completed / abandoned)
- Decisions seen, options selected, decision time (ms)
- Resource before/after snapshots
- Laws, arcs, crises, ending, ruler identity, medals
- Restart-after-ending flag; crash/interrupt marker
- Optional feedback (type, rating, short comment, flags)

**Not collected:** email, name, account, device serial, advertising ID, exact location, personal free-text beyond optional comments the tester chooses to enter.

---

## Tester and build instructions

- Tester guide: [`docs/alpha/CLOSED_ALPHA_TESTER_GUIDE.md`](../alpha/CLOSED_ALPHA_TESTER_GUIDE.md)
- Build checklist: [`docs/alpha/CLOSED_ALPHA_BUILD_CHECKLIST.md`](../alpha/CLOSED_ALPHA_BUILD_CHECKLIST.md)
- Research plan / questions: [`docs/alpha/CLOSED_ALPHA_RESEARCH_PLAN.md`](../alpha/CLOSED_ALPHA_RESEARCH_PLAN.md), [`docs/alpha/CLOSED_ALPHA_FEEDBACK_QUESTIONS.md`](../alpha/CLOSED_ALPHA_FEEDBACK_QUESTIONS.md)

**Primary play path verified here:** Godot 4.7 editor boot (`Main` → Start). Desktop export presets are present; full signed binaries still require export templates + owner packaging. No Android/iOS claim.

**Automated checks run:**
- `tests/run_2b19_alpha_smoke.gd` — PASS
- `tests/run_2b19_alpha_import.gd` (empty dir) — reports no dataset
- Headless boot to Start screen — OK

---

## Files the owner must collect and import

From each tester, collect the full export folder:

```text
tiny_dictator_alpha_<timestamp>/
  runs.json
  runs.csv
  feedback.json
  summary.json
  summary.txt
  versions.json
  manifest_snapshot.json
  session.json
  KNOWN_LIMITATIONS.txt
```

Place packages under `user://alpha_imports/` or `docs/alpha/imports/`, then:

```bash
godot --headless --path . -s res://tests/run_2b19_alpha_import.gd -- \
  --import-dir="res://docs/alpha/imports" \
  --write-docs=true
```

This regenerates `docs/alpha/CLOSED_ALPHA_RESULTS.md` and `docs/alpha/CLOSED_ALPHA_CONTENT_FIX_BACKLOG.md`.

Import guide: [`docs/alpha/CLOSED_ALPHA_DATA_IMPORT_GUIDE.md`](../alpha/CLOSED_ALPHA_DATA_IMPORT_GUIDE.md)

---

## Completion criteria (not yet met)

| Criterion | Status |
|---|---|
| 20–50 testers represented (or owner waiver) | Pending real data |
| ≥200 completed runs analyzed (or owner waiver) | Pending real data |
| Top technical blockers identified | Pending |
| Top confusing cards identified | Pending |
| Repetition problems identified | Pending |
| Favorite / weakest content identified | Pending |
| Restart rate calculated | Pending |
| Prioritized P0–P3 backlog from real evidence | Pending |

---

## Explicit statements

- **READY_FOR_EXTERNAL_TESTING**
- Closed alpha is **not** marked complete
- Milestone **2B-20 must not start** until real alpha findings justify the freeze pass
- Simulated / diagnostics runs are **not** closed-alpha user data
