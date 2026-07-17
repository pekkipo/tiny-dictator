# Milestone 2B-12 — Major-Arc Pack C Final Report

**Status:** Complete  
**Do not start:** Milestone 2B-13  
**Quota after pack:** major-arc decisions **72 / 96**; major arcs **12 / 18**

---

## 1. Changed files

### New
- `docs/content/drafts/2B-12_major_arc_pack_c_briefs.md`
- `data/decisions/ministan_doctor_maybe_arc.json` (full rewrite, 6)
- `data/decisions/ministan_profit_corporate_state_arc.json` (6)
- `data/decisions/ministan_ai_government_arc.json` (6)
- `data/decisions/ministan_sell_the_moon_arc.json` (6)
- `tests/run_2b12_sim_5k.gd`
- `docs/content/BATCH_REPORTS/2B-12_major_arc_pack_c_final.md` (this file)

### Updated
- `data/arcs/ministan_arcs.json` — Pack C arcs; promote `robot_government`; rewrite Maybe
- `data/countries/ministan.json` — decision_files
- `data/laws/laws.json` — `national_trial_oversight_act`, `privatize_air`, `rent_a_ministry`, `corporate_capital_naming`, `ai_cabinet_pilot`, `moon_replacement_research`
- `data/endings/endings.json` — Pack C endings; moon description untangled from Maybe
- `data/follow_up_pools/follow_up_pools.json` — `corporate_side_effects`, `moon_noise_pool`
- `data/visual_states/country_visual_map.json` — Pack C visual tags
- `data/advisors/advisors.json` — guest `foreign_ambassador`
- `data/crises/ministan_crises.json` — `ai_cabinet_lockout`, `moon_ownership_dispute`
- `data/decisions/ministan_crises.json` — crisis cards
- `data/decisions/ministan_advisor_affinity.json` — `science_gamble` retarget; deny abandons
- `data/decisions/ministan_cat_politics.json` — removed deferred robot cards
- `scripts/dev/ContentManifestBuilder.gd` — phase `2b_12_major_arc_pack_c`, Pack C approvals
- `data/content_manifest.json` / `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- `docs/content/MINISTAN_ARC_CATALOG.md`
- Tests: `test_content_validation.gd`, `test_content_manifest.gd`, `test_diagnostics_simulation.gd`, `test_advisor_ruler_identity.gd`, `test_law_popup.gd`, `test_content_scaffolding.gd`

### Deleted / rejected IDs
- `maybe_moon_dust_trial`, `maybe_lab_runaway`, `maybe_golden_age`, `maybe_containment_protocol` (folded into rewrite)
- `robot_cabinet_proposal`, `robot_government_installed` (replaced by AI Government 6-card chain)

---

## 2. Approved decisions (exactly 6 × 4 = 24)

| Arc | Runtime ID | Cards |
|-----|------------|------:|
| Experimental Republic | `doctor_maybe_arc` | 6 |
| Corporate State | `profit_corporate_state` | 6 |
| AI Government | `robot_government` | 6 |
| Sell the Moon | `sell_the_moon` | 6 |
| **Total** | | **24** |

### Maybe
`maybe_useful_trial`, `maybe_national_trial`, `maybe_experiment_dependence`, `maybe_ethics_fork`, `maybe_major_consequence`, `maybe_experimental_resolution`

### Profit
`profit_partnership_brief`, `profit_commercial_success`, `profit_institution_lease`, `profit_ownership_fork`, `profit_identity_crisis`, `profit_corporate_resolution`

### AI
`ai_admin_pilot`, `ai_admin_success`, `ai_authority_expand`, `ai_human_system_fork`, `ai_cabinet_crisis`, `ai_government_resolution`

### Moon
`moon_budget_proposal`, `moon_ownership_campaign`, `moon_path_fork`, `moon_international_reaction`, `moon_crisis_opportunity`, `moon_arc_resolution`

---

## 3. Branches and resolutions

| Arc | Branch A | Branch B | Branch C | Resolutions / endings |
|-----|----------|----------|----------|------------------------|
| Maybe | controlled_progress | reckless_republic | ethical_limits | Costly progress seal; `experimental_republic`; `experiment_leaves` |
| Profit | controlled_ppp | corporate_state | nationalize_reject | PPP seal; `country_is_acquired` / corporate flags; `profit_buys_retirement` |
| AI | supervised_efficiency | ai_control | shutdown_reject | Supervised seal; `ai_accepts_resignation`; clerk recovery |
| Moon | commercial_sale | science_public | diplomatic_claim | `moon_new_owner`; `accidental_moon_replacement`; shared observation |

---

## 4. Reuse / rewrite / reject / defer

| Item | Disposition |
|------|-------------|
| `doctor_maybe_arc` + `science_gamble` entry | **Rewritten** — moon fantasy removed; useful trial path |
| Old Maybe 4 cards | **Rejected** / folded into 6 |
| `robot_government` | **Promoted** minor→major; **rewritten** from 2 debug cards |
| Old robot cards | **Rejected** (removed from cat_politics) |
| Profit / Sell the Moon | **New** |
| `accidental_moon_replacement` | **Reowned** by Sell the Moon |
| `corporate_ministan` | **Strengthened** via full corporate path flags |
| Bench/garden privatize standalones | **Deferred untouched** |

---

## 5. Quality scores (Critical Reviewer)

All 24 approved cards scored **≥16/20** on the style-guide rubric (clarity, voice, choice, consequence, novelty, state, replay, visual, localization, technical). Non-zero on clarity / choice / technical / advisor voice for spoken cards.

Notable: Maybe ethics fork / resolution 17–18; Profit ownership fork 17–18; AI human-system fork 17–18; Moon Article 12 legal beat / resolution 17–18.

---

## 6. Per-arc simulations (1,000 runs, seed 20260715)

| Arc | Start rate | Completion rate |
|-----|----------:|----------------:|
| doctor_maybe_arc | 0.192 | 0.052 |
| profit_corporate_state | 0.086 | 0.036 |
| robot_government | 0.094 | 0.052 |
| sell_the_moon | 0.143 | 0.063 |

Content exhaustion: **0**. Decisions never selected: **[]**.

---

## 7. Final 5,000-run simulation (seed 20260718, Random)

| Metric | Value |
|--------|------:|
| Content exhaustion | 0 |
| Fallback usage | 1 |
| Average run length | 20.2 |
| Crisis frequency | 1966 |
| Avg completed arcs | 1.09 |
| Never-selected decisions | none |

| Arc | Start | Complete |
|-----|------:|---------:|
| doctor_maybe_arc | 0.208 | 0.066 |
| profit_corporate_state | 0.071 | 0.033 |
| robot_government | 0.103 | 0.063 |
| sell_the_moon | 0.126 | 0.056 |

Pack C ending hits (5k): `experimental_republic` 99; `experiment_leaves` 106; `country_is_acquired` 51; `profit_buys_retirement` 57; `ai_accepts_resignation` 98; `moon_new_owner` 99; `accidental_moon_replacement` 207.

Multi-strategy sims beyond Random are not implemented (same as 2B-11).

---

## 8. Rare / never-selected

- No never-selected decisions in 1k or 5k.
- Legacy minor `traffic_military` start rate remains 0 (debug_only / displaced by majors) — excluded from required-arc diagnostics.
- Profit completion lower than peers (more abandon/reject on entry) — acceptable; all three resolutions reachable via Force paths.

---

## 9. Connections

**Endings:** experimental_republic, experiment_leaves, country_is_acquired, profit_buys_retirement, ai_accepts_resignation, moon_new_owner, accidental_moon_replacement (+ corporate_ministan flag setup)

**Crises:** mass_protest (Maybe/Profit/AI); ai_cabinet_lockout; moon_ownership_dispute

**Laws:** scientific_experiment_permit, national_trial_oversight_act, privatize_air, rent_a_ministry, corporate_capital_naming, ai_cabinet_pilot, robot_civil_service, moon_replacement_research

**Affinity:** Maybe, Profit, Clerk, Penny, Olga, Luna (+ guest speakers without meters)

**Traits:** scientific, chaotic, bureaucratic, capitalist, propagandist, populist, authoritarian

**Mutex:** AI ↔ cat_politics (`government_replacement_arc`); Profit soft-blocked vs penny/hyperinflation live; Maybe/Moon soft-blocked vs maybe_reckless_path

**Follow-ups:** hard (Maybe progress path), soft (escalations), pools (`corporate_side_effects`, `moon_noise_pool`)

**Recovery / meta:** `profit_recovery_soft`, `ai_shutdown_recovery`, `moon_recovery_soft`; `palace_gift_shop_soft`, `palace_lunar_deed_meta`

---

## 10. Quotas

| Metric | Before | After |
|--------|-------:|------:|
| Approved major-arc decisions | 48 / 96 | **72 / 96** |
| Approved major arcs | 8 / 18 | **12 / 18** |
| Short-chain approved | 80 / 80 | 80 / 80 |
| Gap remaining (Pack D) | 48 | **24** |

Global major-arc target unchanged: **96**.

---

## 11. Debug / manual test paths

**Maybe:** Force `science_gamble` (fund) → `maybe_useful_trial` → national → dependence → ethics fork → consequence → resolution. Variants: progress / reckless / limits.

**Profit:** Force `profit_partnership_brief` → commercial → lease → ownership fork → identity → resolution. Variants: PPP / full / nationalize.

**AI:** Force `ai_admin_pilot` → success → expand → human-system fork → cabinet crisis → resolution. Variants: supervised / control / shutdown. Confirm blocked while `cat_politics` live.

**Moon:** Force `moon_budget_proposal` → ownership (chief_judge) → path fork → international (ambassador) → crisis → resolution. Variants: sale / research / diplomacy.

---

## 12. Minimal system fixes

- Removed narrative `step` fields from Pack C mid-cards (step-matching made soft-queued Maybe cards invalid after `science_gamble` advance).
- `science_gamble` deny now abandons arc (old containment target removed).
- Diagnostics required-arc list: drop legacy `traffic_military`; add Pack C arcs.
- Law popup / advisor trait tests updated for larger catalog and current Boom trait deltas.

---

## 13. Stop line

**Did not begin Milestone 2B-13.**
