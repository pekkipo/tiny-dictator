# Milestone 2B-18 — Full-Library Diagnostics and Balance (Final)

**Status:** Complete  
**Do not start:** Milestone 2B-19  
**Inventory:** **330 / 330** approved decisions (standalone **72 / 72**)

---

## 1. Changed files (summary)

### Content
- `data/decisions/ministan_standalone_pack_d.json` — **new** 9 standalone cards
- `data/decisions/ministan_profit_corporate_state_arc.json` — force/eligibility fixes
- `data/decisions/ministan_traffic_military_control.json` — convoy/checkpoint fixes
- `data/decisions/ministan_penny_austerity_arc.json` — trimming/sunset fixes
- Multiple arc entry weights lowered; palace gates loosened on selected standalones
- `data/endings/endings.json` — special `minimum_day` bands; `nation_in_darkness` conditions cleared
- `data/countries/ministan.json` — register pack D; starting resources 60
- `data/visual_states/country_visual_map.json` — pack D tags
- `data/content_manifest.json` — regenerated (phase `2b_18_full_library_diagnostics`)

### Systems / tools / tests
- `scripts/core/ContentDiagnostics.gd` — Part B checks + false-positive fix
- `scripts/core/SimulationChoiceStrategy.gd` — 5 strategies
- `scripts/core/RunSimulator.gd` / `SimulationReport.gd` — richer metrics + stable export
- `scripts/dev/ContentManifestBuilder.gd` — phase 2B-18 + pack D approval
- `scripts/dev/ContentScaffoldingValidator.gd` — runtime count 352
- `tests/run_2b18_sim_10k.gd`, `tests/run_2b18_static_export.gd`, `tests/run_2b18_sim_5k_check.gd`
- Manifest/validation tests updated for 330/72/352

### Docs
- `docs/content/BATCH_REPORTS/2B_18_INVENTORY_DISCREPANCY.md`
- `docs/content/BATCH_REPORTS/2B_18_STATIC_DIAGNOSTICS.md`
- `docs/content/BATCH_REPORTS/2B_18_SIMULATION_REPORT.md`
- `docs/content/BATCH_REPORTS/2B_18_MANUAL_TEST_MATRIX.md`
- This file

---

## 2. Final inventory

| Catalog | Count |
|---|---:|
| Approved decisions | **330** |
| Onboarding / standalone / short_chain / major_arc / crisis / recovery / endgame | **10 / 72 / 80 / 96 / 28 / 24 / 20** |
| Major arcs | 18 |
| Short chains | 32 |
| Crises | 18 |
| Laws | 50 |
| Collectible endings | 50 |
| Palace upgrades | 24 |
| Runtime decisions (catalog) | 352 |

---

## 3. Static diagnostics

**Blocking errors: 0.** See [2B_18_STATIC_DIAGNOSTICS.md](2B_18_STATIC_DIAGNOSTICS.md).

---

## 4. 10,000-run simulation

See [2B_18_SIMULATION_REPORT.md](2B_18_SIMULATION_REPORT.md).

Highlights: exhaustion **0**, fallback **0.43%**, avg length **23**, unique **99.98%**, all majors/crises reachable, secrets debug-proven.

Misses vs target bands: Day40 **3.6%** (want 8–20%), special **61.2%** (want 25–45%), generic fail **38.9%** (want 40–65%), raw same-advisor triples above 0.5% heuristic.

---

## 5. Closed-alpha readiness

**Content-inventory ready; balance soft-gated.**

Ready for internal closed-alpha packaging **with known limitations** documented (Day40/special mix, 7/12 ruler identities, palace-gated rares, advisor-streak heuristic). Not a hard content freeze — 2B-19 should collect player evidence before further large balance swings.

**Do not start Milestone 2B-19 in this change set.**
