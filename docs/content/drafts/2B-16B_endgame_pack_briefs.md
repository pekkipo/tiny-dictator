# Milestone 2B-16B — Endgame Pack Sub-batch B Briefs

**Target:** 10 approved endgame decisions  
**Prerequisite:** Sub-batch A validated.

## Roster

### General arc-resolution (4)
1. **`endgame_succession_debate`** (rewrite) — Zero. Multi-path succession / competent successor ending.
2. **`endgame_final_audit`** (rewrite) — Penny. Publish / seal / mercy audit; ambiguous positive path.
3. **`endgame_profit_zero_ownership`** — Profit. Corporate seals vs forms government contradiction.
4. **`endgame_cabinet_loyalty_ledger`** — Palace Chef. Affinity-dependent cabinet finale.

### Rare success (2)
5. **`endgame_peaceful_democracy_seal`** — Chief Judge. Election-arc seals → democracy endings.
6. **`endgame_scientific_golden_age`** — Maybe. Science/AI/sun stack → `scientific_golden_age`.

### Ruler climax (2)
7. **`endgame_climax_cat_servant`** — Whiskers. cat_friendly≥5; cat-law callbacks; 2+ endings.
8. **`endgame_climax_technocratic_accident`** — Maybe. scientific≥4; experiment callbacks; 2+ endings.

### Secret (2)
9. **`endgame_secret_palace_micronation`** — Profit. Palace reno/tour laws → palace micronation ending.
10. **`endgame_secret_forms_awaken`** — Zero. Forms complete + form laws → forms awaken ending.

## Debug paths

```text
debug set day 28
# Succession / audit: endgame stage only
# Profit vs Zero: flags profit_corp_complete zero_forms_complete
# Cabinet ledger: affinity any advisor ≥3
# Democracy: election_arc_complete
# Golden age: artificial_sun_success OR ai_gov_complete + scientific trait
# Cat servant: trait cat_friendly=5 + cat laws
# Technocratic: trait scientific=5
# Palace micronation: palace_reno_complete + palace_public_tour_act
# Forms awaken: zero_forms_complete + form_sovereignty_act
```
