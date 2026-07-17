# Milestone 2B-16A — Endgame Pack Sub-batch A Briefs

**Target:** 10 approved endgame decisions  
**Do not start Sub-batch B until A validation + 2k sims + manual paths pass.**

## Quality bar

All cards ≥16/20. `card_type`: `resolution` or `ending_setup`. Stage: primarily `endgame`. `one_time: true`. No long arcs. Visual tags required. No trait numbers in copy.

## Roster

### General arc-resolution (4)
1. **`endgame_media_forms_convergence`** — Zero. Requires `luna_media_complete` + `zero_forms_complete` (or endgame media/admin stables). Three options: merge broadcast forms, separate ministries, ambiguous filing truce. Callbacks to Luna/Zero arcs.
2. **`endgame_boom_olga_ceasefire`** — Olga. Requires `boom_arc_complete` + `olga_movement_complete` with affinity tension (Boom high OR Olga high). Contradiction payoff: street charter vs parade peace vs shared plaza. Affinity variants on options.
3. **`endgame_civic_stack_verdict`** — Chief Judge. Requires ≥2 of queue/compliment/complaint laws. Multi-resolution civic verdict; positive/ambiguous path.
4. **`endgame_legacy_statue`** (rewrite) — Boom. Requires `boom_arc_complete` or parade/martial law. Three options: bronze horse, modest plaque, living garden memorial (positive/ambiguous).

### Rare success (2)
5. **`endgame_beloved_retirement`** — Olga. High happiness + `festival_econ_complete` or `endgame_festival_stable` / civic love flags → `trigger_ending: beloved_retirement`.
6. **`endgame_country_somehow_works`** — Penny. Multi-resource floor + ≥2 complete-arc seals → new ending `country_somehow_works`.

### Ruler-identity climax (2)
7. **`endgame_climax_smiling_tyrant`** — Luna. `minimum_traits` authoritarian≥4, propagandist≥3. Two ending variants (seal smile state vs soft abdication broadcast).
8. **`endgame_climax_spreadsheet_emperor`** — Penny. `minimum_traits` bureaucratic≥4. Ledger finale: spreadsheet_state vs balanced mercy ending.

### Secret (2)
9. **`endgame_secret_toaster_election`** — Maybe. Requires `predictive_toaster_act` + used `predictive_toaster_admin`. Ending `toaster_elected_president`. Debug: force law + decision used + day 28.
10. **`endgame_secret_wrong_map`** — Foreign Ambassador. Requires border/cheese/trade flags (`endgame_trade_stable` or cheese complete or border parade). Ending `wrong_map_republic`.

## Manual / debug paths

```text
# Endgame day
debug set day 28

# Media+forms convergence
debug add flags luna_media_complete zero_forms_complete endgame_media_stable endgame_admin_stable

# Boom/Olga ceasefire
debug add flags boom_arc_complete olga_movement_complete
debug set affinity general_boom 3 auntie_olga 3

# Civic stack
debug add laws queue_etiquette_law compliment_quota_law complaint_permit_act

# Beloved retirement
debug set resources happiness=75
debug add flags festival_econ_complete beloved_retirement_ready

# Country somehow works
debug set resources treasury=55 happiness=55 order=55 elite_loyalty=55
debug add flags penny_austerity_complete traffic_mil_complete endgame_economy_stable

# Smiling tyrant climax
debug set traits authoritarian=5 propagandist=4

# Spreadsheet emperor climax
debug set traits bureaucratic=5

# Toaster secret
debug add laws predictive_toaster_act
debug mark used predictive_toaster_admin

# Wrong map secret
debug add flags cheese_arc_complete endgame_trade_stable
```

Force each Pack A ID via debug queue; verify `one_time` and ending triggers.
