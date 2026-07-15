# Batch Report — Milestone 2B-2 First-Run and Onboarding Pack

**Batch ID:** 2B-2  
**Date:** 2026-07-15  
**Target:** 10 approved onboarding decisions  

## Pre-integration inventory

| Metric | Before | After |
|--------|-------:|------:|
| Manifest onboarding class | 3 | 10 |
| ONBOARDING_IDS provisional | 6 | 10 (exact) |
| New runtime decisions | — | +2 net (+3 new, −1 moved from generic) |

## Final ten onboarding decisions

| # | ID | Role | Action | Rubric |
|---|-----|------|--------|-------:|
| 1 | `palace_roof_leak` | Palace maintenance | **NEW** | 18/20 |
| 2 | `border_parade_dispute` | General Boom first proposal | **REWRITE** | 17/20 |
| 3 | `window_tax_proposal` | Minister Penny cheap solution | **REWRITE** v2 | 17/20 |
| 4 | `olga_bridge_repair` | Auntie Olga complaint | **RECLASSIFY** | 16/20 |
| 5 | `luna_good_news_only` | Luna reframes problem | **REWRITE** v2 | 18/20 |
| 6 | `science_gamble` | Doctor Maybe experiment | **RECLASSIFY** | 17/20 |
| 7 | `privatize_palace_garden` | Sir Profit privatization | **RECLASSIFY** | 17/20 |
| 8 | `cat_treaty_offer` | Comrade Whiskers petition | **RECLASSIFY** | 17/20 |
| 9 | `bureaucracy_expansion` | Clerk Zero forms | **RECLASSIFY** | 16/20 |
| 10 | `pantry_moth_crisis` | Crisis / delayed resolution | **NEW** | 17/20 |

All approved cards score ≥16/20 with no zero on clarity, choice quality, validity, or advisor voice.

## Rejected candidates

| ID | Score | Reason |
|----|------:|--------|
| `free_pizza_friday` | 17/20 | Rejected from pack — soft follow-up covered by `science_gamble`; avoids duplicate chain teaching |
| `no_weekends_proposal` | 16/20 | Rejected — overlaps Penny slot; harsher early happiness hit |
| `military_parade` | 15/20 | Rejected — arc forced chain; fails choice-quality gate for onboarding |
| `army_snack_budget` | 14/20 | Rejected — arc-gated; not reachable day 1–3 |
| `parade_budget_boost` | 14/20 | Rejected — arc-gated |
| `budget_meltdown_crisis` | 12/20 | Rejected — deferred placeholder; unsafe early endings |
| `switch_off_traffic_lights` | 14/20 | Rejected — major arc hard follow-up on day 1 pool |

## Concept coverage

| Concept | Primary card(s) |
|---------|-----------------|
| resources | `palace_roof_leak` |
| visible_effects | `luna_good_news_only` |
| hidden_consequences | `luna_good_news_only`, `window_tax_proposal` |
| laws | `window_tax_proposal` |
| advisors | all 10 |
| affinity_feedback | `border_parade_dispute`, `privatize_palace_garden`, `cat_treaty_offer`, `science_gamble` |
| ruler_traits | `science_gamble`, `privatize_palace_garden`, `bureaucracy_expansion` |
| delayed_followups | `science_gamble` |
| hard_followups | `pantry_moth_crisis` (mandatory crisis resolution) |
| crises | `pantry_moth_crisis` |
| endings_replay | RunEndScreen first-run hint |
| no_perfect_option | `palace_roof_leak`, `olga_bridge_repair` |

## Manual first-run test

1. Reset save (`user://save.json` or debug reset).
2. Start Ministan — resource hint on day 1.
3. Within ~5 decisions, see an onboarding card; no tutorial wall-of-text.
4. Pass window tax — “New law” in result + laws hint.
5. Luna good-news path — happiness shown on card; order drop in result.
6. Fund science gamble — Doctor affinity line; queued follow-up within 5 days.
7. Resolve `pantry_moth_crisis` — crisis banner, 3 options, crisis clears.
8. Advisor feedback lines only — no numeric affinity/trait values.
9. End run — RunEndScreen replay/endings line on first completion.
10. Second run — onboarding cards appear less often; run still playable.
