# Milestone 2B-14 — Crisis Content Pack Final Report

**Status:** Complete  
**Do not start:** Milestone 2B-15  
**Quota after pack:** crisis decisions **28 / 28**; crisis definitions **18 / 18** (plus non-quota `pantry_moth_crisis`)

---

## 1. Changed files

### New
- `data/decisions/ministan_crisis_pack_a.json` (14)
- `data/decisions/ministan_crisis_pack_b.json` (14)
- `docs/content/drafts/2B-14A_crisis_pack_briefs.md`
- `docs/content/drafts/2B-14B_crisis_pack_briefs.md`
- `tests/run_2b14a_sim_2k.gd`
- `tests/run_2b14b_sim_2k.gd`
- `tests/run_2b14_sim_5k.gd`
- `docs/content/BATCH_REPORTS/2B-14A_crisis_pack.md`
- `docs/content/BATCH_REPORTS/2B-14B_crisis_pack.md`
- `docs/content/BATCH_REPORTS/2B-14_crisis_content_pack_final.md` (this file)

### Updated
- `docs/content/MINISTAN_CRISIS_CATALOG.md` — 2B-14 structure, dispositions, sub-batches
- `data/crises/ministan_crises.json` — 18 approved + pantry; `resolution_decision_id` on 2-card crises
- `data/decisions/ministan_crises.json` — emptied (content moved to packs)
- `data/decisions/ministan_core.json` — removed deferred `budget_meltdown_crisis`
- `data/countries/ministan.json` — registers pack A/B decision files
- `scripts/core/CrisisManager.gd` — two-card mandatory handoff via `resolution_decision_id`
- `scripts/core/ContentValidator.gd` — validate resolve/fail paths against resolution card when set
- `docs/08_PHASE_2A_CONTENT_SCHEMA_REFERENCE.md` — document `resolution_decision_id`
- `scripts/dev/ContentManifestBuilder.gd` — phase `2b_14_crisis_content_pack`, crisis approvals
- `scripts/dev/ContentScaffoldingValidator.gd` — runtime count 298
- `data/content_manifest.json` / `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)
- Tests: crisis_manager, content_validation, content_manifest, content_scaffolding, diagnostics_simulation, manual_path_verification, schema_v2

### Minimal system fix
Optional crisis field `resolution_decision_id`. After entry is used, `get_mandatory_decision_id` returns the resolution card while the crisis remains active. Validator checks resolution/failure option IDs against that card. No CrisisManager redesign beyond this handoff.

---

## 2. Final crisis inventory (18 + pantry)

### Two-decision crises (10 → 20 cards)

| Crisis ID | Entry | Resolution |
|---|---|---|
| `national_power_outage` | `national_power_outage` | `national_power_outage_resolution` |
| `bank_run` | `bank_run` | `bank_run_resolution` |
| `mass_protest` | `mass_protest` | `mass_protest_resolution` |
| `palace_fire` | `palace_fire` | `palace_fire_resolution` |
| `military_mutiny` | `military_mutiny` | `military_mutiny_resolution` |
| `cheese_shortage_crisis` | `cheese_shortage_crisis` | `cheese_shortage_crisis_resolution` |
| `international_border_confusion` | `international_border_confusion` | `international_border_confusion_resolution` |
| `bureaucrat_general_strike` | `bureaucrat_general_strike` | `bureaucrat_general_strike_resolution` |
| `national_internet_outage` | `national_internet_outage` | `national_internet_outage_resolution` |
| `fake_news_panic` | `fake_news_panic` | `fake_news_panic_resolution` |

### One-decision crises (8)

| Crisis ID | Decision |
|---|---|
| `government_data_leak` | `government_data_leak` |
| `cat_parliament_occupation` | `cat_parliament_occupation` |
| `water_supply_turns_blue` | `water_supply_turns_blue` |
| `public_transport_strike` | `public_transport_strike` |
| `budget_meltdown` (Currency Collapse) | `budget_meltdown_crisis` |
| `ai_cabinet_lockout` | `ai_cabinet_lockout` |
| `moon_ownership_dispute` | `moon_ownership_dispute` |
| `national_festival_stampede` | `national_festival_stampede` |

### Non-quota
`pantry_moth_crisis` — onboarding only.

---

## 3. Disposition

| Item | Disposition |
|---|---|
| Power / Bank / Protest / Cheese / Cat / AI / Moon / Festival | **Rewritten** |
| Power / Bank / Protest / Cheese | **Expanded** to 2-card |
| `budget_meltdown` | **Promoted** as Currency Collapse (runtime ID kept) |
| Palace Fire, Data Leak, Mutiny, Border, Bureaucrat, Internet, Blue Water, Transport, Fake News | **New** |
| `pantry_moth_crisis` | **Deferred from quota** (kept) |
| Old one-card resolve-on-entry patterns for expanded crises | **Superseded** |

---

## 4. Resolution / failure summary (high level)

| Crisis | Success paths | Failure / timeout |
|---|---|---|
| Power outage | Hospital restore; TV science generator | Palace glow → `nation_in_darkness`; timeout same |
| Bank run | Deposit guarantee; emergency loan | Close banks → `bankrupt_leader` |
| Mass protest | Civic pact; local fixes | Crackdown → `revolution`; timeout → `chaos_country` |
| Palace fire | Brigade; open gates | Ignore → `palace_beautiful_empty` |
| Military mutiny | Service charter; Boom mascot | Arrest → `general_boom_coup` |
| Data leak | Publish / security | Blame printer (soft) |
| Cat parliament | Gallery / fish compact | Move parliament → `cat_republic` |
| Blue water | Test / tankers | Brand → `experiment_leaves` |
| Transport strike | Negotiate / bikes | Tank buses (soft) |
| Cheese | Import / ration | Cancel Pizza Friday (soft) |
| Border | Treaty / picnic | Claim everything (soft) |
| Bureaucrat strike | Charter / simplify forms | Boxes → `government_by_form` |
| Internet | Repair / mesh | Unplug (soft) |
| Fake news | Show work / rumor lessons | Ban questions (soft) |
| Currency collapse | Freeze luxury / merch | Coupons → `bankrupt_leader` |
| AI lockout | Dual key / optimize | Smash terminal (soft) |
| Moon dispute | Share / picnic | Sell rights → `moon_new_owner` |
| Festival stampede | Exits / stagger shows | More fireworks (soft) |

---

## 5. Quality scores

All **28** approved crisis decisions scored **≥16/20** (clarity, voice, choice, consequence, novelty, state, replay, visual hook, localization readiness, technical). Cat occupation rebalanced after a dominant-choice diagnostic hit.

---

## 6. Simulations

### Sub-batch A (2000, seed 20260717)
Exhaustion 0; fallback 11; crisis frequency 1011; all 14 A cards activated.

### Sub-batch B (2000, seed 20260718)
Exhaustion 0; fallback 7; crisis frequency 1010; all 14 B cards activated; never-selected empty.

### Final (5000, seed 20260720)
Exhaustion **0**; fallback 16; crisis frequency **2578**; **all 28 crisis cards activated**; never-selected empty. Military mutiny still rarer (44/34) but present after gate softening.

---

## 7. Strong-launch quotas (post-2B-14)

| Class | Approved | Target |
|---|---:|---:|
| Onboarding | 10 | 10 |
| Standalone | 63 | 72 |
| Short-chain | 80 | 80 |
| Major-arc | 96 | 96 |
| **Crisis** | **28** | **28** |
| Recovery | 0 | 24 |
| Endgame | 0 | 20 |
| **Crisis definitions** | **18** | **18** |
| Major arcs | 18 | 18 |
| Short chains | 32 | 32 |

Runtime decisions loaded: **298**.

---

## 8. Debug / manual test paths

```text
debug_force_crisis("<crisis_id>")
# Two-card: choose entry option → Content Director forces resolution_decision_id
debug_advance_crisis_duration(n)  # toward timeout
debug_resolve_crisis / debug_fail_crisis
```

Covered by `tests/test_crisis_manager.gd` (two-card handoff) and `tests/test_manual_path_verification.gd` (all 18 force paths).

---

## 9. Totals confirmation

- Approved crisis definitions: **18**
- Approved crisis-class decisions: **28**
- Two-decision crises: **10**
- One-decision crises: **8**
- Do **not** start Milestone 2B-15.
