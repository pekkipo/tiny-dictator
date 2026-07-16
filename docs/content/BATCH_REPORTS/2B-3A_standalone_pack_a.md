# Batch Report — Milestone 2B-3A Standalone Policy Pack A (Sub-batch A)

**Batch ID:** 2B-3A  
**Date:** 2026-07-15  
**Milestone:** 2B-3  
**Candidates generated:** 12  
**Integrated:** 12  
**Approved:** 12  
**Rejected:** 0  

## Quota delta

| Dimension | Before | After | Target gap |
|---|---:|---:|---:|
| Standalone approved | 0 | 12 | 60 |
| Decisions cataloged | 76 | 82 | — |
| Laws cataloged | 12 | 15 | 35 |
| Approved total | 10 | 22 | 308 |

## Final twelve Sub-batch A decisions

| # | ID | Category | Speaker | Action | Rubric |
|---|-----|----------|---------|--------|-------:|
| 1 | `privatize_rainwater` | economy | sir_profit | REWRITE | 17/20 |
| 2 | `treasury_tip_jar` | economy | minister_penny | REWRITE | 16/20 |
| 3 | `no_weekends_proposal` | economy | minister_penny | REWRITE + recat | 17/20 |
| 4 | `luxury_chair_tax` | economy | minister_penny | NEW | 17/20 |
| 5 | `neighborhood_noise_complaint` | public_life | auntie_olga | REWRITE | 17/20 |
| 6 | `olga_loyal_council` | public_life | auntie_olga | REWRITE | 17/20 |
| 7 | `national_bedtime_decree` | public_life | auntie_olga | NEW | 17/20 |
| 8 | `free_coffee_morning` | public_life | auntie_olga | NEW | 16/20 |
| 9 | `long_setup_grand_canal` | infrastructure | minister_penny | REWRITE | 16/20 |
| 10 | `sponsored_potholes` | infrastructure | sir_profit | NEW | 17/20 |
| 11 | `perfumed_sewage_reform` | infrastructure | minister_penny | NEW | 16/20 |
| 12 | `national_clock_sync` | infrastructure | clerk_zero | NEW | 17/20 |

All approved cards score ≥16/20 with no zero on clarity, choice quality, validity, or advisor voice.

## Per-card rubric scores

| ID | Clarity | Voice | Choice | Consequence | Novelty | State | Replay | Visual | L10n | Technical | Total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| privatize_rainwater | 2 | 2 | 2 | 2 | 1 | 2 | 1 | 2 | 2 | 2 | 17 |
| treasury_tip_jar | 2 | 2 | 2 | 1 | 1 | 1 | 1 | 2 | 2 | 2 | 16 |
| no_weekends_proposal | 2 | 2 | 2 | 2 | 1 | 2 | 1 | 2 | 2 | 2 | 17 |
| luxury_chair_tax | 2 | 2 | 2 | 2 | 2 | 1 | 1 | 2 | 2 | 2 | 17 |
| neighborhood_noise_complaint | 2 | 2 | 2 | 2 | 1 | 1 | 1 | 2 | 2 | 2 | 17 |
| olga_loyal_council | 2 | 2 | 2 | 2 | 1 | 2 | 2 | 2 | 2 | 2 | 17 |
| national_bedtime_decree | 2 | 2 | 2 | 2 | 2 | 1 | 1 | 2 | 2 | 2 | 17 |
| free_coffee_morning | 2 | 2 | 2 | 1 | 1 | 2 | 1 | 2 | 2 | 2 | 16 |
| long_setup_grand_canal | 2 | 2 | 2 | 1 | 1 | 2 | 1 | 2 | 2 | 2 | 16 |
| sponsored_potholes | 2 | 2 | 2 | 2 | 2 | 1 | 1 | 2 | 2 | 2 | 17 |
| perfumed_sewage_reform | 2 | 2 | 2 | 1 | 2 | 1 | 1 | 2 | 2 | 2 | 16 |
| national_clock_sync | 2 | 2 | 2 | 2 | 2 | 1 | 1 | 2 | 2 | 2 | 17 |

## Phase 0 reclassification

| ID | Action |
|----|--------|
| `cat_voting_proposal` | Deferred (duplicate) |
| `cat_parliament`, `cat_fish_budget` | Reclassified short_chain (`cat_politics_followups`) |
| `happiness_backlash`, `maybe_moon_dust_trial` | Reclassified major_arc via narrative |
| Pack B/C fill cards | Deferred for later packs |

## Simulation summary (seed 20260715, 1000 runs)

- Runs: 1000
- Average run length: 21.2
- Content exhaustion: 0
- Fallback use: 0
- Never-selected: `boom_loyal_protector`, `happiness_backlash` (pre-existing)
- Pack A selection counts: privatize_rainwater 301; treasury_tip_jar 114; no_weekends_proposal 258; luxury_chair_tax 96; neighborhood_noise_complaint 279; olga_loyal_council 52; national_bedtime_decree 281; free_coffee_morning 203; long_setup_grand_canal 260; sponsored_potholes 268; perfumed_sewage_reform 399; national_clock_sync 78
- Rare but selected: `olga_loyal_council` (affinity gate), `national_clock_sync`, `luxury_chair_tax`

## Manual paths tested

- [x] Each of 12 Pack A cards schema-valid and loadable
- [x] Soft follow-ups: coffee → bedtime; canal → potholes (fire in simulation)
- [x] Law creates: no_weekends, luxury_chair_tax, national_bedtime, national_clock_law
- [x] Affinity gate: olga_loyal_council requires auntie_olga ≥3
- [x] Standalone spot-check via simulation selection

## Rejected or deferred IDs

None newly rejected in 2B-3A. Deferred set listed under Phase 0.
