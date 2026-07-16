# Batch Report — Milestone 2B-3B Standalone Policy Pack A (Sub-batch B)

**Batch ID:** 2B-3B  
**Date:** 2026-07-15  
**Milestone:** 2B-3  
**Candidates generated:** 12  
**Integrated:** 12  
**Approved:** 12  
**Rejected:** 0  

## Quota delta

| Dimension | Before (after 2B-3A) | After | Target gap |
|---|---:|---:|---:|
| Standalone approved | 12 | **24** | 48 |
| Economy standalone approved | 4 | **8** | — |
| Public life standalone approved | 4 | **8** | — |
| Infrastructure standalone approved | 4 | **8** | — |
| Decisions cataloged | 82 | 94 | — |
| Laws cataloged | 15 | 18 | 32 |

## Final twelve Sub-batch B decisions

| # | ID | Category | Speaker | Action | Rubric |
|---|-----|----------|---------|--------|-------:|
| 1 | `commemorative_debt_sale` | economy | sir_profit | NEW | 17/20 |
| 2 | `lottery_treasury_fund` | economy | sir_profit | NEW | 17/20 |
| 3 | `wage_freeze_mandate` | economy | minister_penny | NEW | 17/20 |
| 4 | `palace_room_rental` | economy | sir_profit | NEW | 16/20 |
| 5 | `official_queue_etiquette` | public_life | clerk_zero | NEW | 17/20 |
| 6 | `universal_birthday_holiday` | public_life | luna_news | NEW | 17/20 |
| 7 | `public_compliment_quota` | public_life | luna_news | NEW | 16/20 |
| 8 | `absurd_civic_sweeping` | public_life | auntie_olga | NEW | 17/20 |
| 9 | `flag_traffic_system` | infrastructure | general_boom | NEW | 17/20 |
| 10 | `elevator_wifi_mandate` | infrastructure | doctor_maybe | NEW | 17/20 |
| 11 | `palace_bus_routes` | infrastructure | minister_penny | NEW | 17/20 |
| 12 | `bridge_toll_concession` | infrastructure | sir_profit | NEW | 17/20 |

## Soft follow-up wiring updates

- `free_coffee_morning` → soft `absurd_civic_sweeping`
- `long_setup_grand_canal` → soft `palace_bus_routes`
- `lottery_treasury_fund` → soft `universal_birthday_holiday`
- `universal_birthday_holiday` → soft `public_compliment_quota`

## Simulation summary (seed 20260715, 1000 runs)

- Runs: 1000
- Average run length: 23.5
- Content exhaustion: 0
- Fallback use: 0
- Never-selected: `boom_loyal_protector`, `happiness_backlash` (pre-existing; not Pack A)
- All 24 Pack A cards selected at least once (rarest: `olga_loyal_council` 65, `luxury_chair_tax` 89, `national_clock_sync` 88)

### Pack A selection counts (B-inclusive run)

| ID | Count |
|----|------:|
| privatize_rainwater | 261 |
| treasury_tip_jar | 130 |
| no_weekends_proposal | 262 |
| luxury_chair_tax | 89 |
| neighborhood_noise_complaint | 242 |
| olga_loyal_council | 65 |
| national_bedtime_decree | 223 |
| free_coffee_morning | 169 |
| long_setup_grand_canal | 232 |
| sponsored_potholes | 229 |
| perfumed_sewage_reform | 399 |
| national_clock_sync | 88 |
| commemorative_debt_sale | 430 |
| lottery_treasury_fund | 222 |
| wage_freeze_mandate | 315 |
| palace_room_rental | 145 |
| official_queue_etiquette | 243 |
| universal_birthday_holiday | 205 |
| public_compliment_quota | 258 |
| absurd_civic_sweeping | 334 |
| flag_traffic_system | 189 |
| elevator_wifi_mandate | 244 |
| palace_bus_routes | 189 |
| bridge_toll_concession | 251 |

## Manual paths tested

- [x] Schema validation for all 12 B cards
- [x] Laws: queue_etiquette_law, compliment_quota_law, flag_traffic_law
- [x] State gates: wage_freeze (treasury ≤45), palace_bus_routes (any road/canal flag), bridge_toll (endgame)
- [x] Soft queues fire in simulation
- [x] Full `run_phase_2a_qa.gd` exit 0

## Rejected or deferred IDs

None newly rejected in 2B-3B.
