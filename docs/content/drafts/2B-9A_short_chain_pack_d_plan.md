# Draft Plan — Milestone 2B-9 Sub-batch A

**Batch ID:** 2B-9A  
**Target:** 10 approved short-chain decisions across 4 chains  
**Status:** Ready for integration  

## Critical review notes

- Coupons: salary/economy path only — distinct from Pack B rest coupons / science coupons.
- Perfumed Sewage: absorb standalone `perfumed_sewage_reform`; consequence is health/budget/pipes, not smell-only jokes.
- Forms: Kafka escalation + efficiency resolution at real cost; seed `government_by_form` ending flags.
- Fish Currency: distinct from `fish_market_subsidy`; include initially successful unstable path; crisis on collapse.
- Sub-batch B cards stay out until A report exists.
- Pizza legacy still deferred.

## Sub-batch A inventory

| ID | Action | Chain | Speaker | Stage | Follow-up | Visual tag |
|----|--------|-------|---------|-------|-----------|------------|
| `coupon_salaries_proposal` | NEW | salaries_paid_in_coupons | minister_penny | establishment | soft → market | `coupon_pay_stubs` |
| `coupon_salary_market` | NEW | salaries_paid_in_coupons | sir_profit | establishment | completes | `coupon_black_market` |
| `perfumed_sewage_pilot` | NEW (absorb) | perfumed_sewage | doctor_maybe | escalation | soft → fallout | `scent_manhole_covers` |
| `perfumed_sewage_fallout` | NEW | perfumed_sewage | auntie_olga | escalation | completes | `pipe_repair_crews` |
| `form_request_forms_proposal` | NEW | form_to_request_forms | clerk_zero | establishment | hard → backlog | `meta_form_desk` |
| `form_request_forms_backlog` | NEW | form_to_request_forms | clerk_zero | establishment | soft → resolution | `form_backlog_towers` |
| `form_request_forms_resolution` | NEW | form_to_request_forms | minister_penny | establishment | completes / ending | `efficiency_desk_plaque` |
| `fish_currency_proposal` | NEW | fish_currency_experiment | comrade_whiskers | escalation | pool → boom | `fish_scrip_booth` |
| `fish_currency_boom` | NEW | fish_currency_experiment | sir_profit | escalation | soft → resolution | `fish_exchange_board` |
| `fish_currency_resolution` | NEW | fish_currency_experiment | comrade_whiskers | escalation | completes / crisis | `fish_peg_stabilizer` |

## Chain structure

### Salaries Paid in Coupons (2) — soft + state-dependent
1. Penny: store-credit coupons vs tradable coupons; law `coupon_salaries`.
2. Soft market (Profit): black-market vs morale depends on coupon type flags; clawback / convert / formalize.

### Perfumed Sewage (2) — soft
1. Maybe: scent pilot vs limited repair; law `scent_mask_act`.
2. Soft fallout (Olga): public-health / budget / pipe consequence; real repair / regulate / scrap.

### Form to Request Forms (3) — hard + soft + ending
1. Clerk meta-form law `form_request_form_act`.
2. Hard backlog escalation.
3. Soft resolution: deepen / efficiency (cost + `government_by_form` flags) / repeal.

### Fish Currency Experiment (3) — pool + soft + crisis
1. Whiskers fish-backed scrip; law `fish_currency_act`; blocked if `fish_market_subsidy_act` live optional soft block via flag.
2. Pool boom: initially successful unstable market.
3. Soft resolution: stabilize / emergency reserve / abandon (+`bank_run` crisis).

## Mechanical quota (A toward full Pack D)

- Speakers A: Penny, Profit, Maybe, Olga, Clerk, Whiskers (6)
- Laws: coupon_salaries, scent_mask_act, form_request_form_act, fish_currency_act
- Soft: coupons, sewage, forms resolution link; Hard: forms backlog; Pool: fish_currency_consequences
- Three-option: coupon market, sewage fallout, forms resolution, fish resolution
- State-dependent: coupon store-credit vs tradable market text/flags
- Ending seed: government_by_form
- Crisis modifier: fish abandon → bank_run

## Joke structure tags

- `coupon_salaries`
- `perfumed_sewage`
- `form_request_forms`
- `fish_currency`

## Absorb / supersede

- Remove standalone `perfumed_sewage_reform` from `ministan_standalone_pack_a.json` and from standalone approved lists.
