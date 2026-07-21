# Milestone 2B-18 — Static Diagnostics Report

**Date:** 2026-07-20  
**Phase:** `2b_18_full_library_diagnostics`  
**Blocking errors:** **0**  
**Warnings:** 203 (mostly `unreachable_decisions` for queue-only / arc-mid beats)  
**Total findings:** 211  

Export: `user://diagnostics/content_diagnostics_*.json` (latest via `tests/run_2b18_static_export.gd`)

---

## 1. Extensions added in 2B-18

[`scripts/core/ContentDiagnostics.gd`](../../scripts/core/ContentDiagnostics.gd) now also checks:

- ending-priority conflicts
- unresolved mandatory follow-ups
- crises with no resolution / permanent-active risk
- laws with no downstream / laws blocking arc entries
- recovery loops
- duplicate premises / repeated result text / repeated option labels
- orphaned flags and counters
- wrong run-stage assignment
- palace unlock validity

Fixed false positive: resource-failure endings (`maximum_resources: 0`) are no longer flagged as “impossible” from day-1 starting values.

---

## 2. Blocking errors

**None.** Validator: 0 errors, 0 warnings. Forced-follow-up cycles: 0. Recovery loops: 0. Crisis resolution graph errors: 0. Arc entry/resolution catalog errors: 0.

---

## 3. Warning summary (non-blocking)

| Category | Count | Notes |
|---|---:|---|
| `unreachable_decisions` | ~187 | Expected for `queue_only` / forced mid-arc beats not day-1 startable |
| `ending_priority_conflicts` | 15 | Shared priorities among specials; resolver still picks a deterministic winner |
| `wrong_run_stage_assignment` | 1 | Day range vs stage band mismatch on one card |
| `orphaned_flags_and_counters` | 2 | Info-level |
| `repeated_option_labels` | 3 | Info-level |
| Concentration (advisor/tag) | few | Info-level |

---

## 4. Graph reachability (approved majors / crises)

After arc force/eligibility fixes:

- All **18** approved major arcs have valid entries and at least one completed path in simulation.
- All **18** approved crises activate in the 10k matrix.
- Legacy minor arc `traffic_military` remains outside the major quota (not blocking).

---

## 5. Commands

```bash
godot --headless --path . -s tests/run_2b18_static_export.gd
godot --headless --path . -s tests/test_content_validation.gd
godot --headless --path . -s tests/test_diagnostics_simulation.gd
```
