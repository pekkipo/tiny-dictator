# Phase 3 Visual Asset Inventory

**Source milestone:** 2B-17  
**Purpose:** Production-ready placeholder inventory for art. No final graphics in this milestone.

## Summary counts

| Asset class | Unique keys | Reusable / shared | Notes |
|---|---:|---:|---|
| Advisor portrait sets | 8 | — | Main advisors |
| Advisor expressions | 5 per set (40) | Shared pose template | Neutral, pleased, worried, smug, panicked |
| Guest speaker portraits | 6 | Reuse expression set | Optional Phase 3 polish |
| Law icons | 50 | Shared frame | One per approved law (`law_<id>`) |
| City props (law visual tags) | ~45 | Many tags shared across laws | From `country_visual_map.json` |
| Crisis effect overlays | 18 | Shared VFX kit | One primary effect per crisis |
| Palace upgrade states | 24 | Room backdrop reuse | `palace_<upgrade_id>` |
| Ending illustrations | 50 | Shared newspaper frame | `ending_<id>` |
| Reusable overlays | 12 | — | Flags, applause, blackout, smoke, confetti, forms rain, etc. |

**Estimated unique art commissions:** ~140  
**Estimated reusable templates/kits:** ~20

## 8 advisor portrait sets

1. `general_boom`
2. `minister_penny`
3. `luna_news`
4. `auntie_olga`
5. `doctor_maybe`
6. `sir_profit`
7. `comrade_whiskers`
8. `clerk_zero`

### Required expressions (each set)

- `neutral`
- `pleased`
- `worried`
- `smug`
- `panicked`

## 50 law icons

Keys: `law_<law_id>` for every entry in `data/laws/laws.json`.  
Placeholder emoji already present via `placeholder_icon`.

## City props associated with laws

All `visual_tags` on approved laws must map in `data/visual_states/country_visual_map.json`.  
Examples: `bricked_windows`, `pizza_stalls`, `traffic_tanks`, `cats_in_square`, `ministry_of_forms`, `nap_grid_cots`.

## Crisis effects

One primary overlay key per crisis definition (18), e.g. `crisis_fx_national_power_outage`, plus shared kit pieces (`smoke`, `crowd`, `sirens`).

## Palace-upgrade states

Keys: `palace_<upgrade_id>` for all 24 upgrades across:

- throne_room (6)
- propaganda_room (4)
- emergency_bunker (4)
- office_bureaucracy (4)
- science_laboratory (3)
- cat_related (3)

## Ending illustration keys

Keys: `ending_<ending_id>` for all 50 collectible endings.  
Newspaper masthead reuse: `THE MINISTAN TIMES` frame + headline plate.

## Reusable overlays

1. applause burst  
2. blackout vignette  
3. parade confetti  
4. form rain  
5. fish splash  
6. tank silhouette  
7. smile meter  
8. stamp slam  
9. moon swap flash  
10. toaster spark  
11. bunker hatch  
12. cat nap Zzz  

## Unique vs reusable guidance

- Prefer unique hero art for secret endings and major-arc finales.
- Reuse newspaper frame, resource-failure stamp set, and advisor expression templates.
- Palace rooms share base plates; upgrades are layer deltas.
