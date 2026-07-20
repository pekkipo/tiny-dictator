# Milestone 2B-17 — Pre-Implementation Audit

**Date:** 2026-07-17  
**Baseline phase:** 2B-16 complete

## Counts

| Catalog | Runtime | Manifest status | Target |
|---|---:|---|---:|
| Laws | 106 | 106 integrated, 0 approved | 50 |
| Endings | 53 | 53 integrated, 0 approved | 50 |
| Palace upgrades | 3 | 3 needs_rewrite | 24 |
| Decisions (approved) | — | **321** | 330 (gap −9 standalone → 2B-18) |
| Decisions (runtime) | 343 | — | keep; no net new approved |

## Laws

- **Never activated:** `flag_traffic_law` (no `add_laws` reference).
- **Thin interaction (<2 req gates):** 88 of 106 (many are enacted but rarely gate later cards).
- **PRD gaps (missing IDs):** `universal_birthday`, `cat_parliament_seats`, `official_nap_zones`.
- **Near-aliases present:** `luxury_chair_tax`, `national_coffee_reserve`, `compliment_quota_law`, `queue_etiquette_law`, `palace_curfew_act`, `emergency_salute_law`, `antigravity_transit`, `sponsored_potholes_act`, `complaint_permit_act`, `fish_market_subsidy_act`, `antivacuum_act`, `mouse_protection_law`.

## Endings

- No `rarity`, `archive_hint`, `subtitle`, or complete `illustration_key` coverage.
- Near-duplicates: `cat_republic` vs `purrfect_transfer`.
- Runtime-only / non-collectible candidates: `survived_the_prototype` (survival), `content_exhausted` (fallback), `nation_in_darkness` (empty conditions / crisis-only).
- Secrets already wired (2B-16): toaster, wrong_map, palace_micronation, forms_become_citizens (need 6 total).

## Palace

- Placeholders only: `gold_desk` (5), `propaganda_studio` (10), `emergency_bunker` (15).
- No categories, no content unlocks, no visual keys beyond emoji.

## Decision total confirmation

Approved decisions remain **321** before 2B-17 edits. This milestone must not add net new approved decisions.

## Curation plan summary

1. Keep/rename 47 existing PRD-aligned laws; add 3 missing; cut 56 extras with thematic remaps.
2. Curate endings 53→50 collectible; assign rarity 12/18/14/6.
3. Expand palace 3→24 with ≥8 content unlocks.
4. Patch decision law refs; strengthen ≥2 interactions per retained law.
