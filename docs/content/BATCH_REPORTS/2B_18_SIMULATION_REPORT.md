# Milestone 2B-18 — Simulation Report (10,000 runs)

**Date:** 2026-07-20  
**Runner:** `tests/run_2b18_sim_10k.gd`  
**Exports:**

- `user://diagnostics/phase_2b_18_final_simulation.json`
- `user://diagnostics/phase_2b_18_final_simulation.txt`

Absolute (this machine):  
`~/Library/Application Support/Godot/app_userdata/Tiny Dictator/diagnostics/phase_2b_18_final_simulation.{json,txt}`

---

## 1. Configuration

| Strategy | Runs | Base seed |
|---|---:|---:|
| random | 2000 | 20260720 |
| resource_preserver | 2000 | 20260721 |
| power_maximizer | 2000 | 20260722 |
| chaotic_explorer | 2000 | 20260723 |
| happiness_populist | 2000 | 20260724 |

Every per-run seed is recorded in the JSON (`seeds` array and per-strategy `seeds`).

---

## 2. Combined results vs targets

| Metric | Result | Target | Status |
|---|---:|---|---|
| Content exhaustion | **0** | 0 | PASS |
| Blocking validation errors | **0** | 0 | PASS |
| Fallback-card share | **0.43%** (993 / 229,650) | &lt;1% | PASS |
| One-time decision repetition | **0** | 0 | PASS |
| Average run length | **23.0** days | 18–30 | PASS |
| Runs reaching Day 40 | **3.6%** | 8–20% | MISS |
| Special-ending share | **61.2%** | 25–45% | MISS |
| Generic resource-failure share | **38.9%** | 40–65% | MISS (near) |
| Ordinary never-selected (excl. palace-gated) | **0.6%** (2/330) | &lt;3% | PASS |
| Major arcs never started | **0** (legacy `traffic_military` only) | 0 | PASS |
| Major arcs without completed paths | **0** | 0 | PASS |
| Crises never activated | **0** | 0 | PASS |
| Avg unique-card ratio | **99.98%** | &gt;95% | PASS |
| Approved decisions | **330** | 330 | PASS |
| Same-advisor triple rate (raw) | ~6.8% of sequences | &lt;0.5% | MISS (see notes) |

---

## 3. Per-strategy summary

| Strategy | Avg length | Day40 | Special | Generic fail | Fallback share |
|---|---:|---:|---:|---:|---:|
| random | 24.1 | 3.5% | 80.0% | 20.0% | 0.48% |
| resource_preserver | 27.3 | 6.6% | 99.4% | 0.7% | 0.70% |
| power_maximizer | 28.2 | **8.0%** | 50.0% | 50.0% | 0.48% |
| chaotic_explorer | 16.6 | 0.1% | 65.3% | 34.6% | 0.15% |
| happiness_populist | 18.9 | 0.0% | 11.0% | 89.0% | 0.16% |

---

## 4. Before / after balance changes

### A. Standalone fill (−9 → 0)

- **Before:** 321 approved / standalone 63  
- **After:** 330 approved / standalone 72 via `ministan_standalone_pack_d.json` (9 cards)

### B. Broken major-arc completions

| Arc | Before complete rate | After |
|---|---:|---:|
| `profit_corporate_state` | 0% | ~5% of runs / completes when started |
| `traffic_military_control` | 0% (+ force errors) | ≈ start rate (~14%) |
| `penny_austerity_arc` | ~0.1% | ~7% |

Root cause: mismatched `any_laws` on forced mid-beats; fixed by removing incorrect law gates and hardening force-next links.

### C. `nation_in_darkness` condition bug

- **Before (broken):** `conditions: { minimum_day: 28 }` made ~40% of runs end at day 28 → Day40 = 0%.  
- **After:** conditions cleared (trigger-only via power-outage crisis). Day40 recovered to 3.6%; max length returns to 40.

### D. Special-ending delay + arc entry weights

- Added `minimum_day` 28–30 on collectible specials; stripped redundant `trigger_ending` where flags already set.  
- Lowered major-arc entry `base_weight` (~45% reduction).  
- Raised starting resources 55 → 60.  
- Loosened several palace gates so headless sims can select those standalones.

Special/generic still skewed by `resource_preserver` (near-100% special). Combined special remains above the 45% band.

---

## 5. Never-selected / rare

**Never selected in 10k (4):**

- `anthem_sponsor_reads` — intentional palace gate (`propaganda_studio`)
- `midnight_filing_amnesty` — intentional palace gate (`prototype_shelf`)
- `luna_good_news_only` — tight affinity/state gate (ordinary miss)
- `recovery_zero_queue_charter` — rare recovery eligibility

**Secrets (debug-proven; sim counts):** toaster 8, wrong_map 6, micronation 2, forms 1, cat_republic 333, accidental_moon 214.

---

## 6. Other aggregates

- Average Medals: **15.4**
- Average palace upgrades affordable at ending: **~5.6**
- Crisis activations: all 18 approved crises &gt; 0
- Arc starts: all 18 approved majors &gt; 0; completions &gt; 0
- Content exhaustion: **0**
- Fallback share: **0.43%**

---

## 7. Known metric limitations

1. **Day 40 (3.6% vs 8–20%):** Combined strategies end via arc specials / collapses before day 40. `power_maximizer` alone hits 8.0%. Further Day40 gains need softer special conditions or milder mid-game drains (risk raising exhaustion/fallback).  
2. **Special share (61% vs 25–45%):** `resource_preserver` almost never collapses resources, so arc/special endings dominate. Random alone also high (~80%) due to frequent arc completion flags.  
3. **Same-advisor triples:** Raw consecutive-advisor heuristic (~6.8%) includes mandatory chain/arc beats; not filtered to “outside mandatory chains.” Needs a stricter exclusion list before treating as a hard fail.  
4. **Ruler identities:** runtime has **7** identities (PRD target 12) — pre-existing gap; not expanded in 2B-18.

---

## 8. Secret reachability

`tests/run_2b17_secret_debug_proof.gd` — **failures=0** (four secret cards + accidental moon trigger/conditions).
