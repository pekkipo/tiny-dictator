# Known Issues and Limitations — Phase 1 Prototype

Intentional scope limits (per the Phase 1 PRDs), not defects:

## Art and presentation

- All visuals are emoji/ColorRect placeholders; no final art, typography, or theme.
- No animations or tweens (delta feedback is instant text, not animated).
- No audio of any kind.
- Country diorama states are placeholder emoji rows, not the final layered scene.

## Content volume

- One country (Ministan), 17 decisions (11 core + 6 follow-ups). The PRD target
  of 24+6 is a pure-JSON authoring task with no code changes required.
- Because of the small pool, the decision pool can run dry around day 10-14.
  The fallback decision ("generic_minister_disagreement") bridges at most
  `fallback_decision_limit` days (2 for Ministan), then the run ends with the
  "An Unexpected Peace" (content_exhausted) ending. Authoring more decisions
  will push runs toward the full 30 days and the survival ending.

## Platform and export

- Desktop editor play only; no Android/iOS export configuration or testing yet.
- Portrait layout is responsive, but only spot-checked at 1080×1920 aspect ratios.

## Systems deferred beyond Phase 1

- Save system stores meta progression (Medals, Ending Archive, palace upgrades) in save v2 with migration from v1.
- No mid-run persistence — closing the game abandons the current run.
- No monetization, analytics, ads, localization, or accessibility options.
- TC-013 (weighted-selection distribution over 1,000 draws) is not automated;
  all shipped decisions currently use the default weight of 10.

## Minor known quirks

- A fresh run reads as "tense" in the diorama summary because 55 order sits in
  the middle tier by design; tune thresholds in `CountryStateResolver` if desired.
- The debug overlay's RELOAD CONTENT acts immediately; reloading mid-run while
  a decision is displayed keeps the already-selected card until the next day.
