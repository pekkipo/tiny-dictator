# Milestone 2B-15A — Recovery Pack Sub-batch A Briefs

**Target:** 12 approved recovery decisions (3 per resource) + 4 delayed consequence cards  
**Do not start Sub-batch B until A validation + 2k sims + manual paths pass.**

## Quality bar

All recovery cards ≥16/20. Target resource +8…+20 on at least one option. Meaningful cost elsewhere. `one_time: true`. Visual tags required.

## Roster

### Treasury
1. **`recovery_international_bank`** (rewrite) — Penny. Loan with haiku interest; delayed debt callback; elite/law cost. Stages: establishment–escalation.
2. **`recovery_sell_palace_wing`** — Profit. Sell a wing to tourists; happiness/identity cost; ending flag `palace_wing_sold`.
3. **`recovery_emergency_stamp_tax`** — Clerk Zero. Emergency stamp tax; affinity gate on Zero; three options.

### Happiness
4. **`recovery_national_smile_day`** (rewrite) — Luna. Keep Nap soft link. Campaign + smile hangover delay. Law: fake smile standard path.
5. **`recovery_olga_soup_line`** — Olga. Volunteer kitchens; treasury cost; community order bump optional.
6. **`recovery_maybe_mood_pilot`** — Maybe. Experimental mood pilot; trait scientific; order risk path.

### Order
7. **`recovery_martial_law_pause`** (rewrite) — Boom. Three options: negotiate schedule, temporary pause law, keep marching (no recovery). Freedom-law cost on hard path.
8. **`recovery_olga_block_captains`** — Olga. Neighborhood block captains; soft enforcement alternative.
9. **`recovery_zero_queue_charter`** — Zero. Queue charter law; bureaucratic stabilize; crisis flag optional.

### Elite Loyalty
10. **`recovery_elite_dinner`** (rewrite) — Profit. Dinner + delayed tabloid leak.
11. **`recovery_cabinet_nameplates`** — Zero. Appointments / shared responsibility.
12. **`recovery_controlled_audit_show`** — Penny. Anti-corruption theater; state-dependent on austerity/recovery flags.

### Delayed consequences (queue_only)
- `recovery_bank_interest_haiku`
- `recovery_smile_hangover`
- `recovery_parade_sulk`
- `recovery_dinner_tabloid`

## Manual low-resource scenarios

```text
# Treasury ≤20 → expect bank / wing / stamp cards eligible
debug set resources treasury=15 happiness=50 order=50 elite_loyalty=50

# Happiness ≤20
debug set resources treasury=50 happiness=15 order=50 elite_loyalty=50

# Order ≤20 (reachability focus)
debug set resources treasury=50 happiness=50 order=15 elite_loyalty=50

# Elite ≤20
debug set resources treasury=50 happiness=50 order=50 elite_loyalty=15
```

Force each Pack A recovery ID via debug queue if needed; verify one_time blocks re-select.
