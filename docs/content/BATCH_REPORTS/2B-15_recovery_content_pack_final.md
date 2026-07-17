# Milestone 2B-15 — Recovery Content Pack Final Report

**Status:** Complete  
**Do not start:** Milestone 2B-16  
**Quota after pack:** recovery decisions **24 / 24** (exactly 6 per resource)

---

## 1. Changed files

### New
- `data/decisions/ministan_recovery_pack_a.json` (12 recovery + 4 consequences)
- `data/decisions/ministan_recovery_pack_b.json` (12 recovery + 4 consequences)
- `docs/content/MINISTAN_RECOVERY_CATALOG.md`
- `docs/content/drafts/2B-15A_recovery_pack_briefs.md`
- `docs/content/drafts/2B-15B_recovery_pack_briefs.md`
- `tests/run_2b15a_sim_2k.gd`
- `tests/run_2b15b_sim_2k.gd`
- `tests/run_2b15_sim_5k.gd`
- `docs/content/BATCH_REPORTS/2B-15A_recovery_pack.md`
- `docs/content/BATCH_REPORTS/2B-15B_recovery_pack.md`
- `docs/content/BATCH_REPORTS/2B-15_recovery_content_pack_final.md` (this file)

### Updated
- `data/decisions/ministan_stage_placeholders.json` — removed 4 Phase 2A recovery cards
- `data/countries/ministan.json` — registers recovery packs A/B
- `data/laws/laws.json` — 14 recovery-related laws
- `data/advisors/advisors.json` — guest `workers_union_leader`
- `data/visual_states/country_visual_map.json` — recovery visual tags
- `scripts/dev/ContentManifestBuilder.gd` — phase `2b_15_recovery_content_pack`, `APPROVED_RECOVERY_DECISION_IDS`
- `scripts/dev/ContentScaffoldingValidator.gd` — runtime count **326**
- Tests: content_validation, content_manifest, content_scaffolding, advisor_ruler_identity
- `data/content_manifest.json` / `docs/content/PHASE_2A_CONTENT_AUDIT.md` (regenerated)

### Minimal system fixes
- None to ContentDirector.
- Nap short-chain soft queue of `recovery_national_smile_day` removed (flag-only soft link via `civic_rest_recovery`) so `one_time` recovery gates no longer push_error when happiness is high.
- Diagnostics 1k sample allows `card_type: recovery` in never-selected allowlist; reachability enforced by 2B-15 5k sims.

---

## 2. Final six recovery decisions per resource

### Treasury (6)
1. `recovery_international_bank` — rewrite — Penny — loan + delayed interest
2. `recovery_sell_palace_wing` — new — Profit — asset sale
3. `recovery_emergency_stamp_tax` — new — Clerk Zero — emergency tax
4. `recovery_foreign_picnic_grant` — new — foreign_ambassador — foreign support
5. `recovery_austerity_clipboards` — new — Penny — austerity
6. `recovery_maybe_miracle_bond` — new — Doctor Maybe — endgame-eligible bond

### Happiness (6)
1. `recovery_national_smile_day` — rewrite — Luna — campaign + hangover
2. `recovery_olga_soup_line` — new — Olga — volunteer kitchens
3. `recovery_maybe_mood_pilot` — new — Maybe — experimental pilot
4. `recovery_workers_shift_relief` — new — workers_union_leader — shift relief
5. `recovery_civic_half_day` — new — Clerk Zero — half-day act
6. `recovery_endgame_hope_reel` — new — Luna — endgame-eligible hope reel

### Order (6)
1. `recovery_martial_law_pause` — rewrite — Boom — negotiate / pause / march
2. `recovery_olga_block_captains` — new — Olga — community captains
3. `recovery_zero_queue_charter` — new — Zero — queue charter
4. `recovery_whiskers_alley_truce` — new — Whiskers — negotiation
5. `recovery_boom_cone_grid` — new — Boom — practical cone grid
6. `recovery_endgame_quiet_hours` — new — chief_judge — endgame quiet hours

### Elite Loyalty (6)
1. `recovery_elite_dinner` — rewrite — Profit — dinner + tabloid delay
2. `recovery_cabinet_nameplates` — new — Zero — appointments
3. `recovery_controlled_audit_show` — new — Penny — anti-corruption theater
4. `recovery_prestige_fountain` — new — Profit — prestige project
5. `recovery_shared_blame_board` — new — Luna — shared blame
6. `recovery_endgame_title_lottery` — new — palace_chef — endgame title lottery

---

## 3. Disposition

| Item | Disposition |
|---|---|
| 4 Phase 2A recovery IDs | **Rewritten** in pack A (IDs kept for Nap soft link) |
| 20 new recovery decisions | **New** |
| 8 delayed consequence cards | **New** (queue_only; not recovery quota) |
| `workers_union_leader` | **New** guest advisor |
| Endgame placeholders | **Deferred** (left in stage placeholders for 2B-16) |
| Infinite `one_time: false` rescue buttons | **Rejected** / fixed |

---

## 4. Quality scores

All **24** approved recovery decisions scored **≥16/20** (authoring notes). No zero on clarity / choice / technical / advisor voice.

---

## 5. Recovery amounts and costs (primary restore options)

| Card | Target Δ | Primary costs |
|---|---:|---|
| international_bank | +18 | elite −7, happiness −2, delayed interest |
| sell_palace_wing | +16 | happiness −6 |
| emergency_stamp_tax | +14 | happiness −5, order −2 |
| foreign_picnic_grant | +15 | elite −4, delayed strings |
| austerity_clipboards | +14 | happiness −6, elite −3 |
| maybe_miracle_bond | +16 | order −4, happiness −2 |
| national_smile_day | +15 | treasury −7, delayed hangover |
| olga_soup_line | +14 | treasury −9 |
| maybe_mood_pilot | +13 | order −5, treasury −5 |
| workers_shift_relief | +14 | treasury −8, elite −3 |
| civic_half_day | +13 | treasury −5, order −3 |
| endgame_hope_reel | +15 | treasury −6, delayed hangover |
| martial_law_pause | +12/+16 | happiness/elite costs by path |
| olga_block_captains | +13 | treasury −4, elite −4 |
| zero_queue_charter | +14 | treasury −5, happiness −2 |
| whiskers_alley_truce | +13 | treasury −5, elite −3 |
| boom_cone_grid | +14 | treasury −7, delayed cones |
| endgame_quiet_hours | +15 | happiness −6 |
| elite_dinner | +15 | treasury −9, delayed tabloid |
| cabinet_nameplates | +13 | treasury −6, happiness −2 |
| controlled_audit_show | +12 | happiness −4 |
| prestige_fountain | +14 | treasury −10, happiness −4 |
| shared_blame_board | +12 | treasury −4, order −3 |
| endgame_title_lottery | +14 | treasury −8, delayed grudge |

---

## 6. Simulations

### Sub-batch A (2000, seed 20260721)
Exhaustion 0 · Fallback 5 · Avg length 17.4 · All 12 Pack A recovery IDs selected

### Sub-batch B (2000, seed 20260722)
Exhaustion 0 · Fallback 9 · Avg length 17.6 · All 12 Pack B recovery IDs selected

### Final (5000, seed 20260723)
| Metric | Value |
|---|---|
| Exhaustion | 0 |
| Fallback | 28 |
| Avg run length | 17.9 |
| Crisis frequency | 2648 |
| Recovery never selected | **none** |

**Dominant (high pick):** treasury recoveries + miracle bond (bank 383, wing 341, stamp 311, picnic 315, miracle 499)  
**Rare but reachable:** quiet_hours 4, cabinet_nameplates 3, zero_queue 3, block_captains 5  
**No infinite recovery loops:** all recovery cards `one_time: true`

Generic resource endings remain reachable (recovery does not erase failure). Fallback share remains low vs run volume.

---

## 7. Strong-launch quotas (post 2B-15)

| Class | Approved | Target |
|---|---:|---:|
| Onboarding | 10 | 10 |
| Standalone | 63 | 72 |
| Short chain | 80 | 80 |
| Major arc | 96 | 96 |
| Crisis | 28 | 28 |
| **Recovery** | **24** | **24** |
| Endgame | 0 | 20 |
| Decisions total | 301 | 330 |

Runtime decisions loaded: **326**.

---

## 8. Manual low-resource test scenarios

```text
# Treasury stress
set resources treasury=15 happiness=50 order=50 elite_loyalty=50
# expect treasury recovery pool (bank/wing/stamp/picnic/clipboards/miracle by day)

# Happiness stress
set resources treasury=50 happiness=15 order=50 elite_loyalty=50

# Order stress
set resources treasury=50 happiness=50 order=15 elite_loyalty=50

# Elite stress
set resources treasury=50 happiness=50 order=50 elite_loyalty=15

# After choosing a recovery path, advance day and confirm same card does not reappear (one_time)
# Soft follow-ups: bank interest, smile hangover, parade sulk, dinner tabloid, grant strings, hope hangover, cone gridlock, title grudge
```

---

## 9. Cross-pack confirmation

- All 8 main advisors used
- Guests: ambassador, workers_union_leader, chief_judge, palace_chef (≥4)
- All four run stages covered; ≥1 endgame-eligible per resource
- Laws, affinity, traits, delayed downsides, state variants, 3-option cards, crisis/arc/ending nudges met across A+B
- Exact total approved recovery decisions: **24**

---

**Do not start Milestone 2B-16.**
