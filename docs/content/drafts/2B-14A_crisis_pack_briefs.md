# Milestone 2B-14A — Crisis Pack Sub-batch A Briefs

**Target:** 9 crises / 14 decisions (5×2 + 4×1)  
**Do not start Sub-batch B until A validation + 2k sims + manual paths pass.**

## Inventory

| Crisis | Structure | Entry | Resolution |
|---|---|---|---|
| National Power Outage | 2 | `national_power_outage` | `national_power_outage_resolution` |
| Bank Run | 2 | `bank_run` | `bank_run_resolution` |
| Mass Protest | 2 | `mass_protest` | `mass_protest_resolution` |
| Palace Fire | 2 | `palace_fire` | `palace_fire_resolution` |
| Military Mutiny | 2 | `military_mutiny` | `military_mutiny_resolution` |
| Government Data Leak | 1 | `government_data_leak` | — |
| Cat Occupation of Parliament | 1 | `cat_parliament_occupation` | — |
| Water Supply Turns Blue | 1 | `water_supply_turns_blue` | — |
| Public Transport Strike | 1 | `public_transport_strike` | — |

## Quality bar

All cards authored ≥16/20 (clarity, voice, choice, consequence, novelty, state, replay, visual, localization, technical).

## Debug-force paths

```text
debug_force_crisis("<crisis_id>")
# two-card: play entry option → mandatory resolution card
# fail/timeout: debug_advance_crisis_duration / fail options
```
